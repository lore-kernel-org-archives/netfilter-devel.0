From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 12/14] Add state support to PGSQL output module.
Date: Sun, 23 Mar 2008 17:25:20 +0100
Message-ID: <12062895232878-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55054 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752867AbYCWQZ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:26 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds raw.state support to the PGSQL module. It creates a state_t
table to store the state of the packets.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/pgsql-ulogd2.sql |   40 ++++++++++++++++++++++++++++++++++------
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index fc4aa1b..b18f4a8 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -25,6 +25,7 @@ CREATE TABLE _extensions (
   join_name varchar(64) NOT NULL
 ) WITH (OIDS=FALSE);
 
+DROP TABLE IF EXISTS state_t CASCADE;
 DROP TABLE IF EXISTS mac CASCADE;
 DROP TABLE IF EXISTS tcp CASCADE;
 DROP TABLE IF EXISTS udp CASCADE;
@@ -65,6 +66,13 @@ CREATE INDEX ulog2_ip_saddr ON ulog2(ip_saddr_str);
 CREATE INDEX ulog2_ip_daddr ON ulog2(ip_daddr_str);
 CREATE INDEX ulog2_timestamp ON ulog2(timestamp);
 
+CREATE TABLE state_t (
+  _state_id bigint PRIMARY KEY UNIQUE NOT NULL,
+  state smallint default NULL
+) WITH (OIDS=FALSE);
+
+CREATE INDEX state ON state_t(state);
+
 CREATE TABLE mac (
   _mac_id bigint PRIMARY KEY UNIQUE NOT NULL,
   mac_saddr macaddr default NULL,
@@ -191,10 +199,12 @@ CREATE OR REPLACE VIEW ulog AS
         icmpv6_echoseq,
         icmpv6_csum,
         mac_saddr AS mac_saddr_str,
-        mac_protocol AS oob_protocol
+        mac_protocol AS oob_protocol,
+        state AS raw_state
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
-                LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
+                LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id
+                LEFT JOIN state_t ON ulog2._id = state_t._state_id;
 
 -- shortcuts
 CREATE OR REPLACE VIEW view_tcp_quad AS
@@ -306,6 +316,8 @@ INSERT INTO _extensions (ext_name,table_name,join_name) VALUES
 
 CREATE OR REPLACE FUNCTION ULOG2_DROP_FOREIGN_KEYS()
 RETURNS void AS $$
+  ALTER TABLE state_t DROP CONSTRAINT state_id_fk;
+  ALTER TABLE mac DROP CONSTRAINT mac_id_fk;
   ALTER TABLE icmpv6 DROP CONSTRAINT icmpv6_id_fk;
   ALTER TABLE icmp DROP CONSTRAINT icmp_id_fk;
   ALTER TABLE udp  DROP CONSTRAINT udp_id_fk;
@@ -319,6 +331,8 @@ RETURNS void AS $$
   ALTER TABLE udp  ADD CONSTRAINT udp_id_fk  FOREIGN KEY (_udp_id)  REFERENCES ulog2(_id);
   ALTER TABLE icmp ADD CONSTRAINT icmp_id_fk FOREIGN KEY (_icmp_id) REFERENCES ulog2(_id);
   ALTER TABLE icmpv6 ADD CONSTRAINT icmpv6_id_fk FOREIGN KEY (_icmpv6_id) REFERENCES ulog2(_id);
+  ALTER TABLE mac ADD CONSTRAINT mac_id_fk FOREIGN KEY (_mac_id) REFERENCES ulog2(_id);
+  ALTER TABLE state_t ADD CONSTRAINT state_id_fk FOREIGN KEY (_state_id) REFERENCES ulog2(_id);
 $$ LANGUAGE SQL SECURITY INVOKER;
 
 
@@ -433,6 +447,16 @@ RETURNS bigint AS $$
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
+CREATE OR REPLACE FUNCTION INSERT_STATE(
+                IN state_id bigint,
+                IN state integer
+        )
+RETURNS bigint AS $$
+        INSERT INTO state_t (_state_id,state)
+                VALUES ($1,$2);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
 CREATE OR REPLACE FUNCTION INSERT_MAC(
                 IN mac_id bigint,
                 IN mac_saddr macaddr,
@@ -492,7 +516,8 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN icmpv6_echoseq integer,
                 IN icmpv6_csum integer,
                 IN mac_saddr varchar(32),
-                IN mac_protocol integer
+                IN mac_protocol integer,
+                IN state integer
         )
 RETURNS bigint AS $$
 DECLARE
@@ -511,13 +536,13 @@ BEGIN
         IF (mac_saddr IS NOT NULL) THEN
                 PERFORM INSERT_MAC(_id,$45::macaddr,$46);
         END IF;
+        IF (state IS NOT NULL) THEN
+                PERFORM INSERT_STATE(_id,$47);
+        END IF;
         RETURN _id;
 END
 $$ LANGUAGE plpgsql SECURITY INVOKER;
 
-
-
-
 CREATE OR REPLACE FUNCTION DELETE_PACKET(
                 IN _packet_id bigint
         )
@@ -526,6 +551,8 @@ RETURNS void AS $$
   DELETE FROM icmp  WHERE icmp._icmp_id = $1;
   DELETE FROM tcp   WHERE tcp._tcp_id   = $1;
   DELETE FROM udp   WHERE udp._udp_id   = $1;
+  DELETE FROM mac   WHERE mac._mac_id   = $1;
+  DELETE FROM state_t   WHERE state_t._state_id   = $1;
   DELETE FROM ulog2 WHERE ulog2._id     = $1;
 $$ LANGUAGE SQL SECURITY INVOKER;
 
@@ -564,6 +591,7 @@ RETURNS void AS $$
   DELETE FROM tcp WHERE _tcp_id NOT IN (SELECT _id FROM ulog2);
   -- XXX note: could be rewritten (need to see what is more efficient) as:
   -- DELETE FROM tcp WHERE _tcp_id IN (SELECT tcp._tcp_id FROM tcp LEFT OUTER JOIN ulog2  ON (tcp._tcp_id = ulog2._id) WHERE ulog2._id IS NULL);
+  DELETE FROM state_t WHERE _state_id NOT IN (SELECT _id FROM ulog2);
   DELETE FROM mac WHERE _mac_id NOT IN (SELECT _id FROM ulog2);
   DELETE FROM udp WHERE _udp_id NOT IN (SELECT _id FROM ulog2);
   DELETE FROM icmp WHERE _icmp_id NOT IN (SELECT _id FROM ulog2);
-- 
1.5.2.5

