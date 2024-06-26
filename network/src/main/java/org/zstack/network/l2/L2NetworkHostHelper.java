package org.zstack.network.l2;

import org.springframework.beans.factory.annotation.Autowire;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;
import org.zstack.core.db.DatabaseFacade;
import org.zstack.core.db.Q;
import org.zstack.header.host.HostState;
import org.zstack.header.host.HostStatus;
import org.zstack.header.host.HostVO;
import org.zstack.header.host.HostVO_;
import org.zstack.header.network.l2.*;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static java.util.Arrays.asList;


@Configurable(preConstruction = true, autowire = Autowire.BY_TYPE)
public class L2NetworkHostHelper {
    @Autowired
    DatabaseFacade dbf;

    public void attachL2NetworkToHost(String l2NetworkUuid, String hostUuid,
                                      String providerType,
                                      L2NetworkAttachStatus status) {
        L2NetworkHostRefVO ref = Q.New(L2NetworkHostRefVO.class)
                .eq(L2NetworkHostRefVO_.l2NetworkUuid, l2NetworkUuid)
                .eq(L2NetworkHostRefVO_.hostUuid, hostUuid).find();
        if (ref != null) {
            ref.setAttachStatus(status);
            dbf.updateAndRefresh(ref);
        } else {
            L2NetworkHostRefVO vo = new L2NetworkHostRefVO();
            vo.setHostUuid(hostUuid);
            vo.setL2NetworkUuid(l2NetworkUuid);
            vo.setL2ProviderType(providerType);
            vo.setAttachStatus(status);
            dbf.persist(vo);
        }
    }

    public void attachL2NetworksToHost(List<String> l2NetworkUuids, String hostUuid,
                                       String providerType,
                                       L2NetworkAttachStatus status) {
        List<L2NetworkHostRefVO> newAdded = new ArrayList<>();
        List<L2NetworkHostRefVO> updated = new ArrayList<>();
        for (String uuid : l2NetworkUuids) {
            L2NetworkHostRefVO ref = Q.New(L2NetworkHostRefVO.class)
                    .eq(L2NetworkHostRefVO_.l2NetworkUuid, uuid)
                    .eq(L2NetworkHostRefVO_.hostUuid, hostUuid).find();
            if (ref != null) {
                ref.setAttachStatus(status);
                updated.add(ref);
            } else {
                L2NetworkHostRefVO vo = new L2NetworkHostRefVO();
                vo.setHostUuid(hostUuid);
                vo.setL2NetworkUuid(uuid);
                vo.setL2ProviderType(providerType);
                vo.setAttachStatus(status);
                newAdded.add(vo);
            }
        }

        if (!newAdded.isEmpty()) {
            dbf.persistCollection(newAdded);
        }

        if (!updated.isEmpty()) {
            dbf.updateCollection(updated);
        }
    }

    public L2NetworkHostRefInventory getL2NetworkHostRef(String l2NetworkUuid, String hostUuid) {
        L2NetworkHostRefVO ref = Q.New(L2NetworkHostRefVO.class)
                .eq(L2NetworkHostRefVO_.l2NetworkUuid, l2NetworkUuid)
                .eq(L2NetworkHostRefVO_.hostUuid, hostUuid).find();
        if (ref == null) {
            return null;
        } else {
            return L2NetworkHostRefInventory.valueOf(ref);
        }
    }

    public static Set<HostVO> getHostsByL2NetworkAttachedCluster(L2NetworkInventory l2NetworkInventory) {
        return new HashSet<>(Q.New(HostVO.class)
                .in(HostVO_.clusterUuid, l2NetworkInventory.getAttachedClusterUuids())
                .notIn(HostVO_.state,asList(HostState.PreMaintenance, HostState.Maintenance))
                .eq(HostVO_.status, HostStatus.Connected).list());
    }
}
