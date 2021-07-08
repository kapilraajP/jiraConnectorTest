// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import  ballerina/http;
import  ballerina/url;
import  ballerina/lang.'string;

public type ClientConfig record {
    http:BearerTokenConfig|http:OAuth2RefreshTokenGrantConfig|http:CredentialsConfig authConfig;
    http:ClientSecureSocket secureSocketConfig?;
};

public type ApplicationPropertyArr ApplicationProperty[];

public type ApplicationRoleArr ApplicationRole[];

public type TimeTrackingProviderArr TimeTrackingProvider[];

public type FieldDetailsArr FieldDetails[];

public type FilterArr Filter[];

public type ColumnItemArr ColumnItem[];

public type SharePermissionArr SharePermission[];

public type AttachmentArr Attachment[];

public type IssueTypeDetailsArr IssueTypeDetails[];

public type PriorityArr Priority[];

public type ProjectArr Project[];

public type ProjectTypeArr ProjectType[];

public type ProjectComponentArr ProjectComponent[];

public type ProjectRoleDetailsArr ProjectRoleDetails[];

public type IssueTypeWithStatusArr IssueTypeWithStatus[];

public type VersionArr Version[];

public type ProjectCategoryArr ProjectCategory[];

# Client endpoint for Jira Cloud platform API
#
# + clientEp - Connector http endpoint
public client class Client {
    http:Client clientEp;
    public isolated function init(ClientConfig clientConfig, string serviceUrl = "https://your-domain.atlassian.net") returns error? {
        http:ClientSecureSocket? secureSocketConfig = clientConfig?.secureSocketConfig;
        http:Client httpEp = check new (serviceUrl, { auth: clientConfig.authConfig, secureSocket: secureSocketConfig });
        self.clientEp = httpEp;
    }
    # Get custom field configurations
    #
    # + fieldIdOrKey - The ID or key of the custom field, for example `customfield_10000`.
    # + contextId - The list of context IDs. To include multiple contexts, separate IDs with an ampersand: `contextId=10000&contextId=10001`. Either this or `issueId` can be provided, but not both.
    # + issueId - The ID of the issue to filter results by. If the issue doesn't exist, an empty list is returned. Either this or `contextIds` can be provided, but not both.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getCustomFieldConfiguration(string fieldIdOrKey, int[]? contextId = (), int? issueId = (), int? startAt = 0, int? maxResults = 100) returns PageBeanContextualConfiguration|error {
        string  path = string `/rest/api/2/app/field/${fieldIdOrKey}/context/configuration`;
        map<anydata> queryParam = {"contextId": contextId, "issueId": issueId, "startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanContextualConfiguration response = check self.clientEp-> get(path, targetType = PageBeanContextualConfiguration);
        return response;
    }
    # Update custom field configurations
    #
    # + fieldIdOrKey - The ID or key of the custom field, for example `customfield_10000`.
    # + return - Returned if the request is successful.
    remote isolated function updateCustomFieldConfiguration(string fieldIdOrKey, CustomFieldConfigurations payload) returns json|error {
        string  path = string `/rest/api/2/app/field/${fieldIdOrKey}/context/configuration`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Update custom field value
    #
    # + fieldIdOrKey - The ID or key of the custom field. For example, `customfield_10010`.
    # + payload - Details of updates for a custom field.
    # + generateChangelog - Whether to generate a changelog for this update. Default: true.
    # + return - Returned if the request is successful.
    remote isolated function updateCustomFieldValue(string fieldIdOrKey, CustomFieldValueUpdateRequest payload, boolean? generateChangelog = true) returns json|error {
        string  path = string `/rest/api/2/app/field/${fieldIdOrKey}/value`;
        map<anydata> queryParam = {"generateChangelog": generateChangelog};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Get application property
    #
    # + 'key - The key of the application property.
    # + permissionLevel - The permission level of all items being returned in the list.
    # + keyFilter - When a `key` isn't provided, this filters the list of results by the application property `key` using a regular expression. For example, using `jira.lf.*` will return all application properties with keys that start with *jira.lf.*.
    # + return - Returned if the request is successful.
    remote isolated function getApplicationProperty(string? 'key = (), string? permissionLevel = (), string? keyFilter = ()) returns ApplicationPropertyArr|error {
        string  path = string `/rest/api/2/application-properties`;
        map<anydata> queryParam = {"key": 'key, "permissionLevel": permissionLevel, "keyFilter": keyFilter};
        path = path + getPathForQueryParam(queryParam);
        ApplicationPropertyArr response = check self.clientEp-> get(path, targetType = ApplicationPropertyArr);
        return response;
    }
    # Get advanced settings
    #
    # + return - Returned if the request is successful.
    remote isolated function getAdvancedSettings() returns ApplicationPropertyArr|error {
        string  path = string `/rest/api/2/application-properties/advanced-settings`;
        ApplicationPropertyArr response = check self.clientEp-> get(path, targetType = ApplicationPropertyArr);
        return response;
    }
    # Set application property
    #
    # + id - The key of the application property to update.
    # + payload - The Details of the application property.
    # + return - Returned if the request is successful.
    remote isolated function setApplicationProperty(string id, SimpleApplicationPropertyBean payload) returns ApplicationProperty|error {
        string  path = string `/rest/api/2/application-properties/${id}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ApplicationProperty response = check self.clientEp->put(path, request, targetType=ApplicationProperty);
        return response;
    }
    # Get all application roles
    #
    # + return - Returned if the request is successful.
    remote isolated function getAllApplicationRoles() returns ApplicationRoleArr|error {
        string  path = string `/rest/api/2/applicationrole`;
        ApplicationRoleArr response = check self.clientEp-> get(path, targetType = ApplicationRoleArr);
        return response;
    }
    # Get application role
    #
    # + 'key - The key of the application role. Use the [Get all application roles](#api-rest-api-2-applicationrole-get) operation to get the key for each application role.
    # + return - Returned if the request is successful.
    remote isolated function getApplicationRole(string 'key) returns ApplicationRole|error {
        string  path = string `/rest/api/2/applicationrole/${'key}`;
        ApplicationRole response = check self.clientEp-> get(path, targetType = ApplicationRole);
        return response;
    }
    # Get Jira attachment settings
    #
    # + return - Returned if the request is successful.
    remote isolated function getAttachmentMeta() returns AttachmentSettings|error {
        string  path = string `/rest/api/2/attachment/meta`;
        AttachmentSettings response = check self.clientEp-> get(path, targetType = AttachmentSettings);
        return response;
    }
    # Get attachment metadata
    #
    # + id - The ID of the attachment.
    # + return - Returned if the request is successful.
    remote isolated function getAttachment(string id) returns AttachmentMetadata|error {
        string  path = string `/rest/api/2/attachment/${id}`;
        AttachmentMetadata response = check self.clientEp-> get(path, targetType = AttachmentMetadata);
        return response;
    }
    # Delete attachment
    #
    # + id - The ID of the attachment.
    # + return - Returned if the request is successful.
    remote isolated function removeAttachment(string id) returns error? {
        string  path = string `/rest/api/2/attachment/${id}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get all metadata for an expanded attachment
    #
    # + id - The ID of the attachment.
    # + return - Returned if the request is successful. If an empty list is returned in the response, the attachment is empty, corrupt, or not an archive.
    remote isolated function expandAttachmentForHumans(string id) returns AttachmentArchiveMetadataReadable|error {
        string  path = string `/rest/api/2/attachment/${id}/expand/human`;
        AttachmentArchiveMetadataReadable response = check self.clientEp-> get(path, targetType = AttachmentArchiveMetadataReadable);
        return response;
    }
    # Get contents metadata for an expanded attachment
    #
    # + id - The ID of the attachment.
    # + return - Returned if the request is successful. If an empty list is returned in the response, the attachment is empty, corrupt, or not an archive.
    remote isolated function expandAttachmentForMachines(string id) returns AttachmentArchiveImpl|error {
        string  path = string `/rest/api/2/attachment/${id}/expand/raw`;
        AttachmentArchiveImpl response = check self.clientEp-> get(path, targetType = AttachmentArchiveImpl);
        return response;
    }
    # Get audit records
    #
    # + offset - The number of records to skip before returning the first result.
    # + 'limit - The maximum number of results to return.
    # + filter - The strings to match with audit field content, space separated.
    # + 'from - The date and time on or after which returned audit records must have been created. If `to` is provided `from` must be before `to` or no audit records are returned.
    # + to - The date and time on or before which returned audit results must have been created. If `from` is provided `to` must be after `from` or no audit records are returned.
    # + return - Returned if the request is successful.
    remote isolated function getAuditRecords(int? offset = 0, int? 'limit = 1000, string? filter = (), string? 'from = (), string? to = ()) returns AuditRecords|error {
        string  path = string `/rest/api/2/auditing/record`;
        map<anydata> queryParam = {"offset": offset, "limit": 'limit, "filter": filter, "from": 'from, "to": to};
        path = path + getPathForQueryParam(queryParam);
        AuditRecords response = check self.clientEp-> get(path, targetType = AuditRecords);
        return response;
    }
    # Get system avatars by type
    #
    # + 'type - The avatar type.
    # + return - Returned if the request is successful.
    remote isolated function getAllSystemAvatars(string 'type) returns SystemAvatars|error {
        string  path = string `/rest/api/2/avatar/${'type}/system`;
        SystemAvatars response = check self.clientEp-> get(path, targetType = SystemAvatars);
        return response;
    }
    # Get comments by IDs
    #
    # + payload - The list of comment IDs.
    # + expand - Use [expand](#expansion) to include additional information about comments in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getCommentsByIds(IssueCommentListRequestBean payload, string? expand = ()) returns PageBeanComment|error {
        string  path = string `/rest/api/2/comment/list`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        PageBeanComment response = check self.clientEp->post(path, request, targetType=PageBeanComment);
        return response;
    }
    # Get comment property keys
    #
    # + commentId - The ID of the comment.
    # + return - Returned if the request is successful.
    remote isolated function getCommentPropertyKeys(string commentId) returns PropertyKeys|error {
        string  path = string `/rest/api/2/comment/${commentId}/properties`;
        PropertyKeys response = check self.clientEp-> get(path, targetType = PropertyKeys);
        return response;
    }
    # Get comment property
    #
    # + commentId - The ID of the comment.
    # + propertyKey - The key of the property.
    # + return - Returned if the request is successful.
    remote isolated function getCommentProperty(string commentId, string propertyKey) returns EntityProperty|error {
        string  path = string `/rest/api/2/comment/${commentId}/properties/${propertyKey}`;
        EntityProperty response = check self.clientEp-> get(path, targetType = EntityProperty);
        return response;
    }
    # Set comment property
    #
    # + commentId - The ID of the comment.
    # + propertyKey - The key of the property. The maximum length is 255 characters.
    # + payload - The request payload value of a property for a comment to update.
    # + return - Returned if the comment property is updated.
    remote isolated function setCommentProperty(string commentId, string propertyKey, json payload) returns json|error {
        string  path = string `/rest/api/2/comment/${commentId}/properties/${propertyKey}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete comment property
    #
    # + commentId - The ID of the comment.
    # + propertyKey - The key of the property.
    # + return - Returned if the request is successful.
    remote isolated function deleteCommentProperty(string commentId, string propertyKey) returns error? {
        string  path = string `/rest/api/2/comment/${commentId}/properties/${propertyKey}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Create component
    #
    # + payload - The reuest payload to create a component
    # + return - Returned if the request is successful.
    remote isolated function createComponent(ProjectComponent payload) returns ProjectComponent|error {
        string  path = string `/rest/api/2/component`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ProjectComponent response = check self.clientEp->post(path, request, targetType=ProjectComponent);
        return response;
    }
    # Get component
    #
    # + id - The ID of the component.
    # + return - Returned if the request is successful.
    remote isolated function getComponent(string id) returns ProjectComponent|error {
        string  path = string `/rest/api/2/component/${id}`;
        ProjectComponent response = check self.clientEp-> get(path, targetType = ProjectComponent);
        return response;
    }
    # Update component
    #
    # + id - The ID of the component.
    # + payload - The reuest payload to update a component
    # + return - Returned if the request is successful.
    remote isolated function updateComponent(string id, ProjectComponent payload) returns ProjectComponent|error {
        string  path = string `/rest/api/2/component/${id}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ProjectComponent response = check self.clientEp->put(path, request, targetType=ProjectComponent);
        return response;
    }
    # Delete component
    #
    # + id - The ID of the component.
    # + moveIssuesTo - The ID of the component to replace the deleted component. If this value is null no replacement is made.
    # + return - Returned if the request is successful.
    remote isolated function deleteComponent(string id, string? moveIssuesTo = ()) returns error? {
        string  path = string `/rest/api/2/component/${id}`;
        map<anydata> queryParam = {"moveIssuesTo": moveIssuesTo};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get component issues count
    #
    # + id - The ID of the component.
    # + return - Returned if the request is successful.
    remote isolated function getComponentRelatedIssues(string id) returns ComponentIssuesCount|error {
        string  path = string `/rest/api/2/component/${id}/relatedIssueCounts`;
        ComponentIssuesCount response = check self.clientEp-> get(path, targetType = ComponentIssuesCount);
        return response;
    }
    # Get global settings
    #
    # + return - Returned if the request is successful.
    remote isolated function getConfiguration() returns Configuration|error {
        string  path = string `/rest/api/2/configuration`;
        Configuration response = check self.clientEp-> get(path, targetType = Configuration);
        return response;
    }
    # Get selected time tracking provider
    #
    # + return - Returned if the request is successful and time tracking is enabled.
    remote isolated function getSelectedTimeTrackingImplementation() returns TimeTrackingProvider|error {
        string  path = string `/rest/api/2/configuration/timetracking`;
        TimeTrackingProvider response = check self.clientEp-> get(path, targetType = TimeTrackingProvider);
        return response;
    }
    # Select time tracking provider
    #
    # + payload - The request payload to select a time tracking provider.
    # + return - Returned if the request is successful.
    remote isolated function selectTimeTrackingImplementation(TimeTrackingProvider payload) returns json|error {
        string  path = string `/rest/api/2/configuration/timetracking`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Get all time tracking providers
    #
    # + return - Returned if the request is successful.
    remote isolated function getAvailableTimeTrackingImplementations() returns TimeTrackingProviderArr|error {
        string  path = string `/rest/api/2/configuration/timetracking/list`;
        TimeTrackingProviderArr response = check self.clientEp-> get(path, targetType = TimeTrackingProviderArr);
        return response;
    }
    # Get time tracking settings
    #
    # + return - Returned if the request is successful.
    remote isolated function getSharedTimeTrackingConfiguration() returns TimeTrackingConfiguration|error {
        string  path = string `/rest/api/2/configuration/timetracking/options`;
        TimeTrackingConfiguration response = check self.clientEp-> get(path, targetType = TimeTrackingConfiguration);
        return response;
    }
    # Set time tracking settings
    #
    # + payload - The request payload to set time tracking settings
    # + return - Returned if the request is successful.
    remote isolated function setSharedTimeTrackingConfiguration(TimeTrackingConfiguration payload) returns TimeTrackingConfiguration|error {
        string  path = string `/rest/api/2/configuration/timetracking/options`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        TimeTrackingConfiguration response = check self.clientEp->put(path, request, targetType=TimeTrackingConfiguration);
        return response;
    }
    # Get custom field option
    #
    # + id - The ID of the custom field option.
    # + return - Returned if the request is successful.
    remote isolated function getCustomFieldOption(string id) returns CustomFieldOption|error {
        string  path = string `/rest/api/2/customFieldOption/${id}`;
        CustomFieldOption response = check self.clientEp-> get(path, targetType = CustomFieldOption);
        return response;
    }
    # Get all dashboards
    #
    # + filter - The filter applied to the list of dashboards. Valid values are:
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getAllDashboards(string? filter = (), int? startAt = 0, int? maxResults = 20) returns PageOfDashboards|error {
        string  path = string `/rest/api/2/dashboard`;
        map<anydata> queryParam = {"filter": filter, "startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageOfDashboards response = check self.clientEp-> get(path, targetType = PageOfDashboards);
        return response;
    }
    # Create dashboard
    #
    # + payload - Dashboard details.
    # + return - Returned if the request is successful.
    remote isolated function createDashboard(DashboardDetails payload) returns Dashboard|error {
        string  path = string `/rest/api/2/dashboard`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Dashboard response = check self.clientEp->post(path, request, targetType=Dashboard);
        return response;
    }
    # Search for dashboards
    #
    # + dashboardName - String used to perform a case-insensitive partial match with `name`.
    # + accountId - User account ID used to return dashboards with the matching `owner.accountId`. This parameter cannot be used with the `owner` parameter.
    # + owner - This parameter is deprecated because of privacy changes. Use `accountId` instead. See the [migration guide](https://developer.atlassian.com/cloud/jira/platform/deprecation-notice-user-privacy-api-migration-guide/) for details. User name used to return dashboards with the matching `owner.name`. This parameter cannot be used with the `accountId` parameter.
    # + groupname - Group name used to returns dashboards that are shared with a group that matches `sharePermissions.group.name`.
    # + projectId - Project ID used to returns dashboards that are shared with a project that matches `sharePermissions.project.id`.
    # + orderBy - [Order](#ordering) the results by a field:
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + expand - Use [expand](#expansion) to include additional information about dashboard in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getDashboardsPaginated(string? dashboardName = (), string? accountId = (), string? owner = (), string? groupname = (), int? projectId = (), string? orderBy = "name", int? startAt = 0, int? maxResults = 50, string? expand = ()) returns PageBeanDashboard|error {
        string  path = string `/rest/api/2/dashboard/search`;
        map<anydata> queryParam = {"dashboardName": dashboardName, "accountId": accountId, "owner": owner, "groupname": groupname, "projectId": projectId, "orderBy": orderBy, "startAt": startAt, "maxResults": maxResults, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PageBeanDashboard response = check self.clientEp-> get(path, targetType = PageBeanDashboard);
        return response;
    }
    # Get dashboard item property keys
    #
    # + dashboardId - The ID of the dashboard.
    # + itemId - The ID of the dashboard item.
    # + return - Returned if the request is successful.
    remote isolated function getDashboardItemPropertyKeys(string dashboardId, string itemId) returns PropertyKeys|error {
        string  path = string `/rest/api/2/dashboard/${dashboardId}/items/${itemId}/properties`;
        PropertyKeys response = check self.clientEp-> get(path, targetType = PropertyKeys);
        return response;
    }
    # Get dashboard item property
    #
    # + dashboardId - The ID of the dashboard.
    # + itemId - The ID of the dashboard item.
    # + propertyKey - The key of the dashboard item property.
    # + return - Returned if the request is successful.
    remote isolated function getDashboardItemProperty(string dashboardId, string itemId, string propertyKey) returns EntityProperty|error {
        string  path = string `/rest/api/2/dashboard/${dashboardId}/items/${itemId}/properties/${propertyKey}`;
        EntityProperty response = check self.clientEp-> get(path, targetType = EntityProperty);
        return response;
    }
    # Set dashboard item property
    #
    # + dashboardId - The ID of the dashboard.
    # + itemId - The ID of the dashboard item.
    # + propertyKey - The key of the dashboard item property. The maximum length is 255 characters.
    # + payload - The request payload to set the value of a dashboard item property.
    # + return - Returned if the dashboard item property is updated.
    remote isolated function setDashboardItemProperty(string dashboardId, string itemId, string propertyKey, json payload) returns json|error {
        string  path = string `/rest/api/2/dashboard/${dashboardId}/items/${itemId}/properties/${propertyKey}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete dashboard item property
    #
    # + dashboardId - The ID of the dashboard.
    # + itemId - The ID of the dashboard item.
    # + propertyKey - The key of the dashboard item property.
    # + return - Returned if the dashboard item property is deleted.
    remote isolated function deleteDashboardItemProperty(string dashboardId, string itemId, string propertyKey) returns error? {
        string  path = string `/rest/api/2/dashboard/${dashboardId}/items/${itemId}/properties/${propertyKey}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get dashboard
    #
    # + id - The ID of the dashboard.
    # + return - Returned if the request is successful.
    remote isolated function getDashboard(string id) returns Dashboard|error {
        string  path = string `/rest/api/2/dashboard/${id}`;
        Dashboard response = check self.clientEp-> get(path, targetType = Dashboard);
        return response;
    }
    # Update dashboard
    #
    # + id - The ID of the dashboard to update.
    # + payload - Replacement dashboard details.
    # + return - Returned if the request is successful.
    remote isolated function updateDashboard(string id, DashboardDetails payload) returns Dashboard|error {
        string  path = string `/rest/api/2/dashboard/${id}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Dashboard response = check self.clientEp->put(path, request, targetType=Dashboard);
        return response;
    }
    # Delete dashboard
    #
    # + id - The ID of the dashboard.
    # + return - Returned if the dashboard is deleted.
    remote isolated function deleteDashboard(string id) returns error? {
        string  path = string `/rest/api/2/dashboard/${id}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Copy dashboard
    #
    # + id - The ID a dashboard to copy.
    # + payload - Dashboard details.
    # + return - Returned if the request is successful.
    remote isolated function copyDashboard(string id, DashboardDetails payload) returns Dashboard|error {
        string  path = string `/rest/api/2/dashboard/${id}/copy`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Dashboard response = check self.clientEp->post(path, request, targetType=Dashboard);
        return response;
    }
    # Analyse Jira expression
    #
    # + payload - The Jira expressions to analyse.
    # + 'check - The check to perform:
    # + return - Returned if the request is successful.
    remote isolated function analyseExpression(JiraExpressionForAnalysis payload, string? 'check = "syntax") returns JiraExpressionsAnalysis|error {
        string  path = string `/rest/api/2/expression/analyse`;
        map<anydata> queryParam = {"check": 'check};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        JiraExpressionsAnalysis response = check self.clientEp->post(path, request, targetType=JiraExpressionsAnalysis);
        return response;
    }
    # Evaluate Jira expression
    #
    # + payload - The Jira expression and the evaluation context.
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts `meta.complexity` that returns information about the expression complexity. For example, the number of expensive operations used by the expression and how close the expression is to reaching the [complexity limit](https://developer.atlassian.com/cloud/jira/platform/jira-expressions/#restrictions). Useful when designing and debugging your expressions.
    # + return - Returned if the evaluation results in a value. The result is a JSON primitive value, list, or object.
    remote isolated function evaluateJiraExpression(JiraExpressionEvalRequestBean payload, string? expand = ()) returns JiraExpressionResult|error {
        string  path = string `/rest/api/2/expression/eval`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        JiraExpressionResult response = check self.clientEp->post(path, request, targetType=JiraExpressionResult);
        return response;
    }
    # Get fields
    #
    # + return - Returned if the request is successful.
    remote isolated function getFields() returns FieldDetailsArr|error {
        string  path = string `/rest/api/2/field`;
        FieldDetailsArr response = check self.clientEp-> get(path, targetType = FieldDetailsArr);
        return response;
    }
    # Create custom field
    #
    # + payload - Definition of the custom field to be created
    # + return - Returned if the custom field is created.
    remote isolated function createCustomField(CustomFieldDefinitionJsonBean payload) returns FieldDetails|error {
        string  path = string `/rest/api/2/field`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        FieldDetails response = check self.clientEp->post(path, request, targetType=FieldDetails);
        return response;
    }
    # Get fields paginated
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + 'type - The type of fields to search.
    # + id - The IDs of the custom fields to return or, where `query` is specified, filter.
    # + query - String used to perform a case-insensitive partial match with field names or descriptions.
    # + orderBy - [Order](#ordering) the results by a field:
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getFieldsPaginated(int? startAt = 0, int? maxResults = 50, string[]? 'type = (), string[]? id = (), string? query = (), string? orderBy = (), string? expand = ()) returns PageBeanField|error {
        string  path = string `/rest/api/2/field/search`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "type": 'type, "id": id, "query": query, "orderBy": orderBy, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PageBeanField response = check self.clientEp-> get(path, targetType = PageBeanField);
        return response;
    }
    # Update custom field
    #
    # + fieldId - The ID of the custom field.
    # + payload - The custom field update details.
    # + return - Returned if the request is successful.
    remote isolated function updateCustomField(string fieldId, UpdateCustomFieldDetails payload) returns json|error {
        string  path = string `/rest/api/2/field/${fieldId}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Get custom field contexts
    #
    # + fieldId - The ID of the custom field.
    # + isAnyIssueType - Whether to return contexts that apply to all issue types.
    # + isGlobalContext - Whether to return contexts that apply to all projects.
    # + contextId - The list of context IDs. To include multiple contexts, separate IDs with ampersand: `contextId=10000&contextId=10001`.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getContextsForField(string fieldId, boolean? isAnyIssueType = (), boolean? isGlobalContext = (), int[]? contextId = (), int? startAt = 0, int? maxResults = 50) returns PageBeanCustomFieldContext|error {
        string  path = string `/rest/api/2/field/${fieldId}/context`;
        map<anydata> queryParam = {"isAnyIssueType": isAnyIssueType, "isGlobalContext": isGlobalContext, "contextId": contextId, "startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanCustomFieldContext response = check self.clientEp-> get(path, targetType = PageBeanCustomFieldContext);
        return response;
    }
    # Create custom field context
    #
    # + fieldId - The ID of the custom field.
    # + payload - The request payload to create a custom field context.
    # + return - Returned if the custom field context is created.
    remote isolated function createCustomFieldContext(string fieldId, CreateCustomFieldContext payload) returns CreateCustomFieldContext|error {
        string  path = string `/rest/api/2/field/${fieldId}/context`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        CreateCustomFieldContext response = check self.clientEp->post(path, request, targetType=CreateCustomFieldContext);
        return response;
    }
    # Get custom field contexts default values
    #
    # + fieldId - The ID of the custom field, for example `customfield\_10000`.
    # + contextId - The IDs of the contexts.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getDefaultValues(string fieldId, int[]? contextId = (), int? startAt = 0, int? maxResults = 50) returns PageBeanCustomFieldContextDefaultValue|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/defaultValue`;
        map<anydata> queryParam = {"contextId": contextId, "startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanCustomFieldContextDefaultValue response = check self.clientEp-> get(path, targetType = PageBeanCustomFieldContextDefaultValue);
        return response;
    }
    # Set custom field contexts default values
    #
    # + fieldId - The ID of the custom field.
    # + payload - The request payload to set default for contexts of a custom field.
    # + return - Returned if operation is successful.
    remote isolated function setDefaultValues(string fieldId, CustomFieldContextDefaultValueUpdate payload) returns json|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/defaultValue`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Get issue types for custom field context
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context. To include multiple contexts, provide an ampersand-separated list. For example, `contextId=10001&contextId=10002`.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if operation is successful.
    remote isolated function getIssueTypeMappingsForContexts(string fieldId, int[]? contextId = (), int? startAt = 0, int? maxResults = 50) returns PageBeanIssueTypeToContextMapping|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/issuetypemapping`;
        map<anydata> queryParam = {"contextId": contextId, "startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueTypeToContextMapping response = check self.clientEp-> get(path, targetType = PageBeanIssueTypeToContextMapping);
        return response;
    }
    # Get custom field contexts for projects and issue types
    #
    # + fieldId - The ID of the custom field.
    # + payload - The list of project and issue type mappings.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getCustomFieldContextsForProjectsAndIssueTypes(string fieldId, ProjectIssueTypeMappings payload, int? startAt = 0, int? maxResults = 50) returns PageBeanContextForProjectAndIssueType|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/mapping`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        PageBeanContextForProjectAndIssueType response = check self.clientEp->post(path, request, targetType=PageBeanContextForProjectAndIssueType);
        return response;
    }
    # Get project mappings for custom field context
    #
    # + fieldId - The ID of the custom field, for example `customfield\_10000`.
    # + contextId - The list of context IDs. To include multiple context, separate IDs with ampersand: `contextId=10000&contextId=10001`.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getProjectContextMapping(string fieldId, int[]? contextId = (), int? startAt = 0, int? maxResults = 50) returns PageBeanCustomFieldContextProjectMapping|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/projectmapping`;
        map<anydata> queryParam = {"contextId": contextId, "startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanCustomFieldContextProjectMapping response = check self.clientEp-> get(path, targetType = PageBeanCustomFieldContextProjectMapping);
        return response;
    }
    # Update custom field context
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context.
    # + payload - The request payload to update a custom field context
    # + return - Returned if the context is updated.
    remote isolated function updateCustomFieldContext(string fieldId, int contextId, CustomFieldContextUpdateDetails payload) returns json|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete custom field context
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context.
    # + return - Returned if the context is deleted.
    remote isolated function deleteCustomFieldContext(string fieldId, int contextId) returns json|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
        json response = check self.clientEp-> delete(path, request, targetType = json);
        return response;
    }
    # Add issue types to context
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context.
    # + payload - The request payload to add issue types to a custom field context
    # + return - Returned if operation is successful.
    remote isolated function addIssueTypesToContext(string fieldId, int contextId, IssueTypeIds payload) returns json|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}/issuetype`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Remove issue types from context
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context.
    # + payload - The request payload to remove issue types from a custom field context
    # + return - Returned if operation is successful.
    remote isolated function removeIssueTypesFromContext(string fieldId, int contextId, IssueTypeIds payload) returns json|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}/issuetype/remove`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->post(path, request, targetType=json);
        return response;
    }
    # Get custom field options (context)
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context.
    # + optionId - The ID of the option.
    # + onlyOptions - Whether only options are returned.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getOptionsForContext(string fieldId, int contextId, int? optionId = (), boolean? onlyOptions = false, int? startAt = 0, int? maxResults = 100) returns PageBeanCustomFieldContextOption|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}/option`;
        map<anydata> queryParam = {"optionId": optionId, "onlyOptions": onlyOptions, "startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanCustomFieldContextOption response = check self.clientEp-> get(path, targetType = PageBeanCustomFieldContextOption);
        return response;
    }
    # Update custom field options (context)
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context.
    # + payload - The request payload to update issue types to a custom field context
    # + return - Returned if the request is successful.
    remote isolated function updateCustomFieldOption(string fieldId, int contextId, BulkCustomFieldOptionUpdateRequest payload) returns CustomFieldUpdatedContextOptionsList|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}/option`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        CustomFieldUpdatedContextOptionsList response = check self.clientEp->put(path, request, targetType=CustomFieldUpdatedContextOptionsList);
        return response;
    }
    # Create custom field options (context)
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context.
    # + payload - The request payolad to create custom field options (context)
    # + return - Returned if the request is successful.
    remote isolated function createCustomFieldOption(string fieldId, int contextId, BulkCustomFieldOptionCreateRequest payload) returns CustomFieldCreatedContextOptionsList|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}/option`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        CustomFieldCreatedContextOptionsList response = check self.clientEp->post(path, request, targetType=CustomFieldCreatedContextOptionsList);
        return response;
    }
    # Reorder custom field options (context)
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context.
    # + payload - The request payload to reorder custom field options (context)
    # + return - Returned if options are reordered.
    remote isolated function reorderCustomFieldOptions(string fieldId, int contextId, OrderOfCustomFieldOptions payload) returns json|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}/option/move`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete custom field options (context)
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context from which an option should be deleted.
    # + optionId - The ID of the option to delete.
    # + return - Returned if the option is deleted.
    remote isolated function deleteCustomFieldOption(string fieldId, int contextId, int optionId) returns error? {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}/option/${optionId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Assign custom field context to projects
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context.
    # + payload - The request payload to assign custom field context to projects
    # + return - Returned if operation is successful.
    remote isolated function assignProjectsToCustomFieldContext(string fieldId, int contextId, ProjectIds payload) returns json|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}/project`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Remove custom field context from projects
    #
    # + fieldId - The ID of the custom field.
    # + contextId - The ID of the context.
    # + payload - The request payload to remove custom field context from projects
    # + return - Returned if the custom field context is removed from the projects.
    remote isolated function removeCustomFieldContextFromProjects(string fieldId, int contextId, ProjectIds payload) returns json|error {
        string  path = string `/rest/api/2/field/${fieldId}/context/${contextId}/project/remove`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->post(path, request, targetType=json);
        return response;
    }
    # Get contexts for a field
    #
    # + fieldId - The ID of the field to return contexts for.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getContextsForFieldDeprecated(string fieldId, int? startAt = 0, int? maxResults = 20) returns PageBeanContext|error {
        string  path = string `/rest/api/2/field/${fieldId}/contexts`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanContext response = check self.clientEp-> get(path, targetType = PageBeanContext);
        return response;
    }
    # Get screens for a field
    #
    # + fieldId - The ID of the field to return screens for.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + expand - Use [expand](#expansion) to include additional information about screens in the response. This parameter accepts `tab` which returns details about the screen tabs the field is used in.
    # + return - Returned if the request is successful.
    remote isolated function getScreensForField(string fieldId, int? startAt = 0, int? maxResults = 100, string? expand = ()) returns PageBeanScreenWithTab|error {
        string  path = string `/rest/api/2/field/${fieldId}/screens`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PageBeanScreenWithTab response = check self.clientEp-> get(path, targetType = PageBeanScreenWithTab);
        return response;
    }
    # Get all issue field options
    #
    # + fieldKey - The field key is specified in the following format: **$(app-key)\_\_$(field-key)**. For example, *example-add-on\_\_example-issue-field*. To determine the `fieldKey` value, do one of the following:
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getAllIssueFieldOptions(string fieldKey, int? startAt = 0, int? maxResults = 50) returns PageBeanIssueFieldOption|error {
        string  path = string `/rest/api/2/field/${fieldKey}/option`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueFieldOption response = check self.clientEp-> get(path, targetType = PageBeanIssueFieldOption);
        return response;
    }
    # Create issue field option
    #
    # + fieldKey - The field key is specified in the following format: **$(app-key)\_\_$(field-key)**. For example, *example-add-on\_\_example-issue-field*. To determine the `fieldKey` value, do one of the following:
    # + payload - The request payload to create issue field option
    # + return - Returned if the request is successful.
    remote isolated function createIssueFieldOption(string fieldKey, IssueFieldOptionCreateBean payload) returns IssueFieldOption|error {
        string  path = string `/rest/api/2/field/${fieldKey}/option`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        IssueFieldOption response = check self.clientEp->post(path, request, targetType=IssueFieldOption);
        return response;
    }
    # Get selectable issue field options
    #
    # + fieldKey - The field key is specified in the following format: **$(app-key)\_\_$(field-key)**. For example, *example-add-on\_\_example-issue-field*. To determine the `fieldKey` value, do one of the following:
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + projectId - Filters the results to options that are only available in the specified project.
    # + return - Returned if the request is successful.
    remote isolated function getSelectableIssueFieldOptions(string fieldKey, int? startAt = 0, int? maxResults = 50, int? projectId = ()) returns PageBeanIssueFieldOption|error {
        string  path = string `/rest/api/2/field/${fieldKey}/option/suggestions/edit`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "projectId": projectId};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueFieldOption response = check self.clientEp-> get(path, targetType = PageBeanIssueFieldOption);
        return response;
    }
    # Get visible issue field options
    #
    # + fieldKey - The field key is specified in the following format: **$(app-key)\_\_$(field-key)**. For example, *example-add-on\_\_example-issue-field*. To determine the `fieldKey` value, do one of the following:
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + projectId - Filters the results to options that are only available in the specified project.
    # + return - Returned if the request is successful.
    remote isolated function getVisibleIssueFieldOptions(string fieldKey, int? startAt = 0, int? maxResults = (), int? projectId = ()) returns PageBeanIssueFieldOption|error {
        string  path = string `/rest/api/2/field/${fieldKey}/option/suggestions/search`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "projectId": projectId};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueFieldOption response = check self.clientEp-> get(path, targetType = PageBeanIssueFieldOption);
        return response;
    }
    # Get issue field option
    #
    # + fieldKey - The field key is specified in the following format: **$(app-key)\_\_$(field-key)**. For example, *example-add-on\_\_example-issue-field*. To determine the `fieldKey` value, do one of the following:
    # + optionId - The ID of the option to be returned.
    # + return - Returned if the requested option is returned.
    remote isolated function getIssueFieldOption(string fieldKey, int optionId) returns IssueFieldOption|error {
        string  path = string `/rest/api/2/field/${fieldKey}/option/${optionId}`;
        IssueFieldOption response = check self.clientEp-> get(path, targetType = IssueFieldOption);
        return response;
    }
    # Update issue field option
    #
    # + fieldKey - The field key is specified in the following format: **$(app-key)\_\_$(field-key)**. For example, *example-add-on\_\_example-issue-field*. To determine the `fieldKey` value, do one of the following:
    # + optionId - The ID of the option to be updated.
    # + payload - The request payload to update issue field option
    # + return - Returned if the option is updated or created.
    remote isolated function updateIssueFieldOption(string fieldKey, int optionId, IssueFieldOption payload) returns IssueFieldOption|error {
        string  path = string `/rest/api/2/field/${fieldKey}/option/${optionId}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        IssueFieldOption response = check self.clientEp->put(path, request, targetType=IssueFieldOption);
        return response;
    }
    # Delete issue field option
    #
    # + fieldKey - The field key is specified in the following format: **$(app-key)\_\_$(field-key)**. For example, *example-add-on\_\_example-issue-field*. To determine the `fieldKey` value, do one of the following:
    # + optionId - The ID of the option to be deleted.
    # + return - Returned if the field option is deleted.
    remote isolated function deleteIssueFieldOption(string fieldKey, int optionId) returns json|error {
        string  path = string `/rest/api/2/field/${fieldKey}/option/${optionId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
        json response = check self.clientEp-> delete(path, request, targetType = json);
        return response;
    }
    # Replace issue field option
    #
    # + fieldKey - The field key is specified in the following format: **$(app-key)\_\_$(field-key)**. For example, *example-add-on\_\_example-issue-field*. To determine the `fieldKey` value, do one of the following:
    # + optionId - The ID of the option to be deselected.
    # + replaceWith - The ID of the option that will replace the currently selected option.
    # + jql - A JQL query that specifies the issues to be updated. For example, *project=10000*.
    # + return - Returned if the long-running task to deselect the option is started.
    remote isolated function replaceIssueFieldOption(string fieldKey, int optionId, int? replaceWith = (), string? jql = ()) returns TaskProgressBeanRemoveOptionFromIssuesResult|error {
        string  path = string `/rest/api/2/field/${fieldKey}/option/${optionId}/issue`;
        map<anydata> queryParam = {"replaceWith": replaceWith, "jql": jql};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
        TaskProgressBeanRemoveOptionFromIssuesResult response = check self.clientEp-> delete(path, request, targetType = TaskProgressBeanRemoveOptionFromIssuesResult);
        return response;
    }
    # Get all field configurations
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + id - The list of field configuration IDs. To include multiple IDs, provide an ampersand-separated list. For example, `id=10000&id=10001`.
    # + isDefault - If *true* returns default field configurations only.
    # + query - The query string used to match against field configuration names and descriptions.
    # + return - Returned if the request is successful.
    remote isolated function getAllFieldConfigurations(int? startAt = 0, int? maxResults = 50, int[]? id = (), boolean? isDefault = false, string? query = "") returns PageBeanFieldConfiguration|error {
        string  path = string `/rest/api/2/fieldconfiguration`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "id": id, "isDefault": isDefault, "query": query};
        path = path + getPathForQueryParam(queryParam);
        PageBeanFieldConfiguration response = check self.clientEp-> get(path, targetType = PageBeanFieldConfiguration);
        return response;
    }
    # Get field configuration items
    #
    # + id - The ID of the field configuration.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getFieldConfigurationItems(int id, int? startAt = 0, int? maxResults = 50) returns PageBeanFieldConfigurationItem|error {
        string  path = string `/rest/api/2/fieldconfiguration/${id}/fields`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanFieldConfigurationItem response = check self.clientEp-> get(path, targetType = PageBeanFieldConfigurationItem);
        return response;
    }
    # Get all field configuration schemes
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + id - The list of field configuration scheme IDs. To include multiple IDs, provide an ampersand-separated list. For example, `id=10000&id=10001`.
    # + return - Returned if the request is successful.
    remote isolated function getAllFieldConfigurationSchemes(int? startAt = 0, int? maxResults = 50, int[]? id = ()) returns PageBeanFieldConfigurationScheme|error {
        string  path = string `/rest/api/2/fieldconfigurationscheme`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "id": id};
        path = path + getPathForQueryParam(queryParam);
        PageBeanFieldConfigurationScheme response = check self.clientEp-> get(path, targetType = PageBeanFieldConfigurationScheme);
        return response;
    }
    # Get field configuration issue type items
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + fieldConfigurationSchemeId - The list of field configuration scheme IDs. To include multiple field configuration schemes separate IDs with ampersand: `fieldConfigurationSchemeId=10000&fieldConfigurationSchemeId=10001`.
    # + return - Returned if the request is successful.
    remote isolated function getFieldConfigurationSchemeMappings(int? startAt = 0, int? maxResults = 50, int[]? fieldConfigurationSchemeId = ()) returns PageBeanFieldConfigurationIssueTypeItem|error {
        string  path = string `/rest/api/2/fieldconfigurationscheme/mapping`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "fieldConfigurationSchemeId": fieldConfigurationSchemeId};
        path = path + getPathForQueryParam(queryParam);
        PageBeanFieldConfigurationIssueTypeItem response = check self.clientEp-> get(path, targetType = PageBeanFieldConfigurationIssueTypeItem);
        return response;
    }
    # Get field configuration schemes for projects
    #
    # + projectId - The list of project IDs. To include multiple projects, separate IDs with ampersand: `projectId=10000&projectId=10001`.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getFieldConfigurationSchemeProjectMapping(int[] projectId, int? startAt = 0, int? maxResults = 50) returns PageBeanFieldConfigurationSchemeProjects|error {
        string  path = string `/rest/api/2/fieldconfigurationscheme/project`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "projectId": projectId};
        path = path + getPathForQueryParam(queryParam);
        PageBeanFieldConfigurationSchemeProjects response = check self.clientEp-> get(path, targetType = PageBeanFieldConfigurationSchemeProjects);
        return response;
    }
    # Assign field configuration scheme to project
    #
    # + payload - The request payload to assign field configuration scheme to project
    # + return - Returned if the request is successful.
    remote isolated function assignFieldConfigurationSchemeToProject(FieldConfigurationSchemeProjectAssociation payload) returns json|error {
        string  path = string `/rest/api/2/fieldconfigurationscheme/project`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Get filters
    #
    # + expand - Use [expand](#expansion) to include additional information about filter in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getFilters(string? expand = ()) returns FilterArr|error {
        string  path = string `/rest/api/2/filter`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        FilterArr response = check self.clientEp-> get(path, targetType = FilterArr);
        return response;
    }
    # Create filter
    #
    # + payload - The filter to create.
    # + expand - Use [expand](#expansion) to include additional information about filter in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function createFilter(Filter payload, string? expand = ()) returns Filter|error {
        string  path = string `/rest/api/2/filter`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Filter response = check self.clientEp->post(path, request, targetType=Filter);
        return response;
    }
    # Get default share scope
    #
    # + return - Returned if the request is successful.
    remote isolated function getDefaultShareScope() returns DefaultShareScope|error {
        string  path = string `/rest/api/2/filter/defaultShareScope`;
        DefaultShareScope response = check self.clientEp-> get(path, targetType = DefaultShareScope);
        return response;
    }
    # Set default share scope
    #
    # + payload - The request payload to set default share scope
    # + return - Returned if the request is successful.
    remote isolated function setDefaultShareScope(DefaultShareScope payload) returns DefaultShareScope|error {
        string  path = string `/rest/api/2/filter/defaultShareScope`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        DefaultShareScope response = check self.clientEp->put(path, request, targetType=DefaultShareScope);
        return response;
    }
    # Get favorite filters
    #
    # + expand - Use [expand](#expansion) to include additional information about filter in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getFavouriteFilters(string? expand = ()) returns FilterArr|error {
        string  path = string `/rest/api/2/filter/favourite`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        FilterArr response = check self.clientEp-> get(path, targetType = FilterArr);
        return response;
    }
    # Get my filters
    #
    # + expand - Use [expand](#expansion) to include additional information about filter in the response. This parameter accepts a comma-separated list. Expand options include:
    # + includeFavourites - Include the user's favorite filters in the response.
    # + return - Returned if the request is successful.
    remote isolated function getMyFilters(string? expand = (), boolean? includeFavourites = false) returns FilterArr|error {
        string  path = string `/rest/api/2/filter/my`;
        map<anydata> queryParam = {"expand": expand, "includeFavourites": includeFavourites};
        path = path + getPathForQueryParam(queryParam);
        FilterArr response = check self.clientEp-> get(path, targetType = FilterArr);
        return response;
    }
    # Search for filters
    #
    # + filterName - String used to perform a case-insensitive partial match with `name`.
    # + accountId - User account ID used to return filters with the matching `owner.accountId`. This parameter cannot be used with `owner`.
    # + owner - This parameter is deprecated because of privacy changes. Use `accountId` instead. See the [migration guide](https://developer.atlassian.com/cloud/jira/platform/deprecation-notice-user-privacy-api-migration-guide/) for details. User name used to return filters with the matching `owner.name`. This parameter cannot be used with `accountId`.
    # + groupname - Group name used to returns filters that are shared with a group that matches `sharePermissions.group.groupname`.
    # + projectId - Project ID used to returns filters that are shared with a project that matches `sharePermissions.project.id`.
    # + id - The list of filter IDs. To include multiple IDs, provide an ampersand-separated list. For example, `id=10000&id=10001`.
    # + orderBy - [Order](#ordering) the results by a field:
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + expand - Use [expand](#expansion) to include additional information about filter in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getFiltersPaginated(string? filterName = (), string? accountId = (), string? owner = (), string? groupname = (), int? projectId = (), int[]? id = (), string? orderBy = "name", int? startAt = 0, int? maxResults = 50, string? expand = ()) returns PageBeanFilterDetails|error {
        string  path = string `/rest/api/2/filter/search`;
        map<anydata> queryParam = {"filterName": filterName, "accountId": accountId, "owner": owner, "groupname": groupname, "projectId": projectId, "id": id, "orderBy": orderBy, "startAt": startAt, "maxResults": maxResults, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PageBeanFilterDetails response = check self.clientEp-> get(path, targetType = PageBeanFilterDetails);
        return response;
    }
    # Get filter
    #
    # + id - The ID of the filter to return.
    # + expand - Use [expand](#expansion) to include additional information about filter in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getFilter(int id, string? expand = ()) returns Filter|error {
        string  path = string `/rest/api/2/filter/${id}`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        Filter response = check self.clientEp-> get(path, targetType = Filter);
        return response;
    }
    # Update filter
    #
    # + id - The ID of the filter to update.
    # + payload - The filter to update.
    # + expand - Use [expand](#expansion) to include additional information about filter in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function updateFilter(int id, Filter payload, string? expand = ()) returns Filter|error {
        string  path = string `/rest/api/2/filter/${id}`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Filter response = check self.clientEp->put(path, request, targetType=Filter);
        return response;
    }
    # Delete filter
    #
    # + id - The ID of the filter to delete.
    # + return - Returned if the request is successful.
    remote isolated function deleteFilter(int id) returns error? {
        string  path = string `/rest/api/2/filter/${id}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get columns
    #
    # + id - The ID of the filter.
    # + return - Returned if the request is successful.
    remote isolated function getColumns(int id) returns ColumnItemArr|error {
        string  path = string `/rest/api/2/filter/${id}/columns`;
        ColumnItemArr response = check self.clientEp-> get(path, targetType = ColumnItemArr);
        return response;
    }
    # Set columns
    #
    # + id - The ID of the filter.
    # + payload - The IDs of the fields to set as columns. In the form data, specify each field as `columns=id`, where `id` is the *id* of a field (as seen in the response for [Get fields](#api-rest-api-<ver>-field-get)). For example, `columns=summary`.
    # + return - Returned if the request is successful.
    remote isolated function setColumns(int id, string[] payload) returns json|error {
        string  path = string `/rest/api/2/filter/${id}/columns`;
        http:Request request = new;
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Reset columns
    #
    # + id - The ID of the filter.
    # + return - Returned if the request is successful.
    remote isolated function resetColumns(int id) returns error? {
        string  path = string `/rest/api/2/filter/${id}/columns`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Add filter as favorite
    #
    # + id - The ID of the filter.
    # + expand - Use [expand](#expansion) to include additional information about filter in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function setFavouriteForFilter(int id, string? expand = ()) returns Filter|error {
        string  path = string `/rest/api/2/filter/${id}/favourite`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
        Filter response = check self.clientEp-> put(path, request, targetType = Filter);
        return response;
    }
    # Remove filter as favorite
    #
    # + id - The ID of the filter.
    # + expand - Use [expand](#expansion) to include additional information about filter in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function deleteFavouriteForFilter(int id, string? expand = ()) returns Filter|error {
        string  path = string `/rest/api/2/filter/${id}/favourite`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
        Filter response = check self.clientEp-> delete(path, request, targetType = Filter);
        return response;
    }
    # Get share permissions
    #
    # + id - The ID of the filter.
    # + return - Returned if the request is successful.
    remote isolated function getSharePermissions(int id) returns SharePermissionArr|error {
        string  path = string `/rest/api/2/filter/${id}/permission`;
        SharePermissionArr response = check self.clientEp-> get(path, targetType = SharePermissionArr);
        return response;
    }
    # Add share permission
    #
    # + id - The ID of the filter.
    # + payload - The request payload to add share permission
    # + return - Returned if the request is successful.
    remote isolated function addSharePermission(int id, SharePermissionInputBean payload) returns SharePermissionArr|error {
        string  path = string `/rest/api/2/filter/${id}/permission`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        SharePermissionArr response = check self.clientEp->post(path, request, targetType=SharePermissionArr);
        return response;
    }
    # Get share permission
    #
    # + id - The ID of the filter.
    # + permissionId - The ID of the share permission.
    # + return - Returned if the request is successful.
    remote isolated function getSharePermission(int id, int permissionId) returns SharePermission|error {
        string  path = string `/rest/api/2/filter/${id}/permission/${permissionId}`;
        SharePermission response = check self.clientEp-> get(path, targetType = SharePermission);
        return response;
    }
    # Delete share permission
    #
    # + id - The ID of the filter.
    # + permissionId - The ID of the share permission.
    # + return - Returned if the request is successful.
    remote isolated function deleteSharePermission(int id, int permissionId) returns error? {
        string  path = string `/rest/api/2/filter/${id}/permission/${permissionId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get group
    #
    # + groupname - The name of the group.
    # + expand - List of fields to expand.
    # + return - Returned if the request is successful.
    remote isolated function getGroup(string groupname, string? expand = ()) returns Group|error {
        string  path = string `/rest/api/2/group`;
        map<anydata> queryParam = {"groupname": groupname, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        Group response = check self.clientEp-> get(path, targetType = Group);
        return response;
    }
    # Create group
    #
    # + payload - The name of the group.
    # + return - Returned if the request is successful.
    remote isolated function createGroup(AddGroupBean payload) returns Group|error {
        string  path = string `/rest/api/2/group`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Group response = check self.clientEp->post(path, request, targetType=Group);
        return response;
    }
    # Remove group
    #
    # + groupname - The name of the group.
    # + swapGroup - The group to transfer restrictions to. Only comments and worklogs are transferred. If restrictions are not transferred, comments and worklogs are inaccessible after the deletion.
    # + return - Returned if the request is successful.
    remote isolated function removeGroup(string groupname, string? swapGroup = ()) returns error? {
        string  path = string `/rest/api/2/group`;
        map<anydata> queryParam = {"groupname": groupname, "swapGroup": swapGroup};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Bulk get groups
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + groupId - The ID of a group. To specify multiple IDs, pass multiple `groupId` parameters. For example, `groupId=5b10a2844c20165700ede21g&groupId=5b10ac8d82e05b22cc7d4ef5`.
    # + groupName - The name of a group. To specify multiple names, pass multiple `groupName` parameters. For example, `groupName=administrators&groupName=jira-software-users`.
    # + return - Returned if the request is successful.
    remote isolated function bulkGetGroups(int? startAt = 0, int? maxResults = 50, string[]? groupId = (), string[]? groupName = ()) returns PageBeanGroupDetails|error {
        string  path = string `/rest/api/2/group/bulk`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "groupId": groupId, "groupName": groupName};
        path = path + getPathForQueryParam(queryParam);
        PageBeanGroupDetails response = check self.clientEp-> get(path, targetType = PageBeanGroupDetails);
        return response;
    }
    # Get users from group
    #
    # + groupname - The name of the group.
    # + includeInactiveUsers - Include inactive users.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getUsersFromGroup(string groupname, boolean? includeInactiveUsers = false, int? startAt = 0, int? maxResults = 50) returns PageBeanUserDetails|error {
        string  path = string `/rest/api/2/group/member`;
        map<anydata> queryParam = {"groupname": groupname, "includeInactiveUsers": includeInactiveUsers, "startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanUserDetails response = check self.clientEp-> get(path, targetType = PageBeanUserDetails);
        return response;
    }
    # Add user to group
    #
    # + groupname - The name of the group (case sensitive).
    # + payload - The user to add to the group.
    # + return - Returned if the request is successful.
    remote isolated function addUserToGroup(string groupname, UpdateUserToGroupBean payload) returns Group|error {
        string  path = string `/rest/api/2/group/user`;
        map<anydata> queryParam = {"groupname": groupname};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Group response = check self.clientEp->post(path, request, targetType=Group);
        return response;
    }
    # Remove user from group
    #
    # + groupname - The name of the group.
    # + accountId - The account ID of the user, which uniquely identifies the user across all Atlassian products. For example, *5b10ac8d82e05b22cc7d4ef5*.
    # + username - This parameter is no longer available and will be removed from the documentation soon. See the [deprecation notice](https://developer.atlassian.com/cloud/jira/platform/deprecation-notice-user-privacy-api-migration-guide/) for details.
    # + return - Returned if the request is successful.
    remote isolated function removeUserFromGroup(string groupname, string accountId, string? username = ()) returns error? {
        string  path = string `/rest/api/2/group/user`;
        map<anydata> queryParam = {"groupname": groupname, "username": username, "accountId": accountId};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Find groups
    #
    # + accountId - This parameter is deprecated, setting it does not affect the results. To find groups containing a particular user, use [Get user groups](#api-rest-api-2-user-groups-get).
    # + query - The string to find in group names.
    # + exclude - A group to exclude from the result. To exclude multiple groups, provide an ampersand-separated list. For example, `exclude=group1&exclude=group2`.
    # + maxResults - The maximum number of groups to return. The maximum number of groups that can be returned is limited by the system property `jira.ajax.autocomplete.limit`.
    # + userName - This parameter is no longer available and will be removed from the documentation soon. See the [deprecation notice](https://developer.atlassian.com/cloud/jira/platform/deprecation-notice-user-privacy-api-migration-guide/) for details.
    # + return - Returned if the request is successful.
    remote isolated function findGroups(string? accountId = (), string? query = (), string[]? exclude = (), int? maxResults = (), string? userName = ()) returns FoundGroups|error {
        string  path = string `/rest/api/2/groups/picker`;
        map<anydata> queryParam = {"accountId": accountId, "query": query, "exclude": exclude, "maxResults": maxResults, "userName": userName};
        path = path + getPathForQueryParam(queryParam);
        FoundGroups response = check self.clientEp-> get(path, targetType = FoundGroups);
        return response;
    }
    # Find users and groups
    #
    # + query - The search string.
    # + maxResults - The maximum number of items to return in each list.
    # + showAvatar - Whether the user avatar should be returned. If an invalid value is provided, the default value is used.
    # + fieldId - The custom field ID of the field this request is for.
    # + projectId - The ID of a project that returned users and groups must have permission to view. To include multiple projects, provide an ampersand-separated list. For example, `projectId=10000&projectId=10001`. This parameter is only used when `fieldId` is present.
    # + issueTypeId - The ID of an issue type that returned users and groups must have permission to view. To include multiple issue types, provide an ampersand-separated list. For example, `issueTypeId=10000&issueTypeId=10001`. Special values, such as `-1` (all standard issue types) and `-2` (all subtask issue types), are supported. This parameter is only used when `fieldId` is present.
    # + avatarSize - The size of the avatar to return. If an invalid value is provided, the default value is used.
    # + caseInsensitive - Whether the search for groups should be case insensitive.
    # + excludeConnectAddons - Whether Connect app users and groups should be excluded from the search results. If an invalid value is provided, the default value is used.
    # + return - Returned if the request is successful.
    remote isolated function findUsersAndGroups(string query, int? maxResults = 50, boolean? showAvatar = false, string? fieldId = (), string[]? projectId = (), string[]? issueTypeId = (), string? avatarSize = "xsmall", boolean? caseInsensitive = false, boolean? excludeConnectAddons = false) returns FoundUsersAndGroups|error {
        string  path = string `/rest/api/2/groupuserpicker`;
        map<anydata> queryParam = {"query": query, "maxResults": maxResults, "showAvatar": showAvatar, "fieldId": fieldId, "projectId": projectId, "issueTypeId": issueTypeId, "avatarSize": avatarSize, "caseInsensitive": caseInsensitive, "excludeConnectAddons": excludeConnectAddons};
        path = path + getPathForQueryParam(queryParam);
        FoundUsersAndGroups response = check self.clientEp-> get(path, targetType = FoundUsersAndGroups);
        return response;
    }
    # Get license
    #
    # + return - Returned if the request is successful.
    remote isolated function getLicense() returns License|error {
        string  path = string `/rest/api/2/instance/license`;
        License response = check self.clientEp-> get(path, targetType = License);
        return response;
    }
    # Create issue
    #
    # + payload - The request payload to create issue
    # + updateHistory - Whether the project in which the issue is created is added to the user's **Recently viewed** project list, as shown under **Projects** in Jira. When provided, the issue type and request type are added to the user's history for a project. These values are then used to provide defaults on the issue create screen.
    # + return - Returned if the request is successful.
    remote isolated function createIssue(IssueUpdateDetails payload, boolean? updateHistory = false) returns CreatedIssue|error {
        string  path = string `/rest/api/2/issue`;
        map<anydata> queryParam = {"updateHistory": updateHistory};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        CreatedIssue response = check self.clientEp->post(path, request, targetType=CreatedIssue);
        return response;
    }
    # Bulk create issue
    #
    # + payload - The request payload to bulk create issue
    # + return - Returned if any of the issue or subtask creation requests were successful. A request may be unsuccessful when it:
    remote isolated function createIssues(IssuesUpdateBean payload) returns CreatedIssues|error {
        string  path = string `/rest/api/2/issue/bulk`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        CreatedIssues response = check self.clientEp->post(path, request, targetType=CreatedIssues);
        return response;
    }
    # Get create issue metadata
    #
    # + projectIds - List of project IDs. This parameter accepts a comma-separated list. Multiple project IDs can also be provided using an ampersand-separated list. For example, `projectIds=10000,10001&projectIds=10020,10021`. This parameter may be provided with `projectKeys`.
    # + projectKeys - List of project keys. This parameter accepts a comma-separated list. Multiple project keys can also be provided using an ampersand-separated list. For example, `projectKeys=proj1,proj2&projectKeys=proj3`. This parameter may be provided with `projectIds`.
    # + issuetypeIds - List of issue type IDs. This parameter accepts a comma-separated list. Multiple issue type IDs can also be provided using an ampersand-separated list. For example, `issuetypeIds=10000,10001&issuetypeIds=10020,10021`. This parameter may be provided with `issuetypeNames`.
    # + issuetypeNames - List of issue type names. This parameter accepts a comma-separated list. Multiple issue type names can also be provided using an ampersand-separated list. For example, `issuetypeNames=name1,name2&issuetypeNames=name3`. This parameter may be provided with `issuetypeIds`.
    # + expand - Use [expand](#expansion) to include additional information about issue metadata in the response. This parameter accepts `projects.issuetypes.fields`, which returns information about the fields in the issue creation screen for each issue type. Fields hidden from the screen are not returned. Use the information to populate the `fields` and `update` fields in [Create issue](#api-rest-api-2-issue-post) and [Create issues](#api-rest-api-2-issue-bulk-post).
    # + return - Returned if the request is successful.
    remote isolated function getCreateIssueMeta(string[]? projectIds = (), string[]? projectKeys = (), string[]? issuetypeIds = (), string[]? issuetypeNames = (), string? expand = ()) returns IssueCreateMetadata|error {
        string  path = string `/rest/api/2/issue/createmeta`;
        map<anydata> queryParam = {"projectIds": projectIds, "projectKeys": projectKeys, "issuetypeIds": issuetypeIds, "issuetypeNames": issuetypeNames, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        IssueCreateMetadata response = check self.clientEp-> get(path, targetType = IssueCreateMetadata);
        return response;
    }
    # Get issue picker suggestions
    #
    # + query - A string to match against text fields in the issue such as title, description, or comments.
    # + currentJQL - A JQL query defining a list of issues to search for the query term. Note that `username` and `userkey` cannot be used as search terms for this parameter, due to privacy reasons. Use `accountId` instead.
    # + currentIssueKey - The key of an issue to exclude from search results. For example, the issue the user is viewing when they perform this query.
    # + currentProjectId - The ID of a project that suggested issues must belong to.
    # + showSubTasks - Indicate whether to include subtasks in the suggestions list.
    # + showSubTaskParent - When `currentIssueKey` is a subtask, whether to include the parent issue in the suggestions if it matches the query.
    # + return - Returned if the request is successful.
    remote isolated function getIssuePickerResource(string? query = (), string? currentJQL = (), string? currentIssueKey = (), string? currentProjectId = (), boolean? showSubTasks = (), boolean? showSubTaskParent = ()) returns IssuePickerSuggestions|error {
        string  path = string `/rest/api/2/issue/picker`;
        map<anydata> queryParam = {"query": query, "currentJQL": currentJQL, "currentIssueKey": currentIssueKey, "currentProjectId": currentProjectId, "showSubTasks": showSubTasks, "showSubTaskParent": showSubTaskParent};
        path = path + getPathForQueryParam(queryParam);
        IssuePickerSuggestions response = check self.clientEp-> get(path, targetType = IssuePickerSuggestions);
        return response;
    }
    # Bulk set issues properties
    #
    # + payload - Issue properties to be set or updated with values.
    # + return - Returned if the operation is successful.
    remote isolated function bulkSetIssuesProperties(IssueEntityProperties payload) returns error? {
        string  path = string `/rest/api/2/issue/properties`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
         _ = check self.clientEp-> post(path, request, targetType=http:Response);
    }
    # Bulk set issue property
    #
    # + propertyKey - The key of the property. The maximum length is 255 characters.
    # + payload - The request payload to bulk set issue property
    # + return - Returned if the request is successful.
    remote isolated function bulkSetIssueProperty(string propertyKey, BulkIssuePropertyUpdateRequest payload) returns error? {
        string  path = string `/rest/api/2/issue/properties/${propertyKey}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
         _ = check self.clientEp-> put(path, request, targetType=http:Response);
    }
    # Bulk delete issue property
    #
    # + propertyKey - The key of the property.
    # + payload - The request payload to bulk delete issue property
    # + return - Returned if the request is successful.
    remote isolated function bulkDeleteIssueProperty(string propertyKey, IssueFilterForBulkPropertyDelete payload) returns error? {
        string  path = string `/rest/api/2/issue/properties/${propertyKey}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
         _ = check self.clientEp-> delete(path, request, targetType=http:Response);
    }
    # Get issue
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + fields - A list of fields to return for the issue. This parameter accepts a comma-separated list. Use it to retrieve a subset of fields. Allowed values:
    # + fieldsByKeys - Whether fields in `fields` are referenced by keys rather than IDs. This parameter is useful where fields have been added by a connect app and a field's key may differ from its ID.
    # + expand - Use [expand](#expansion) to include additional information about the issues in the response. This parameter accepts a comma-separated list. Expand options include:
    # + properties - A list of issue properties to return for the issue. This parameter accepts a comma-separated list. Allowed values:
    # + updateHistory - Whether the project in which the issue is created is added to the user's **Recently viewed** project list, as shown under **Projects** in Jira. This also populates the [JQL issues search](#api-rest-api-2-search-get) `lastViewed` field.
    # + return - Returned if the request is successful.
    remote isolated function getIssue(string issueIdOrKey, string[]? fields = (), boolean? fieldsByKeys = false, string? expand = (), string[]? properties = (), boolean? updateHistory = false) returns IssueBean|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}`;
        map<anydata> queryParam = {"fields": fields, "fieldsByKeys": fieldsByKeys, "expand": expand, "properties": properties, "updateHistory": updateHistory};
        path = path + getPathForQueryParam(queryParam);
        IssueBean response = check self.clientEp-> get(path, targetType = IssueBean);
        return response;
    }
    # Edit issue
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + payload - The request payload to edit issue
    # + notifyUsers - Whether a notification email about the issue update is sent to all watchers. To disable the notification, administer Jira or administer project permissions are required. If the user doesn't have the necessary permission the request is ignored.
    # + overrideScreenSecurity - Whether screen security should be overridden to enable hidden fields to be edited. Available to Connect app users with admin permissions.
    # + overrideEditableFlag - Whether screen security should be overridden to enable uneditable fields to be edited. Available to Connect app users with admin permissions.
    # + return - Returned if the request is successful.
    remote isolated function editIssue(string issueIdOrKey, IssueUpdateDetails payload, boolean? notifyUsers = true, boolean? overrideScreenSecurity = false, boolean? overrideEditableFlag = false) returns json|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}`;
        map<anydata> queryParam = {"notifyUsers": notifyUsers, "overrideScreenSecurity": overrideScreenSecurity, "overrideEditableFlag": overrideEditableFlag};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete issue
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + deleteSubtasks - Whether the issue's subtasks are deleted when the issue is deleted.
    # + return - Returned if the request is successful.
    remote isolated function deleteIssue(string issueIdOrKey, string? deleteSubtasks = "false") returns error? {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}`;
        map<anydata> queryParam = {"deleteSubtasks": deleteSubtasks};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Assign issue
    #
    # + issueIdOrKey - The ID or key of the issue to be assigned.
    # + payload - The request object with the user that the issue is assigned to.
    # + return - Returned if the request is successful.
    remote isolated function assignIssue(string issueIdOrKey, User payload) returns json|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/assignee`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Add attachment
    #
    # + issueIdOrKey - The ID or key of the issue that attachments are added to.
    # + payload - The request payload to add attachment
    # + return - Returned if the request is successful.
    remote isolated function addAttachment(string issueIdOrKey, string payload) returns AttachmentArr|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/attachments`;
        http:Request request = new;
        AttachmentArr response = check self.clientEp->post(path, request, targetType=AttachmentArr);
        return response;
    }
    # Get change logs
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getChangeLogs(string issueIdOrKey, int? startAt = 0, int? maxResults = 100) returns PageBeanChangelog|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/changelog`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanChangelog response = check self.clientEp-> get(path, targetType = PageBeanChangelog);
        return response;
    }
    # Get changelogs by IDs
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + payload - The request payload to get changelogs by IDs
    # + return - Returned if the request is successful.
    remote isolated function getChangeLogsByIds(string issueIdOrKey, IssueChangelogIds payload) returns PageOfChangelogs|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/changelog/list`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        PageOfChangelogs response = check self.clientEp->post(path, request, targetType=PageOfChangelogs);
        return response;
    }
    # Get comments
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + orderBy - [Order](#ordering) the results by a field. Accepts *created* to sort comments by their created date.
    # + expand - Use [expand](#expansion) to include additional information about comments in the response. This parameter accepts `renderedBody`, which returns the comment body rendered in HTML.
    # + return - Returned if the request is successful.
    remote isolated function getComments(string issueIdOrKey, int? startAt = 0, int? maxResults = 50, string? orderBy = (), string? expand = ()) returns PageOfComments|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/comment`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "orderBy": orderBy, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PageOfComments response = check self.clientEp-> get(path, targetType = PageOfComments);
        return response;
    }
    # Add comment
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + payload - The request payload to add comment
    # + expand - Use [expand](#expansion) to include additional information about comments in the response. This parameter accepts `renderedBody`, which returns the comment body rendered in HTML.
    # + return - Returned if the request is successful.
    remote isolated function addComment(string issueIdOrKey, Comment payload, string? expand = ()) returns Comment|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/comment`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Comment response = check self.clientEp->post(path, request, targetType=Comment);
        return response;
    }
    # Get comment
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + id - The ID of the comment.
    # + expand - Use [expand](#expansion) to include additional information about comments in the response. This parameter accepts `renderedBody`, which returns the comment body rendered in HTML.
    # + return - Returned if the request is successful.
    remote isolated function getComment(string issueIdOrKey, string id, string? expand = ()) returns Comment|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/comment/${id}`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        Comment response = check self.clientEp-> get(path, targetType = Comment);
        return response;
    }
    # Update comment
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + id - The ID of the comment.
    # + payload - The request payload to update comment
    # + expand - Use [expand](#expansion) to include additional information about comments in the response. This parameter accepts `renderedBody`, which returns the comment body rendered in HTML.
    # + return - Returned if the request is successful.
    remote isolated function updateComment(string issueIdOrKey, string id, Comment payload, string? expand = ()) returns Comment|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/comment/${id}`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Comment response = check self.clientEp->put(path, request, targetType=Comment);
        return response;
    }
    # Delete comment
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + id - The ID of the comment.
    # + return - Returned if the request is successful.
    remote isolated function deleteComment(string issueIdOrKey, string id) returns error? {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/comment/${id}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get edit issue metadata
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + overrideScreenSecurity - Whether hidden fields should be returned. Available to connect app users with admin permissions.
    # + overrideEditableFlag - Whether non-editable fields should be returned. Available to connect app users with admin permissions.
    # + return - Returned if the request is successful.
    remote isolated function getEditIssueMeta(string issueIdOrKey, boolean? overrideScreenSecurity = false, boolean? overrideEditableFlag = false) returns IssueUpdateMetadata|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/editmeta`;
        map<anydata> queryParam = {"overrideScreenSecurity": overrideScreenSecurity, "overrideEditableFlag": overrideEditableFlag};
        path = path + getPathForQueryParam(queryParam);
        IssueUpdateMetadata response = check self.clientEp-> get(path, targetType = IssueUpdateMetadata);
        return response;
    }
    # Send notification for issue
    #
    # + issueIdOrKey - ID or key of the issue that the notification is sent for.
    # + payload - The request object for the notification and recipients.
    # + return - Returned if the email is queued for sending.
    remote isolated function notify(string issueIdOrKey, Notification payload) returns json|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/notify`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->post(path, request, targetType=json);
        return response;
    }
    # Get issue property keys
    #
    # + issueIdOrKey - The key or ID of the issue.
    # + return - Returned if the request is successful.
    remote isolated function getIssuePropertyKeys(string issueIdOrKey) returns PropertyKeys|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/properties`;
        PropertyKeys response = check self.clientEp-> get(path, targetType = PropertyKeys);
        return response;
    }
    # Get issue property
    #
    # + issueIdOrKey - The key or ID of the issue.
    # + propertyKey - The key of the property.
    # + return - Returned if the request is successful.
    remote isolated function getIssueProperty(string issueIdOrKey, string propertyKey) returns EntityProperty|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/properties/${propertyKey}`;
        EntityProperty response = check self.clientEp-> get(path, targetType = EntityProperty);
        return response;
    }
    # Set issue property
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + propertyKey - The key of the issue property. The maximum length is 255 characters.
    # + payload - The request payload to set issue property
    # + return - Returned if the issue property is updated.
    remote isolated function setIssueProperty(string issueIdOrKey, string propertyKey, json payload) returns json|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/properties/${propertyKey}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete issue property
    #
    # + issueIdOrKey - The key or ID of the issue.
    # + propertyKey - The key of the property.
    # + return - Returned if the request is successful.
    remote isolated function deleteIssueProperty(string issueIdOrKey, string propertyKey) returns error? {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/properties/${propertyKey}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get remote issue links
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + globalId - The global ID of the remote issue link.
    # + return - Returned if the request is successful.
    remote isolated function getRemoteIssueLinks(string issueIdOrKey, string? globalId = ()) returns RemoteIssueLink|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/remotelink`;
        map<anydata> queryParam = {"globalId": globalId};
        path = path + getPathForQueryParam(queryParam);
        RemoteIssueLink response = check self.clientEp-> get(path, targetType = RemoteIssueLink);
        return response;
    }
    # Create or update remote issue link
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + payload - The request payload to create or update remote issue link
    # + return - Returned if the remote issue link is updated.
    remote isolated function createOrUpdateRemoteIssueLink(string issueIdOrKey, RemoteIssueLinkRequest payload) returns RemoteIssueLinkIdentifies|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/remotelink`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        RemoteIssueLinkIdentifies response = check self.clientEp->post(path, request, targetType=RemoteIssueLinkIdentifies);
        return response;
    }
    # Delete remote issue link by global ID
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + globalId - The global ID of a remote issue link.
    # + return - Returned if the request is successful.
    remote isolated function deleteRemoteIssueLinkByGlobalId(string issueIdOrKey, string globalId) returns error? {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/remotelink`;
        map<anydata> queryParam = {"globalId": globalId};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get remote issue link by ID
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + linkId - The ID of the remote issue link.
    # + return - Returned if the request is successful.
    remote isolated function getRemoteIssueLinkById(string issueIdOrKey, string linkId) returns RemoteIssueLink|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/remotelink/${linkId}`;
        RemoteIssueLink response = check self.clientEp-> get(path, targetType = RemoteIssueLink);
        return response;
    }
    # Update remote issue link by ID
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + linkId - The ID of the remote issue link.
    # + payload - The request payload to update remote issue link by ID
    # + return - Returned if the request is successful.
    remote isolated function updateRemoteIssueLink(string issueIdOrKey, string linkId, RemoteIssueLinkRequest payload) returns json|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/remotelink/${linkId}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete remote issue link by ID
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + linkId - The ID of a remote issue link.
    # + return - Returned if the request is successful.
    remote isolated function deleteRemoteIssueLinkById(string issueIdOrKey, string linkId) returns error? {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/remotelink/${linkId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get transitions
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + expand - Use [expand](#expansion) to include additional information about transitions in the response. This parameter accepts `transitions.fields`, which returns information about the fields in the transition screen for each transition. Fields hidden from the screen are not returned. Use this information to populate the `fields` and `update` fields in [Transition issue](#api-rest-api-2-issue-issueIdOrKey-transitions-post).
    # + transitionId - The ID of the transition.
    # + skipRemoteOnlyCondition - Whether transitions with the condition *Hide From User Condition* are included in the response.
    # + includeUnavailableTransitions - Whether details of transitions that fail a condition are included in the response
    # + sortByOpsBarAndStatus - Whether the transitions are sorted by ops-bar sequence value first then category order (Todo, In Progress, Done) or only by ops-bar sequence value.
    # + return - Returned if the request is successful.
    remote isolated function getTransitions(string issueIdOrKey, string? expand = (), string? transitionId = (), boolean? skipRemoteOnlyCondition = false, boolean? includeUnavailableTransitions = false, boolean? sortByOpsBarAndStatus = false) returns Transitions|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/transitions`;
        map<anydata> queryParam = {"expand": expand, "transitionId": transitionId, "skipRemoteOnlyCondition": skipRemoteOnlyCondition, "includeUnavailableTransitions": includeUnavailableTransitions, "sortByOpsBarAndStatus": sortByOpsBarAndStatus};
        path = path + getPathForQueryParam(queryParam);
        Transitions response = check self.clientEp-> get(path, targetType = Transitions);
        return response;
    }
    # Transition issue
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + payload - The request payload to update the fields from the transition screen
    # + return - Returned if the request is successful.
    remote isolated function doTransition(string issueIdOrKey, IssueUpdateDetails payload) returns json|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/transitions`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->post(path, request, targetType=json);
        return response;
    }
    # Get votes
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + return - Returned if the request is successful.
    remote isolated function getVotes(string issueIdOrKey) returns Votes|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/votes`;
        Votes response = check self.clientEp-> get(path, targetType = Votes);
        return response;
    }
    # Add vote
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + return - Returned if the request is successful.
    remote isolated function addVote(string issueIdOrKey) returns json|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/votes`;
        http:Request request = new;
        //TODO: Update the request as needed;
        json response = check self.clientEp-> post(path, request, targetType = json);
        return response;
    }
    # Delete vote
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + return - Returned if the request is successful.
    remote isolated function removeVote(string issueIdOrKey) returns error? {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/votes`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get issue watchers
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + return - Returned if the request is successful
    remote isolated function getIssueWatchers(string issueIdOrKey) returns Watchers|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/watchers`;
        Watchers response = check self.clientEp-> get(path, targetType = Watchers);
        return response;
    }
    # Add watcher
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + payload - The account ID of the user. Note that username cannot be used due to privacy changes.
    # + return - Returned if the request is successful.
    remote isolated function addWatcher(string issueIdOrKey, string payload) returns json|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/watchers`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->post(path, request, targetType=json);
        return response;
    }
    # Delete watcher
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + username - This parameter is no longer available and will be removed from the documentation soon. See the [deprecation notice](https://developer.atlassian.com/cloud/jira/platform/deprecation-notice-user-privacy-api-migration-guide/) for details.
    # + accountId - The account ID of the user, which uniquely identifies the user across all Atlassian products. For example, *5b10ac8d82e05b22cc7d4ef5*. Required.
    # + return - Returned if the request is successful.
    remote isolated function removeWatcher(string issueIdOrKey, string? username = (), string? accountId = ()) returns error? {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/watchers`;
        map<anydata> queryParam = {"username": username, "accountId": accountId};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get issue worklogs
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + startedAfter - The worklog start date and time, as a UNIX timestamp in milliseconds, after which worklogs are returned.
    # + expand - Use [expand](#expansion) to include additional information about worklogs in the response. This parameter accepts`properties`, which returns worklog properties.
    # + return - Returned if the request is successful
    remote isolated function getIssueWorklog(string issueIdOrKey, int? startAt = 0, int? maxResults = 1048576, int? startedAfter = (), string? expand = "") returns PageOfWorklogs|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/worklog`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "startedAfter": startedAfter, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PageOfWorklogs response = check self.clientEp-> get(path, targetType = PageOfWorklogs);
        return response;
    }
    # Add worklog
    #
    # + issueIdOrKey - The ID or key the issue.
    # + payload - The request payload to add worklog
    # + notifyUsers - Whether users watching the issue are notified by email.
    # + adjustEstimate - Defines how to update the issue's time estimate, the options are:
    # + newEstimate - The value to set as the issue's remaining time estimate, as days (\#d), hours (\#h), or minutes (\#m or \#). For example, *2d*. Required when `adjustEstimate` is `new`.
    # + reduceBy - The amount to reduce the issue's remaining estimate by, as days (\#d), hours (\#h), or minutes (\#m). For example, *2d*. Required when `adjustEstimate` is `manual`.
    # + expand - Use [expand](#expansion) to include additional information about work logs in the response. This parameter accepts `properties`, which returns worklog properties.
    # + overrideEditableFlag - Whether the worklog entry should be added to the issue even if the issue is not editable, because jira.issue.editable set to false or missing. For example, the issue is closed. Only connect app users with admin scope permission can use this flag.
    # + return - Returned if the request is successful.
    remote isolated function addWorklog(string issueIdOrKey, Worklog payload, boolean? notifyUsers = true, string? adjustEstimate = "auto", string? newEstimate = (), string? reduceBy = (), string? expand = "", boolean? overrideEditableFlag = false) returns Worklog|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/worklog`;
        map<anydata> queryParam = {"notifyUsers": notifyUsers, "adjustEstimate": adjustEstimate, "newEstimate": newEstimate, "reduceBy": reduceBy, "expand": expand, "overrideEditableFlag": overrideEditableFlag};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Worklog response = check self.clientEp->post(path, request, targetType=Worklog);
        return response;
    }
    # Get worklog
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + id - The ID of the worklog.
    # + expand - Use [expand](#expansion) to include additional information about work logs in the response. This parameter accepts
    # + return - Returned if the request is successful.
    remote isolated function getWorklog(string issueIdOrKey, string id, string? expand = "") returns Worklog|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/worklog/${id}`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        Worklog response = check self.clientEp-> get(path, targetType = Worklog);
        return response;
    }
    # Update worklog
    #
    # + issueIdOrKey - The ID or key the issue.
    # + id - The ID of the worklog.
    # + payload - The request payload to update worklog
    # + notifyUsers - Whether users watching the issue are notified by email.
    # + adjustEstimate - Defines how to update the issue's time estimate, the options are:
    # + newEstimate - The value to set as the issue's remaining time estimate, as days (\#d), hours (\#h), or minutes (\#m or \#). For example, *2d*. Required when `adjustEstimate` is `new`.
    # + expand - Use [expand](#expansion) to include additional information about worklogs in the response. This parameter accepts `properties`, which returns worklog properties.
    # + overrideEditableFlag - Whether the worklog should be added to the issue even if the issue is not editable. For example, because the issue is closed. Only connect app users with admin permissions can use this flag.
    # + return - Returned if the request is successful
    remote isolated function updateWorklog(string issueIdOrKey, string id, Worklog payload, boolean? notifyUsers = true, string? adjustEstimate = "auto", string? newEstimate = (), string? expand = "", boolean? overrideEditableFlag = false) returns Worklog|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/worklog/${id}`;
        map<anydata> queryParam = {"notifyUsers": notifyUsers, "adjustEstimate": adjustEstimate, "newEstimate": newEstimate, "expand": expand, "overrideEditableFlag": overrideEditableFlag};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Worklog response = check self.clientEp->put(path, request, targetType=Worklog);
        return response;
    }
    # Delete worklog
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + id - The ID of the worklog.
    # + notifyUsers - Whether users watching the issue are notified by email.
    # + adjustEstimate - Defines how to update the issue's time estimate, the options are:
    # + newEstimate - The value to set as the issue's remaining time estimate, as days (\#d), hours (\#h), or minutes (\#m or \#). For example, *2d*. Required when `adjustEstimate` is `new`.
    # + increaseBy - The amount to increase the issue's remaining estimate by, as days (\#d), hours (\#h), or minutes (\#m or \#). For example, *2d*. Required when `adjustEstimate` is `manual`.
    # + overrideEditableFlag - Whether the work log entry should be added to the issue even if the issue is not editable, because jira.issue.editable set to false or missing. For example, the issue is closed. Only connect app users with admin permissions can use this flag.
    # + return - Returned if the request is successful.
    remote isolated function deleteWorklog(string issueIdOrKey, string id, boolean? notifyUsers = true, string? adjustEstimate = "auto", string? newEstimate = (), string? increaseBy = (), boolean? overrideEditableFlag = false) returns error? {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/worklog/${id}`;
        map<anydata> queryParam = {"notifyUsers": notifyUsers, "adjustEstimate": adjustEstimate, "newEstimate": newEstimate, "increaseBy": increaseBy, "overrideEditableFlag": overrideEditableFlag};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get worklog property keys
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + worklogId - The ID of the worklog.
    # + return - Returned if the request is successful.
    remote isolated function getWorklogPropertyKeys(string issueIdOrKey, string worklogId) returns PropertyKeys|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/worklog/${worklogId}/properties`;
        PropertyKeys response = check self.clientEp-> get(path, targetType = PropertyKeys);
        return response;
    }
    # Get worklog property
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + worklogId - The ID of the worklog.
    # + propertyKey - The key of the property.
    # + return - Returned if the request is successful.
    remote isolated function getWorklogProperty(string issueIdOrKey, string worklogId, string propertyKey) returns EntityProperty|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/worklog/${worklogId}/properties/${propertyKey}`;
        EntityProperty response = check self.clientEp-> get(path, targetType = EntityProperty);
        return response;
    }
    # Set worklog property
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + worklogId - The ID of the worklog.
    # + propertyKey - The key of the issue property. The maximum length is 255 characters.
    # + payload - The request payload to set worklog property
    # + return - Returned if the worklog property is updated.
    remote isolated function setWorklogProperty(string issueIdOrKey, string worklogId, string propertyKey, json payload) returns json|error {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/worklog/${worklogId}/properties/${propertyKey}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete worklog property
    #
    # + issueIdOrKey - The ID or key of the issue.
    # + worklogId - The ID of the worklog.
    # + propertyKey - The key of the property.
    # + return - Returned if the worklog property is removed.
    remote isolated function deleteWorklogProperty(string issueIdOrKey, string worklogId, string propertyKey) returns error? {
        string  path = string `/rest/api/2/issue/${issueIdOrKey}/worklog/${worklogId}/properties/${propertyKey}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Create issue link
    #
    # + payload - The issue link request.
    # + return - Returned if the request is successful.
    remote isolated function linkIssues(LinkIssueRequestJsonBean payload) returns json|error {
        string  path = string `/rest/api/2/issueLink`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->post(path, request, targetType=json);
        return response;
    }
    # Get issue link
    #
    # + linkId - The ID of the issue link.
    # + return - Returned if the request is successful.
    remote isolated function getIssueLink(string linkId) returns IssueLink|error {
        string  path = string `/rest/api/2/issueLink/${linkId}`;
        IssueLink response = check self.clientEp-> get(path, targetType = IssueLink);
        return response;
    }
    # Delete issue link
    #
    # + linkId - The ID of the issue link.
    # + return - 200 response
    remote isolated function deleteIssueLink(string linkId) returns error? {
        string  path = string `/rest/api/2/issueLink/${linkId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get issue link types
    #
    # + return - Returned if the request is successful.
    remote isolated function getIssueLinkTypes() returns IssueLinkTypes|error {
        string  path = string `/rest/api/2/issueLinkType`;
        IssueLinkTypes response = check self.clientEp-> get(path, targetType = IssueLinkTypes);
        return response;
    }
    # Create issue link type
    #
    # + payload - The request payload to create issue link type
    # + return - Returned if the request is successful.
    remote isolated function createIssueLinkType(IssueLinkType payload) returns IssueLinkType|error {
        string  path = string `/rest/api/2/issueLinkType`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        IssueLinkType response = check self.clientEp->post(path, request, targetType=IssueLinkType);
        return response;
    }
    # Get issue link type
    #
    # + issueLinkTypeId - The ID of the issue link type.
    # + return - Returned if the request is successful.
    remote isolated function getIssueLinkType(string issueLinkTypeId) returns IssueLinkType|error {
        string  path = string `/rest/api/2/issueLinkType/${issueLinkTypeId}`;
        IssueLinkType response = check self.clientEp-> get(path, targetType = IssueLinkType);
        return response;
    }
    # Update issue link type
    #
    # + issueLinkTypeId - The ID of the issue link type.
    # + payload - The request payload to update issue link type
    # + return - Returned if the request is successful.
    remote isolated function updateIssueLinkType(string issueLinkTypeId, IssueLinkType payload) returns IssueLinkType|error {
        string  path = string `/rest/api/2/issueLinkType/${issueLinkTypeId}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        IssueLinkType response = check self.clientEp->put(path, request, targetType=IssueLinkType);
        return response;
    }
    # Delete issue link type
    #
    # + issueLinkTypeId - The ID of the issue link type.
    # + return - Returned if the request is successful.
    remote isolated function deleteIssueLinkType(string issueLinkTypeId) returns error? {
        string  path = string `/rest/api/2/issueLinkType/${issueLinkTypeId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get issue security schemes
    #
    # + return - Returned if the request is successful.
    remote isolated function getIssueSecuritySchemes() returns SecuritySchemes|error {
        string  path = string `/rest/api/2/issuesecurityschemes`;
        SecuritySchemes response = check self.clientEp-> get(path, targetType = SecuritySchemes);
        return response;
    }
    # Get issue security scheme
    #
    # + id - The ID of the issue security scheme. Use the [Get issue security schemes](#api-rest-api-2-issuesecurityschemes-get) operation to get a list of issue security scheme IDs.
    # + return - Returned if the request is successful.
    remote isolated function getIssueSecurityScheme(int id) returns SecurityScheme|error {
        string  path = string `/rest/api/2/issuesecurityschemes/${id}`;
        SecurityScheme response = check self.clientEp-> get(path, targetType = SecurityScheme);
        return response;
    }
    # Get issue security level members
    #
    # + issueSecuritySchemeId - The ID of the issue security scheme. Use the [Get issue security schemes](#api-rest-api-2-issuesecurityschemes-get) operation to get a list of issue security scheme IDs.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + issueSecurityLevelId - The list of issue security level IDs. To include multiple issue security levels separate IDs with ampersand: `issueSecurityLevelId=10000&issueSecurityLevelId=10001`.
    # + expand - Use expand to include additional information in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getIssueSecurityLevelMembers(int issueSecuritySchemeId, int? startAt = 0, int? maxResults = 50, int[]? issueSecurityLevelId = (), string? expand = ()) returns PageBeanIssueSecurityLevelMember|error {
        string  path = string `/rest/api/2/issuesecurityschemes/${issueSecuritySchemeId}/members`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "issueSecurityLevelId": issueSecurityLevelId, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueSecurityLevelMember response = check self.clientEp-> get(path, targetType = PageBeanIssueSecurityLevelMember);
        return response;
    }
    # Get all issue types for user
    #
    # + return - Returned if the request is successful.
    remote isolated function getIssueAllTypes() returns IssueTypeDetailsArr|error {
        string  path = string `/rest/api/2/issuetype`;
        IssueTypeDetailsArr response = check self.clientEp-> get(path, targetType = IssueTypeDetailsArr);
        return response;
    }
    # Create issue type
    #
    # + payload - The request payload to create issue type
    # + return - Returned if the request is successful.
    remote isolated function createIssueType(IssueTypeCreateBean payload) returns IssueTypeDetails|error {
        string  path = string `/rest/api/2/issuetype`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        IssueTypeDetails response = check self.clientEp->post(path, request, targetType=IssueTypeDetails);
        return response;
    }
    # Get issue types for project
    #
    # + projectId - The ID of the project.
    # + level - The level of the issue type to filter by. Use:
    # + return - Returned if the request is successful.
    remote isolated function getIssueTypesForProject(int projectId, int? level = ()) returns IssueTypeDetailsArr|error {
        string  path = string `/rest/api/2/issuetype/project`;
        map<anydata> queryParam = {"projectId": projectId, "level": level};
        path = path + getPathForQueryParam(queryParam);
        IssueTypeDetailsArr response = check self.clientEp-> get(path, targetType = IssueTypeDetailsArr);
        return response;
    }
    # Get issue type
    #
    # + id - The ID of the issue type.
    # + return - Returned if the request is successful.
    remote isolated function getIssueType(string id) returns IssueTypeDetails|error {
        string  path = string `/rest/api/2/issuetype/${id}`;
        IssueTypeDetails response = check self.clientEp-> get(path, targetType = IssueTypeDetails);
        return response;
    }
    # Update issue type
    #
    # + id - The ID of the issue type.
    # + payload - The request payload to update issue type
    # + return - Returned if the request is successful.
    remote isolated function updateIssueType(string id, IssueTypeUpdateBean payload) returns IssueTypeDetails|error {
        string  path = string `/rest/api/2/issuetype/${id}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        IssueTypeDetails response = check self.clientEp->put(path, request, targetType=IssueTypeDetails);
        return response;
    }
    # Delete issue type
    #
    # + id - The ID of the issue type.
    # + alternativeIssueTypeId - The ID of the replacement issue type.
    # + return - Returned if the request is successful.
    remote isolated function deleteIssueType(string id, string? alternativeIssueTypeId = ()) returns error? {
        string  path = string `/rest/api/2/issuetype/${id}`;
        map<anydata> queryParam = {"alternativeIssueTypeId": alternativeIssueTypeId};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get alternative issue types
    #
    # + id - The ID of the issue type.
    # + return - Returned if the request is successful.
    remote isolated function getAlternativeIssueTypes(string id) returns IssueTypeDetailsArr|error {
        string  path = string `/rest/api/2/issuetype/${id}/alternatives`;
        IssueTypeDetailsArr response = check self.clientEp-> get(path, targetType = IssueTypeDetailsArr);
        return response;
    }
    # Load issue type avatar
    #
    # + id - The ID of the issue type.
    # + size - The length of each side of the crop region.
    # + payload - The request payload to load issue type avatar
    # + x - The X coordinate of the top-left corner of the crop region.
    # + y - The Y coordinate of the top-left corner of the crop region.
    # + return - Returned if the request is successful.
    remote isolated function createIssueTypeAvatar(string id, int size, json payload, int? x = 0, int? y = 0) returns Avatar|error {
        string  path = string `/rest/api/2/issuetype/${id}/avatar2`;
        map<anydata> queryParam = {"x": x, "y": y, "size": size};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        Avatar response = check self.clientEp->post(path, request, targetType=Avatar);
        return response;
    }
    # Get issue type property keys
    #
    # + issueTypeId - The ID of the issue type.
    # + return - Returned if the request is successful.
    remote isolated function getIssueTypePropertyKeys(string issueTypeId) returns PropertyKeys|error {
        string  path = string `/rest/api/2/issuetype/${issueTypeId}/properties`;
        PropertyKeys response = check self.clientEp-> get(path, targetType = PropertyKeys);
        return response;
    }
    # Get issue type property
    #
    # + issueTypeId - The ID of the issue type.
    # + propertyKey - The key of the property. Use [Get issue type property keys](#api-rest-api-2-issuetype-issueTypeId-properties-get) to get a list of all issue type property keys.
    # + return - Returned if the request is successful.
    remote isolated function getIssueTypeProperty(string issueTypeId, string propertyKey) returns EntityProperty|error {
        string  path = string `/rest/api/2/issuetype/${issueTypeId}/properties/${propertyKey}`;
        EntityProperty response = check self.clientEp-> get(path, targetType = EntityProperty);
        return response;
    }
    # Set issue type property
    #
    # + issueTypeId - The ID of the issue type.
    # + propertyKey - The key of the issue type property. The maximum length is 255 characters.
    # + payload - The request payload to set issue type property
    # + return - Returned if the issue type property is updated.
    remote isolated function setIssueTypeProperty(string issueTypeId, string propertyKey, json payload) returns json|error {
        string  path = string `/rest/api/2/issuetype/${issueTypeId}/properties/${propertyKey}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete issue type property
    #
    # + issueTypeId - The ID of the issue type.
    # + propertyKey - The key of the property. Use [Get issue type property keys](#api-rest-api-2-issuetype-issueTypeId-properties-get) to get a list of all issue type property keys.
    # + return - Returned if the issue type property is deleted.
    remote isolated function deleteIssueTypeProperty(string issueTypeId, string propertyKey) returns error? {
        string  path = string `/rest/api/2/issuetype/${issueTypeId}/properties/${propertyKey}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get all issue type schemes
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + id - The list of issue type schemes IDs. To include multiple IDs, provide an ampersand-separated list. For example, `id=10000&id=10001`.
    # + return - Returned if the request is successful.
    remote isolated function getAllIssueTypeSchemes(int? startAt = 0, int? maxResults = 50, int[]? id = ()) returns PageBeanIssueTypeScheme|error {
        string  path = string `/rest/api/2/issuetypescheme`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "id": id};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueTypeScheme response = check self.clientEp-> get(path, targetType = PageBeanIssueTypeScheme);
        return response;
    }
    # Create issue type scheme
    #
    # + payload - The request payload to create issue type scheme
    # + return - Returned if the request is successful.
    remote isolated function createIssueTypeScheme(IssueTypeSchemeDetails payload) returns IssueTypeSchemeID|error {
        string  path = string `/rest/api/2/issuetypescheme`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        IssueTypeSchemeID response = check self.clientEp->post(path, request, targetType=IssueTypeSchemeID);
        return response;
    }
    # Get issue type scheme items
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + issueTypeSchemeId - The list of issue type scheme IDs. To include multiple IDs, provide an ampersand-separated list. For example, `issueTypeSchemeId=10000&issueTypeSchemeId=10001`.
    # + return - Returned if the request is successful.
    remote isolated function getIssueTypeSchemesMapping(int? startAt = 0, int? maxResults = 50, int[]? issueTypeSchemeId = ()) returns PageBeanIssueTypeSchemeMapping|error {
        string  path = string `/rest/api/2/issuetypescheme/mapping`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "issueTypeSchemeId": issueTypeSchemeId};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueTypeSchemeMapping response = check self.clientEp-> get(path, targetType = PageBeanIssueTypeSchemeMapping);
        return response;
    }
    # Get issue type schemes for projects
    #
    # + projectId - The list of project IDs. To include multiple project IDs, provide an ampersand-separated list. For example, `projectId=10000&projectId=10001`.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getIssueTypeSchemeForProjects(int[] projectId, int? startAt = 0, int? maxResults = 50) returns PageBeanIssueTypeSchemeProjects|error {
        string  path = string `/rest/api/2/issuetypescheme/project`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "projectId": projectId};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueTypeSchemeProjects response = check self.clientEp-> get(path, targetType = PageBeanIssueTypeSchemeProjects);
        return response;
    }
    # Assign issue type scheme to project
    #
    # + payload - The request payload to assign issue type scheme to project
    # + return - Returned if the request is successful.
    remote isolated function assignIssueTypeSchemeToProject(IssueTypeSchemeProjectAssociation payload) returns json|error {
        string  path = string `/rest/api/2/issuetypescheme/project`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Update issue type scheme
    #
    # + issueTypeSchemeId - The ID of the issue type scheme.
    # + payload - The request payload to update issue type scheme
    # + return - Returned if the request is successful.
    remote isolated function updateIssueTypeScheme(int issueTypeSchemeId, IssueTypeSchemeUpdateDetails payload) returns json|error {
        string  path = string `/rest/api/2/issuetypescheme/${issueTypeSchemeId}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete issue type scheme
    #
    # + issueTypeSchemeId - The ID of the issue type scheme.
    # + return - Returned if the issue type scheme is deleted.
    remote isolated function deleteIssueTypeScheme(int issueTypeSchemeId) returns json|error {
        string  path = string `/rest/api/2/issuetypescheme/${issueTypeSchemeId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
        json response = check self.clientEp-> delete(path, request, targetType = json);
        return response;
    }
    # Add issue types to issue type scheme
    #
    # + issueTypeSchemeId - The ID of the issue type scheme.
    # + payload - The request payload to add issue types to issue type scheme
    # + return - Returned if the request is successful.
    remote isolated function addIssueTypesToIssueTypeScheme(int issueTypeSchemeId, IssueTypeIds payload) returns json|error {
        string  path = string `/rest/api/2/issuetypescheme/${issueTypeSchemeId}/issuetype`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Change order of issue types
    #
    # + issueTypeSchemeId - The ID of the issue type scheme.
    # + payload - The request payload to change order of issue types
    # + return - Returned if the request is successful.
    remote isolated function reorderIssueTypesInIssueTypeScheme(int issueTypeSchemeId, OrderOfIssueTypes payload) returns json|error {
        string  path = string `/rest/api/2/issuetypescheme/${issueTypeSchemeId}/issuetype/move`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Remove issue type from issue type scheme
    #
    # + issueTypeSchemeId - The ID of the issue type scheme.
    # + issueTypeId - The ID of the issue type.
    # + return - Returned if the request is successful.
    remote isolated function removeIssueTypeFromIssueTypeScheme(int issueTypeSchemeId, int issueTypeId) returns json|error {
        string  path = string `/rest/api/2/issuetypescheme/${issueTypeSchemeId}/issuetype/${issueTypeId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
        json response = check self.clientEp-> delete(path, request, targetType = json);
        return response;
    }
    # Get issue type screen schemes
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + id - The list of issue type screen scheme IDs. To include multiple IDs, provide an ampersand-separated list. For example, `id=10000&id=10001`.
    # + return - Returned if the request is successful.
    remote isolated function getIssueTypeScreenSchemes(int? startAt = 0, int? maxResults = 50, int[]? id = ()) returns PageBeanIssueTypeScreenScheme|error {
        string  path = string `/rest/api/2/issuetypescreenscheme`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "id": id};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueTypeScreenScheme response = check self.clientEp-> get(path, targetType = PageBeanIssueTypeScreenScheme);
        return response;
    }
    # Create issue type screen scheme
    #
    # + payload - An issue type screen scheme bean.
    # + return - Returned if the request is successful.
    remote isolated function createIssueTypeScreenScheme(IssueTypeScreenSchemeDetails payload) returns IssueTypeScreenSchemeId|error {
        string  path = string `/rest/api/2/issuetypescreenscheme`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        IssueTypeScreenSchemeId response = check self.clientEp->post(path, request, targetType=IssueTypeScreenSchemeId);
        return response;
    }
    # Get issue type screen scheme items
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + issueTypeScreenSchemeId - The list of issue type screen scheme IDs. To include multiple issue type screen schemes, separate IDs with ampersand: `issueTypeScreenSchemeId=10000&issueTypeScreenSchemeId=10001`.
    # + return - Returned if the request is successful.
    remote isolated function getIssueTypeScreenSchemeMappings(int? startAt = 0, int? maxResults = 50, int[]? issueTypeScreenSchemeId = ()) returns PageBeanIssueTypeScreenSchemeItem|error {
        string  path = string `/rest/api/2/issuetypescreenscheme/mapping`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "issueTypeScreenSchemeId": issueTypeScreenSchemeId};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueTypeScreenSchemeItem response = check self.clientEp-> get(path, targetType = PageBeanIssueTypeScreenSchemeItem);
        return response;
    }
    # Get issue type screen schemes for projects
    #
    # + projectId - The list of project IDs. To include multiple projects, separate IDs with ampersand: `projectId=10000&projectId=10001`.
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getIssueTypeScreenSchemeProjectAssociations(int[] projectId, int? startAt = 0, int? maxResults = 50) returns PageBeanIssueTypeScreenSchemesProjects|error {
        string  path = string `/rest/api/2/issuetypescreenscheme/project`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "projectId": projectId};
        path = path + getPathForQueryParam(queryParam);
        PageBeanIssueTypeScreenSchemesProjects response = check self.clientEp-> get(path, targetType = PageBeanIssueTypeScreenSchemesProjects);
        return response;
    }
    # Assign issue type screen scheme to project
    #
    # + payload - The request payload to assign issue type screen scheme to project
    # + return - Returned if the request is successful.
    remote isolated function assignIssueTypeScreenSchemeToProject(IssueTypeScreenSchemeProjectAssociation payload) returns json|error {
        string  path = string `/rest/api/2/issuetypescreenscheme/project`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Update issue type screen scheme
    #
    # + issueTypeScreenSchemeId - The ID of the issue type screen scheme.
    # + payload - The issue type screen scheme update details.
    # + return - Returned if the request is successful.
    remote isolated function updateIssueTypeScreenScheme(string issueTypeScreenSchemeId, IssueTypeScreenSchemeUpdateDetails payload) returns json|error {
        string  path = string `/rest/api/2/issuetypescreenscheme/${issueTypeScreenSchemeId}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete issue type screen scheme
    #
    # + issueTypeScreenSchemeId - The ID of the issue type screen scheme.
    # + return - Returned if the issue type screen scheme is deleted.
    remote isolated function deleteIssueTypeScreenScheme(string issueTypeScreenSchemeId) returns json|error {
        string  path = string `/rest/api/2/issuetypescreenscheme/${issueTypeScreenSchemeId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
        json response = check self.clientEp-> delete(path, request, targetType = json);
        return response;
    }
    # Append mappings to issue type screen scheme
    #
    # + issueTypeScreenSchemeId - The ID of the issue type screen scheme.
    # + payload - The request payload to append mappings to issue type screen scheme
    # + return - Returned if the request is successful.
    remote isolated function appendMappingsForIssueTypeScreenScheme(string issueTypeScreenSchemeId, IssueTypeScreenSchemeMappingDetails payload) returns json|error {
        string  path = string `/rest/api/2/issuetypescreenscheme/${issueTypeScreenSchemeId}/mapping`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Update issue type screen scheme default screen scheme
    #
    # + issueTypeScreenSchemeId - The ID of the issue type screen scheme.
    # + payload - The request payload to update issue type screen scheme
    # + return - Returned if the request is successful.
    remote isolated function updateDefaultScreenScheme(string issueTypeScreenSchemeId, UpdateDefaultScreenScheme payload) returns json|error {
        string  path = string `/rest/api/2/issuetypescreenscheme/${issueTypeScreenSchemeId}/mapping/default`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Remove mappings from issue type screen scheme
    #
    # + issueTypeScreenSchemeId - The ID of the issue type screen scheme.
    # + payload - The request payload to remove mappings from issue type screen scheme
    # + return - Returned if the screen scheme mappings are removed from the issue type screen scheme.
    remote isolated function removeMappingsFromIssueTypeScreenScheme(string issueTypeScreenSchemeId, IssueTypeIds payload) returns json|error {
        string  path = string `/rest/api/2/issuetypescreenscheme/${issueTypeScreenSchemeId}/mapping/remove`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->post(path, request, targetType=json);
        return response;
    }
    # Get field reference data (GET)
    #
    # + return - Returned if the request is successful.
    remote isolated function getAutoComplete() returns JQLReferenceData|error {
        string  path = string `/rest/api/2/jql/autocompletedata`;
        JQLReferenceData response = check self.clientEp-> get(path, targetType = JQLReferenceData);
        return response;
    }
    # Get field reference data (POST)
    #
    # + payload - The request payload to get field reference data
    # + return - Returned if the request is successful.
    remote isolated function getAutoCompletePost(SearchAutoCompleteFilter payload) returns JQLReferenceData|error {
        string  path = string `/rest/api/2/jql/autocompletedata`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        JQLReferenceData response = check self.clientEp->post(path, request, targetType=JQLReferenceData);
        return response;
    }
    # Get field auto complete suggestions
    #
    # + fieldName - The name of the field.
    # + fieldValue - The partial field item name entered by the user.
    # + predicateName - The name of the [ CHANGED operator predicate](https://confluence.atlassian.com/x/hQORLQ#Advancedsearching-operatorsreference-CHANGEDCHANGED) for which the suggestions are generated. The valid predicate operators are *by*, *from*, and *to*.
    # + predicateValue - The partial predicate item name entered by the user.
    # + return - Returned if the request is successful.
    remote isolated function getFieldAutoCompleteForQueryString(string? fieldName = (), string? fieldValue = (), string? predicateName = (), string? predicateValue = ()) returns AutoCompleteSuggestions|error {
        string  path = string `/rest/api/2/jql/autocompletedata/suggestions`;
        map<anydata> queryParam = {"fieldName": fieldName, "fieldValue": fieldValue, "predicateName": predicateName, "predicateValue": predicateValue};
        path = path + getPathForQueryParam(queryParam);
        AutoCompleteSuggestions response = check self.clientEp-> get(path, targetType = AutoCompleteSuggestions);
        return response;
    }
    # Check issues against JQL
    #
    # + payload - The request payload to check issues against JQL
    # + return - Returned if the request is successful.
    remote isolated function matchIssues(IssuesAndJQLQueries payload) returns IssueMatches|error {
        string  path = string `/rest/api/2/jql/match`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        IssueMatches response = check self.clientEp->post(path, request, targetType=IssueMatches);
        return response;
    }
    # Parse JQL query
    #
    # + payload - The request payload to parse JQL query
    # + validation - How to validate the JQL query and treat the validation results. Validation options include:
    # + return - Returned if the request is successful.
    remote isolated function parseJqlQueries(JqlQueriesToParse payload, string? validation = "strict") returns ParsedJqlQueries|error {
        string  path = string `/rest/api/2/jql/parse`;
        map<anydata> queryParam = {"validation": validation};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ParsedJqlQueries response = check self.clientEp->post(path, request, targetType=ParsedJqlQueries);
        return response;
    }
    # Convert user identifiers to account IDs in JQL queries
    #
    # + payload - The request payload to convert user identifiers to account IDs in JQL queries
    # + return - Returned if the request is successful. Note that the JQL queries are returned in the same order that they were passed.
    remote isolated function migrateQueries(JQLPersonalDataMigrationRequest payload) returns ConvertedJQLQueries|error {
        string  path = string `/rest/api/2/jql/pdcleaner`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ConvertedJQLQueries response = check self.clientEp->post(path, request, targetType=ConvertedJQLQueries);
        return response;
    }
    # Get all labels
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + return - Returned if the request is successful.
    remote isolated function getAllLabels(int? startAt = 0, int? maxResults = 1000) returns PageBeanString|error {
        string  path = string `/rest/api/2/label`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults};
        path = path + getPathForQueryParam(queryParam);
        PageBeanString response = check self.clientEp-> get(path, targetType = PageBeanString);
        return response;
    }
    # Get my permissions
    #
    # + projectKey - The key of project. Ignored if `projectId` is provided.
    # + projectId - The ID of project.
    # + issueKey - The key of the issue. Ignored if `issueId` is provided.
    # + issueId - The ID of the issue.
    # + permissions - A list of permission keys. (Required) This parameter accepts a comma-separated list. To get the list of available permissions, use [Get all permissions](#api-rest-api-2-permissions-get).
    # + projectUuid - Uuid of a project.
    # + projectConfigurationUuid - Uuid of a project configuration.
    # + return - Returned if the request is successful.
    remote isolated function getMyPermissions(string? projectKey = (), string? projectId = (), string? issueKey = (), string? issueId = (), string? permissions = (), string? projectUuid = (), string? projectConfigurationUuid = ()) returns Permissions|error {
        string  path = string `/rest/api/2/mypermissions`;
        map<anydata> queryParam = {"projectKey": projectKey, "projectId": projectId, "issueKey": issueKey, "issueId": issueId, "permissions": permissions, "projectUuid": projectUuid, "projectConfigurationUuid": projectConfigurationUuid};
        path = path + getPathForQueryParam(queryParam);
        Permissions response = check self.clientEp-> get(path, targetType = Permissions);
        return response;
    }
    # Get preference
    #
    # + 'key - The key of the preference.
    # + return - Returned if the request is successful.
    remote isolated function getPreference(string key) returns string|error {
        string  path = string `/rest/api/2/mypreferences`;
        map<anydata> queryParam = {"key": 'key};
        path = path + getPathForQueryParam(queryParam);
        string response = check self.clientEp-> get(path, targetType = string);
        return response;
    }
    # Set preference
    #
    # + 'key - The key of the preference. The maximum length is 255 characters.
    # + payload - The value of the preference as a plain text string. The maximum length is 255 characters.
    # + return - Returned if the request is successful.
    remote isolated function setPreference(string key, string payload) returns json|error {
        string  path = string `/rest/api/2/mypreferences`;
        map<anydata> queryParam = {"key": 'key};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete preference
    #
    # + 'key - The key of the preference.
    # + return - Returned if the request is successful.
    remote isolated function removePreference(string key) returns error? {
        string  path = string `/rest/api/2/mypreferences`;
        map<anydata> queryParam = {"key": 'key};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get locale
    #
    # + return - Returned if the request is successful.
    remote isolated function getLocale() returns Locale|error {
        string  path = string `/rest/api/2/mypreferences/locale`;
        Locale response = check self.clientEp-> get(path, targetType = Locale);
        return response;
    }
    # Set locale
    #
    # + payload - The locale defined in a LocaleBean.
    # + return - Returned if the request is successful.
    remote isolated function setLocale(Locale payload) returns json|error {
        string  path = string `/rest/api/2/mypreferences/locale`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete locale
    #
    # + return - Returned if the request is successful.
    remote isolated function deleteLocale() returns json|error {
        string  path = string `/rest/api/2/mypreferences/locale`;
        http:Request request = new;
        //TODO: Update the request as needed;
        json response = check self.clientEp-> delete(path, request, targetType = json);
        return response;
    }
    # Get current user
    #
    # + expand - Use [expand](#expansion) to include additional information about user in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getCurrentUser(string? expand = ()) returns User|error {
        string  path = string `/rest/api/2/myself`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        User response = check self.clientEp-> get(path, targetType = User);
        return response;
    }
    # Get notification schemes paginated
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful. Only returns notification schemes that the user has permission to access. An empty list is returned if the user lacks permission to access all notification schemes.
    remote isolated function getNotificationSchemes(int? startAt = 0, int? maxResults = 50, string? expand = ()) returns PageBeanNotificationScheme|error {
        string  path = string `/rest/api/2/notificationscheme`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PageBeanNotificationScheme response = check self.clientEp-> get(path, targetType = PageBeanNotificationScheme);
        return response;
    }
    # Get notification scheme
    #
    # + id - The ID of the notification scheme. Use [Get notification schemes paginated](#api-rest-api-2-notificationscheme-get) to get a list of notification scheme IDs.
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getNotificationScheme(int id, string? expand = ()) returns NotificationScheme|error {
        string  path = string `/rest/api/2/notificationscheme/${id}`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        NotificationScheme response = check self.clientEp-> get(path, targetType = NotificationScheme);
        return response;
    }
    # Get all permissions
    #
    # + return - Returned if the request is successful.
    remote isolated function getAllPermissions() returns Permissions|error {
        string  path = string `/rest/api/2/permissions`;
        Permissions response = check self.clientEp-> get(path, targetType = Permissions);
        return response;
    }
    # Get bulk permissions
    #
    # + payload - Details of the permissions to check.
    # + return - Returned if the request is successful.
    remote isolated function getBulkPermissions(BulkPermissionsRequestBean payload) returns BulkPermissionGrants|error {
        string  path = string `/rest/api/2/permissions/check`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        BulkPermissionGrants response = check self.clientEp->post(path, request, targetType=BulkPermissionGrants);
        return response;
    }
    # Get permitted projects
    #
    # + payload - The request payload to get permitted projects
    # + return - Returned if the request is successful.
    remote isolated function getPermittedProjects(PermissionsKeysBean payload) returns PermittedProjects|error {
        string  path = string `/rest/api/2/permissions/project`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        PermittedProjects response = check self.clientEp->post(path, request, targetType=PermittedProjects);
        return response;
    }
    # Get all permission schemes
    #
    # + expand - Use expand to include additional information in the response. This parameter accepts a comma-separated list. Note that permissions are included when you specify any value. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getAllPermissionSchemes(string? expand = ()) returns PermissionSchemes|error {
        string  path = string `/rest/api/2/permissionscheme`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PermissionSchemes response = check self.clientEp-> get(path, targetType = PermissionSchemes);
        return response;
    }
    # Create permission scheme
    #
    # + payload - The permission scheme to create.
    # + expand - Use expand to include additional information in the response. This parameter accepts a comma-separated list. Note that permissions are always included when you specify any value. Expand options include:
    # + return - Returned if the permission scheme is created.
    remote isolated function createPermissionScheme(PermissionScheme payload, string? expand = ()) returns PermissionScheme|error {
        string  path = string `/rest/api/2/permissionscheme`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        PermissionScheme response = check self.clientEp->post(path, request, targetType=PermissionScheme);
        return response;
    }
    # Get permission scheme
    #
    # + schemeId - The ID of the permission scheme to return.
    # + expand - Use expand to include additional information in the response. This parameter accepts a comma-separated list. Note that permissions are included when you specify any value. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getPermissionScheme(int schemeId, string? expand = ()) returns PermissionScheme|error {
        string  path = string `/rest/api/2/permissionscheme/${schemeId}`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PermissionScheme response = check self.clientEp-> get(path, targetType = PermissionScheme);
        return response;
    }
    # Update permission scheme
    #
    # + schemeId - The ID of the permission scheme to update.
    # + payload - The request payload to update permission scheme
    # + expand - Use expand to include additional information in the response. This parameter accepts a comma-separated list. Note that permissions are always included when you specify any value. Expand options include:
    # + return - Returned if the scheme is updated.
    remote isolated function updatePermissionScheme(int schemeId, PermissionScheme payload, string? expand = ()) returns PermissionScheme|error {
        string  path = string `/rest/api/2/permissionscheme/${schemeId}`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        PermissionScheme response = check self.clientEp->put(path, request, targetType=PermissionScheme);
        return response;
    }
    # Delete permission scheme
    #
    # + schemeId - The ID of the permission scheme being deleted.
    # + return - Returned if the permission scheme is deleted.
    remote isolated function deletePermissionScheme(int schemeId) returns error? {
        string  path = string `/rest/api/2/permissionscheme/${schemeId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get permission scheme grants
    #
    # + schemeId - The ID of the permission scheme.
    # + expand - Use expand to include additional information in the response. This parameter accepts a comma-separated list. Note that permissions are always included when you specify any value. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getPermissionSchemeGrants(int schemeId, string? expand = ()) returns PermissionGrants|error {
        string  path = string `/rest/api/2/permissionscheme/${schemeId}/permission`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PermissionGrants response = check self.clientEp-> get(path, targetType = PermissionGrants);
        return response;
    }
    # Create permission grant
    #
    # + schemeId - The ID of the permission scheme in which to create a new permission grant.
    # + payload - The permission grant to create.
    # + expand - Use expand to include additional information in the response. This parameter accepts a comma-separated list. Note that permissions are always included when you specify any value. Expand options include:
    # + return - Returned if the scheme permission is created.
    remote isolated function createPermissionGrant(int schemeId, PermissionGrant payload, string? expand = ()) returns PermissionGrant|error {
        string  path = string `/rest/api/2/permissionscheme/${schemeId}/permission`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        PermissionGrant response = check self.clientEp->post(path, request, targetType=PermissionGrant);
        return response;
    }
    # Get permission scheme grant
    #
    # + schemeId - The ID of the permission scheme.
    # + permissionId - The ID of the permission grant.
    # + expand - Use expand to include additional information in the response. This parameter accepts a comma-separated list. Note that permissions are always included when you specify any value. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getPermissionSchemeGrant(int schemeId, int permissionId, string? expand = ()) returns PermissionGrant|error {
        string  path = string `/rest/api/2/permissionscheme/${schemeId}/permission/${permissionId}`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PermissionGrant response = check self.clientEp-> get(path, targetType = PermissionGrant);
        return response;
    }
    # Delete permission scheme grant
    #
    # + schemeId - The ID of the permission scheme to delete the permission grant from.
    # + permissionId - The ID of the permission grant to delete.
    # + return - Returned if the permission grant is deleted.
    remote isolated function deletePermissionSchemeEntity(int schemeId, int permissionId) returns error? {
        string  path = string `/rest/api/2/permissionscheme/${schemeId}/permission/${permissionId}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get priorities
    #
    # + return - Returned if the request is successful.
    remote isolated function getPriorities() returns PriorityArr|error {
        string  path = string `/rest/api/2/priority`;
        PriorityArr response = check self.clientEp-> get(path, targetType = PriorityArr);
        return response;
    }
    # Get priority
    #
    # + id - The ID of the issue priority.
    # + return - Returned if the request is successful.
    remote isolated function getPriority(string id) returns Priority|error {
        string  path = string `/rest/api/2/priority/${id}`;
        Priority response = check self.clientEp-> get(path, targetType = Priority);
        return response;
    }
    # Get all projects
    #
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Expanded options include:
    # + recent - Returns the user's most recently accessed projects. You may specify the number of results to return up to a maximum of 20. If access is anonymous, then the recently accessed projects are based on the current HTTP session.
    # + properties - A list of project properties to return for the project. This parameter accepts a comma-separated list.
    # + return - Returned if the request is successful.
    remote isolated function getAllProjects(string? expand = (), int? recent = (), string[]? properties = ()) returns ProjectArr|error {
        string  path = string `/rest/api/2/project`;
        map<anydata> queryParam = {"expand": expand, "recent": recent, "properties": properties};
        path = path + getPathForQueryParam(queryParam);
        ProjectArr response = check self.clientEp-> get(path, targetType = ProjectArr);
        return response;
    }
    # Create project
    #
    # + payload - The JSON representation of the project being created.
    # + return - Returned if the project is created.
    remote isolated function createProject(CreateProjectDetails payload) returns ProjectIdentifiers|error {
        string  path = string `/rest/api/2/project`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ProjectIdentifiers response = check self.clientEp->post(path, request, targetType=ProjectIdentifiers);
        return response;
    }
    # Get projects paginated
    #
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + orderBy - [Order](#ordering) the results by a field.
    # + id - The project IDs to filter the results by. To include multiple IDs, provide an ampersand-separated list. For example, `id=10000&id=10001`. Up to 50 project IDs can be provided.
    # + query - Filter the results using a literal string. Projects with a matching `key` or `name` are returned (case insensitive).
    # + typeKey - Orders results by the [project type](https://confluence.atlassian.com/x/GwiiLQ#Jiraapplicationsoverview-Productfeaturesandprojecttypes). This parameter accepts a comma-separated list. Valid values are `business`, `service_desk`, and `software`.
    # + categoryId - The ID of the project's category. A complete list of category IDs is found using the [Get all project categories](#api-rest-api-2-projectCategory-get) operation.
    # + action - Filter results by projects for which the user can:
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Expanded options include:
    # + status - EXPERIMENTAL. Filter results by project status:
    # + properties - EXPERIMENTAL. A list of project properties to return for the project. This parameter accepts a comma-separated list.
    # + propertyQuery - EXPERIMENTAL. A query string used to search properties. The query string cannot be specified using a JSON object. For example, to search for the value of `nested` from `{"something":{"nested":1,"other":2}}` use `[thepropertykey].something.nested=1`. Note that the propertyQuery key is enclosed in square brackets to enable searching where the propertyQuery key includes dot (.) or equals (=) characters.
    # + return - Returned if the request is successful.
    remote isolated function searchProjects(int? startAt = 0, int? maxResults = 50, string? orderBy = "key", int[]? id = (), string? query = (), string? typeKey = (), int? categoryId = (), string? action = "view", string? expand = (), string[]? status = (), StringList[]? properties = (), string? propertyQuery = ()) returns PageBeanProject|error {
        string  path = string `/rest/api/2/project/search`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "orderBy": orderBy, "id": id, "query": query, "typeKey": typeKey, "categoryId": categoryId, "action": action, "expand": expand, "status": status, "properties": properties, "propertyQuery": propertyQuery};
        path = path + getPathForQueryParam(queryParam);
        PageBeanProject response = check self.clientEp-> get(path, targetType = PageBeanProject);
        return response;
    }
    # Get all project types
    #
    # + return - Returned if the request is successful.
    remote isolated function getAllProjectTypes() returns ProjectTypeArr|error {
        string  path = string `/rest/api/2/project/type`;
        ProjectTypeArr response = check self.clientEp-> get(path, targetType = ProjectTypeArr);
        return response;
    }
    # Get licensed project types
    #
    # + return - Returned if the request is successful.
    remote isolated function getAllAccessibleProjectTypes() returns ProjectTypeArr|error {
        string  path = string `/rest/api/2/project/type/accessible`;
        ProjectTypeArr response = check self.clientEp-> get(path, targetType = ProjectTypeArr);
        return response;
    }
    # Get project type by key
    #
    # + projectTypeKey - The key of the project type.
    # + return - Returned if the request is successful.
    remote isolated function getProjectTypeByKey(string projectTypeKey) returns ProjectType|error {
        string  path = string `/rest/api/2/project/type/${projectTypeKey}`;
        ProjectType response = check self.clientEp-> get(path, targetType = ProjectType);
        return response;
    }
    # Get accessible project type by key
    #
    # + projectTypeKey - The key of the project type.
    # + return - Returned if the request is successful.
    remote isolated function getAccessibleProjectTypeByKey(string projectTypeKey) returns ProjectType|error {
        string  path = string `/rest/api/2/project/type/${projectTypeKey}/accessible`;
        ProjectType response = check self.clientEp-> get(path, targetType = ProjectType);
        return response;
    }
    # Get project
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Note that the project description, issue types, and project lead are included in all responses by default. Expand options include:
    # + properties - A list of project properties to return for the project. This parameter accepts a comma-separated list.
    # + return - Returned if successful.
    remote isolated function getProject(string projectIdOrKey, string? expand = (), string[]? properties = ()) returns Project|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}`;
        map<anydata> queryParam = {"expand": expand, "properties": properties};
        path = path + getPathForQueryParam(queryParam);
        Project response = check self.clientEp-> get(path, targetType = Project);
        return response;
    }
    # Update project
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + payload - The project details to be updated.
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Note that the project description, issue types, and project lead are included in all responses by default. Expand options include:
    # + return - Returned if the project is updated.
    remote isolated function updateProject(string projectIdOrKey, UpdateProjectDetails payload, string? expand = ()) returns Project|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        Project response = check self.clientEp->put(path, request, targetType=Project);
        return response;
    }
    # Delete project
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + enableUndo - Whether this project is placed in the Jira recycle bin where it will be available for restoration.
    # + return - Returned if the project is deleted.
    remote isolated function deleteProject(string projectIdOrKey, boolean? enableUndo = false) returns error? {
        string  path = string `/rest/api/2/project/${projectIdOrKey}`;
        map<anydata> queryParam = {"enableUndo": enableUndo};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Archive project
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + return - Returned if the request is successful.
    remote isolated function archiveProject(string projectIdOrKey) returns json|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/archive`;
        http:Request request = new;
        //TODO: Update the request as needed;
        json response = check self.clientEp-> post(path, request, targetType = json);
        return response;
    }
    # Set project avatar
    #
    # + projectIdOrKey - The ID or (case-sensitive) key of the project.
    # + payload - The request payload to update project avatar
    # + return - Returned if the request is successful.
    remote isolated function updateProjectAvatar(string projectIdOrKey, Avatar payload) returns json|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/avatar`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete project avatar
    #
    # + projectIdOrKey - The project ID or (case-sensitive) key.
    # + id - The ID of the avatar.
    # + return - Returned if the request is successful.
    remote isolated function deleteProjectAvatar(string projectIdOrKey, int id) returns error? {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/avatar/${id}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Load project avatar
    #
    # + projectIdOrKey - The ID or (case-sensitive) key of the project.
    # + payload - The request payload to add project avatar
    # + x - The X coordinate of the top-left corner of the crop region.
    # + y - The Y coordinate of the top-left corner of the crop region.
    # + size - The length of each side of the crop region.
    # + return - Returned if the request is successful.
    remote isolated function createProjectAvatar(string projectIdOrKey, json payload, int? x = 0, int? y = 0, int? size = ()) returns Avatar|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/avatar2`;
        map<anydata> queryParam = {"x": x, "y": y, "size": size};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        Avatar response = check self.clientEp->post(path, request, targetType=Avatar);
        return response;
    }
    # Get all project avatars
    #
    # + projectIdOrKey - The ID or (case-sensitive) key of the project.
    # + return - Returned if request is successful.
    remote isolated function getAllProjectAvatars(string projectIdOrKey) returns ProjectAvatars|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/avatars`;
        ProjectAvatars response = check self.clientEp-> get(path, targetType = ProjectAvatars);
        return response;
    }
    # Get project components paginated
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + orderBy - [Order](#ordering) the results by a field:
    # + query - Filter the results using a literal string. Components with a matching `name` or `description` are returned (case insensitive).
    # + return - Returned if the request is successful.
    remote isolated function getProjectComponentsPaginated(string projectIdOrKey, int? startAt = 0, int? maxResults = 50, string? orderBy = (), string? query = ()) returns PageBeanComponentWithIssueCount|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/component`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "orderBy": orderBy, "query": query};
        path = path + getPathForQueryParam(queryParam);
        PageBeanComponentWithIssueCount response = check self.clientEp-> get(path, targetType = PageBeanComponentWithIssueCount);
        return response;
    }
    # Get project components
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + return - Returned if the request is successful.
    remote isolated function getProjectComponents(string projectIdOrKey) returns ProjectComponentArr|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/components`;
        ProjectComponentArr response = check self.clientEp-> get(path, targetType = ProjectComponentArr);
        return response;
    }
    # Delete project asynchronously
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + return - Returned if the request is successful.
    remote isolated function deleteProjectAsynchronously(string projectIdOrKey) returns TaskProgressBeanObject|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/delete`;
        http:Request request = new;
        //TODO: Update the request as needed;
        TaskProgressBeanObject response = check self.clientEp-> post(path, request, targetType = TaskProgressBeanObject);
        return response;
    }
    # Get project property keys
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + return - Returned if the request is successful.
    remote isolated function getProjectPropertyKeys(string projectIdOrKey) returns PropertyKeys|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/properties`;
        PropertyKeys response = check self.clientEp-> get(path, targetType = PropertyKeys);
        return response;
    }
    # Get project property
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + propertyKey - The project property key. Use [Get project property keys](#api-rest-api-2-project-projectIdOrKey-properties-get) to get a list of all project property keys.
    # + return - Returned if the request is successful.
    remote isolated function getProjectProperty(string projectIdOrKey, string propertyKey) returns EntityProperty|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/properties/${propertyKey}`;
        EntityProperty response = check self.clientEp-> get(path, targetType = EntityProperty);
        return response;
    }
    # Set project property
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + propertyKey - The key of the project property. The maximum length is 255 characters.
    # + payload - The request payload to set project property
    # + return - Returned if the project property is updated.
    remote isolated function setProjectProperty(string projectIdOrKey, string propertyKey, json payload) returns json|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/properties/${propertyKey}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Delete project property
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + propertyKey - The project property key. Use [Get project property keys](#api-rest-api-2-project-projectIdOrKey-properties-get) to get a list of all project property keys.
    # + return - Returned if the project property is deleted.
    remote isolated function deleteProjectProperty(string projectIdOrKey, string propertyKey) returns error? {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/properties/${propertyKey}`;
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Restore deleted project
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + return - Returned if the request is successful.
    remote isolated function restore(string projectIdOrKey) returns Project|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/restore`;
        http:Request request = new;
        //TODO: Update the request as needed;
        Project response = check self.clientEp-> post(path, request, targetType = Project);
        return response;
    }
    # Get project roles for project
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + return - Returned if the request is successful.
    remote isolated function getProjectRoles(string projectIdOrKey) returns json|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/role`;
        json response = check self.clientEp-> get(path, targetType = json);
        return response;
    }
    # Get project role for project
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + id - The ID of the project role. Use [Get all project roles](#api-rest-api-2-role-get) to get a list of project role IDs.
    # + return - Returned if the request is successful.
    remote isolated function getProjectRole(string projectIdOrKey, int id) returns ProjectRole|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/role/${id}`;
        ProjectRole response = check self.clientEp-> get(path, targetType = ProjectRole);
        return response;
    }
    # Set actors for project role
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + id - The ID of the project role. Use [Get all project roles](#api-rest-api-2-role-get) to get a list of project role IDs.
    # + payload - The groups or users to associate with the project role for this project. Provide the user account ID or group name.
    # + return - Returned if the request is successful. The complete list of actors for the project is returned.
    remote isolated function setActors(string projectIdOrKey, int id, ProjectRoleActorsUpdateBean payload) returns ProjectRole|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/role/${id}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ProjectRole response = check self.clientEp->put(path, request, targetType=ProjectRole);
        return response;
    }
    # Add actors to project role
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + id - The ID of the project role. Use [Get all project roles](#api-rest-api-2-role-get) to get a list of project role IDs.
    # + payload - The groups or users to associate with the project role for this project. Provide the user account ID or group name.
    # + return - Returned if the request is successful. The complete list of actors for the project is returned.
    remote isolated function addActorUsers(string projectIdOrKey, int id, ActorsMap payload) returns ProjectRole|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/role/${id}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ProjectRole response = check self.clientEp->post(path, request, targetType=ProjectRole);
        return response;
    }
    # Delete actors from project role
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + id - The ID of the project role. Use [Get all project roles](#api-rest-api-2-role-get) to get a list of project role IDs.
    # + user - The user account ID of the user to remove from the project role.
    # + 'group - The name of the group to remove from the project role.
    # + return - Returned if the request is successful.
    remote isolated function deleteActor(string projectIdOrKey, int id, string? user = (), string? 'group = ()) returns error? {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/role/${id}`;
        map<anydata> queryParam = {"user": user, "group": 'group};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        //TODO: Update the request as needed;
         _ = check self.clientEp-> delete(path, request, targetType =http:Response);
    }
    # Get project role details
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + currentMember - Whether the roles should be filtered to include only those the user is assigned to.
    # + excludeConnectAddons - Project role to exclude.
    # + return - Returned if the request is successful.
    remote isolated function getProjectRoleDetails(string projectIdOrKey, boolean? currentMember = false, boolean? excludeConnectAddons = false) returns ProjectRoleDetailsArr|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/roledetails`;
        map<anydata> queryParam = {"currentMember": currentMember, "excludeConnectAddons": excludeConnectAddons};
        path = path + getPathForQueryParam(queryParam);
        ProjectRoleDetailsArr response = check self.clientEp-> get(path, targetType = ProjectRoleDetailsArr);
        return response;
    }
    # Get all statuses for project
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + return - Returned if the request is successful.
    remote isolated function getAllStatuses(string projectIdOrKey) returns IssueTypeWithStatusArr|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/statuses`;
        IssueTypeWithStatusArr response = check self.clientEp-> get(path, targetType = IssueTypeWithStatusArr);
        return response;
    }
    # Update project type
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + newProjectTypeKey - The key of the new project type.
    # + return - Returned if the project type is updated.
    remote isolated function updateProjectType(string projectIdOrKey, string newProjectTypeKey) returns Project|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/type/${newProjectTypeKey}`;
        http:Request request = new;
        //TODO: Update the request as needed;
        Project response = check self.clientEp-> put(path, request, targetType = Project);
        return response;
    }
    # Get project versions paginated
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + startAt - The index of the first item to return in a page of results (page offset).
    # + maxResults - The maximum number of items to return per page.
    # + orderBy - [Order](#ordering) the results by a field:
    # + query - Filter the results using a literal string. Versions with matching `name` or `description` are returned (case insensitive).
    # + status - A list of status values used to filter the results by version status. This parameter accepts a comma-separated list. The status values are `released`, `unreleased`, and `archived`.
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getProjectVersionsPaginated(string projectIdOrKey, int? startAt = 0, int? maxResults = 50, string? orderBy = (), string? query = (), string? status = (), string? expand = ()) returns PageBeanVersion|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/version`;
        map<anydata> queryParam = {"startAt": startAt, "maxResults": maxResults, "orderBy": orderBy, "query": query, "status": status, "expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PageBeanVersion response = check self.clientEp-> get(path, targetType = PageBeanVersion);
        return response;
    }
    # Get project versions
    #
    # + projectIdOrKey - The project ID or project key (case sensitive).
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts `operations`, which returns actions that can be performed on the version.
    # + return - Returned if the request is successful.
    remote isolated function getProjectVersions(string projectIdOrKey, string? expand = ()) returns VersionArr|error {
        string  path = string `/rest/api/2/project/${projectIdOrKey}/versions`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        VersionArr response = check self.clientEp-> get(path, targetType = VersionArr);
        return response;
    }
    # Get project's sender email
    #
    # + projectId - The project ID.
    # + return - Returned if the request is successful.
    remote isolated function getProjectEmail(int projectId) returns ProjectEmailAddress|error {
        string  path = string `/rest/api/2/project/${projectId}/email`;
        ProjectEmailAddress response = check self.clientEp-> get(path, targetType = ProjectEmailAddress);
        return response;
    }
    # Set project's sender email
    #
    # + projectId - The project ID.
    # + payload - The project's sender email address to be set.
    # + return - Returned if the project's sender email address is successfully set.
    remote isolated function updateProjectEmail(int projectId, ProjectEmailAddress payload) returns json|error {
        string  path = string `/rest/api/2/project/${projectId}/email`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        json response = check self.clientEp->put(path, request, targetType=json);
        return response;
    }
    # Get project issue type hierarchy
    #
    # + projectId - The ID of the project.
    # + return - Returned if the request is successful.
    remote isolated function getHierarchy(int projectId) returns ProjectIssueTypeHierarchy|error {
        string  path = string `/rest/api/2/project/${projectId}/hierarchy`;
        ProjectIssueTypeHierarchy response = check self.clientEp-> get(path, targetType = ProjectIssueTypeHierarchy);
        return response;
    }
    # Get project issue security scheme
    #
    # + projectKeyOrId - The project ID or project key (case sensitive).
    # + return - Returned if the request is successful.
    remote isolated function getProjectIssueSecurityScheme(string projectKeyOrId) returns SecurityScheme|error {
        string  path = string `/rest/api/2/project/${projectKeyOrId}/issuesecuritylevelscheme`;
        SecurityScheme response = check self.clientEp-> get(path, targetType = SecurityScheme);
        return response;
    }
    # Get project notification scheme
    #
    # + projectKeyOrId - The project ID or project key (case sensitive).
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getNotificationSchemeForProject(string projectKeyOrId, string? expand = ()) returns NotificationScheme|error {
        string  path = string `/rest/api/2/project/${projectKeyOrId}/notificationscheme`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        NotificationScheme response = check self.clientEp-> get(path, targetType = NotificationScheme);
        return response;
    }
    # Get assigned permission scheme
    #
    # + projectKeyOrId - The project ID or project key (case sensitive).
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Note that permissions are included when you specify any value. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function getAssignedPermissionScheme(string projectKeyOrId, string? expand = ()) returns PermissionScheme|error {
        string  path = string `/rest/api/2/project/${projectKeyOrId}/permissionscheme`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        PermissionScheme response = check self.clientEp-> get(path, targetType = PermissionScheme);
        return response;
    }
    # Assign permission scheme
    #
    # + projectKeyOrId - The project ID or project key (case sensitive).
    # + payload - The request payload to assign permission scheme
    # + expand - Use [expand](#expansion) to include additional information in the response. This parameter accepts a comma-separated list. Note that permissions are included when you specify any value. Expand options include:
    # + return - Returned if the request is successful.
    remote isolated function assignPermissionScheme(string projectKeyOrId, IdBean payload, string? expand = ()) returns PermissionScheme|error {
        string  path = string `/rest/api/2/project/${projectKeyOrId}/permissionscheme`;
        map<anydata> queryParam = {"expand": expand};
        path = path + getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        PermissionScheme response = check self.clientEp->put(path, request, targetType=PermissionScheme);
        return response;
    }
    # Get project issue security levels
    #
    # + projectKeyOrId - The project ID or project key (case sensitive).
    # + return - Returned if the request is successful.
    remote isolated function getSecurityLevelsForProject(string projectKeyOrId) returns ProjectIssueSecurityLevels|error {
        string  path = string `/rest/api/2/project/${projectKeyOrId}/securitylevel`;
        ProjectIssueSecurityLevels response = check self.clientEp-> get(path, targetType = ProjectIssueSecurityLevels);
        return response;
    }
    # Get all project categories
    #
    # + return - Returned if the request is successful.
    remote isolated function getAllProjectCategories() returns ProjectCategoryArr|error {
        string  path = string `/rest/api/2/projectCategory`;
        ProjectCategoryArr response = check self.clientEp-> get(path, targetType = ProjectCategoryArr);
        return response;
    }
    # Create project category
    #
    # + payload - The request payload to create project category
    # + return - Returned if the request is successful.
    remote isolated function createProjectCategory(ProjectCategory payload) returns ProjectCategory|error {
        string  path = string `/rest/api/2/projectCategory`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ProjectCategory response = check self.clientEp->post(path, request, targetType=ProjectCategory);
        return response;
    }
}

# Generate query path with query parameter.
#
# + queryParam - Query parameter map
# + return - Returns generated Path or error at failure of client initialization
isolated function  getPathForQueryParam(map<anydata>   queryParam)  returns  string {
    string[] param = [];
    param[param.length()] = "?";
    foreach  var [key, value] in  queryParam.entries() {
        if  value  is  () {
            _ = queryParam.remove(key);
        } else {
            if  string:startsWith( key, "'") {
                 param[param.length()] = string:substring(key, 1, key.length());
            } else {
                param[param.length()] = key;
            }
            param[param.length()] = "=";
            if  value  is  string {
                string updateV =  checkpanic url:encode(value, "UTF-8");
                param[param.length()] = updateV;
            } else {
                param[param.length()] = value.toString();
            }
            param[param.length()] = "&";
        }
    }
    _ = param.remove(param.length()-1);
    if  param.length() ==  1 {
        _ = param.remove(0);
    }
    string restOfPath = string:'join("", ...param);
    return restOfPath;
}
