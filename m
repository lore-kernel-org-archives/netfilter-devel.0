From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 11/11] remove the alarm library
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.32320.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:50260 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751068AbYAVOSH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:18:07 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 include/Makefile.am |    2 +-
 include/alarm.h     |   23 --------------------
 src/Makefile.am     |    2 +-
 src/alarm.c         |   60 ---------------------------------------------------
 src/cache_timer.c   |   36 ++++++++++++++++++++-----------
 src/run.c           |    1 -
 src/sync-alarm.c    |   56 ++++++++++++++++++++++++++++++++----------------
 src/sync-ftfw.c     |   23 ++++++++++++++------
 8 files changed, 81 insertions(+), 122 deletions(-)
 delete mode 100644 include/alarm.h
 delete mode 100644 src/alarm.c


diff --git a/include/Makefile.am b/include/Makefile.am
index e8e7f81..906ce20 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,5 +1,5 @@
 
-noinst_HEADERS = alarm.h jhash.h slist.h cache.h linux_list.h \
+noinst_HEADERS = jhash.h slist.h cache.h linux_list.h \
 		 sync.h conntrackd.h local.h us-conntrack.h \
 		 debug.h log.h hash.h mcast.h conntrack.h \
 		 state_helper.h network.h ignore.h queue.h \
diff --git a/include/alarm.h b/include/alarm.h
deleted file mode 100644
index 5b59994..0000000
--- a/include/alarm.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#ifndef _TIMER_H_
-#define _TIMER_H_
-
-#include <sys/types.h>
-#include <event.h>
-
-struct alarm_list {
-	struct event event;
-	void			*data;
-	void			(*function)(struct alarm_list *a, void *data);
-};
-
-void init_alarm(struct alarm_list *t,
-		void *data,
-		void (*fcn)(struct alarm_list *a, void *data));
-
-void add_alarm(struct alarm_list *alarm, unsigned long sc, unsigned long usc);
-
-void del_alarm(struct alarm_list *alarm);
-
-int alarm_pending(struct alarm_list *alarm, struct timeval *tv);
-
-#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index d71cd55..2264fd1 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -10,7 +10,7 @@ conntrack_SOURCES = conntrack.c
 conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_icmp.la
 conntrack_LDFLAGS = $(all_libraries) @LIBNETFILTER_CONNTRACK_LIBS@
 
-conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c \
+conntrackd_SOURCES = main.c run.c hash.c queue.c \
 		    local.c log.c mcast.c netlink.c \
 		    ignore_pool.c \
 		    cache.c cache_iterators.c \
diff --git a/src/alarm.c b/src/alarm.c
deleted file mode 100644
index b0fd28f..0000000
--- a/src/alarm.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.org>
- * 
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "alarm.h"
-
-#include <stdlib.h>
-
-static void
-alarm_event_callback(int fd, short event, void *ctx)
-{
-	struct alarm_list *alarm = ctx;
-
-	alarm->function(alarm, alarm->data);
-}
-
-void init_alarm(struct alarm_list *t,
-		void *data,
-		void (*fcn)(struct alarm_list *a, void *data))
-{
-	evtimer_set(&t->event, alarm_event_callback, t);
-	t->data = data;
-	t->function = fcn;
-}
-
-void add_alarm(struct alarm_list *alarm, unsigned long sc, unsigned long usc)
-{
-	struct timeval tv;
-
-	evtimer_del(&alarm->event);
-
-	tv.tv_sec = sc;
-	tv.tv_usec = usc;
-
-	evtimer_add(&alarm->event, &tv);
-}
-
-void del_alarm(struct alarm_list *alarm)
-{
-	evtimer_del(&alarm->event);
-}
-
-int alarm_pending(struct alarm_list *alarm, struct timeval *tv)
-{
-	return evtimer_pending(&alarm->event, tv) != 0;
-}
diff --git a/src/cache_timer.c b/src/cache_timer.c
index a7afbe2..f3efec4 100644
--- a/src/cache_timer.c
+++ b/src/cache_timer.c
@@ -19,12 +19,13 @@
 #include "cache.h"
 #include "conntrackd.h"
 #include "us-conntrack.h"
