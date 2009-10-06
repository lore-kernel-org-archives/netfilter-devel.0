From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH] Fix oob_prefix maximum length
Date: Tue,  6 Oct 2009 11:30:36 +0200
Message-ID: <1254821436-19324-1-git-send-email-chifflier@inl.fr>
Cc: eleblond@inl.fr, Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41264 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655AbZJFJbZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:31:25 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id C0BBE940169
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2009 11:30:44 +0200 (CEST)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id D80A7940026
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2009 11:30:41 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

oob_prefix length can be greater than 32, for ex when using nflog.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 doc/mysql-ulogd2-flat.sql |    2 +-
 doc/mysql-ulogd2.sql      |    8 ++++----
 doc/pgsql-ulogd2-flat.sql |    2 +-
 doc/pgsql-ulogd2.sql      |    8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/doc/mysql-ulogd2-flat.sql b/doc/mysql-ulogd2-flat.sql
index 11474c0..29fc3fc 100644
--- a/doc/mysql-ulogd2-flat.sql
+++ b/doc/mysql-ulogd2-flat.sql
@@ -27,7 +27,7 @@ CREATE TABLE `ulog2` (
   `oob_time_sec` int(10) unsigned default NULL,
   `oob_time_usec` int(10) unsigned default NULL,
   `oob_hook` tinyint(3) unsigned default NULL,
-  `oob_prefix` varchar(32) default NULL,
+  `oob_prefix` varchar(128) default NULL,
   `oob_mark` int(10) unsigned default NULL,
   `oob_in` varchar(32) default NULL,
   `oob_out` varchar(32) default NULL,
diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index 0c2973d..1c5e75a 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -45,7 +45,7 @@ CREATE TABLE `ulog2` (
   `oob_time_sec` int(10) unsigned default NULL,
   `oob_time_usec` int(10) unsigned default NULL,
   `oob_hook` tinyint(3) unsigned default NULL,
-  `oob_prefix` varchar(32) default NULL,
+  `oob_prefix` varchar(128) default NULL,
   `oob_mark` int(10) unsigned default NULL,
   `oob_in` varchar(32) default NULL,
   `oob_out` varchar(32) default NULL,
@@ -488,7 +488,7 @@ CREATE FUNCTION INSERT_IP_PACKET(
 		_oob_time_sec int(10) unsigned,
 		_oob_time_usec int(10) unsigned,
 		_oob_hook tinyint(3) unsigned,
-		_oob_prefix varchar(32),
+		_oob_prefix varchar(128),
 		_oob_mark int(10) unsigned,
 		_oob_in varchar(32),
 		_oob_out varchar(32),
@@ -515,7 +515,7 @@ CREATE FUNCTION INSERT_IP_PACKET_FULL(
 		_oob_time_sec int(10) unsigned,
 		_oob_time_usec int(10) unsigned,
 		_oob_hook tinyint(3) unsigned,
-		_oob_prefix varchar(32),
+		_oob_prefix varchar(128),
 		_oob_mark int(10) unsigned,
 		_oob_in varchar(32),
 		_oob_out varchar(32),
@@ -685,7 +685,7 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		_oob_time_sec int(10) unsigned,
 		_oob_time_usec int(10) unsigned,
 		_oob_hook tinyint(3) unsigned,
-		_oob_prefix varchar(32),
+		_oob_prefix varchar(128),
 		_oob_mark int(10) unsigned,
 		_oob_in varchar(32),
 		_oob_out varchar(32),
diff --git a/doc/pgsql-ulogd2-flat.sql b/doc/pgsql-ulogd2-flat.sql
index cf1a07f..a390f18 100644
--- a/doc/pgsql-ulogd2-flat.sql
+++ b/doc/pgsql-ulogd2-flat.sql
@@ -33,7 +33,7 @@ CREATE TABLE ulog2 (
   oob_time_sec integer default NULL,
   oob_time_usec integer default NULL,
   oob_hook smallint default NULL,
-  oob_prefix varchar(32) default NULL,
+  oob_prefix varchar(128) default NULL,
   oob_mark integer default NULL,
   oob_in varchar(32) default NULL,
   oob_out varchar(32) default NULL,
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 8f47bf9..c7ce8b7 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -44,7 +44,7 @@ CREATE TABLE ulog2 (
   oob_time_sec integer default NULL,
   oob_time_usec integer default NULL,
   oob_hook smallint default NULL,
-  oob_prefix varchar(32) default NULL,
+  oob_prefix varchar(128) default NULL,
   oob_mark integer default NULL,
   oob_in varchar(32) default NULL,
   oob_out varchar(32) default NULL,
@@ -356,7 +356,7 @@ $$ LANGUAGE SQL SECURITY INVOKER;
 CREATE OR REPLACE FUNCTION INSERT_IP_PACKET(
                 IN oob_time_sec integer,
                 IN oob_time_usec integer,
-                IN oob_prefix varchar(32),
+                IN oob_prefix varchar(128),
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
@@ -377,7 +377,7 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
                 IN oob_time_sec integer,
                 IN oob_time_usec integer,
                 IN oob_hook integer,
-                IN oob_prefix varchar(32),
+                IN oob_prefix varchar(128),
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
@@ -516,7 +516,7 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN oob_time_sec integer,
                 IN oob_time_usec integer,
                 IN oob_hook integer,
-                IN oob_prefix varchar(32),
+                IN oob_prefix varchar(128),
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
-- 
1.6.4.3

