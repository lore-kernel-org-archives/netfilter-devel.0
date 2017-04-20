From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 1/4] conntrackd: factorice tx_queue functions
Date: Thu, 20 Apr 2017 18:40:34 +0200
Message-ID: <149270643473.7706.16087221625455760877.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54545 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1033529AbdDTRsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 13:48:05 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 2A43351F34F
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 16:40:42 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TNiY1VeeV1Gi for <netfilter-devel@vger.kernel.org>;
        Thu, 20 Apr 2017 18:40:35 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 7A3D551F33E
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 18:40:35 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

They are shared by both sync-ftfw and sync-notrack.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 include/Makefile.am |    2 +-
 include/queue_tx.h  |    7 ++++++
 src/Makefile.am     |    2 +-
 src/queue_tx.c      |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 src/sync-ftfw.c     |   37 +------------------------------
 src/sync-notrack.c  |   37 +------------------------------
 6 files changed, 71 insertions(+), 74 deletions(-)
 create mode 100644 include/queue_tx.h
 create mode 100644 src/queue_tx.c

diff --git a/include/Makefile.am b/include/Makefile.am
index e81463a..84fd608 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -6,5 +6,5 @@ noinst_HEADERS = alarm.h jhash.h cache.h linux_list.h linux_rbtree.h \
 		 network.h filter.h queue.h vector.h cidr.h \
 		 traffic_stats.h netlink.h fds.h event.h bitops.h channel.h \
 		 process.h origin.h internal.h external.h date.h nfct.h \
-		 helper.h myct.h stack.h systemd.h
+		 helper.h myct.h stack.h systemd.h queue_tx.h
 
diff --git a/include/queue_tx.h b/include/queue_tx.h
new file mode 100644
index 0000000..e29b1f0
--- /dev/null
+++ b/include/queue_tx.h
@@ -0,0 +1,7 @@
+#ifndef _QUEUE_TX_H_
+#define _QUEUE_TX_H_
+
+void tx_queue_add_ctlmsg(uint32_t flags, uint32_t from, uint32_t to);
+void tx_queue_add_ctlmsg2(uint32_t flags);
+
+#endif /* _QUEUE_TX_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index 144c52c..39c7315 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -37,7 +37,7 @@ endif
 
 nfct_LDFLAGS = -export-dynamic @LAZY_LDFLAGS@
 
-conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c rbtree.c \
+conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c queue_tx.c rbtree.c \
 		    local.c log.c mcast.c udp.c netlink.c vector.c \
 		    filter.c fds.c event.c process.c origin.c date.c \
 		    cache.c cache-ct.c cache-exp.c \
diff --git a/src/queue_tx.c b/src/queue_tx.c
new file mode 100644
index 0000000..0c99163
--- /dev/null
+++ b/src/queue_tx.c
@@ -0,0 +1,60 @@
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
+#include <stdint.h>
+#include "queue_tx.h"
+#include "queue.h"
+#include "conntrackd.h"
+#include "network.h"
+
+void tx_queue_add_ctlmsg(uint32_t flags, uint32_t from, uint32_t to)
+{
+	struct queue_object *qobj;
+	struct nethdr_ack *ack;
+
+	qobj = queue_object_new(Q_ELEM_CTL, sizeof(struct nethdr_ack));
+	if (qobj == NULL)
+		return;
+
+	ack		= (struct nethdr_ack *)qobj->data;
+	ack->type 	= NET_T_CTL;
+	ack->flags	= flags;
+	ack->from	= from;
+	ack->to		= to;
+
+	if (queue_add(STATE_SYNC(tx_queue), &qobj->qnode) < 0)
+		queue_object_free(qobj);
+}
+
+void tx_queue_add_ctlmsg2(uint32_t flags)
+{
+	struct queue_object *qobj;
+	struct nethdr *ctl;
+
+	qobj = queue_object_new(Q_ELEM_CTL, sizeof(struct nethdr_ack));
+	if (qobj == NULL)
+		return;
+
+	ctl		= (struct nethdr *)qobj->data;
+	ctl->type 	= NET_T_CTL;
+	ctl->flags	= flags;
+
+	if (queue_add(STATE_SYNC(tx_queue), &qobj->qnode) < 0)
+		queue_object_free(qobj);
+}
diff --git a/src/sync-ftfw.c b/src/sync-ftfw.c
index aa6838a..ce5270b 100644
--- a/src/sync-ftfw.c
+++ b/src/sync-ftfw.c
@@ -20,6 +20,7 @@
 #include "conntrackd.h"
 #include "sync.h"
 #include "queue.h"
