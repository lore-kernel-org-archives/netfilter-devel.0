From: Pierre Chifflier <chifflier@inl.fr>
Subject: [ULOGD PATCH] Store only one copy of mac address in SQL DB
Date: Tue,  3 Jun 2008 15:41:08 +0200
Message-ID: <1212500468-32377-1-git-send-email-chifflier@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:39024 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYFCOWq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 10:22:46 -0400
Received: from piche.inl.fr ([192.168.33.181])
	by fydelkass.inl.fr with esmtp (Exim 4.63)
	(envelope-from <p.chifflier@inl.fr>)
	id 1K3XPR-00039G-4t
	for netfilter-devel@vger.kernel.org; Tue, 03 Jun 2008 16:22:45 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the SQL schema for MySQL and PostgreSQL to store
the mac address only once (instead of duplicating the mac address for
each packet).
This is done by using a shared reference to the entry containing the
tuple (mac_address,mac_protocol).

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 doc/mysql-ulogd2.sql |   32 +++++++++++++++++------------
 doc/pgsql-ulogd2.sql |   53 ++++++++++++++++++++++++++++++++-----------------
 2 files changed, 53 insertions(+), 32 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index ba50f48..8659c38 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -59,6 +59,7 @@ CREATE TABLE `ulog2` (
   `ip_id` smallint(5) unsigned default NULL,
   `ip_fragoff` smallint(5) unsigned default NULL,
   `label` tinyint(3) unsigned default NULL,
+  `mac_id` bigint unsigned default NULL,
   `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
   UNIQUE KEY `key_id` (`_id`)
 ) ENGINE=INNODB COMMENT='Table for IP packets';
@@ -72,13 +73,13 @@ ALTER TABLE ulog2 ADD KEY `timestamp` (`timestamp`);
 -- ALTER TABLE ulog2 ADD KEY `oob_time_sec` (`oob_time_sec`);
 
 CREATE TABLE `mac` (
-  `_mac_id` bigint unsigned NOT NULL,
+  `_mac_id` bigint unsigned NOT NULL auto_increment,
   `mac_saddr` varchar(32) default NULL,
-  `mac_protocol` smallint(5) default NULL
+  `mac_protocol` smallint(5) default NULL,
+  UNIQUE KEY `key_id` (`_mac_id`)
 ) ENGINE=INNODB;
 
-ALTER TABLE mac ADD UNIQUE KEY `_mac_id` (`_mac_id`);
-ALTER TABLE mac ADD KEY `mac_saddr` (`mac_saddr`);
+ALTER TABLE mac ADD UNIQUE KEY `mac_saddr` (`mac_saddr`,`mac_protocol`);
 ALTER TABLE mac ADD KEY `index_mac_id` (`_mac_id`);
 
 CREATE TABLE `tcp` (
@@ -603,15 +604,17 @@ $$
 
 
 delimiter $$
-DROP PROCEDURE IF EXISTS PACKET_ADD_MAC;
-CREATE PROCEDURE PACKET_ADD_MAC(
-		IN `id` int(10) unsigned,
-		IN `_saddr` varchar(32),
-		IN `_protocol` smallint(5)
-		)
+DROP FUNCTION IF EXISTS INSERT_OR_SELECT_MAC;
+CREATE FUNCTION INSERT_OR_SELECT_MAC(
+		`_saddr` varchar(32),
+		`_protocol` smallint(5)
+		) RETURNS bigint unsigned
+NOT DETERMINISTIC
+READS SQL DATA
 BEGIN
-	INSERT INTO mac (_mac_id, mac_saddr, mac_protocol) VALUES
-	(id, _saddr, _protocol);
+	INSERT IGNORE INTO mac (mac_saddr, mac_protocol) VALUES (_saddr, _protocol);
+	SELECT _mac_id FROM mac WHERE mac_saddr = _saddr AND mac_protocol = _protocol INTO @last_id;
+	RETURN @last_id;
 END
 $$
 
@@ -687,7 +690,10 @@ BEGIN
 				       icmpv6_echoseq, icmpv6_csum);
 	END IF;
 	IF mac_protocol IS NOT NULL THEN
-		CALL PACKET_ADD_MAC(@lastid, mac_saddr, mac_protocol);
+		SET @mac_id = INSERT_OR_SELECT_MAC(mac_saddr, mac_protocol);
+		IF @mac_id IS NOT NULL THEN
+			UPDATE ulog2 SET mac_id = @mac_id WHERE _id = @lastid;
+		END IF;
 	END IF;
 	RETURN @lastid;
 END
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 20f5014..b7e0038 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -58,6 +58,7 @@ CREATE TABLE ulog2 (
   ip_id integer default NULL,
   ip_fragoff smallint default NULL,
   label smallint default NULL,
+  mac_id bigint default NULL,
   timestamp timestamp NOT NULL default 'now'
 ) WITH (OIDS=FALSE);
 
@@ -66,13 +67,16 @@ CREATE INDEX ulog2_ip_saddr ON ulog2(ip_saddr_str);
 CREATE INDEX ulog2_ip_daddr ON ulog2(ip_daddr_str);
 CREATE INDEX ulog2_timestamp ON ulog2(timestamp);
 
+DROP SEQUENCE IF EXISTS mac__id_seq;
+CREATE SEQUENCE mac__id_seq;
 CREATE TABLE mac (
-  _mac_id bigint PRIMARY KEY UNIQUE NOT NULL,
-  mac_saddr macaddr default NULL,
+  _mac_id bigint PRIMARY KEY UNIQUE NOT NULL DEFAULT nextval('mac__id_seq'),
+  mac_saddr macaddr NOT NULL,
   mac_protocol smallint default NULL
 ) WITH (OIDS=FALSE);
 
 CREATE INDEX mac_saddr ON mac(mac_saddr);
+CREATE UNIQUE INDEX unique_mac ON mac(mac_saddr,mac_protocol);
 
 CREATE TABLE tcp (
   _tcp_id bigint PRIMARY KEY UNIQUE NOT NULL,
@@ -195,7 +199,8 @@ CREATE OR REPLACE VIEW ulog AS
         mac_protocol AS oob_protocol,
         label AS raw_label
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
-                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
+                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id
+                LEFT JOIN mac ON ulog2.mac_id = mac._mac_id
                 LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
 
 -- shortcuts
@@ -308,6 +313,7 @@ INSERT INTO _extensions (ext_name,table_name,join_name) VALUES
 
 CREATE OR REPLACE FUNCTION ULOG2_DROP_FOREIGN_KEYS()
 RETURNS void AS $$
+  ALTER TABLE ulog2 DROP CONSTRAINT mac_id_fk;
   ALTER TABLE icmpv6 DROP CONSTRAINT icmpv6_id_fk;
   ALTER TABLE icmp DROP CONSTRAINT icmp_id_fk;
   ALTER TABLE udp  DROP CONSTRAINT udp_id_fk;
@@ -321,6 +327,7 @@ RETURNS void AS $$
   ALTER TABLE udp  ADD CONSTRAINT udp_id_fk  FOREIGN KEY (_udp_id)  REFERENCES ulog2(_id);
   ALTER TABLE icmp ADD CONSTRAINT icmp_id_fk FOREIGN KEY (_icmp_id) REFERENCES ulog2(_id);
   ALTER TABLE icmpv6 ADD CONSTRAINT icmpv6_id_fk FOREIGN KEY (_icmpv6_id) REFERENCES ulog2(_id);
+  ALTER TABLE ulog2 ADD CONSTRAINT mac_id_fk FOREIGN KEY (mac_id) REFERENCES mac(_mac_id);
 $$ LANGUAGE SQL SECURITY INVOKER;
 
 
@@ -436,16 +443,22 @@ RETURNS bigint AS $$
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
-CREATE OR REPLACE FUNCTION INSERT_MAC(
-                IN mac_id bigint,
-                IN mac_saddr macaddr,
-                IN mac_protocol integer
+CREATE OR REPLACE FUNCTION INSERT_OR_SELECT_MAC(
+                IN in_mac_saddr macaddr,
+                IN in_mac_protocol integer
         )
 RETURNS bigint AS $$
-        INSERT INTO mac (_mac_id,mac_saddr,mac_protocol)
-                VALUES ($1,$2,$3);
-        SELECT currval('ulog2__id_seq');
-$$ LANGUAGE SQL SECURITY INVOKER;
+DECLARE
+        _id bigint;
+BEGIN
+        SELECT INTO _id _mac_id FROM mac WHERE mac_saddr = $1 AND mac_protocol = $2;
+        IF NOT FOUND THEN
+                INSERT INTO mac (mac_saddr,mac_protocol) VALUES ($1,$2) RETURNING _mac_id INTO _id;
+                RETURN _id;
+        END IF;
+        RETURN _id;
+END
+$$ LANGUAGE plpgsql SECURITY INVOKER;
 
 -- this function requires plpgsql
 -- su -c "createlang plpgsql ulog2" postgres
@@ -500,22 +513,24 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
         )
 RETURNS bigint AS $$
 DECLARE
-        _id bigint;
+        t_id bigint;
+        t_mac_id bigint;
 BEGIN
-        _id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$47);
+        t_id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$47);
         IF (ip_protocol = 6) THEN
-                PERFORM INSERT_TCP_FULL(_id,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30);
+                PERFORM INSERT_TCP_FULL(t_id,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30);
         ELSIF (ip_protocol = 17) THEN
-                PERFORM INSERT_UDP(_id,$31,$32,$33);
+                PERFORM INSERT_UDP(t_id,$31,$32,$33);
         ELSIF (ip_protocol = 1) THEN
-                PERFORM INSERT_ICMP(_id,$34,$35,$36,$37,$38,$39);
+                PERFORM INSERT_ICMP(t_id,$34,$35,$36,$37,$38,$39);
         ELSIF (ip_protocol = 58) THEN
-                PERFORM INSERT_ICMPV6(_id,$40,$41,$42,$43,$44);
+                PERFORM INSERT_ICMPV6(t_id,$40,$41,$42,$43,$44);
         END IF;
         IF (mac_saddr IS NOT NULL) THEN
-                PERFORM INSERT_MAC(_id,$45::macaddr,$46);
+                t_mac_id = INSERT_OR_SELECT_MAC($45::macaddr,$46);
+                UPDATE ulog2 SET mac_id = t_mac_id WHERE _id = t_id;
         END IF;
-        RETURN _id;
+        RETURN t_id;
 END
 $$ LANGUAGE plpgsql SECURITY INVOKER;
 
-- 
1.5.5.3

