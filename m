From: Bob Hockney <zeus@ix.netcom.com>
Subject: [PATCH 1/2] Make column type for oob_protocol in mysql smallint(5)
Date: Thu, 27 Dec 2012 10:38:47 -0700
Message-ID: <201404221917.s3MJHoe5022658@gateway.ford-prefect.net>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [24.49.174.127] ([24.49.174.127]:7235 "EHLO
	smtp.ford-prefect.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaDVT0W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:26:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Make column type for oob_protocol in mysql smallint(5) unsigned
 (was smallint(5)). Highest defined value in linux/if_ether.h is
 0xFBFB (64507)

Signed-off-by: Bob Hockney <zeus@ix.netcom.com>
---
 doc/mysql-ulogd2-flat.sql | 2 +-
 doc/mysql-ulogd2.sql      | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/doc/mysql-ulogd2-flat.sql b/doc/mysql-ulogd2-flat.sql
index d71608c..6d663f6 100644
--- a/doc/mysql-ulogd2-flat.sql
+++ b/doc/mysql-ulogd2-flat.sql
@@ -51,7 +51,7 @@ CREATE TABLE `ulog2` (
   `raw_label` tinyint(3) unsigned default NULL,
   `mac_saddr_str` varchar(32) default NULL,
   `mac_daddr_str` varchar(32) default NULL,
-  `oob_protocol` smallint(5) default NULL,
+  `oob_protocol` smallint(5) unsigned default NULL,
   `raw_type` int(10) unsigned default NULL,
   `mac_str` varchar(255) default NULL,
   `tcp_sport` int(5) unsigned default NULL,
diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index c44f9a9..782f368 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -84,7 +84,7 @@ CREATE TABLE `mac` (
   `_mac_id` bigint unsigned NOT NULL auto_increment,
   `mac_saddr` varchar(32) default NULL,
   `mac_daddr` varchar(32) default NULL,
-  `mac_protocol` smallint(5) default NULL,
+  `mac_protocol` smallint(5) unsigned default NULL,
   UNIQUE KEY `key_id` (`_mac_id`)
 ) ENGINE=INNODB;
 
@@ -681,7 +681,7 @@ delimiter $$
 CREATE FUNCTION INSERT_OR_SELECT_MAC(
 		`_saddr` varchar(32),
 		`_daddr` varchar(32),
-		`_protocol` smallint(5)
+		`_protocol` smallint(5) unsigned
 		) RETURNS bigint unsigned
 NOT DETERMINISTIC
 READS SQL DATA
@@ -764,7 +764,7 @@ CREATE FUNCTION INSERT_PACKET_FULL(
                 raw_header varchar(256),
 		mac_saddr varchar(32),
 		mac_daddr varchar(32),
-		mac_protocol smallint(5),
+		mac_protocol smallint(5) unsigned,
 		_label tinyint(4) unsigned,
 		sctp_sport smallint(5) unsigned,
 		sctp_dport smallint(5) unsigned,
-- 
1.8.3.1