+#include "queue_tx.h"
 #include "network.h"
 #include "alarm.h"
 #include "log.h"
@@ -95,42 +96,6 @@ static void nethdr_set_hello(struct nethdr *net)
 	}
 }
 
-static void tx_queue_add_ctlmsg(uint32_t flags, uint32_t from, uint32_t to)
-{
-	struct queue_object *qobj;
-	struct nethdr_ack *ack;
-
-	qobj = queue_object_new(Q_ELEM_CTL, sizeof(struct nethdr_ack));
-	if (qobj == NULL)
-		return;
-
-	ack		= (struct nethdr_ack *)qobj->data;
-	ack->type 	= NET_T_CTL;
-	ack->flags	= flags;
-	ack->from	= from;
-	ack->to		= to;
-
-	if (queue_add(STATE_SYNC(tx_queue), &qobj->qnode) < 0)
-		queue_object_free(qobj);
-}
-
-static void tx_queue_add_ctlmsg2(uint32_t flags)
-{
-	struct queue_object *qobj;
-	struct nethdr *ctl;
-
-	qobj = queue_object_new(Q_ELEM_CTL, sizeof(struct nethdr_ack));
-	if (qobj == NULL)
-		return;
-
-	ctl		= (struct nethdr *)qobj->data;
-	ctl->type 	= NET_T_CTL;
-	ctl->flags	= flags;
-
-	if (queue_add(STATE_SYNC(tx_queue), &qobj->qnode) < 0)
-		queue_object_free(qobj);
-}
-
 /* this function is called from the alarm framework */
 static void do_alive_alarm(struct alarm_block *a, void *data)
 {
diff --git a/src/sync-notrack.c b/src/sync-notrack.c
index 7ade3a7..5b6814d 100644
--- a/src/sync-notrack.c
+++ b/src/sync-notrack.c
@@ -20,6 +20,7 @@
 #include "conntrackd.h"
 #include "sync.h"
 #include "queue.h"
+#include "queue_tx.h"
 #include "network.h"
 #include "log.h"
 #include "cache.h"
@@ -56,25 +57,6 @@ static struct cache_extra cache_notrack_extra = {
 	.destroy	= cache_notrack_del
 };
 
-static void tx_queue_add_ctlmsg(uint32_t flags, uint32_t from, uint32_t to)
-{
-	struct queue_object *qobj;
-	struct nethdr_ack *ack;
-
-	qobj = queue_object_new(Q_ELEM_CTL, sizeof(struct nethdr_ack));
-	if (qobj == NULL)
-		return;
-
-	ack		= (struct nethdr_ack *)qobj->data;
-        ack->type	= NET_T_CTL;
-	ack->flags	= flags;
-	ack->from	= from;
-	ack->to		= to;
-
-	if (queue_add(STATE_SYNC(tx_queue), &qobj->qnode) < 0)
-		queue_object_free(qobj);
-}
-
 static int do_cache_to_tx(void *data1, void *data2)
 {
 	struct cache_object *obj = data2;
@@ -228,23 +210,6 @@ static void notrack_enqueue(struct cache_object *obj, int query)
 		cache_object_get(obj);
 }
 
-static void tx_queue_add_ctlmsg2(uint32_t flags)
-{
-	struct queue_object *qobj;
-	struct nethdr *ctl;
-
-	qobj = queue_object_new(Q_ELEM_CTL, sizeof(struct nethdr_ack));
-	if (qobj == NULL)
-		return;
-
-	ctl		= (struct nethdr *)qobj->data;
-	ctl->type	= NET_T_CTL;
-	ctl->flags	= flags;
-
-	if (queue_add(STATE_SYNC(tx_queue), &qobj->qnode) < 0)
-		queue_object_free(qobj);
-}
-
 static void do_alive_alarm(struct alarm_block *a, void *data)
 {
 	tx_queue_add_ctlmsg2(NET_F_ALIVE);

