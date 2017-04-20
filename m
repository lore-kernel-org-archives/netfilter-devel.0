From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 3/4] conntrackd: factorize resync operations
Date: Thu, 20 Apr 2017 18:40:45 +0200
Message-ID: <149270644528.7706.13689714798325517855.stgit@nfdev2.cica.es>
References: <149270643473.7706.16087221625455760877.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54550 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1033528AbdDTRsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 13:48:05 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 79AA451F356
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 16:40:54 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id I2SqAPMY88Dv for <netfilter-devel@vger.kernel.org>;
        Thu, 20 Apr 2017 18:40:46 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 1C2E051F348
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 18:40:46 +0200 (CEST)
In-Reply-To: <149270643473.7706.16087221625455760877.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Resync operations factorization. There are two:
 * resync_send	--> conntrackd -B (send bulk resync)
 * resync_req	--> conntrackd -n (request resync)

Future patches reuse this factorized code.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 include/Makefile.am |    2 +-
 include/resync.h    |    7 +++++++
 src/Makefile.am     |    2 +-
 src/resync.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 src/sync-ftfw.c     |   10 +++-------
 src/sync-notrack.c  |   14 +++-----------
 6 files changed, 55 insertions(+), 20 deletions(-)
 create mode 100644 include/resync.h
 create mode 100644 src/resync.c

diff --git a/include/Makefile.am b/include/Makefile.am
index 84fd608..352054e 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -6,5 +6,5 @@ noinst_HEADERS = alarm.h jhash.h cache.h linux_list.h linux_rbtree.h \
 		 network.h filter.h queue.h vector.h cidr.h \
 		 traffic_stats.h netlink.h fds.h event.h bitops.h channel.h \
 		 process.h origin.h internal.h external.h date.h nfct.h \
-		 helper.h myct.h stack.h systemd.h queue_tx.h
+		 helper.h myct.h stack.h systemd.h queue_tx.h resync.h
 
diff --git a/include/resync.h b/include/resync.h
new file mode 100644
index 0000000..5986600
--- /dev/null
+++ b/include/resync.h
@@ -0,0 +1,7 @@
+#ifndef _RESYNC_H_
+#define _RESYNC_H_
+
+void resync_req(void);
+void resync_send(int (*do_cache_to_tx)(void *data1, void *data2));
+
+#endif /*_RESYNC_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index 39c7315..a9a8685 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -52,7 +52,7 @@ conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c queue_tx.c rbtree.c \
 		    external_cache.c external_inject.c \
 		    internal_cache.c internal_bypass.c \
 		    read_config_yy.y read_config_lex.l \
-		    stack.c
+		    stack.c resync.c
 
 if HAVE_CTHELPER
 conntrackd_SOURCES += cthelper.c helpers.c utils.c expect.c
diff --git a/src/resync.c b/src/resync.c
new file mode 100644
index 0000000..dbb2b6f
--- /dev/null
+++ b/src/resync.c
@@ -0,0 +1,40 @@
+/*
+ * (C) 2006-2011 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2011 by Vyatta Inc. <http://www.vyatta.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include "conntrackd.h"
+#include "network.h"
+#include "log.h"
+#include "queue_tx.h"
+#include "resync.h"
+#include "cache.h"
+
+void resync_req(void)
+{
+	dlog(LOG_NOTICE, "resync requested");
+	tx_queue_add_ctlmsg(NET_F_RESYNC, 0, 0);
+}
+
+void resync_send(int (*do_cache_to_tx)(void *data1, void *data2))
+{
+	dlog(LOG_NOTICE, "sending bulk update");
+	cache_iterate(STATE(mode)->internal->ct.data,
+		      NULL, do_cache_to_tx);
+	cache_iterate(STATE(mode)->internal->exp.data,
+		      NULL, do_cache_to_tx);
+}
diff --git a/src/sync-ftfw.c b/src/sync-ftfw.c
index ce5270b..6fdb058 100644
--- a/src/sync-ftfw.c
+++ b/src/sync-ftfw.c
@@ -26,6 +26,7 @@
 #include "log.h"
 #include "cache.h"
 #include "fds.h"
+#include "resync.h"
 
 #include <string.h>
 #include <errno.h>
@@ -189,15 +190,10 @@ static int ftfw_local(int fd, int type, void *data)
 
 	switch(type) {
 	case REQUEST_DUMP:
-		dlog(LOG_NOTICE, "request resync");
-		tx_queue_add_ctlmsg(NET_F_RESYNC, 0, 0);
+		resync_req();
 		break;
 	case SEND_BULK:
-		dlog(LOG_NOTICE, "sending bulk update");
-		cache_iterate(STATE(mode)->internal->ct.data,
-			      NULL, do_cache_to_tx);
-		cache_iterate(STATE(mode)->internal->exp.data,
-			      NULL, do_cache_to_tx);
+		resync_send(do_cache_to_tx);
 		break;
 	case STATS_RSQUEUE:
 		ftfw_local_queue(fd);
diff --git a/src/sync-notrack.c b/src/sync-notrack.c
index 5b6814d..7ce62d9 100644
--- a/src/sync-notrack.c
+++ b/src/sync-notrack.c
@@ -25,6 +25,7 @@
 #include "log.h"
 #include "cache.h"
 #include "fds.h"
+#include "resync.h"
 
 #include <string.h>
 
@@ -103,19 +104,10 @@ static int notrack_local(int fd, int type, void *data)
 
 	switch(type) {
 	case REQUEST_DUMP:
-		dlog(LOG_NOTICE, "request resync");
-		tx_queue_add_ctlmsg(NET_F_RESYNC, 0, 0);
+		resync_req();
 		break;
 	case SEND_BULK:
-		dlog(LOG_NOTICE, "sending bulk update");
-		if (CONFIG(sync).internal_cache_disable) {
-			kernel_resync();
-		} else {
-			cache_iterate(STATE(mode)->internal->ct.data,
-				      NULL, do_cache_to_tx);
-			cache_iterate(STATE(mode)->internal->exp.data,
-				      NULL, do_cache_to_tx);
-		}
+		resync_send(do_cache_to_tx);
 		break;
 	default:
 		ret = 0;