-#include "alarm.h"
 #include "debug.h"
 
 #include <stdio.h>
+#include <sys/types.h>
+#include <event.h>
 
-static void timeout(struct alarm_list *a, void *data)
+static void timeout(int fd, short event, void *data)
 {
 	struct us_conntrack *u = data;
 
@@ -34,33 +35,44 @@ static void timeout(struct alarm_list *a, void *data)
 
 static void timer_add(struct us_conntrack *u, void *data)
 {
-	struct alarm_list *alarm = data;
+	struct event *event = data;
+	struct timeval tv = {
+		.tv_sec = CONFIG(cache_timeout),
+		.tv_usec = 0,
+	};
 
-	init_alarm(alarm, u, timeout);
-	add_alarm(alarm, CONFIG(cache_timeout), 0);
+	evtimer_set(event, timeout, u);
+	evtimer_add(event, &tv);
 }
 
 static void timer_update(struct us_conntrack *u, void *data)
 {
-	struct alarm_list *alarm = data;
-	add_alarm(alarm, CONFIG(cache_timeout), 0);
+	struct event *event = data;
+	struct timeval tv = {
+		.tv_sec = CONFIG(cache_timeout),
+		.tv_usec = 0,
+	};
+
+	evtimer_del(event);
+	evtimer_add(event, &tv);
 }
 
 static void timer_destroy(struct us_conntrack *u, void *data)
 {
-	struct alarm_list *alarm = data;
-	del_alarm(alarm);
+	struct event *event = data;
+
+	evtimer_del(event);
 }
 
 static int timer_dump(struct us_conntrack *u, void *data, char *buf, int type)
 {
+	struct event *event = data;
 	struct timeval tv, tmp;
- 	struct alarm_list *alarm = data;
 
 	if (type == NFCT_O_XML)
 		return 0;
 
-	if (!alarm_pending(alarm, &tmp))
+	if (!evtimer_pending(event, &tmp))
 		return 0;
 
 	gettimeofday(&tv, NULL);
@@ -69,7 +81,7 @@ static int timer_dump(struct us_conntrack *u, void *data, char *buf, int type)
 }
 
 struct cache_feature timer_feature = {
-	.size		= sizeof(struct alarm_list),
+	.size		= sizeof(struct event),
 	.add		= timer_add,
 	.update		= timer_update,
 	.destroy	= timer_destroy,
diff --git a/src/run.c b/src/run.c
index 9631481..e762815 100644
--- a/src/run.c
+++ b/src/run.c
@@ -22,7 +22,6 @@
 #include "netlink.h"
 #include "ignore.h"
 #include "log.h"
-#include "alarm.h"
 
 #include <errno.h>
 #include <signal.h>
diff --git a/src/sync-alarm.c b/src/sync-alarm.c
index c7cecc8..9e318b0 100644
--- a/src/sync-alarm.c
+++ b/src/sync-alarm.c
@@ -20,24 +20,33 @@
 #include "sync.h"
 #include "network.h"
 #include "us-conntrack.h"
-#include "alarm.h"
 #include "cache.h"
 #include "debug.h"
 
 #include <stdlib.h>
 #include <string.h>
+#include <sys/types.h>
+#include <event.h>
 
-static void refresher(struct alarm_list *a, void *data)
+struct cache_alarm {
+	struct us_conntrack *u;
+	struct event event;
+};
+
+static void refresher(int fd, short event, void *data)
 {
+	struct cache_alarm *sa = data;
+	struct timeval tv;
+	struct us_conntrack *u = sa->u;
 	size_t len;
 	struct nethdr *net;
-	struct us_conntrack *u = data;
 
 	debug_ct(u->ct, "persistence update");
 
-	add_alarm(a, 
-		  random() % CONFIG(refresh) + 1,
-		  ((random() % 5 + 1)  * 200000) - 1);
+	tv.tv_sec = random() % CONFIG(refresh) + 1;
+	tv.tv_usec = ((random() % 5 + 1)  * 200000) - 1;
+
+	evtimer_add(&sa->event, &tv);
 
 	net = BUILD_NETMSG(u->ct, NFCT_Q_UPDATE);
 	len = prepare_send_netmsg(STATE_SYNC(mcast_client), net);
@@ -46,30 +55,41 @@ static void refresher(struct alarm_list *a, void *data)
 
 static void cache_alarm_add(struct us_conntrack *u, void *data)
 {
-	struct alarm_list *alarm = data;
+	struct cache_alarm *sa = data;
+	struct timeval tv;
+
+	sa->u = u;
+
+	tv.tv_sec = random() % CONFIG(refresh) + 1;
+	tv.tv_usec = ((random() % 5 + 1)  * 200000) - 1;
 
-	init_alarm(alarm, u, refresher);
-	add_alarm(alarm,
-		  random() % CONFIG(refresh) + 1,
-		  ((random() % 5 + 1)  * 200000) - 1);
+	evtimer_set(&sa->event, refresher, sa);
+	evtimer_add(&sa->event, &tv);
 }
 
 static void cache_alarm_update(struct us_conntrack *u, void *data)
 {
-	struct alarm_list *alarm = data;
-	add_alarm(alarm, 
-		  random() % CONFIG(refresh) + 1,
-		  ((random() % 5 + 1)  * 200000) - 1);
+	struct cache_alarm *sa = data;
+	struct timeval tv;
+
+	sa->u = u;
+
+	tv.tv_sec = random() % CONFIG(refresh) + 1;
+	tv.tv_usec = ((random() % 5 + 1)  * 200000) - 1;
+
+	evtimer_del(&sa->event);
+	evtimer_add(&sa->event, &tv);
 }
 
 static void cache_alarm_destroy(struct us_conntrack *u, void *data)
 {
-	struct alarm_list *alarm = data;
-	del_alarm(alarm);
+	struct cache_alarm *sa = data;
+
+	evtimer_del(&sa->event);
 }
 
 static struct cache_extra cache_alarm_extra = {
-	.size 		= sizeof(struct alarm_list),
+	.size 		= sizeof(struct cache_alarm),
 	.add		= cache_alarm_add,
 	.update		= cache_alarm_update,
 	.destroy	= cache_alarm_destroy
diff --git a/src/sync-ftfw.c b/src/sync-ftfw.c
index 49c0b2c..a4394ba 100644
--- a/src/sync-ftfw.c
+++ b/src/sync-ftfw.c
@@ -22,11 +22,12 @@
 #include "queue.h"
 #include "debug.h"
 #include "network.h"
-#include "alarm.h"
 #include "log.h"
 #include "cache.h"
 
 #include <string.h>
+#include <sys/types.h>
+#include <event.h>
 
 #if 0 
 #define dp printf
@@ -83,17 +84,27 @@ static void tx_queue_add_ctlmsg(uint32_t flags, uint32_t from, uint32_t to)
 	queue_add(tx_queue, &ack, NETHDR_ACK_SIZ);
 }
 
-static struct alarm_list alive_alarm;
+static struct event alive_event;
 
-static void do_alive_alarm(struct alarm_list *a, void *data)
+static void do_alive_alarm(int fd, short event, void *data)
 {
+	struct timeval tv = {
+		.tv_sec = 1,
+		.tv_usec = 0,
+	};
+
 	tx_queue_add_ctlmsg(NET_F_ALIVE, 0, 0);
 
-	add_alarm(&alive_alarm, 1, 0);
+	evtimer_add(&alive_event, &tv);
 }
 
 static int ftfw_init(void)
 {
+	struct timeval tv = {
+		.tv_sec = 1,
+		.tv_usec = 0,
+	};
+
 	tx_queue = queue_create(CONFIG(resend_queue_size));
 	if (tx_queue == NULL) {
 		dlog(LOG_ERR, "cannot create tx queue");
@@ -110,8 +121,8 @@ static int ftfw_init(void)
 	INIT_LIST_HEAD(&rs_list);
 
 	/* XXX: alive message expiration configurable */
-	init_alarm(&alive_alarm, NULL, do_alive_alarm);
-	add_alarm(&alive_alarm, 1, 0);
+	evtimer_set(&alive_event, do_alive_alarm, NULL);
+	evtimer_add(&alive_event, &tv);
 
 	return 0;
 }


