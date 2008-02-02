From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 18/34]  Update schema for PostgreSQL.
Date: Sat,  2 Feb 2008 22:24:13 +0100
Message-ID: <1201987471346-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
 <12019874703897-git-send-email-eric@inl.fr>
 <12019874712066-git-send-email-eric@inl.fr>
 <1201987471474-git-send-email-eric@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>, Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:45999 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761704AbYBBWOY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:14:24 -0500
In-Reply-To: <1201987471474-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pierre Chifflier <chifflier@inl.fr>

This patch add _str suffix to inet types (needed after IP2STR introduction)

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 016abc8... d6e6efd... M	doc/pgsql-ulogd2.sql
 doc/pgsql-ulogd2.sql |   46 +++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 016abc8..d6e6efd 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -44,8 +44,8 @@ CREATE TABLE ulog2 (
   oob_mark integer default NULL,
   oob_in varchar(32) default NULL,
   oob_out varchar(32) default NULL,
-  ip_saddr inet default NULL,
-  ip_daddr inet default NULL,
+  ip_saddr_str inet default NULL,
+  ip_daddr_str inet default NULL,
   ip_protocol smallint default NULL,
   ip_tos smallint default NULL,
   ip_ttl smallint default NULL,
@@ -58,8 +58,8 @@ CREATE TABLE ulog2 (
 ) WITH (OIDS=FALSE);
 
 CREATE INDEX ulog2_timestamp ON ulog2(timestamp);
-CREATE INDEX ulog2_ip_saddr ON ulog2(ip_saddr);
-CREATE INDEX ulog2_ip_daddr ON ulog2(ip_daddr);
+CREATE INDEX ulog2_ip_saddr ON ulog2(ip_saddr_str);
+CREATE INDEX ulog2_ip_daddr ON ulog2(ip_daddr_str);
 
 CREATE TABLE mac (
   _mac_id bigint PRIMARY KEY UNIQUE NOT NULL,
@@ -136,10 +136,10 @@ CREATE OR REPLACE VIEW ulog AS
 
 -- shortcuts
 CREATE OR REPLACE VIEW view_tcp_quad AS
-        SELECT ulog2._id,ulog2.ip_saddr,tcp.tcp_sport,ulog2.ip_daddr,tcp.tcp_dport FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id;
+        SELECT ulog2._id,ulog2.ip_saddr_str,tcp.tcp_sport,ulog2.ip_daddr_str,tcp.tcp_dport FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id;
 
 CREATE OR REPLACE VIEW view_udp_quad AS
-        SELECT ulog2._id,ulog2.ip_saddr,udp.udp_sport,ulog2.ip_daddr,udp.udp_dport FROM ulog2 INNER JOIN udp ON ulog2._id = udp._udp_id;
+        SELECT ulog2._id,ulog2.ip_saddr_str,udp.udp_sport,ulog2.ip_daddr_str,udp.udp_dport FROM ulog2 INNER JOIN udp ON ulog2._id = udp._udp_id;
 
 -- 
 -- conntrack
@@ -148,15 +148,15 @@ DROP SEQUENCE IF EXISTS ulog2_ct__ct_id_seq;
 CREATE SEQUENCE ulog2_ct__ct_id_seq;
 CREATE TABLE ulog2_ct (
   _ct_id bigint PRIMARY KEY UNIQUE NOT NULL DEFAULT nextval('ulog2_ct__ct_id_seq'),
-  orig_ip_saddr inet default NULL,
-  orig_ip_daddr inet default NULL,
+  orig_ip_saddr_str inet default NULL,
+  orig_ip_daddr_str inet default NULL,
   orig_ip_protocol smallint default NULL,
   orig_l4_sport integer default NULL,
   orig_l4_dport integer default NULL,
   orig_bytes bigint default 0,
   orig_packets bigint default 0,
-  reply_ip_saddr inet default NULL,
-  reply_ip_daddr inet default NULL,
+  reply_ip_saddr_str inet default NULL,
+  reply_ip_daddr_str inet default NULL,
   reply_ip_protocol smallint default NULL,
   reply_l4_sport integer default NULL,
   reply_l4_dport integer default NULL,
@@ -172,10 +172,10 @@ CREATE TABLE ulog2_ct (
   state smallint default 0
 ) WITH (OIDS=FALSE);
 
-CREATE INDEX ulog2_ct_orig_ip_saddr ON ulog2_ct(orig_ip_saddr);
-CREATE INDEX ulog2_ct_orig_ip_daddr ON ulog2_ct(orig_ip_daddr);
-CREATE INDEX ulog2_ct_reply_ip_saddr ON ulog2_ct(reply_ip_saddr);
-CREATE INDEX ulog2_ct_reply_ip_daddr ON ulog2_ct(reply_ip_daddr);
+CREATE INDEX ulog2_ct_orig_ip_saddr ON ulog2_ct(orig_ip_saddr_str);
+CREATE INDEX ulog2_ct_orig_ip_daddr ON ulog2_ct(orig_ip_daddr_str);
+CREATE INDEX ulog2_ct_reply_ip_saddr ON ulog2_ct(reply_ip_saddr_str);
+CREATE INDEX ulog2_ct_reply_ip_daddr ON ulog2_ct(reply_ip_daddr_str);
 CREATE INDEX ulog2_ct_orig_l4_sport ON ulog2_ct(orig_l4_sport);
 CREATE INDEX ulog2_ct_orig_l4_dport ON ulog2_ct(orig_l4_dport);
 CREATE INDEX ulog2_ct_reply_l4_sport ON ulog2_ct(reply_l4_sport);
@@ -263,13 +263,13 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET(
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
-                IN ip_saddr inet,
-                IN ip_daddr inet,
+                IN ip_saddr_str inet,
+                IN ip_daddr_str inet,
                 IN ip_protocol smallint
         )
 RETURNS bigint AS $$
         INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_prefix,oob_mark,
-                        oob_in,oob_out,ip_saddr,ip_daddr,ip_protocol)
+                        oob_in,oob_out,ip_saddr_str,ip_daddr_str,ip_protocol)
                 VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9);
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
@@ -282,8 +282,8 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
-                IN ip_saddr inet,
-                IN ip_daddr inet,
+                IN ip_saddr_str inet,
+                IN ip_daddr_str inet,
                 IN ip_protocol smallint,
                 IN ip_tos smallint,
                 IN ip_ttl smallint,
@@ -295,7 +295,7 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
         )
 RETURNS bigint AS $$
         INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_prefix,oob_mark,
-                        oob_in,oob_out,ip_saddr,ip_daddr,ip_protocol,
+                        oob_in,oob_out,ip_saddr_str,ip_daddr_str,ip_protocol,
                         ip_tos,ip_ttl,ip_totlen,ip_ihl,ip_csum,ip_id,ip_fragoff)
                 VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16);
         SELECT currval('ulog2__id_seq');
@@ -371,8 +371,8 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
-                IN ip_saddr inet,
-                IN ip_daddr inet,
+                IN ip_saddr_str inet,
+                IN ip_daddr_str inet,
                 IN ip_protocol smallint,
                 IN ip_tos smallint,
                 IN ip_ttl smallint,
@@ -498,4 +498,4 @@ $$ LANGUAGE SQL SECURITY INVOKER;
 -- Add foreign keys to tables
 SELECT ULOG2_ADD_FOREIGN_KEYS();
 
-
+-- Pierre Chifflier <chifflier AT inl DOT fr>
-- 
1.5.2.5

