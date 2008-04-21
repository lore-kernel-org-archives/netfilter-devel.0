From: Pierre Chifflier <chifflier@inl.fr>
Subject: [ULOGD PATCH 2/4] Add label option (SQL part)
Date: Mon, 21 Apr 2008 23:58:24 +0200
Message-ID: <1208815106-3315-3-git-send-email-chifflier@inl.fr>
References: <1208815106-3315-1-git-send-email-chifflier@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:45515
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271AbYDUVy5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:54:57 -0400
In-Reply-To: <1208815106-3315-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for "label" option in the SQL schema. For example, it
can be used by another module to determine if the packet has been dropped,
rejected or accepted.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
:100644 100644 00017be... bcd3ab8... M	doc/mysql-ulogd2.sql
:100644 100644 cfef267... 8e8c823... M	doc/pgsql-ulogd2.sql
 doc/mysql-ulogd2.sql |   16 ++++++++++------
 doc/pgsql-ulogd2.sql |   16 ++++++++++------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index 00017be..bcd3ab8 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -58,6 +58,7 @@ CREATE TABLE `ulog2` (
   `ip_csum` smallint(5) unsigned default NULL,
   `ip_id` smallint(5) unsigned default NULL,
   `ip_fragoff` smallint(5) unsigned default NULL,
+  `label` tinyint(3) unsigned default NULL,
   `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
   UNIQUE KEY `key_id` (`_id`)
 ) ENGINE=INNODB COMMENT='Table for IP packets';
@@ -213,7 +214,8 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
 	icmpv6_echoseq,
 	icmpv6_csum,
 	mac_saddr as mac_saddr_str,
-	mac_protocol as oob_protocol
+	mac_protocol as oob_protocol,
+	label as raw_label
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
                 LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
@@ -458,7 +460,8 @@ CREATE FUNCTION INSERT_IP_PACKET_FULL(
 	  	_ip_ihl tinyint(3) unsigned,
 	  	_ip_csum smallint(5) unsigned,
 	  	_ip_id smallint(5) unsigned,
-	  	_ip_fragoff smallint(5) unsigned
+	  	_ip_fragoff smallint(5) unsigned,
+		_label tinyint(4) unsigned
 		) RETURNS int(10) unsigned
 SQL SECURITY INVOKER
 NOT DETERMINISTIC
@@ -466,10 +469,10 @@ READS SQL DATA
 BEGIN
 	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_hook, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
 			   ip_saddr, ip_daddr, ip_protocol, ip_tos, ip_ttl, ip_totlen, ip_ihl,
-		 	   ip_csum, ip_id, ip_fragoff ) VALUES 
+		 	   ip_csum, ip_id, ip_fragoff, label ) VALUES 
 		(_oob_time_sec, _oob_time_usec, _oob_hook, _oob_prefix, _oob_mark, _oob_in, _oob_out, _oob_family,
 		 _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos, _ip_ttl, _ip_totlen, _ip_ihl,
-		 _ip_csum, _ip_id, _ip_fragoff);
+		 _ip_csum, _ip_id, _ip_fragoff, _label);
 	RETURN LAST_INSERT_ID();
 END
 $$
@@ -625,7 +628,8 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		icmpv6_echoseq smallint(5) unsigned,
 		icmpv6_csum int(10) unsigned,
 		mac_saddr varchar(32),
-		mac_protocol smallint(5)
+		mac_protocol smallint(5),
+		_label tinyint(4) unsigned
 		) RETURNS bigint unsigned
 READS SQL DATA
 BEGIN
@@ -633,7 +637,7 @@ BEGIN
 					   _oob_mark, _oob_in, _oob_out, _oob_family, 
 					   _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos,
 					   _ip_ttl, _ip_totlen, _ip_ihl, _ip_csum, _ip_id,
-					   _ip_fragoff);
+					   _ip_fragoff, _label);
 	IF _ip_protocol = 6 THEN
 		CALL PACKET_ADD_TCP_FULL(@lastid, tcp_sport, tcp_dport, tcp_seq, tcp_ackseq,
 					 tcp_window, tcp_urg, tcp_urgp, tcp_ack, tcp_psh,
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index cfef267..8e8c823 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -57,6 +57,7 @@ CREATE TABLE ulog2 (
   ip_csum integer default NULL,
   ip_id integer default NULL,
   ip_fragoff smallint default NULL,
+  label smallint default NULL,
   timestamp timestamp NOT NULL default 'now'
 ) WITH (OIDS=FALSE);
 
@@ -191,7 +192,8 @@ CREATE OR REPLACE VIEW ulog AS
         icmpv6_echoseq,
         icmpv6_csum,
         mac_saddr AS mac_saddr_str,
-        mac_protocol AS oob_protocol
+        mac_protocol AS oob_protocol,
+        label AS raw_label
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
                 LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
@@ -360,13 +362,14 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
                 IN ip_ihl integer,
                 IN ip_csum integer,
                 IN ip_id integer,
-                IN ip_fragoff integer
+                IN ip_fragoff integer,
+                IN label integer
         )
 RETURNS bigint AS $$
         INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_hook,oob_prefix,oob_mark,
                         oob_in,oob_out,oob_family,ip_saddr_str,ip_daddr_str,ip_protocol,
-                        ip_tos,ip_ttl,ip_totlen,ip_ihl,ip_csum,ip_id,ip_fragoff)
-                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18);
+                        ip_tos,ip_ttl,ip_totlen,ip_ihl,ip_csum,ip_id,ip_fragoff,label)
+                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19);
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
@@ -492,13 +495,14 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN icmpv6_echoseq integer,
                 IN icmpv6_csum integer,
                 IN mac_saddr varchar(32),
-                IN mac_protocol integer
+                IN mac_protocol integer,
+                IN label integer
         )
 RETURNS bigint AS $$
 DECLARE
         _id bigint;
 BEGIN
-        _id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18) ;
+        _id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$47);
         IF (ip_protocol = 6) THEN
                 PERFORM INSERT_TCP_FULL(_id,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30);
         ELSIF (ip_protocol = 17) THEN
-- 
1.5.5

