From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/9] Sync PGSQL schema with NFCT.
Date: Tue, 20 May 2008 00:31:29 +0200
Message-ID: <1211236295-30207-4-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38768 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752835AbYESWaf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 18:30:35 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sync SQL fields with NFCT keys.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/pgsql-ulogd2.sql |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index cd2d911..d174d49 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -218,15 +218,15 @@ CREATE TABLE ulog2_ct (
   orig_ip_protocol smallint default NULL,
   orig_l4_sport integer default NULL,
   orig_l4_dport integer default NULL,
-  orig_bytes bigint default 0,
-  orig_packets bigint default 0,
+  orig_raw_pktlen bigint default 0,
+  orig_raw_pktcount bigint default 0,
   reply_ip_saddr_str inet default NULL,
   reply_ip_daddr_str inet default NULL,
   reply_ip_protocol smallint default NULL,
   reply_l4_sport integer default NULL,
   reply_l4_dport integer default NULL,
-  reply_bytes bigint default 0,
-  reply_packets bigint default 0,
+  reply_raw_pktlen bigint default 0,
+  reply_raw_pktcount bigint default 0,
   icmp_code smallint default NULL,
   icmp_type smallint default NULL,
   ct_mark bigint default 0,
@@ -234,7 +234,7 @@ CREATE TABLE ulog2_ct (
   flow_start_usec bigint default 0,
   flow_end_sec bigint default 0,
   flow_end_usec bigint default 0,
-  state smallint default 0
+  ct_event smallint default 0
 ) WITH (OIDS=FALSE);
 
 CREATE INDEX ulog2_ct_oob_family ON ulog2_ct(oob_family);
@@ -246,7 +246,7 @@ CREATE INDEX ulog2_ct_orig_l4_sport ON ulog2_ct(orig_l4_sport);
 CREATE INDEX ulog2_ct_orig_l4_dport ON ulog2_ct(orig_l4_dport);
 CREATE INDEX ulog2_ct_reply_l4_sport ON ulog2_ct(reply_l4_sport);
 CREATE INDEX ulog2_ct_reply_l4_dport ON ulog2_ct(reply_l4_dport);
-CREATE INDEX ulog2_ct_state ON ulog2_ct(state);
+CREATE INDEX ulog2_ct_event ON ulog2_ct(ct_event);
 
 ALTER TABLE ulog2_ct ADD CONSTRAINT orig_l4_sport CHECK(orig_l4_sport >= 0 AND orig_l4_sport <= 65536);
 ALTER TABLE ulog2_ct ADD CONSTRAINT orig_l4_dport CHECK(orig_l4_dport >= 0 AND orig_l4_dport <= 65536);
@@ -529,15 +529,15 @@ CREATE OR REPLACE FUNCTION INSERT_CT(
                 IN _orig_ip_protocol integer,
                 IN _orig_l4_sport integer,
                 IN _orig_l4_dport integer,
-                IN _orig_bytes bigint,
-                IN _orig_packets bigint,
+                IN _orig_raw_pktlen bigint,
+                IN _orig_raw_pktcount bigint,
                 IN _reply_ip_saddr inet,
                 IN _reply_ip_daddr inet,
                 IN _reply_ip_protocol integer,
                 IN _reply_l4_sport integer,
                 IN _reply_l4_dport integer,
-                IN _reply_bytes bigint,
-                IN _reply_packets bigint,
+                IN _reply_raw_pktlen bigint,
+                IN _reply_raw_pktcount bigint,
                 IN _icmp_code integer,
                 IN _icmp_type integer,
                 IN _ct_mark bigint,
@@ -545,16 +545,16 @@ CREATE OR REPLACE FUNCTION INSERT_CT(
                 IN _flow_start_usec bigint,
                 IN _flow_end_sec bigint,
                 IN _flow_end_usec bigint,
-                IN _state smallint
+                IN _ct_event integer
         )
 RETURNS bigint AS $$
         INSERT INTO ulog2_ct (oob_family, orig_ip_saddr_str, orig_ip_daddr_str, orig_ip_protocol,
-                        orig_l4_sport, orig_l4_dport, orig_bytes, orig_packets,
+                        orig_l4_sport, orig_l4_dport, orig_raw_pktlen, orig_raw_pktcount,
                         reply_ip_saddr_str, reply_ip_daddr_str, reply_ip_protocol,
-                        reply_l4_sport, reply_l4_dport, reply_bytes, reply_packets,
+                        reply_l4_sport, reply_l4_dport, reply_raw_pktlen, reply_raw_pktcount,
                         icmp_code, icmp_type, ct_mark, 
                         flow_start_sec, flow_start_usec,
-                        flow_end_sec, flow_end_usec, state)
+                        flow_end_sec, flow_end_usec, ct_event)
                 VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23);
         SELECT currval('ulog2_ct__ct_id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
-- 
1.5.4.3

