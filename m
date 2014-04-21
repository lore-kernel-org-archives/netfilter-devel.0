From: Bob Hockney <zeus@ix.netcom.com>
Subject: [ ulogd PATCH 1/2 ]  fix oob_protocol field for mysql
Date: Mon, 21 Apr 2014 14:13:10 -0600
Message-ID: <53557BD6.20401@ix.netcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:55563 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754456AbaDUU0Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:26:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 7409897a4c8a07850561c11e52d9b26c667d7a3d
Author: Bob Hockney <zeus@ix.netcom.com>
Date:   Thu Dec 27 10:38:47 2012 -0700

     - make column type for oob_protocol in mysql smallint(5) unsigned 
(was smallint(5))
         highest defined value in linux/if_ether.h is 0xFBFB (64507)
         but smallint range is -32768 to 32767

     Signed-off-by: Bob Hockney <zeus@ix.netcom.com>
===
  doc/mysql-ulogd2-flat.sql | 2 +-
  doc/mysql-ulogd2.sql      | 6 +++---
  2 files changed, 4 insertions(+), 4 deletions(-)
===
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
-        `_protocol` smallint(5)
+        `_protocol` smallint(5) unsigned
          ) RETURNS bigint unsigned
  NOT DETERMINISTIC
  READS SQL DATA
@@ -764,7 +764,7 @@ CREATE FUNCTION INSERT_PACKET_FULL(
                  raw_header varchar(256),
          mac_saddr varchar(32),
          mac_daddr varchar(32),
-        mac_protocol smallint(5),
+        mac_protocol smallint(5) unsigned,
          _label tinyint(4) unsigned,
          sctp_sport smallint(5) unsigned,
          sctp_dport smallint(5) unsigned,
