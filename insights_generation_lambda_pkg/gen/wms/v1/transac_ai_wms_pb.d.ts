import type { GenFile, GenMessage, GenService } from "@bufbuild/protobuf/codegenv1";
import type { Message } from "@bufbuild/protobuf";
/**
 * Describes the file wms/v1/transac_ai_wms.proto.
 */
export declare const file_wms_v1_transac_ai_wms: GenFile;
/**
 * GenerateInsightsRequest is the request message for the GenerateInsights method
 *
 * @generated from message wms.v1.GenerateInsightsRequest
 */
export type GenerateInsightsRequest = Message<"wms.v1.GenerateInsightsRequest"> & {
    /**
     * @generated from field: string client_id = 1;
     */
    clientId: string;
    /**
     * @generated from field: int32 prompt_id = 2;
     */
    promptId: number;
    /**
     * @generated from field: string records_source_id = 3;
     */
    recordsSourceId: string;
    /**
     * @generated from field: string prompt_templates_source_id = 4;
     */
    promptTemplatesSourceId: string;
    /**
     * @generated from field: string from_time = 5;
     */
    fromTime: string;
    /**
     * @generated from field: string to_time = 6;
     */
    toTime: string;
};
/**
 * Describes the message wms.v1.GenerateInsightsRequest.
 * Use `create(GenerateInsightsRequestSchema)` to create a new message.
 */
export declare const GenerateInsightsRequestSchema: GenMessage<GenerateInsightsRequest>;
/**
 * GenerateInsightsResponse is the response message for the GenerateInsights method
 *
 * @generated from message wms.v1.GenerateInsightsResponse
 */
export type GenerateInsightsResponse = Message<"wms.v1.GenerateInsightsResponse"> & {
    /**
     * @generated from field: string request_id = 1;
     */
    requestId: string;
};
/**
 * Describes the message wms.v1.GenerateInsightsResponse.
 * Use `create(GenerateInsightsResponseSchema)` to create a new message.
 */
export declare const GenerateInsightsResponseSchema: GenMessage<GenerateInsightsResponse>;
/**
 * WMS Service
 *
 * @generated from service wms.v1.WMSService
 */
export declare const WMSService: GenService<{
    /**
     * Method to generate insights
     *
     * @generated from rpc wms.v1.WMSService.GenerateInsights
     */
    generateInsights: {
        methodKind: "unary";
        input: typeof GenerateInsightsRequestSchema;
        output: typeof GenerateInsightsResponseSchema;
    };
}>;
