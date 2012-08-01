From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/5] pgsql schema: add nfacct table
Date: Wed,  1 Aug 2012 23:27:13 +0200
Message-ID: <1343856436-11129-3-git-send-email-eric@regit.org>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49517 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab2HAV2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:28:35 -0400
In-Reply-To: <1343856436-11129-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a nfacct table to the postgresql schema. It enables
the storage of all counters at each poll.
---
 doc/pgsql-ulogd2.sql |   22 ++++++++++++++++++++++
 ulogd.conf.in        |    8 ++++++++
 2 files changed, 30 insertions(+)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 8f47bf9..0fc2b45 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -33,6 +33,7 @@ DROP TABLE IF EXISTS sctp CASCADE;
 DROP TABLE IF EXISTS icmp CASCADE;
 DROP TABLE IF EXISTS icmpv6 CASCADE;
 DROP TABLE IF EXISTS nufw CASCADE;
+DROP TABLE IF EXISTS nfacct CASCADE;
 DROP TABLE IF EXISTS ulog2_ct CASCADE;
 DROP TABLE IF EXISTS ulog2 CASCADE;
 
@@ -149,6 +150,16 @@ CREATE TABLE icmpv6 (
   icmpv6_csum integer default NULL
 ) WITH (OIDS=FALSE);
 
+CREATE TABLE nfacct (
+  sum_name varchar(128),
+  sum_pkts integer default 0,
+  sum_bytes integer default 0,
+  oob_time_sec integer default NULL,
+  oob_time_usec integer default NULL
+) WITH (OIDS=FALSE);
+
+CREATE UNIQUE INDEX unique_acct ON nfacct(sum_name, oob_time_sec, oob_time_usec);
+
 -- 
 -- VIEWS
 -- 
@@ -696,6 +707,17 @@ END
 $$ LANGUAGE plpgsql SECURITY INVOKER;
 
 
+CREATE OR REPLACE FUNCTION INSERT_NFACCT(
+                IN sum_name varchar(128),
+                IN sum_pkts integer,
+                IN sum_bytes integer,
+                IN oob_time_sec integer,
+                IN oob_time_usec integer
+        )
+RETURNS void AS $$
+        INSERT INTO nfacct (sum_name,sum_pkts,sum_bytes,oob_time_sec,oob_time_usec)
+                VALUES ($1,$2,$3,$4,$5);
+$$ LANGUAGE SQL SECURITY INVOKER;
 
 
 CREATE OR REPLACE FUNCTION DELETE_PACKET(
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 879ab3c..0e45714 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -232,6 +232,14 @@ table="ulog2_ct"
 pass="changeme"
 procedure="INSERT_OR_REPLACE_CT"
 
+[pgsql4]
+db="nulog"
+host="localhost"
+user="nupik"
+table="nfacct"
+pass="changeme"
+procedure="INSERT_NFACCT"
+
 [dbi1]
 db="ulog2"
 dbtype="pgsql"
-- 
1.7.10.4

