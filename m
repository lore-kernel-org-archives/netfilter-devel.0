From: Eric Leblond <eric@regit.org>
Subject: [PATCH 3/3] Add additional ip6 header fields to database scripts
Date: Fri, 21 Dec 2012 15:01:53 +0100
Message-ID: <1356098513-18684-4-git-send-email-eric@regit.org>
References: <1356098513-18684-1-git-send-email-eric@regit.org>
Cc: Bob Hockney <zeus@ix.netcom.com>, Eric Leblond <eric@regit.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:46342 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2LUOCz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:02:55 -0500
In-Reply-To: <1356098513-18684-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Bob Hockney <zeus@ix.netcom.com>

Rename internal keyname ip6.payload_len to remove "_"
to facilitate this.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 doc/mysql-ulogd2-flat.sql                 |   12 ++++++
 doc/mysql-ulogd2.sql                      |   63 ++++++++++++++++++++---------
 doc/pgsql-ulogd2-flat.sql                 |   12 ++++++
 doc/pgsql-ulogd2.sql                      |   46 ++++++++++++++++-----
 filter/raw2packet/ulogd_raw2packet_BASE.c |    2 +-
 output/pcap/ulogd_output_PCAP.c           |    2 +-
 util/printpkt.c                           |    2 +-
 7 files changed, 108 insertions(+), 31 deletions(-)

