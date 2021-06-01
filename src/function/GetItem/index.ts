import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import db from '../services/db';
import axios from "axios";
import { Guid } from "guid-typescript";


const integrationEndpoint = process.env.INTEGRATION_ENDPOINT;
const integrationKey = process.env.INTEGRATION_KEY;
const env = process.env.ENV;
const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {

    const itemname = (req.query.name || (req.body && req.body.name));
    
    try {
        console.log(`Trying to connect to: ${process.env.PGHOST}`);
        await db.authenticate();
        console.log(`Database connection OK!`);
        const rows = await db.models['item'].findAll(); 
        console.log(rows);
        await postEventToIntegrationLayer("Get", 1, itemname);
        context.res = {
          body:rows
        }
    } catch (error) {
        console.log(`Unable to connect to the database:`);
        console.log(error.message);
        process.exit(1);
        context.res = {
          body:error
        }
    }
    
  }

  async function postEventToIntegrationLayer(event, rowID, itemname) {
    const data = {
      "event": event,
      "rowID": rowID, 
      "table": "items"
    }
    console.log(data);
    if (env=="local") {
      try {
        const response = await axios.post(integrationEndpoint, data, {
          headers: {
            'content-type': 'application/json',
            'content-length': `${data.toString().length}`,
          },
        });
        console.log("POSTED TO DEV LOGIC APP");
        return `${response.status} - ${response.statusText}`;
      } catch (err) {
        console.log(err);
        console.log("Make sure you have pasted in your Logic app local endpoint and run your logic app.");
        return err;
    }
    }
    else {
      console.log("POSTING TO Event grid");
      let date: Date = new Date()
      const id = Guid.create();
      console.log(id);
        const eventdata = [{
            "id": ""+id,
            "eventType": "items",
            "subject": "items"+id,
            "eventTime": date,
            "data": data,
            "dataVersion": "1.0"
          }]
          console.log(eventdata);
        try {
            const response = await axios.post(integrationEndpoint, eventdata, {
              headers: {
                'content-type': 'application/json',
                'content-length': `${eventdata.toString().length}`,
                'aeg-sas-key': integrationKey
              },
            });
            console.log("IT WORKED");
            return `${response.status} - ${response.statusText}`;
          } catch (err) {
            console.log(err);
            return err;
        }
    }
  }



export default httpTrigger;
