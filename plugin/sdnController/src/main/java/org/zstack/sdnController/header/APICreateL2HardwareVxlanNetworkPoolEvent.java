package org.zstack.sdnController.header;

import org.zstack.header.network.l2.APICreateL2NetworkEvent;
import org.zstack.header.rest.RestResponse;

/**
 * Created by shixin.ruan on 09/30/2019.
 */
@RestResponse(allTo = "inventory")
public class APICreateL2HardwareVxlanNetworkPoolEvent extends APICreateL2NetworkEvent {
    public APICreateL2HardwareVxlanNetworkPoolEvent(String apiId) {
        super(apiId);
    }

    public APICreateL2HardwareVxlanNetworkPoolEvent() {
        super(null);
    }

    public static APICreateL2HardwareVxlanNetworkPoolEvent __example__() {
        APICreateL2HardwareVxlanNetworkPoolEvent event = new APICreateL2HardwareVxlanNetworkPoolEvent();
        HardwareL2VxlanNetworkPoolInventory net = new HardwareL2VxlanNetworkPoolInventory();

        net.setName("Test-NetPool");
        net.setDescription("Test");
        net.setZoneUuid(uuid());
        net.setType(SdnControllerConstant.HARDWARE_VXLAN_NETWORK_POOL_TYPE);
        net.setSdnControllerUuid(uuid());

        event.setInventory(net);
        return event;
    }
}
