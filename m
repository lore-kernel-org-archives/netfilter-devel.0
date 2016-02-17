From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] conntrackd: Disable runtime systemd support by default
Date: Wed, 17 Feb 2016 12:26:01 +0100
Message-ID: <1455708361-3143-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44950 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161300AbcBQL0Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Feb 2016 06:26:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6FF10E3A0D
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2016 12:26:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 59AE8DA8FB
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2016 12:26:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 78DEDDA385
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2016 12:26:09 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By default, conntrackd is compiled with no built-in systemd support.
This patch updates the default runtime behaviour to be consistent
with what ./configure provides by default.

Thus, users should explicitly indicate "Systemd On" in their configuration
file to enable this. This shouldn't cause any problem to old users of
conntrackd.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: updates grammar to handle "On" case accordingly.

 conntrackd.conf.5                |  4 ++--
 doc/stats/conntrackd.conf        |  4 ++--
 doc/sync/alarm/conntrackd.conf   |  4 ++--
 doc/sync/ftfw/conntrackd.conf    |  4 ++--
 doc/sync/notrack/conntrackd.conf |  4 ++--
 src/read_config_yy.y             | 10 ++--------
 6 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 4781825..ed387b9 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -457,9 +457,9 @@ Obviusly, this requires the init systemd of your system to be \fBsystemd(1)\fP.
 
 Note: \fBsystemd(1)\fP watchdog is supported as well.
 
-Example: Systemd off
+Example: Systemd on
 
-By default runtime support is activated.
+By default runtime support is disabled.
 
 .TP
 .BI "Nice <value>"
diff --git a/doc/stats/conntrackd.conf b/doc/stats/conntrackd.conf
index b1cca07..6a9aec8 100644
--- a/doc/stats/conntrackd.conf
+++ b/doc/stats/conntrackd.conf
@@ -6,9 +6,9 @@ General {
 	# Enable systemd support. If conntrackd is compiled with the proper
 	# configuration, you can use a systemd service unit of Type=notify
 	# and use conntrackd with systemd watchdog as well.
-	# Default is: on
+	# Default is: off
 	#
-	#Systemd off
+	#Systemd on
 
 	#
 	# Set the nice value of the daemon. This value goes from -20
diff --git a/doc/sync/alarm/conntrackd.conf b/doc/sync/alarm/conntrackd.conf
index 39deb47..225d1c9 100644
--- a/doc/sync/alarm/conntrackd.conf
+++ b/doc/sync/alarm/conntrackd.conf
@@ -221,9 +221,9 @@ General {
 	# Enable systemd support. If conntrackd is compiled with the proper
 	# configuration, you can use a systemd service unit of Type=notify
 	# and use conntrackd with systemd watchdog as well.
-	# Default is: on
+	# Default is: off
 	#
-	#Systemd off
+	#Systemd on
 
 	#
 	# Set the nice value of the daemon, this value goes from -20
diff --git a/doc/sync/ftfw/conntrackd.conf b/doc/sync/ftfw/conntrackd.conf
index 60d7d97..228674c 100644
--- a/doc/sync/ftfw/conntrackd.conf
+++ b/doc/sync/ftfw/conntrackd.conf
@@ -244,9 +244,9 @@ General {
 	# Enable systemd support. If conntrackd is compiled with the proper
 	# configuration, you can use a systemd service unit of Type=notify
 	# and use conntrackd with systemd watchdog as well.
-	# Default is: on
+	# Default is: off
 	#
-	#Systemd off
+	#Systemd on
 
 	#
 	# Set the nice value of the daemon, this value goes from -20
diff --git a/doc/sync/notrack/conntrackd.conf b/doc/sync/notrack/conntrackd.conf
index b9d42ba..3becd91 100644
--- a/doc/sync/notrack/conntrackd.conf
+++ b/doc/sync/notrack/conntrackd.conf
@@ -283,9 +283,9 @@ General {
 	# Enable systemd support. If conntrackd is compiled with the proper
 	# configuration, you can use a systemd service unit of Type=notify
 	# and use conntrackd with systemd watchdog as well.
-	# Default is: on
+	# Default is: off
 	#
-	#Systemd off
+	#Systemd on
 
 	#
 	# Set the nice value of the daemon, this value goes from -20
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 58ad2d0..cc0eb18 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -1126,11 +1126,8 @@ general_line: hashsize
 	    | systemd
 	    ;
 
-systemd: T_SYSTEMD T_ON { /* already enabled in init_config() */ };
-systemd: T_SYSTEMD T_OFF
-{
-	conf.systemd = 0;
-};
+systemd: T_SYSTEMD T_ON		{ conf.systemd = 1; };
+systemd: T_SYSTEMD T_OFF	{ conf.systemd = 0; };
 
 netlink_buffer_size: T_BUFFER_SIZE T_NUMBER
 {
@@ -1864,9 +1861,6 @@ init_config(char *filename)
 	CONFIG(stats).syslog_facility = -1;
 	CONFIG(netlink).subsys_id = -1;
 
-	/* enable systemd by default */
-	CONFIG(systemd) = 1;
-
 	/* Initialize list of user-space helpers */
 	INIT_LIST_HEAD(&CONFIG(cthelper).list);
 
-- 
2.1.4

