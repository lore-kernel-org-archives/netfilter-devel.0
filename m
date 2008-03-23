From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 07/14] MAC address handling in PgSQL output plugin.
Date: Sun, 23 Mar 2008 17:25:15 +0100
Message-ID: <12062895233805-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55048 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752742AbYCWQZZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:25 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds MAC address handling to the postgresql output plugin.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/pgsql-ulogd2.sql |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index f4359ed..fc4aa1b 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -68,12 +68,10 @@ CREATE INDEX ulog2_timestamp ON ulog2(timestamp);
 CREATE TABLE mac (
   _mac_id bigint PRIMARY KEY UNIQUE NOT NULL,
   mac_saddr macaddr default NULL,
-  mac_daddr macaddr default NULL,
   mac_protocol smallint default NULL
 ) WITH (OIDS=FALSE);
 
 CREATE INDEX mac_saddr ON mac(mac_saddr);
-CREATE INDEX mac_daddr ON mac(mac_daddr);
 
 CREATE TABLE tcp (
   _tcp_id bigint PRIMARY KEY UNIQUE NOT NULL,
@@ -191,7 +189,9 @@ CREATE OR REPLACE VIEW ulog AS
         icmpv6_code,
         icmpv6_echoid,
         icmpv6_echoseq,
-        icmpv6_csum
+        icmpv6_csum,
+        mac_saddr AS mac_saddr_str,
+        mac_protocol AS oob_protocol
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
                 LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
@@ -433,6 +433,16 @@ RETURNS bigint AS $$
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
+CREATE OR REPLACE FUNCTION INSERT_MAC(
+                IN mac_id bigint,
+                IN mac_saddr macaddr,
+                IN mac_protocol integer
+        )
+RETURNS bigint AS $$
+        INSERT INTO mac (_mac_id,mac_saddr,mac_protocol)
+                VALUES ($1,$2,$3);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
 
 -- this function requires plpgsql
 -- su -c "createlang plpgsql ulog2" postgres
@@ -480,7 +490,9 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN icmpv6_code integer,
                 IN icmpv6_echoid integer,
                 IN icmpv6_echoseq integer,
-                IN icmpv6_csum integer
+                IN icmpv6_csum integer,
+                IN mac_saddr varchar(32),
+                IN mac_protocol integer
         )
 RETURNS bigint AS $$
 DECLARE
@@ -496,6 +508,9 @@ BEGIN
         ELSIF (ip_protocol = 58) THEN
                 PERFORM INSERT_ICMPV6(_id,$40,$41,$42,$43,$44);
         END IF;
+        IF (mac_saddr IS NOT NULL) THEN
+                PERFORM INSERT_MAC(_id,$45::macaddr,$46);
+        END IF;
         RETURN _id;
 END
 $$ LANGUAGE plpgsql SECURITY INVOKER;
-- 
1.5.2.5

