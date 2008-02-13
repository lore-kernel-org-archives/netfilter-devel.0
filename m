From: Max Kellermann <max@duempel.org>
Subject: [conntrack-tools PATCH r7363 5/5] minor whitespace cleanup
Date: Wed, 13 Feb 2008 18:13:28 +0100
Message-ID: <20080213171328.29912.32932.stgit@woodpecker.roonstrasse.net>
References: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:33675 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760708AbYBMRZZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:25:25 -0500
In-Reply-To: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 include/queue.h |    4 ++--
 src/alarm.c     |    4 ++--
 src/main.c      |    6 +++---
 src/netlink.c   |   14 +++++++-------
 src/run.c       |   12 ++++++------
 5 files changed, 20 insertions(+), 20 deletions(-)


diff --git a/include/queue.h b/include/queue.h
index 9a5d7b8..5a9cf39 100644
--- a/include/queue.h
+++ b/include/queue.h
@@ -21,8 +21,8 @@ void queue_destroy(struct queue *b);
 unsigned int queue_len(const struct queue *b);
 int queue_add(struct queue *b, const void *data, size_t size);
 void queue_del(struct queue *b, void *data);
-void queue_iterate(struct queue *b, 
-		   const void *data, 
+void queue_iterate(struct queue *b,
+		   const void *data,
 		   int (*iterate)(void *data1, const void *data2));
 
 #endif
diff --git a/src/alarm.c b/src/alarm.c
index 8056ee6..91ee2ca 100644
--- a/src/alarm.c
+++ b/src/alarm.c
@@ -1,6 +1,6 @@
 /*
  * (C) 2006-2008 by Pablo Neira Ayuso <pablo@netfilter.org>
- * 
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -85,7 +85,7 @@ int alarm_pending(struct alarm_block *alarm)
 
 static struct timeval *
 calculate_next_run(struct timeval *cand,
-		   struct timeval *tv, 
+		   struct timeval *tv,
 		   struct timeval *next_run)
 {
 	if (cand->tv_sec != LONG_MAX) {
diff --git a/src/main.c b/src/main.c
index 8221564..b6011f0 100644
--- a/src/main.c
+++ b/src/main.c
@@ -1,6 +1,6 @@
 /*
  * (C) 2006-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
- * 
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -34,7 +34,7 @@ static const char usage_daemon_commands[] =
 	"Daemon mode commands:\n"
 	"  -d [options]\t\tRun in daemon mode\n";
 
-static const char usage_client_commands[] = 
+static const char usage_client_commands[] =
 	"Client mode commands:\n"
 	"  -c, commit external cache to conntrack table\n"
 	"  -f, flush internal and external cache\n"
@@ -244,7 +244,7 @@ int main(int argc, char *argv[])
 			exit(EXIT_FAILURE);
 		} else if (pid)
 			exit(EXIT_SUCCESS);
-		
+
 		setsid();
 
 		close(STDOUT_FILENO);
diff --git a/src/netlink.c b/src/netlink.c
index bb94001..f6a2378 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1,6 +1,6 @@
 /*
  * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.org>
- * 
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -35,7 +35,7 @@ int ignore_conntrack(struct nf_conntrack *ct)
 		return 0;
 	}
 
-        /* Accept SNAT'ed traffic: not really coming to the local machine */
+	/* Accept SNAT'ed traffic: not really coming to the local machine */
 	if (nfct_getobjopt(ct, NFCT_GOPT_IS_SNAT)) {
 		debug_ct(ct, "SNAT");
 		return 0;
@@ -54,7 +54,7 @@ static int event_handler(enum nf_conntrack_msg_type type,
 			 struct nf_conntrack *ct,
 			 void *data)
 {
-	/* 
+	/*
 	 * Ignore this conntrack: it talks about a
 	 * connection that is not interesting for us.
 	 */
@@ -94,7 +94,7 @@ int nl_init_event_handler(void)
 
 	/* set up socket buffer size */
 	if (CONFIG(netlink_buffer_size))
-		nfnl_rcvbufsiz(nfct_nfnlh(STATE(event)), 
+		nfnl_rcvbufsiz(nfct_nfnlh(STATE(event)),
 			       CONFIG(netlink_buffer_size));
 	else {
 		socklen_t socklen = sizeof(unsigned int);
@@ -109,7 +109,7 @@ int nl_init_event_handler(void)
 
 	/* ensure that maximum grown size is >= than maximum size */
 	if (CONFIG(netlink_buffer_size_max_grown) < CONFIG(netlink_buffer_size))
-		CONFIG(netlink_buffer_size_max_grown) = 
+		CONFIG(netlink_buffer_size_max_grown) =
 					CONFIG(netlink_buffer_size);
 
 	/* register callback for events */
@@ -122,7 +122,7 @@ static int dump_handler(enum nf_conntrack_msg_type type,
 			struct nf_conntrack *ct,
 			void *data)
 {
-	/* 
+	/*
 	 * Ignore this conntrack: it talks about a
 	 * connection that is not interesting for us.
 	 */
@@ -167,7 +167,7 @@ void nl_resize_socket_buffer(struct nfct_handle *h)
 		return;
 
 	if (s > CONFIG(netlink_buffer_size_max_grown)) {
-		dlog(LOG_WARNING, 
+		dlog(LOG_WARNING,
 		     "maximum netlink socket buffer "
 		     "size has been reached. We are likely to "
 		     "be losing events, this may lead to "
diff --git a/src/run.c b/src/run.c
index f5832bc..6cf259d 100644
--- a/src/run.c
+++ b/src/run.c
@@ -48,7 +48,7 @@ void killer(int foo)
 
 	sigprocmask(SIG_UNBLOCK, &STATE(block), NULL);
 
-	exit(0);			
+	exit(0);
 }
 
 static void child(int foo)
@@ -115,7 +115,7 @@ init(void)
 	}
 
 	if (nl_init_event_handler() == -1) {
-		dlog(LOG_ERR, "can't open netlink handler: %s", 
+		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
 		dlog(LOG_ERR, "no ctnetlink kernel support?");
 		return -1;
@@ -128,7 +128,7 @@ init(void)
 		return -1;
 	}
 
-        /* Signals handling */
+	/* Signals handling */
 	sigemptyset(&STATE(block));
 	sigaddset(&STATE(block), SIGTERM);
 	sigaddset(&STATE(block), SIGINT);
@@ -177,7 +177,7 @@ static void __run(struct timeval *next_alarm)
 	}
 
 	/* signals are racy */
-	sigprocmask(SIG_BLOCK, &STATE(block), NULL);		
+	sigprocmask(SIG_BLOCK, &STATE(block), NULL);
 
 	/* order received via UNIX socket */
 	if (FD_ISSET(STATE(local).fd, &readfds))
@@ -189,8 +189,8 @@ static void __run(struct timeval *next_alarm)
 		if (ret == -1) {
 			switch(errno) {
 			case ENOBUFS:
-                		/*
-		 		 * It seems that ctnetlink can't back off,
+				/*
+				 * It seems that ctnetlink can't back off,
 				 * it's likely that we're losing events.
 				 * Solution: duplicate the socket buffer
 				 * size and resync with master conntrack table.


