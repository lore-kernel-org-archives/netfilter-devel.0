From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/8] Add hook to list of fields in database for packet logging.
Date: Sun,  9 Mar 2008 23:36:22 +0100
Message-ID: <12051021891470-git-send-email-eric@inl.fr>
References: <12051021893015-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57589 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752828AbYCIWgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:36:32 -0400
In-Reply-To: <12051021893015-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds oob.hook to the list of fields export to the databases. This
adds the capability to know where the packet has been logged and will be used
to make a link between connection and logged packets.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/mysql-ulogd2.sql |   17 +++++++++++------
 doc/pgsql-ulogd2.sql |   20 ++++++++++++--------
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index b154c74..1265eba 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -14,7 +14,7 @@ CREATE TABLE `_format` (
   `version` int(4) NOT NULL
 ) ENGINE=INNODB;
 
-INSERT INTO _format (version) VALUES (5);
+INSERT INTO _format (version) VALUES (6);
 
 -- this table could be used to know which user-defined tables are linked
 -- to ulog
@@ -42,6 +42,7 @@ CREATE TABLE `ulog2` (
   `_id` bigint unsigned NOT NULL auto_increment,
   `oob_time_sec` int(10) unsigned default NULL,
   `oob_time_usec` int(10) unsigned default NULL,
+  `oob_hook` tinyint(3) unsigned default NULL,
   `oob_prefix` varchar(32) default NULL,
   `oob_mark` int(10) unsigned default NULL,
   `oob_in` varchar(32) default NULL,
@@ -171,6 +172,7 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
         SELECT _id,
         oob_time_sec,
         oob_time_usec,
+        oob_hook,
         oob_prefix,
         oob_mark,
         oob_in,
@@ -417,6 +419,7 @@ DROP FUNCTION IF EXISTS INSERT_IP_PACKET;
 CREATE FUNCTION INSERT_IP_PACKET(
 		_oob_time_sec int(10) unsigned,
 		_oob_time_usec int(10) unsigned,
+		_oob_hook tinyint(3) unsigned,
 		_oob_prefix varchar(32),
 		_oob_mark int(10) unsigned,
 		_oob_in varchar(32),
@@ -430,9 +433,9 @@ SQL SECURITY INVOKER
 NOT DETERMINISTIC
 READS SQL DATA
 BEGIN
-	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
+	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_hook, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
 			   ip_saddr, ip_daddr, ip_protocol) VALUES 
-		(_oob_time_sec, _oob_time_usec, _oob_prefix, _oob_mark, _oob_in, _oob_out, _oob_family,
+		(_oob_time_sec, _oob_time_usec, _oob_hook, _oob_prefix, _oob_mark, _oob_in, _oob_out, _oob_family,
 		 _ip_saddr, _ip_daddr, _ip_protocol);
 	RETURN LAST_INSERT_ID();
 END
@@ -443,6 +446,7 @@ DROP FUNCTION IF EXISTS INSERT_IP_PACKET_FULL;
 CREATE FUNCTION INSERT_IP_PACKET_FULL(
 		_oob_time_sec int(10) unsigned,
 		_oob_time_usec int(10) unsigned,
+		_oob_hook tinyint(3) unsigned,
 		_oob_prefix varchar(32),
 		_oob_mark int(10) unsigned,
 		_oob_in varchar(32),
@@ -463,10 +467,10 @@ SQL SECURITY INVOKER
 NOT DETERMINISTIC
 READS SQL DATA
 BEGIN
-	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
+	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_hook, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
 			   ip_saddr, ip_daddr, ip_protocol, ip_tos, ip_ttl, ip_totlen, ip_ihl,
 		 	   ip_csum, ip_id, ip_fragoff ) VALUES 
-		(_oob_time_sec, _oob_time_usec, _oob_prefix, _oob_mark, _oob_in, _oob_out, _oob_family,
+		(_oob_time_sec, _oob_time_usec, _oob_hook, _oob_prefix, _oob_mark, _oob_in, _oob_out, _oob_family,
 		 _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos, _ip_ttl, _ip_totlen, _ip_ihl,
 		 _ip_csum, _ip_id, _ip_fragoff);
 	RETURN LAST_INSERT_ID();
@@ -582,6 +586,7 @@ DROP FUNCTION IF EXISTS INSERT_PACKET_FULL;
 CREATE FUNCTION INSERT_PACKET_FULL(
 		_oob_time_sec int(10) unsigned,
 		_oob_time_usec int(10) unsigned,
+		_oob_hook tinyint(3) unsigned,
 		_oob_prefix varchar(32),
 		_oob_mark int(10) unsigned,
 		_oob_in varchar(32),
@@ -629,7 +634,7 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		) RETURNS bigint unsigned
 READS SQL DATA
 BEGIN
-	SET @lastid = INSERT_IP_PACKET_FULL(_oob_time_sec, _oob_time_usec, _oob_prefix,
+	SET @lastid = INSERT_IP_PACKET_FULL(_oob_time_sec, _oob_time_usec, _oob_hook, _oob_prefix,
 					   _oob_mark, _oob_in, _oob_out, _oob_family, 
 					   _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos,
 					   _ip_ttl, _ip_totlen, _ip_ihl, _ip_csum, _ip_id,
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 87a85fb..f4359ed 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -13,7 +13,7 @@ CREATE TABLE _format (
   version integer
 ) WITH (OIDS=FALSE);
 
-INSERT INTO _format (version) VALUES (5);
+INSERT INTO _format (version) VALUES (6);
 
 -- this table could be used to know which user-defined tables are linked
 -- to ulog
@@ -41,6 +41,7 @@ CREATE TABLE ulog2 (
   _id bigint PRIMARY KEY UNIQUE NOT NULL DEFAULT nextval('ulog2__id_seq'),
   oob_time_sec integer default NULL,
   oob_time_usec integer default NULL,
+  oob_hook smallint default NULL,
   oob_prefix varchar(32) default NULL,
   oob_mark integer default NULL,
   oob_in varchar(32) default NULL,
@@ -149,6 +150,7 @@ CREATE OR REPLACE VIEW ulog AS
         SELECT _id,
         oob_time_sec,
         oob_time_usec,
+        oob_hook,
         oob_prefix,
         oob_mark,
         oob_in,
@@ -343,6 +345,7 @@ $$ LANGUAGE SQL SECURITY INVOKER;
 CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
                 IN oob_time_sec integer,
                 IN oob_time_usec integer,
+                IN oob_hook integer,
                 IN oob_prefix varchar(32),
                 IN oob_mark integer,
                 IN oob_in varchar(32),
@@ -360,10 +363,10 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
                 IN ip_fragoff integer
         )
 RETURNS bigint AS $$
-        INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_prefix,oob_mark,
+        INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_hook,oob_prefix,oob_mark,
                         oob_in,oob_out,oob_family,ip_saddr_str,ip_daddr_str,ip_protocol,
                         ip_tos,ip_ttl,ip_totlen,ip_ihl,ip_csum,ip_id,ip_fragoff)
-                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17);
+                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18);
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
@@ -436,6 +439,7 @@ $$ LANGUAGE SQL SECURITY INVOKER;
 CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN oob_time_sec integer,
                 IN oob_time_usec integer,
+                IN oob_hook integer,
                 IN oob_prefix varchar(32),
                 IN oob_mark integer,
                 IN oob_in varchar(32),
@@ -482,15 +486,15 @@ RETURNS bigint AS $$
 DECLARE
         _id bigint;
 BEGIN
-        _id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17) ;
+        _id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18) ;
         IF (ip_protocol = 6) THEN
-                PERFORM INSERT_TCP_FULL(_id,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29);
+                PERFORM INSERT_TCP_FULL(_id,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30);
         ELSIF (ip_protocol = 17) THEN
-                PERFORM INSERT_UDP(_id,$30,$31,$32);
+                PERFORM INSERT_UDP(_id,$31,$32,$33);
         ELSIF (ip_protocol = 1) THEN
-                PERFORM INSERT_ICMP(_id,$33,$34,$35,$36,$37,$38);
+                PERFORM INSERT_ICMP(_id,$34,$35,$36,$37,$38,$39);
         ELSIF (ip_protocol = 58) THEN
-                PERFORM INSERT_ICMPV6(_id,$39,$40,$41,$42,$43);
+                PERFORM INSERT_ICMPV6(_id,$40,$41,$42,$43,$44);
         END IF;
         RETURN _id;
 END
-- 
1.5.4.3

