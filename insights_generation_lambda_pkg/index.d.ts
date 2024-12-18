/**
  Lambda handler function to submit a new request to the Workload Manager Service (WMS) to
  generate insights for transactions that occurred in the last 10 minutes.

  For this demo, these transactions are being generated by a different Lambda
  function deployed through the demo-transaction-injector project.
 */
export declare function insights_generation_handler(): Promise<{
    statusCode: number;
    body: string;
}>;
