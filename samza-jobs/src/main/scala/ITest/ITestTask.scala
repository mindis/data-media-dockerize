package ITest

import org.apache.samza.task._
import org.apache.samza.system.{IncomingMessageEnvelope, OutgoingMessageEnvelope, SystemStream}

/**
  * Created by marat on 8/3/16.
  */
class ITestTask extends StreamTask{

  /**
    * Invoked for each incoming event.
    */
  override def process(envelope: IncomingMessageEnvelope,
                       collector: MessageCollector, coordinator: TaskCoordinator): Unit = {
    println(envelope.getMessage);
    val OUTPUT_STREAM: SystemStream = new SystemStream("kafka", "itest_out");
    collector.send(new OutgoingMessageEnvelope(OUTPUT_STREAM, envelope.getMessage));
  }
}