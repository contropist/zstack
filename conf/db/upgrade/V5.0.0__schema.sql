UPDATE ImageEO SET md5sum = NULL where md5sum != 'not calculated';

ALTER TABLE `zstack`.`LoadBalancerVO` DROP FOREIGN KEY `fkLoadBalancerVOVipVO`;
ALTER TABLE `zstack`.`LoadBalancerVO` MODIFY COLUMN vipUuid varchar(32) DEFAULT NULL;
ALTER TABLE `zstack`.`LoadBalancerVO` ADD CONSTRAINT `fkLoadBalancerVOVipVO` FOREIGN KEY (`vipUuid`) REFERENCES `zstack`.`VipVO` (`uuid`) ON DELETE SET NULL;

ALTER TABLE `zstack`.`LoadBalancerVO` ADD COLUMN `ipv6VipUuid` varchar(32) DEFAULT null;
ALTER TABLE `zstack`.`LoadBalancerVO` ADD CONSTRAINT `fkLoadBalancerVOIpv6VipVO` FOREIGN KEY (`ipv6VipUuid`) REFERENCES `zstack`.`VipVO` (`uuid`) ON DELETE SET NULL;

ALTER TABLE `zstack`.`LoadBalancerServerGroupVmNicRefVO` ADD COLUMN `ipVersion` int(10) unsigned DEFAULT 4;

UPDATE `zstack`.`VipVO` SET `system` = 0 where `uuid` in (select lb.vipUuid from `zstack`.`LoadBalancerVO` lb, `zstack`.`SlbLoadBalancerVO` slb where lb.uuid = slb.uuid);

update EventSubscriptionVO set name = 'Host Hardware Changed' where uuid = '829d96de006043c3b34202861ca82078';

