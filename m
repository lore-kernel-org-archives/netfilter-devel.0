From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 32/34]  Add state extension.
Date: Sat,  2 Feb 2008 22:24:27 +0100
Message-ID: <12019874721527-git-send-email-eric@inl.fr>
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
 <1201987471346-git-send-email-eric@inl.fr>
 <12019874712309-git-send-email-eric@inl.fr>
 <12019874714080-git-send-email-eric@inl.fr>
 <12019874712041-git-send-email-eric@inl.fr>
 <12019874711938-git-send-email-eric@inl.fr>
 <1201987471531-git-send-email-eric@inl.fr>
 <12019874713790-git-send-email-eric@inl.fr>
 <12019874712753-git-send-email-eric@inl.fr>
 <12019874713782-git-send-email-eric@inl.fr>
 <12019874711816-git-send-email-eric@inl.fr>
 <1201987471602-git-send-email-eric@inl.fr>
 <12019874711187-git-send-email-eric@inl.fr>
 <12019874721299-git-send-email-eric@inl.fr>
 <12019874721188-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:45992 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761648AbYBBWOI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:14:08 -0500
In-Reply-To: <12019874721188-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

This patch adds an state extension to SQL schema. This can be used to store
the information about the packet being dropped or accepted.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 eec6e69... d42d216... M	doc/mysql-ulogd2.sql
 doc/mysql-ulogd2.sql |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index eec6e69..d42d216 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -191,6 +191,7 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id;
 
+
 -- shortcuts
 DROP VIEW IF EXISTS `view_tcp_quad`;
 CREATE SQL SECURITY INVOKER VIEW `view_tcp_quad` AS
@@ -301,6 +302,21 @@ INSERT INTO ip_proto (_proto_id,proto_name,proto_desc) VALUES
         (41,'ipv6','Internet Protocol, version 6'),
         (58,'ipv6-icmp','ICMP for IPv6');
 
+-- State
+DROP TABLE IF EXISTS `state_t`;
+CREATE TABLE `state_t` (
+  `_state_id` bigint unsigned NOT NULL,
+  state tinyint(3) unsigned
+) ENGINE=INNODB;
+
+ALTER TABLE state_t ADD UNIQUE KEY `_state_id` (`_state_id`);
+ALTER TABLE state_t ADD KEY `index_state_id` (`_state_id`);
+ALTER TABLE state_t ADD KEY `state` (`state`);
+ALTER TABLE state_t ADD FOREIGN KEY (_state_id) REFERENCES ulog2 (_id);
+
+INSERT INTO _extensions (ext_name,table_name,join_name) VALUES
+        ('state','state_t','_state_id');
+
 -- NuFW specific
 
 DROP TABLE IF EXISTS `nufw`;
@@ -324,6 +340,18 @@ CREATE SQL SECURITY INVOKER VIEW `view_nufw` AS
 INSERT INTO _extensions (ext_name,table_name,join_name) VALUES
         ('nufw','nufw','_nufw_id');
 
+-- nufw view (nulog)
+DROP VIEW IF EXISTS `nulog`;
+-- CREATE SQL SECURITY INVOKER VIEW `ulog` AS
+--         SELECT * FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id INNER JOIN udp ON ulog2._id = udp._udp_id
+-- 		 INNER JOIN icmp ON ulog2._id = icmp._icmp_id INNER JOIN mac ON ulog2._id = mac._mac_id;
+CREATE SQL SECURITY INVOKER VIEW `nulog` AS
+       SELECT * FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
+                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
+		LEFT JOIN nufw ON ulog2._id = nufw._nufw_id LEFT JOIN state_t ON ulog2._id = state_t._state_id;
+
+
+
 -- Procedures
 
 DROP PROCEDURE IF EXISTS ULOG2_DROP_FOREIGN_KEYS;
-- 
1.5.2.5

