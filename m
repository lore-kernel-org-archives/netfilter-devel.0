From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 4/4] conntrackd: deprecate unix backlog
 configuration
Date: Tue, 06 Jun 2017 12:58:44 +0200
Message-ID: <149674672410.18546.18108815853544215114.stgit@nfdev2.cica.es>
References: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40574 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751492AbdFFK6w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 06:58:52 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id B9DA751F355
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 10:58:50 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jqfzGqFyKW5c for <netfilter-devel@vger.kernel.org>;
        Tue,  6 Jun 2017 12:58:44 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id C998251F2B3
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 12:58:44 +0200 (CEST)
In-Reply-To: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This configuration option doesn't add any value to users.
Use the magic value of 100 (i.e, the socket will keep 100 pending connections),
which I think is fair enough for what conntrackd can do in the unix socket.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 conntrackd.conf.5                |    8 +-------
 doc/helper/conntrackd.conf       |    1 -
 doc/stats/conntrackd.conf        |    1 -
 doc/sync/alarm/conntrackd.conf   |    1 -
 doc/sync/ftfw/conntrackd.conf    |    1 -
 doc/sync/notrack/conntrackd.conf |    1 -
 include/local.h                  |    1 -
 src/local.c                      |    4 +++-
 src/read_config_yy.y             |    2 +-
 9 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 1e56a1f..4785f47 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -603,7 +603,6 @@ Example:
 .nf
 	UNIX {
 		Path /var/run/conntrackd.ctl
-		Backlog 20
 	}
 .fi
 
@@ -615,9 +614,7 @@ Example: Path /var/run/conntrackd.ctl
 
 .TP
 .BI "Backlog <value>"
-Number of items in the backlog.
-
-Example: Backlog 20
+Deprecated option.
 
 .SS FILTER
 Event filtering. This clause allows you to filter certain traffic.
@@ -886,7 +883,6 @@ General {
 	LockFile /var/lock/conntrack.lock
 	UNIX {
 		Path /var/run/conntrackd.ctl
-		Backlog 20
 	}
 	NetlinkBufferSize 262142
 	NetlinkBufferSizeMaxGrowth 655355
@@ -952,7 +948,6 @@ General {
 	LockFile /var/lock/conntrack.lock
 	UNIX {
 		Path /var/run/conntrackd.ctl
-		Backlog 20
 	}
 	NetlinkBufferSize 2097152
 	NetlinkBufferSizeMaxGrowth 8388608
@@ -1010,7 +1005,6 @@ General {
 	LockFile /var/lock/conntrack.lock
 	UNIX {
 		Path /var/run/conntrackd.ctl
-		Backlog 20
 	}
 	NetlinkBufferSize 2097152
 	NetlinkBufferSizeMaxGrowth 8388608
diff --git a/doc/helper/conntrackd.conf b/doc/helper/conntrackd.conf
index abc4087..4148544 100644
--- a/doc/helper/conntrackd.conf
+++ b/doc/helper/conntrackd.conf
@@ -124,6 +124,5 @@ General {
 	#
 	UNIX {
 		Path /var/run/conntrackd.ctl
-		Backlog 20
 	}
 }
diff --git a/doc/stats/conntrackd.conf b/doc/stats/conntrackd.conf
index e62ad4b..ba957a1 100644
--- a/doc/stats/conntrackd.conf
+++ b/doc/stats/conntrackd.conf
@@ -43,7 +43,6 @@ General {
 	#
 	UNIX {
 		Path /var/run/conntrackd.ctl
-		Backlog 20
 	}
 
 	#
diff --git a/doc/sync/alarm/conntrackd.conf b/doc/sync/alarm/conntrackd.conf
index f609310..831be15 100644
--- a/doc/sync/alarm/conntrackd.conf
+++ b/doc/sync/alarm/conntrackd.conf
@@ -262,7 +262,6 @@ General {
 	#
 	UNIX {
 		Path /var/run/conntrackd.ctl
-		Backlog 20
 	}
 
 	#
diff --git a/doc/sync/ftfw/conntrackd.conf b/doc/sync/ftfw/conntrackd.conf
index f500637..9da0fb6 100644
--- a/doc/sync/ftfw/conntrackd.conf
+++ b/doc/sync/ftfw/conntrackd.conf
@@ -285,7 +285,6 @@ General {
 	#
 	UNIX {
 		Path /var/run/conntrackd.ctl
-		Backlog 20
 	}
 
 	#
diff --git a/doc/sync/notrack/conntrackd.conf b/doc/sync/notrack/conntrackd.conf
index 718668d..600fc89 100644
--- a/doc/sync/notrack/conntrackd.conf
+++ b/doc/sync/notrack/conntrackd.conf
@@ -324,7 +324,6 @@ General {
 	#
 	UNIX {
 		Path /var/run/conntrackd.ctl
-		Backlog 20
 	}
 
 	#
diff --git a/include/local.h b/include/local.h
index f9121b1..22859d7 100644
--- a/include/local.h
+++ b/include/local.h
@@ -6,7 +6,6 @@
 #endif
 
 struct local_conf {
-	int backlog;
 	int reuseaddr;
 	char path[UNIX_PATH_MAX];
 };
diff --git a/src/local.c b/src/local.c
index 3395b4c..2b67885 100644
--- a/src/local.c
+++ b/src/local.c
@@ -26,6 +26,8 @@
 #include <arpa/inet.h>
 #include <sys/un.h>
 
+#define UNIX_SOCKET_BACKLOG 100
+
 int local_server_create(struct local_server *server, struct local_conf *conf)
 {
 	int fd;
@@ -53,7 +55,7 @@ int local_server_create(struct local_server *server, struct local_conf *conf)
 		return -1;
 	}
 
-	if (listen(fd, conf->backlog) == -1) {
+	if (listen(fd, UNIX_SOCKET_BACKLOG) == -1) {
 		close(fd);
 		unlink(conf->path);
 		return -1;
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index ef6b284..5dca1f6 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -650,7 +650,7 @@ unix_option : T_PATH T_PATH_VAL
 
 unix_option : T_BACKLOG T_NUMBER
 {
-	conf.local.backlog = $2;
+	dlog(LOG_WARNING, "deprecated unix backlog configuration.");
 };
 
 sync: T_SYNC '{' sync_list '}'

