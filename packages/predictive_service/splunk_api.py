
splunk_ip="https://10.147.40.101:8089"


def get_splunk_data():
       query="""
index="events_perf" | chart values(attributes.mem) over attributes.x | rename attributes.x as "Element Count" | rename values(attributes.mem) as "Memory" 
| append [| makeresults | eval "Element Count"=500000 ] 
| append [| makeresults | eval "Element Count"=550000 ]
| append [| makeresults | eval "Element Count"=600000 ]
| fields - _time 
| sort "Element Count"
| fit StateSpaceForecast "Memory" output_metadata=true holdback=0 forecast_k=3 into "app:ordermemcon"
| rename predicted(Memory) as forecast
| rename lower95(predicted(Memory)) as lower95
| rename upper95(predicted(Memory)) as upper95
       """
       #Create a search job
       sid=splunk_create_job(user,password,query)
       #Check status of a search
       #data=splunk_get_result(user,password,sid)
       return data


def splunk_create_job(user,password,query):
        x = requests.post(splunk_ip+"/services/search/jobs/",  auth = HTTPBasicAuth(user,password), data = {"search": "search "+query})
        
        return

def splunk_get_result(user,password,sid):
        query=""
        x = requests.get(splunk_ip+"/services/search/jobs/"+sid,  auth = HTTPBasicAuth(user,password))
        return

def splunk_check_status(user,password,sid):

        while splunk_get_result(user,password,sid):
            query=""
            x = requests.get(splunk_ip+"/services/search/jobs/"+sid+"/results/",  auth = HTTPBasicAuth(user,password), data = {"output_mode": "csv"})

        return

