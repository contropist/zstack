package org.zstack.sdk.zwatch.monitorgroup.entity;

import org.zstack.sdk.zwatch.monitorgroup.entity.MonitorGroupState;

public class MonitorGroupInventory  {

    public java.lang.String name;
    public void setName(java.lang.String name) {
        this.name = name;
    }
    public java.lang.String getName() {
        return this.name;
    }

    public MonitorGroupState state;
    public void setState(MonitorGroupState state) {
        this.state = state;
    }
    public MonitorGroupState getState() {
        return this.state;
    }

    public java.lang.String actions;
    public void setActions(java.lang.String actions) {
        this.actions = actions;
    }
    public java.lang.String getActions() {
        return this.actions;
    }

    public java.lang.String description;
    public void setDescription(java.lang.String description) {
        this.description = description;
    }
    public java.lang.String getDescription() {
        return this.description;
    }

    public java.sql.Timestamp createDate;
    public void setCreateDate(java.sql.Timestamp createDate) {
        this.createDate = createDate;
    }
    public java.sql.Timestamp getCreateDate() {
        return this.createDate;
    }

    public java.sql.Timestamp lastOpDate;
    public void setLastOpDate(java.sql.Timestamp lastOpDate) {
        this.lastOpDate = lastOpDate;
    }
    public java.sql.Timestamp getLastOpDate() {
        return this.lastOpDate;
    }

    public java.lang.String uuid;
    public void setUuid(java.lang.String uuid) {
        this.uuid = uuid;
    }
    public java.lang.String getUuid() {
        return this.uuid;
    }

    public java.util.List monitorGroupTemplateRefs;
    public void setMonitorGroupTemplateRefs(java.util.List monitorGroupTemplateRefs) {
        this.monitorGroupTemplateRefs = monitorGroupTemplateRefs;
    }
    public java.util.List getMonitorGroupTemplateRefs() {
        return this.monitorGroupTemplateRefs;
    }

}
