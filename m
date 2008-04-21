From: Pierre Chifflier <chifflier@inl.fr>
Subject: [ULOGD PATCH 4/4] Add function INSERT_CT for conntrack (PostgreSQL)
Date: Mon, 21 Apr 2008 23:58:26 +0200
Message-ID: <1208815106-3315-5-git-send-email-chifflier@inl.fr>
References: <1208815106-3315-1-git-send-email-chifflier@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from neuf-infra-smtp-out-sp604006av.neufgp.fr ([84.96.92.121]:42893
	"EHLO neuf-infra-smtp-out-sp604006av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbYDUWA3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:00:29 -0400
In-Reply-To: <1208815106-3315-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update PostgreSQL schema to add the insert procedure for conntrack
connections.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
:100644 100644 8e8c823... cd2d911... M	doc/pgsql-ulogd2.sql
 doc/pgsql-ulogd2.sql |   48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 8e8c823..cd2d911 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -230,10 +230,10 @@ CREATE TABLE ulog2_ct (
   icmp_code smallint default NULL,
   icmp_type smallint default NULL,
   ct_mark bigint default 0,
-  flow_start_sec integer default 0,
-  flow_start_usec integer default 0,
-  flow_end_sec integer default 0,
-  flow_end_usec integer default 0,
+  flow_start_sec bigint default 0,
+  flow_start_usec bigint default 0,
+  flow_end_sec bigint default 0,
+  flow_end_usec bigint default 0,
   state smallint default 0
 ) WITH (OIDS=FALSE);
 
@@ -522,6 +522,46 @@ $$ LANGUAGE plpgsql SECURITY INVOKER;
 
 
 
+CREATE OR REPLACE FUNCTION INSERT_CT(
+                IN _oob_family integer,
+                IN _orig_ip_saddr inet,
+                IN _orig_ip_daddr inet,
+                IN _orig_ip_protocol integer,
+                IN _orig_l4_sport integer,
+                IN _orig_l4_dport integer,
+                IN _orig_bytes bigint,
+                IN _orig_packets bigint,
+                IN _reply_ip_saddr inet,
+                IN _reply_ip_daddr inet,
+                IN _reply_ip_protocol integer,
+                IN _reply_l4_sport integer,
+                IN _reply_l4_dport integer,
+                IN _reply_bytes bigint,
+                IN _reply_packets bigint,
+                IN _icmp_code integer,
+                IN _icmp_type integer,
+                IN _ct_mark bigint,
+                IN _flow_start_sec bigint,
+                IN _flow_start_usec bigint,
+                IN _flow_end_sec bigint,
+                IN _flow_end_usec bigint,
+                IN _state smallint
+        )
+RETURNS bigint AS $$
+        INSERT INTO ulog2_ct (oob_family, orig_ip_saddr_str, orig_ip_daddr_str, orig_ip_protocol,
+                        orig_l4_sport, orig_l4_dport, orig_bytes, orig_packets,
+                        reply_ip_saddr_str, reply_ip_daddr_str, reply_ip_protocol,
+                        reply_l4_sport, reply_l4_dport, reply_bytes, reply_packets,
+                        icmp_code, icmp_type, ct_mark, 
+                        flow_start_sec, flow_start_usec,
+                        flow_end_sec, flow_end_usec, state)
+                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23);
+        SELECT currval('ulog2_ct__ct_id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
+
+
+
 CREATE OR REPLACE FUNCTION DELETE_PACKET(
                 IN _packet_id bigint
         )
-- 
1.5.5

