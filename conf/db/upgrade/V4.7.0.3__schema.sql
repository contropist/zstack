ALTER TABLE `zstack`.`GuestOsCategoryVO` MODIFY COLUMN osRelease varchar(64) NOT NULL;

ALTER TABLE VolumeEO ADD COLUMN lastAttachDate bigint unsigned DEFAULT 0;
DROP VIEW IF EXISTS `zstack`.`VolumeVO`;
CREATE VIEW `zstack`.`VolumeVO` AS SELECT uuid, name, description, primaryStorageUuid, vmInstanceUuid, diskOfferingUuid, rootImageUuid, installPath, type, status, size, actualSize, deviceId, format, state, createDate, lastOpDate, isShareable, volumeQos, lastVmInstanceUuid, lastDetachDate, lastAttachDate FROM `zstack`.`VolumeEO` WHERE deleted IS NULL;

ALTER TABLE `zstack`.`VolumeSnapshotGroupRefVO` ADD COLUMN volumeLastAttachDate bigint unsigned DEFAULT 0;