CREATE TABLE  `zstack`.`SNSWeComEndpointVO` (
    `uuid` varchar(32) NOT NULL UNIQUE,
    `url` varchar(1024) NOT NULL,
    `atAll` int(1) unsigned NOT NULL,
    PRIMARY KEY  (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  `zstack`.`SNSWeComAtPersonVO` (
    `uuid` varchar(32) NOT NULL UNIQUE,
    `userId` varchar(64) NOT NULL,
    `endpointUuid` varchar(32) NOT NULL,
    `remark` varchar(128) default '' null,
    `lastOpDate` timestamp ON UPDATE CURRENT_TIMESTAMP,
    `createDate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
    PRIMARY KEY  (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  `zstack`.`SNSFeiShuEndpointVO` (
    `uuid` varchar(32) NOT NULL UNIQUE,
    `url` varchar(1024) NOT NULL,
    `atAll` int(1) unsigned NOT NULL,
    `secret` varchar(128) default '' null,
    PRIMARY KEY  (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  `zstack`.`SNSFeiShuAtPersonVO` (
    `uuid` varchar(32) NOT NULL UNIQUE,
    `userId` varchar(64) NOT NULL,
    `endpointUuid` varchar(32) NOT NULL,
    `remark` varchar(128) default '' null,
    `lastOpDate` timestamp ON UPDATE CURRENT_TIMESTAMP,
    `createDate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
    PRIMARY KEY  (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table SNSDingTalkEndpointVO
    add secret varchar(128) default '' null;

alter table SNSDingTalkAtPersonVO
    add lastOpDate timestamp ON UPDATE CURRENT_TIMESTAMP;

alter table SNSDingTalkAtPersonVO
    add createDate timestamp NULL DEFAULT '0000-00-00 00:00:00';
    
UPDATE SNSDingTalkAtPersonVO
SET createDate = CURRENT_TIMESTAMP,
    lastOpDate = CURRENT_TIMESTAMP;

alter table SNSDingTalkAtPersonVO
    add remark varchar(128) default '' null;

CREATE TABLE IF NOT EXISTS `zstack`.`EthernetVfPciDeviceVO` (
    `uuid` varchar(32) NOT NULL UNIQUE,
    `hostDevUuid` varchar(32) DEFAULT NULL,
    `interfaceName` varchar(32) DEFAULT NULL,
    `vmUuid` varchar(32) DEFAULT NULL,
    `l3NetworkUuid` varchar(32) DEFAULT NULL,
    `vfStatus` varchar(32) NOT NULL,
    PRIMARY KEY  (`uuid`),
    CONSTRAINT `fkEthernetVfPciDeviceVOVmInstanceEO` FOREIGN KEY (`vmUuid`) REFERENCES `VmInstanceEO` (`uuid`) ON DELETE SET NULL,
    CONSTRAINT `fkEthernetVfPciDeviceVOHostEO` FOREIGN KEY (`hostDevUuid`) REFERENCES `HostEO` (`uuid`) ON DELETE CASCADE,
    CONSTRAINT `fkEthernetVfPciDeviceVO` FOREIGN KEY (`uuid`) REFERENCES `PciDeviceVO` (`uuid`) ON DELETE CASCADE,
    CONSTRAINT `fkEthernetVfPciDeviceVOL3NetworkEO` FOREIGN KEY (`l3NetworkUuid`) REFERENCES `L3NetworkEO` (`uuid`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE ConsoleProxyVO ADD COLUMN `expiredDate` timestamp NOT NULL;

delete from EncryptEntityMetadataVO where entityName = 'IAM2VirtualIDVO' and state = 'NeedDecrypt';

ALTER TABLE `SecretResourcePoolVO` ADD COLUMN `ability` varchar(256) NOT NULL DEFAULT 'All';

CREATE TABLE IF NOT EXISTS `zstack`.`JitSecurityMachineVO` (
    `uuid` varchar(32) NOT NULL UNIQUE,
    `port` int unsigned NOT NULL,
    PRIMARY KEY  (`uuid`),
    CONSTRAINT fkJitSecurityMachineVOSecurityMachineVO FOREIGN KEY (uuid) REFERENCES SecurityMachineVO (uuid) ON UPDATE RESTRICT ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `zstack`.`AgentVersionVO` ADD CONSTRAINT fkAgentVersionVOResourceVO FOREIGN KEY (uuid) REFERENCES ResourceVO (uuid) ON DELETE CASCADE;

ALTER TABLE `zstack`.`HostNetworkInterfaceVO` ADD COLUMN `virtStatus` VARCHAR(32) DEFAULT NULL AFTER `offloadStatus`;

CREATE TABLE IF NOT EXISTS `zstack`.`ExternalPrimaryStorageVO` (
    `uuid`            varchar(32)  NOT NULL,
    `identity`        varchar(32)  NOT NULL,
    `config`          varchar(255)  DEFAULT NULL,
    `password`        varchar(255)  DEFAULT NULL,
    `addonInfo`       varchar(2048) DEFAULT NULL,
    `defaultProtocol` varchar(255) NOT NULL,
    PRIMARY KEY (`uuid`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS `zstack`.`PrimaryStorageOutputProtocolRefVO` (
    `id`                 bigint unsigned NOT NULL UNIQUE AUTO_INCREMENT,
    `primaryStorageUuid` varchar(32)     NOT NULL,
    `outputProtocol`     varchar(255)    NOT NULL,
    `createDate`         timestamp       NOT NULL DEFAULT '0000-00-00 00:00:00',
    `lastOpDate`         timestamp       NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fkPrimaryStorageOutputProtocolRefVOExternalPrimaryStorageVO` FOREIGN KEY (`primaryStorageUuid`) REFERENCES ExternalPrimaryStorageVO (`uuid`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE VolumeEO ADD COLUMN protocol VARCHAR(32) DEFAULT NULL;

DROP VIEW IF EXISTS `zstack`.`VolumeVO`;
CREATE VIEW `zstack`.`VolumeVO` AS SELECT uuid, name, description, primaryStorageUuid, vmInstanceUuid, diskOfferingUuid,
    rootImageUuid, installPath, type, status, size, actualSize, deviceId, format, state, createDate, lastOpDate,
    isShareable, volumeQos, lastVmInstanceUuid, lastDetachDate, lastAttachDate, protocol FROM `zstack`.`VolumeEO` WHERE deleted IS NULL;

ALTER TABLE VmCdRomVO ADD COLUMN protocol VARCHAR(32) DEFAULT NULL;
