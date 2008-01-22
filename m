From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 09/11] added handler callback to
	mcast_sock
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.72061.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:50245 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754754AbYAVOQG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:16:06 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 include/mcast.h |   11 ++++++++++-
 src/mcast.c     |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 src/sync-mode.c |   48 +++++++++++-------------------------------------
 3 files changed, 70 insertions(+), 39 deletions(-)


diff --git a/include/mcast.h b/include/mcast.h
index 4e89c72..4d4124f 100644
--- a/include/mcast.h
+++ b/include/mcast.h
@@ -5,6 +5,8 @@
 #include <netinet/in.h>
 #include <net/if.h>
 
+struct nethdr;
+
 struct mcast_conf {
 	int ipproto;
 	int reuseaddr;
@@ -35,9 +37,14 @@ struct mcast_sock {
 		struct sockaddr_in6 ipv6;
 	} addr;
 	struct mcast_stats stats;
+
+	void *data;
+	int (*handler)(struct nethdr *net, void *data);
 };
 
-struct mcast_sock *mcast_server_create(struct mcast_conf *conf);
+struct mcast_sock *mcast_server_create(struct mcast_conf *conf,
+				       void *data,
+				       int (*handler)(struct nethdr *net, void *data));
 void mcast_server_destroy(struct mcast_sock *m);
 
 struct mcast_sock *mcast_client_create(struct mcast_conf *conf);
@@ -46,6 +53,8 @@ void mcast_client_destroy(struct mcast_sock *m);
 ssize_t mcast_send(struct mcast_sock *m, void *data, int size);
 ssize_t mcast_recv(struct mcast_sock *m, void *data, int size);
 
+int mcast_run(struct mcast_sock *m);
+
 struct mcast_stats *mcast_get_stats(struct mcast_sock *m);
 void mcast_dump_stats(int fd, struct mcast_sock *s, struct mcast_sock *r);
 
diff --git a/src/mcast.c b/src/mcast.c
index 8307f26..86de962 100644
--- a/src/mcast.c
+++ b/src/mcast.c
@@ -19,9 +19,12 @@
  */
 
 #include "mcast.h"
+#include "network.h"
+#include "log.h"
 #include "debug.h"
 
 #include <stdio.h>
+#include <syslog.h>
 #include <stdlib.h>
 #include <arpa/inet.h>
 #include <unistd.h>
@@ -29,7 +32,9 @@
 #include <sys/ioctl.h>
 #include <net/if.h>
 
-struct mcast_sock *mcast_server_create(struct mcast_conf *conf)
+struct mcast_sock *mcast_server_create(struct mcast_conf *conf,
+				       void *data,
+				       int (*handler)(struct nethdr *net, void *data))
 {
 	int yes = 1;
 	union {
@@ -122,6 +127,9 @@ struct mcast_sock *mcast_server_create(struct mcast_conf *conf)
 		break;
 	}
 
+	m->data = data;
+	m->handler = handler;
+
 	return m;
 }
 
@@ -283,6 +291,46 @@ ssize_t mcast_recv(struct mcast_sock *m, void *data, int size)
 	return ret;
 }
 
+int mcast_run(struct mcast_sock *m)
+{
+	ssize_t numbytes;
+	size_t remain;
+	int ret;
+	char __net[65536], *ptr = __net; /* XXX: maximum MTU for IPv4 */
+
+	numbytes = mcast_recv(m, __net, sizeof(__net));
+	if (numbytes <= 0)
+		return -1;
+
+	remain = (size_t)numbytes;
+	while (remain > 0) {
+		struct nethdr *net = (struct nethdr *) ptr;
+
+		if (remain < sizeof(*net)) {
+			dlog(LOG_ERR, "packet too small");
+			break;
+		}
+
+		if (ntohs(net->len) > remain) {
+			dlog(LOG_ERR, "fragmented messages");
+			break;
+		}
+
+		debug("recv sq: %u fl:%u len:%u (rem:%d)\n", 
+			ntohl(net->seq), ntohs(net->flags),
+			ntohs(net->len), remain);
+
+		ret = m->handler(net, m->data);
+		if (ret < 0)
+			return ret;
+
+		ptr += ntohs(net->len);
+		remain -= ntohs(net->len);
+	}
+
+	return 0;
+}
+
 struct mcast_stats *mcast_get_stats(struct mcast_sock *m)
 {
 	return &m->stats;
diff --git a/src/sync-mode.c b/src/sync-mode.c
index 5f78bfb..7811d3d 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -85,43 +85,16 @@ retry:
 	}
 }
 
-/* handler for multicast messages received */
-static void mcast_handler(void)
+static int
+mcast_handler(struct nethdr *net, void *data)
 {
-	ssize_t numbytes;
-	size_t remain;
-	char __net[65536], *ptr = __net; /* XXX: maximum MTU for IPv4 */
-
-	numbytes = mcast_recv(STATE_SYNC(mcast_server), __net, sizeof(__net));
-	if (numbytes <= 0)
-		return;
-
-	remain = (size_t)numbytes;
-	while (remain > 0) {
-		struct nethdr *net = (struct nethdr *) ptr;
-
-		if (remain < sizeof(*net)) {
-			dlog(LOG_ERR, "packet too small");
-			break;
-		}
-
-		if (ntohs(net->len) > remain) {
-			dlog(LOG_ERR, "fragmented messages");
-			break;
-		}
-
-		debug("recv sq: %u fl:%u len:%u (rem:%d)\n", 
-			ntohl(net->seq), ntohs(net->flags),
-			ntohs(net->len), remain);
-
-		if (handle_netmsg(net) == -1) {
-			STATE(malformed)++;
-			return;
-		}
-		do_mcast_handler_step(net);
-		ptr += ntohs(net->len);
-		remain -= ntohs(net->len);
+	if (handle_netmsg(net) == -1) {
+		STATE(malformed)++;
+		return -1;
 	}
+
+	do_mcast_handler_step(net);
+	return 0;
 }
 
 static int init_sync(void)
@@ -176,7 +149,8 @@ static int init_sync(void)
 	}
 
 	/* multicast server to receive events from the wire */
-	STATE_SYNC(mcast_server) = mcast_server_create(&CONFIG(mcast));
+	STATE_SYNC(mcast_server) = mcast_server_create(&CONFIG(mcast),
+						       NULL, mcast_handler);
 	if (STATE_SYNC(mcast_server) == NULL) {
 		dlog(LOG_ERR, "can't open multicast server!");
 		return -1;
@@ -214,7 +188,7 @@ static void run_sync(fd_set *readfds)
 {
 	/* multicast packet has been received */
 	if (FD_ISSET(STATE_SYNC(mcast_server->fd), readfds))
-		mcast_handler();
+		mcast_run(STATE_SYNC(mcast_server));
 
 	if (STATE_SYNC(sync)->run)
 		STATE_SYNC(sync)->run();


