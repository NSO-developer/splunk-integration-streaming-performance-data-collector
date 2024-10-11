from opentelemetry.sdk.resources import SERVICE_NAME, Resource

from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

from opentelemetry import metrics
from opentelemetry.exporter.otlp.proto.http.metric_exporter import OTLPMetricExporter
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
import sys

tracer=None

def init(otel_collector_ip):
	# Service name is required for most backends
	resource = Resource(attributes={
		SERVICE_NAME: "splunk_mem_mon"
	})

	traceProvider = TracerProvider(resource=resource)
	processor = BatchSpanProcessor(OTLPSpanExporter(endpoint=otel_collector_ip+"/v1/traces"))
	traceProvider.add_span_processor(processor)
	trace.set_tracer_provider(traceProvider)
	global tracer
	tracer = trace.get_tracer("my.tracer.name")

def send_trace(tracer,msg,mem,time,commited_as,kvs=""):
	with tracer.start_as_current_span("span-name") as current_span:
		print("sending: "+msg + " "+kvs+" " + mem+" " + time)
		#current_span = trace.get_current_span()
		#current_span.add_event(msg)
		current_span.set_attribute("x", msg)
		current_span.set_attribute("mem", mem)
		current_span.set_attribute("time", time)
		current_span.set_attribute("commited_as", commited_as)



if __name__ == '__main__':
	otel_collector_ip=sys.argv[1]
	msg=sys.argv[2]
	mem=sys.argv[3]
	time=sys.argv[4]
	commited_as=sys.argv[5]

	init(otel_collector_ip)
	send_trace(tracer,msg,mem,time,commited_as)
