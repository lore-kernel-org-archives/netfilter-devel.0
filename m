From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/4] Add INSERT_OR_REPLACE_CT pgsql function.
Date: Thu, 15 May 2008 00:54:37 +0200
Message-ID: <1210805679-11813-3-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:33854 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752582AbYENWy3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 18:54:29 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new function which insert or update connection tracking
entries depending on the event type parameter.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/pgsql-ulogd2.sql |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index d174d49..20f5014 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -559,6 +559,67 @@ RETURNS bigint AS $$
         SELECT currval('ulog2_ct__ct_id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
+CREATE OR REPLACE FUNCTION INSERT_OR_REPLACE_CT(
+                IN _oob_family integer,
+                IN _orig_ip_saddr inet,
+                IN _orig_ip_daddr inet,
+                IN _orig_ip_protocol integer,
+                IN _orig_l4_sport integer,
+                IN _orig_l4_dport integer,
+                IN _orig_raw_pktlen bigint,
+                IN _orig_raw_pktcount bigint,
+                IN _reply_ip_saddr inet,
+                IN _reply_ip_daddr inet,
+                IN _reply_ip_protocol integer,
+                IN _reply_l4_sport integer,
+                IN _reply_l4_dport integer,
+                IN _reply_raw_pktlen bigint,
+                IN _reply_raw_pktcount bigint,
+                IN _icmp_code integer,
+                IN _icmp_type integer,
+                IN _ct_mark bigint,
+                IN _flow_start_sec bigint,
+                IN _flow_start_usec bigint,
+                IN _flow_end_sec bigint,
+                IN _flow_end_usec bigint,
+                IN _ct_event integer
+        )
+RETURNS bigint AS $$
+DECLARE
+        _id bigint;
+BEGIN
+        IF (_ct_event = 4) THEN
+          if (_orig_ip_protocol = 1) THEN
+            UPDATE ulog2_ct SET (orig_raw_pktlen, orig_raw_pktcount,
+                reply_raw_pktlen, reply_raw_pktcount,
+                ct_mark, flow_end_sec, flow_end_usec, ct_event)
+                = ($7,$8,$14,$15,$18,$21,$22,$23)
+            WHERE oob_family=$1 AND orig_ip_saddr_str = $2
+                AND orig_ip_daddr_str = $3 AND orig_ip_protocol = $4
+                AND reply_ip_saddr_str = $9 AND reply_ip_daddr_str = $10
+                AND reply_ip_protocol = $11
+                AND icmp_code = $16 AND icmp_type = $17 
+                AND ct_event < 4;
+          ELSE
+            UPDATE ulog2_ct SET (orig_raw_pktlen, orig_raw_pktcount,
+                reply_raw_pktlen, reply_raw_pktcount,
+                ct_mark, flow_end_sec, flow_end_usec, ct_event)
+                = ($7,$8,$14,$15,$18,$21,$22,$23)
+            WHERE oob_family=$1 AND orig_ip_saddr_str = $2
+                AND orig_ip_daddr_str = $3 AND orig_ip_protocol = $4
+                AND orig_l4_sport = $5 AND orig_l4_dport = $6
+                AND reply_ip_saddr_str = $9 AND reply_ip_daddr_str = $10
+                AND reply_ip_protocol = $11 AND reply_l4_sport = $12
+                AND reply_l4_dport = $13 
+                AND ct_event < 4;
+          END IF;
+        ELSE
+          _id := INSERT_CT($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23);
+        END IF;
+        RETURN _id;
+END
+$$ LANGUAGE plpgsql SECURITY INVOKER;
+
 
 
 
-- 
1.5.4.3

