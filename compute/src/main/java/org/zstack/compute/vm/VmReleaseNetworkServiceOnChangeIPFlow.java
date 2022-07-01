package org.zstack.compute.vm;

import org.springframework.beans.factory.annotation.Autowire;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;
import org.zstack.core.componentloader.PluginRegistry;
import org.zstack.header.core.workflow.Flow;
import org.zstack.header.core.workflow.FlowRollback;
import org.zstack.header.core.workflow.FlowTrigger;
import org.zstack.header.core.Completion;
import org.zstack.header.core.workflow.NoRollbackFlow;
import org.zstack.header.errorcode.ErrorCode;
import org.zstack.header.vm.VmInstanceConstant;
import org.zstack.header.vm.VmInstanceDeletionPolicyManager;
import org.zstack.header.vm.VmInstanceSpec;
import org.zstack.network.service.NetworkServiceManager;
import org.zstack.utils.Utils;
import org.zstack.utils.logging.CLogger;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

@Configurable(preConstruction = true, autowire = Autowire.BY_TYPE)
public class VmReleaseNetworkServiceOnChangeIPFlow implements Flow {
    private static final CLogger logger = Utils.getLogger(VmReleaseNetworkServiceOnChangeIPFlow.class);

    @Autowired
    private NetworkServiceManager nsMgr;

    @Override
    public void run(FlowTrigger trigger, Map data) {
        VmInstanceSpec spec = (VmInstanceSpec) data.get(VmInstanceConstant.Params.VmInstanceSpec.toString());
        nsMgr.releaseNetworkServiceOnChangeIP(spec, null, new Completion(trigger) {
            @Override
            public void success() {
                trigger.next();
            }

            @Override
            public void fail(ErrorCode errorCode) {
                trigger.fail(errorCode);
            }
        });
    }

    @Override
    public void rollback(FlowRollback trigger, Map data) {
        trigger.rollback();
    }
}