diff --git a/doc/mysql-ulogd2-flat.sql b/doc/mysql-ulogd2-flat.sql
index acac6aa..d71608c 100644
--- a/doc/mysql-ulogd2-flat.sql
+++ b/doc/mysql-ulogd2-flat.sql
@@ -42,6 +42,12 @@ CREATE TABLE `ulog2` (
   `ip_csum` smallint(5) unsigned default NULL,
   `ip_id` smallint(5) unsigned default NULL,
   `ip_fragoff` smallint(5) unsigned default NULL,
+  `ip6_payloadlen` smallint(5) unsigned default NULL,
+  `ip6_priority` tinyint(3) unsigned default NULL,
+  `ip6_hoplimit` tinyint(3) unsigned default NULL,
+  `ip6_flowlabel` int(10) default NULL,
+  `ip6_fragoff` smallint(5) default NULL,
+  `ip6_fragid` int(10) unsigned default NULL,
   `raw_label` tinyint(3) unsigned default NULL,
   `mac_saddr_str` varchar(32) default NULL,
   `mac_daddr_str` varchar(32) default NULL,
@@ -146,6 +152,12 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
         ip_csum,
         ip_id,
         ip_fragoff,
+        ip6_payloadlen,
+        ip6_priority,
+        ip6_hoplimit,
+        ip6_flowlabel,
+        ip6_fragoff,
+        ip6_fragid,
         tcp_sport,
         tcp_dport,
         tcp_seq,
diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index c8edd4f..c44f9a9 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -60,6 +60,12 @@ CREATE TABLE `ulog2` (
   `ip_csum` smallint(5) unsigned default NULL,
   `ip_id` smallint(5) unsigned default NULL,
   `ip_fragoff` smallint(5) unsigned default NULL,
+  `ip6_payloadlen` smallint(5) unsigned default NULL,
+  `ip6_priority` tinyint(3) unsigned default NULL,
+  `ip6_hoplimit` tinyint(3) unsigned default NULL,
+  `ip6_flowlabel` int(10) default NULL,
+  `ip6_fragoff` smallint(5) default NULL,
+  `ip6_fragid` int(10) unsigned default NULL,
   `label` tinyint(3) unsigned default NULL,
   `mac_id` bigint unsigned default NULL,
   `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
@@ -214,6 +220,12 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
         ip_csum,
         ip_id,
         ip_fragoff,
+        ip6_payloadlen,
+        ip6_priority,
+        ip6_hoplimit,
+        ip6_flowlabel,
+        ip6_fragoff,
+        ip6_fragid,
         tcp_sport,
         tcp_dport,
         tcp_seq,
@@ -502,7 +514,7 @@ NOT DETERMINISTIC
 READS SQL DATA
 BEGIN
 	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_hook, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
-			   ip_saddr, ip_daddr, ip_protocol) VALUES 
+			   ip_saddr, ip_daddr, ip_protocol) VALUES
 		(_oob_time_sec, _oob_time_usec, _oob_hook, _oob_prefix, _oob_mark, _oob_in, _oob_out, _oob_family,
 		 _ip_saddr, _ip_daddr, _ip_protocol);
 	RETURN LAST_INSERT_ID();
@@ -524,13 +536,19 @@ CREATE FUNCTION INSERT_IP_PACKET_FULL(
 		_ip_saddr binary(16),
 		_ip_daddr binary(16),
 		_ip_protocol tinyint(3) unsigned,
-	  	_ip_tos tinyint(3) unsigned,
-	  	_ip_ttl tinyint(3) unsigned,
-	  	_ip_totlen smallint(5) unsigned,
-	  	_ip_ihl tinyint(3) unsigned,
-	  	_ip_csum smallint(5) unsigned,
-	  	_ip_id smallint(5) unsigned,
-	  	_ip_fragoff smallint(5) unsigned,
+		_ip_tos tinyint(3) unsigned,
+		_ip_ttl tinyint(3) unsigned,
+		_ip_totlen smallint(5) unsigned,
+		_ip_ihl tinyint(3) unsigned,
+		_ip_csum smallint(5) unsigned,
+		_ip_id smallint(5) unsigned,
+		_ip_fragoff smallint(5) unsigned,
+		_ip6_payloadlen smallint unsigned,
+		_ip6_priority tinyint unsigned,
+		_ip6_hoplimit tinyint unsigned,
+		_ip6_flowlabel integer,
+		_ip6_fragoff smallint,
+		_ip6_fragid integer unsigned,
 		_label tinyint(4) unsigned
 		) RETURNS int(10) unsigned
 SQL SECURITY INVOKER
@@ -539,10 +557,12 @@ READS SQL DATA
 BEGIN
 	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_hook, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
 			   ip_saddr, ip_daddr, ip_protocol, ip_tos, ip_ttl, ip_totlen, ip_ihl,
-		 	   ip_csum, ip_id, ip_fragoff, label ) VALUES 
+			   ip_csum, ip_id, ip_fragoff, ip6_payloadlen, ip6_priority, ip6_hoplimit, ip6_flowlabel,
+			   ip6_fragoff, ip6_fragid, label ) VALUES
 		(_oob_time_sec, _oob_time_usec, _oob_hook, _oob_prefix, _oob_mark, _oob_in, _oob_out, _oob_family,
 		 _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos, _ip_ttl, _ip_totlen, _ip_ihl,
-		 _ip_csum, _ip_id, _ip_fragoff, _label);
+		 _ip_csum, _ip_id, _ip_fragoff, _ip6_payloadlen, _ip6_priority, _ip6_hoplimit, _ip6_flowlabel,
+		 _ip6_fragoff, _ip6_fragid, _label);
 	RETURN LAST_INSERT_ID();
 END
 $$
@@ -701,13 +721,19 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		_ip_saddr binary(16),
 		_ip_daddr binary(16),
 		_ip_protocol tinyint(3) unsigned,
-	  	_ip_tos tinyint(3) unsigned,
-	  	_ip_ttl tinyint(3) unsigned,
-	  	_ip_totlen smallint(5) unsigned,
-	  	_ip_ihl tinyint(3) unsigned,
-	  	_ip_csum smallint(5) unsigned,
-	  	_ip_id smallint(5) unsigned,
-	  	_ip_fragoff smallint(5) unsigned,
+		_ip_tos tinyint(3) unsigned,
+		_ip_ttl tinyint(3) unsigned,
+		_ip_totlen smallint(5) unsigned,
+		_ip_ihl tinyint(3) unsigned,
+		_ip_csum smallint(5) unsigned,
+		_ip_id smallint(5) unsigned,
+		_ip_fragoff smallint(5) unsigned,
+		_ip6_payloadlen smallint unsigned,
+		_ip6_priority tinyint unsigned,
+		_ip6_hoplimit tinyint unsigned,
+		_ip6_flowlabel integer,
+		_ip6_fragoff smallint,
+		_ip6_fragid integer unsigned,
 		tcp_sport smallint(5) unsigned,
 		tcp_dport smallint(5) unsigned,
 		tcp_seq int(10) unsigned,
@@ -750,7 +776,8 @@ BEGIN
 					   _oob_mark, _oob_in, _oob_out, _oob_family, 
 					   _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos,
 					   _ip_ttl, _ip_totlen, _ip_ihl, _ip_csum, _ip_id,
-					   _ip_fragoff, _label);
+					   _ip_fragoff, _ip6_payloadlen, _ip6_priority, _ip6_hoplimit,
+					   _ip6_flowlabel, _ip6_fragoff, _ip6_fragid, _label);
 	IF _ip_protocol = 6 THEN
 		CALL PACKET_ADD_TCP_FULL(@lastid, tcp_sport, tcp_dport, tcp_seq, tcp_ackseq,
 					 tcp_window, tcp_urg, tcp_urgp, tcp_ack, tcp_psh,
diff --git a/doc/pgsql-ulogd2-flat.sql b/doc/pgsql-ulogd2-flat.sql
index 9ff0ec6..6cd2150 100644
--- a/doc/pgsql-ulogd2-flat.sql
+++ b/doc/pgsql-ulogd2-flat.sql
@@ -48,6 +48,12 @@ CREATE TABLE ulog2 (
   ip_csum integer default NULL,
   ip_id integer default NULL,
   ip_fragoff smallint default NULL,
+  ip6_payloadlen bigint default NULL,
+  ip6_priority smallint default NULL,
+  ip6_hoplimit smallint default NULL,
+  ip6_flowlabel bigint default NULL,
+  ip6_fragoff integer default NULL,
+  ip6_fragid bigint default NULL,
   raw_label smallint default NULL,
   -- timestamp timestamp NOT NULL default 'now',
   mac_saddr_str macaddr default NULL,
@@ -140,6 +146,12 @@ CREATE OR REPLACE VIEW ulog AS
         ip_csum,
         ip_id,
         ip_fragoff,
+        ip6_payloadlen,
+        ip6_priority,
+        ip6_hoplimit,
+        ip6_flowlabel,
+        ip6_fragoff,
+        ip6_fragid,
         tcp_sport,
         tcp_dport,
         tcp_seq,
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index dc954ed..0e01ba4 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -60,6 +60,12 @@ CREATE TABLE ulog2 (
   ip_csum integer default NULL,
   ip_id integer default NULL,
   ip_fragoff smallint default NULL,
+  ip6_payloadlen bigint default NULL,
+  ip6_priority smallint default NULL,
+  ip6_hoplimit smallint default NULL,
+  ip6_flowlabel bigint default NULL,
+  ip6_fragoff integer default NULL,
+  ip6_fragid bigint default NULL,
   label smallint default NULL,
   mac_id bigint default NULL,
   timestamp timestamp NOT NULL default now()
@@ -197,6 +203,12 @@ CREATE OR REPLACE VIEW ulog AS
         ip_csum,
         ip_id,
         ip_fragoff,
+        ip6_payloadlen,
+        ip6_priority,
+        ip6_hoplimit,
+        ip6_flowlabel,
+        ip6_fragoff,
+        ip6_fragid,
         tcp_sport,
         tcp_dport,
         tcp_seq,
@@ -403,13 +415,21 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
                 IN ip_csum integer,
                 IN ip_id integer,
                 IN ip_fragoff integer,
+                IN ip6_payloadlen integer,
+                IN ip6_priority integer,
+                IN ip6_hoplimit integer,
+                IN ip6_flowlabel bigint,
+                IN ip6_fragoff integer,
+                IN ip6_fragid bigint,
                 IN label integer
         )
 RETURNS bigint AS $$
         INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_hook,oob_prefix,oob_mark,
                         oob_in,oob_out,oob_family,ip_saddr_str,ip_daddr_str,ip_protocol,
-                        ip_tos,ip_ttl,ip_totlen,ip_ihl,ip_csum,ip_id,ip_fragoff,label)
-                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19);
+                        ip_tos,ip_ttl,ip_totlen,ip_ihl,ip_csum,ip_id,ip_fragoff,
+                        ip6_payloadlen,ip6_priority,ip6_hoplimit,ip6_flowlabel,
+                        ip6_fragoff,ip6_fragid,label)
+                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25);
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
@@ -542,6 +562,12 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN ip_csum integer,
                 IN ip_id integer,
                 IN ip_fragoff integer,
+                IN ip6_payloadlen integer,
+                IN ip6_priority integer,
+                IN ip6_hoplimit integer,
+                IN ip6_flowlabel bigint,
+                IN ip6_fragoff integer,
+                IN ip6_fragid bigint,
                 IN tcp_sport integer,
                 IN tcp_dport integer,
                 IN tcp_seq bigint,
@@ -583,23 +609,23 @@ DECLARE
         t_id bigint;
         t_mac_id bigint;
 BEGIN
-        t_id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$50);
+        t_id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$56);
         IF (ip_protocol = 6) THEN
-                PERFORM INSERT_TCP_FULL(t_id,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30);
+                PERFORM INSERT_TCP_FULL(t_id,$25,$26,$27,$28,$29,$30,$31,$32,$33,$34,$35,$36);
         ELSIF (ip_protocol = 17) THEN
-                PERFORM INSERT_UDP(t_id,$31,$32,$33);
+                PERFORM INSERT_UDP(t_id,$37,$38,$39);
         ELSIF (ip_protocol = 132) THEN
-                PERFORM INSERT_SCTP(t_id,$51,$52,$53);
+                PERFORM INSERT_SCTP(t_id,$57,$58,$59);
         ELSIF (ip_protocol = 1) THEN
-                PERFORM INSERT_ICMP(t_id,$34,$35,$36,$37,$38,$39);
+                PERFORM INSERT_ICMP(t_id,$40,$41,$42,$43,$44,$45);
         ELSIF (ip_protocol = 58) THEN
-                PERFORM INSERT_ICMPV6(t_id,$40,$41,$42,$43,$44);
+                PERFORM INSERT_ICMPV6(t_id,$46,$47,$48,$49,$50);
         END IF;
         IF (raw_type = 1) THEN
-                t_mac_id = INSERT_OR_SELECT_MAC($47::macaddr,$48::macaddr,$49);
+                t_mac_id = INSERT_OR_SELECT_MAC($53::macaddr,$54::macaddr,$55);
                 UPDATE ulog2 SET mac_id = t_mac_id WHERE _id = t_id;
         ELSE
-                PERFORM INSERT_HARDWARE_HEADER(t_id,$45,$46);
+                PERFORM INSERT_HARDWARE_HEADER(t_id,$51,$52);
         END IF;
         RETURN t_id;
 END
diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 05141b8..9ae838d 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -209,7 +209,7 @@ static struct ulogd_key iphdr_rets[] = {
 	[KEY_IP6_PAYLOAD_LEN] = {
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
-		.name = "ip6.payload_len",
+		.name = "ip6.payloadlen",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_payloadLengthIPv6,
diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index 7b0ce31..2d3f001 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -139,7 +139,7 @@ static struct ulogd_key pcap_keys[INTR_IDS] = {
 	  .name = "oob.family" },
 	{ .type = ULOGD_RET_UINT16,
 	  .flags = ULOGD_RETF_NONE,
-	  .name = "ip6.payload_len" },
+	  .name = "ip6.payloadlen" },
 };
 
 #define GET_FLAGS(res, x)	(res[x].u.source->flags)
diff --git a/util/printpkt.c b/util/printpkt.c
index 5250792..9eb339b 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -62,7 +62,7 @@ struct ulogd_key printpkt_keys[] = {
 	[KEY_IP_ID]		= { .name = "ip.id", },
 	[KEY_IP_FRAGOFF]	= { .name = "ip.fragoff", },
 	[KEY_IP_PROTOCOL]	= { .name = "ip.protocol", },
-	[KEY_IP6_PAYLOAD_LEN]	= { .name = "ip6.payload_len" },
+	[KEY_IP6_PAYLOAD_LEN]	= { .name = "ip6.payloadlen" },
 	[KEY_IP6_PRIORITY]	= { .name = "ip6.priority" },
 	[KEY_IP6_HOPLIMIT]	= { .name = "ip6.hoplimit" },
 	[KEY_IP6_FLOWLABEL]	= { .name = "ip6.flowlabel" },
-- 
1.7.10.4

