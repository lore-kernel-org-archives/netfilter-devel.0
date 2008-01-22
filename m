From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 07/11] use size_t
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.59792.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:46711 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754402AbYAVOOH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:14:07 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 include/mcast.h   |    4 ++--
 include/network.h |    7 ++++---
 src/build.c       |    2 +-
 src/local.c       |    4 ++--
 src/mcast.c       |    8 ++++----
 src/network.c     |   22 +++++++++++-----------
 src/sync-alarm.c  |    2 +-
 src/sync-ftfw.c   |    4 ++--
 src/sync-mode.c   |   11 ++++++-----
 9 files changed, 33 insertions(+), 31 deletions(-)


diff --git a/include/mcast.h b/include/mcast.h
index e3cdb38..4e89c72 100644
--- a/include/mcast.h
+++ b/include/mcast.h
@@ -43,8 +43,8 @@ void mcast_server_destroy(struct mcast_sock *m);
 struct mcast_sock *mcast_client_create(struct mcast_conf *conf);
 void mcast_client_destroy(struct mcast_sock *m);
 
-int mcast_send(struct mcast_sock *m, void *data, int size);
-int mcast_recv(struct mcast_sock *m, void *data, int size);
+ssize_t mcast_send(struct mcast_sock *m, void *data, int size);
+ssize_t mcast_recv(struct mcast_sock *m, void *data, int size);
 
 struct mcast_stats *mcast_get_stats(struct mcast_sock *m);
 void mcast_dump_stats(int fd, struct mcast_sock *s, struct mcast_sock *r);
diff --git a/include/network.h b/include/network.h
index e3e9ce1..92a8490 100644
--- a/include/network.h
+++ b/include/network.h
@@ -2,6 +2,7 @@
 #define _NETWORK_H_
 
 #include <stdint.h>
+#include <sys/types.h>
 
 struct nf_conntrack;
 
@@ -53,7 +54,7 @@ struct us_conntrack;
 struct mcast_sock;
 
 void build_netmsg(struct nf_conntrack *ct, int query, struct nethdr *net);
-int prepare_send_netmsg(struct mcast_sock *m, void *data);
+size_t prepare_send_netmsg(struct mcast_sock *m, void *data);
 int mcast_send_netmsg(struct mcast_sock *m, void *data);
 int handle_netmsg(struct nethdr *net);
 int mcast_track_seq(uint32_t seq, uint32_t *exp_seq);
@@ -62,8 +63,8 @@ struct mcast_conf;
 
 int mcast_buffered_init(struct mcast_conf *conf);
 void mcast_buffered_destroy(void);
-int mcast_buffered_send_netmsg(struct mcast_sock *m, void *data, int len);
-int mcast_buffered_pending_netmsg(struct mcast_sock *m);
+int mcast_buffered_send_netmsg(struct mcast_sock *m, void *data, size_t len);
+ssize_t mcast_buffered_pending_netmsg(struct mcast_sock *m);
 
 #define IS_DATA(x)	((x->flags & ~NET_F_HELLO) == 0)
 #define IS_ACK(x)	(x->flags & NET_F_ACK)
diff --git a/src/build.c b/src/build.c
index c99990b..3de1c25 100644
--- a/src/build.c
+++ b/src/build.c
@@ -20,7 +20,7 @@
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include "network.h"
 
-static void addattr(struct netpld *pld, int attr, const void *data, int len)
+static void addattr(struct netpld *pld, int attr, const void *data, size_t len)
 {
 	struct netattr *nta;
 	int tlen = NTA_LENGTH(len);
diff --git a/src/local.c b/src/local.c
index 7aab151..f054c0a 100644
--- a/src/local.c
+++ b/src/local.c
@@ -31,7 +31,7 @@ int local_server_create(struct local_server *server, struct local_conf *conf,
 			void (*process)(int fd, void *data))
 {
 	int fd;
-	int len;
+	socklen_t len;
 	struct sockaddr_un local;
 
 	if ((fd = socket(AF_UNIX, SOCK_STREAM, 0)) == -1)
@@ -92,7 +92,7 @@ int do_local_server_step(struct local_server *server)
 
 int local_client_create(struct local_conf *conf)
 {
-	int len;
+	socklen_t len;
 	struct sockaddr_un local;
 	int fd;
 
diff --git a/src/mcast.c b/src/mcast.c
index e977c0b..8307f26 100644
--- a/src/mcast.c
+++ b/src/mcast.c
@@ -238,9 +238,9 @@ void mcast_client_destroy(struct mcast_sock *m)
 	free(m);
 }
 
-int mcast_send(struct mcast_sock *m, void *data, int size)
+ssize_t mcast_send(struct mcast_sock *m, void *data, int size)
 {
-	int ret;
+	ssize_t ret;
 	
 	ret = sendto(m->fd, 
 		     data,
@@ -260,9 +260,9 @@ int mcast_send(struct mcast_sock *m, void *data, int size)
 	return ret;
 }
 
-int mcast_recv(struct mcast_sock *m, void *data, int size)
+ssize_t mcast_recv(struct mcast_sock *m, void *data, int size)
 {
-	int ret;
+	ssize_t ret;
 	socklen_t sin_size = sizeof(struct sockaddr_in);
 
         ret = recvfrom(m->fd,
diff --git a/src/network.c b/src/network.c
index da26545..92999a1 100644
--- a/src/network.c
+++ b/src/network.c
@@ -27,7 +27,7 @@
 
 static unsigned int seq_set, cur_seq;
 
-static int __do_send(struct mcast_sock *m, void *data, int len)
+static size_t __do_send(struct mcast_sock *m, void *data, size_t len)
 {
 	struct nethdr *net = data;
 
@@ -50,7 +50,7 @@ static int __do_send(struct mcast_sock *m, void *data, int len)
 	return mcast_send(m, net, len);
 }
 
-static int __do_prepare(struct mcast_sock *m, void *data, int len)
+static size_t __do_prepare(struct mcast_sock *m, void *data, size_t len)
 {
 	struct nethdr *net = data;
 
@@ -66,12 +66,12 @@ static int __do_prepare(struct mcast_sock *m, void *data, int len)
 	return len;
 }
 
-static int __prepare_ctl(struct mcast_sock *m, void *data)
+static size_t __prepare_ctl(struct mcast_sock *m, void *data)
 {
 	return __do_prepare(m, data, NETHDR_ACK_SIZ);
 }
 
-static int __prepare_data(struct mcast_sock *m, void *data)
+static size_t __prepare_data(struct mcast_sock *m, void *data)
 {
 	struct nethdr *net = (struct nethdr *) data;
 	struct netpld *pld = NETHDR_DATA(net);
@@ -79,7 +79,7 @@ static int __prepare_data(struct mcast_sock *m, void *data)
 	return __do_prepare(m, data, ntohs(pld->len) + NETPLD_SIZ + NETHDR_SIZ);
 }
 
-int prepare_send_netmsg(struct mcast_sock *m, void *data)
+size_t prepare_send_netmsg(struct mcast_sock *m, void *data)
 {
 	int ret = 0;
 	struct nethdr *net = (struct nethdr *) data;
@@ -92,8 +92,8 @@ int prepare_send_netmsg(struct mcast_sock *m, void *data)
 	return ret;
 }
 
-static int tx_buflenmax;
-static int tx_buflen = 0;
+static size_t tx_buflenmax;
+static size_t tx_buflen = 0;
 static char *tx_buf;
 
 #define HEADERSIZ 28 /* IP header (20 bytes) + UDP header 8 (bytes) */
@@ -121,7 +121,7 @@ void mcast_buffered_destroy(void)
 }
 
 /* return 0 if it is not sent, otherwise return 1 */
-int mcast_buffered_send_netmsg(struct mcast_sock *m, void *data, int len)
+int mcast_buffered_send_netmsg(struct mcast_sock *m, void *data, size_t len)
 {
 	int ret = 0;
 	struct nethdr *net = data;
@@ -140,9 +140,9 @@ retry:
 	return ret;
 }
 
-int mcast_buffered_pending_netmsg(struct mcast_sock *m)
+ssize_t mcast_buffered_pending_netmsg(struct mcast_sock *m)
 {
-	int ret;
+	ssize_t ret;
 
 	if (tx_buflen == 0)
 		return 0;
@@ -156,7 +156,7 @@ int mcast_buffered_pending_netmsg(struct mcast_sock *m)
 int mcast_send_netmsg(struct mcast_sock *m, void *data)
 {
 	int ret;
-	int len = prepare_send_netmsg(m, data);
+	size_t len = prepare_send_netmsg(m, data);
 
 	ret = mcast_buffered_send_netmsg(m, data, len);
 	mcast_buffered_pending_netmsg(m);
diff --git a/src/sync-alarm.c b/src/sync-alarm.c
index 66727e7..c7cecc8 100644
--- a/src/sync-alarm.c
+++ b/src/sync-alarm.c
@@ -29,7 +29,7 @@
 
 static void refresher(struct alarm_list *a, void *data)
 {
-	int len;
+	size_t len;
 	struct nethdr *net;
 	struct us_conntrack *u = data;
 
diff --git a/src/sync-ftfw.c b/src/sync-ftfw.c
index 1d12002..49c0b2c 100644
--- a/src/sync-ftfw.c
+++ b/src/sync-ftfw.c
@@ -285,7 +285,7 @@ static void ftfw_send(struct nethdr *net, struct us_conntrack *u)
 static int tx_queue_xmit(void *data1, const void *data2)
 {
 	struct nethdr *net = data1;
-	int len = prepare_send_netmsg(STATE_SYNC(mcast_client), net);
+	size_t len = prepare_send_netmsg(STATE_SYNC(mcast_client), net);
 
 	dp("tx_queue sq: %u fl:%u len:%u\n",
                ntohl(net->seq), ntohs(net->flags), ntohs(net->len));
@@ -307,7 +307,7 @@ static int tx_list_xmit(struct list_head *i, struct us_conntrack *u)
 {
 	int ret;
 	struct nethdr *net = BUILD_NETMSG(u->ct, NFCT_Q_UPDATE);
-	int len = prepare_send_netmsg(STATE_SYNC(mcast_client), net);
+	size_t len = prepare_send_netmsg(STATE_SYNC(mcast_client), net);
 
 	dp("tx_list sq: %u fl:%u len:%u\n",
                 ntohl(net->seq), ntohs(net->flags),
diff --git a/src/sync-mode.c b/src/sync-mode.c
index 7db180e..bf8ddef 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -88,14 +88,15 @@ retry:
 /* handler for multicast messages received */
 static void mcast_handler(void)
 {
-	int numbytes, remain;
+	ssize_t numbytes;
+	size_t remain;
 	char __net[65536], *ptr = __net; /* XXX: maximum MTU for IPv4 */
 
 	numbytes = mcast_recv(STATE_SYNC(mcast_server), __net, sizeof(__net));
 	if (numbytes <= 0)
 		return;
 
-	remain = numbytes;
+	remain = (size_t)numbytes;
 	while (remain > 0) {
 		struct nethdr *net = (struct nethdr *) ptr;
 
@@ -333,7 +334,7 @@ static void mcast_send_sync(struct us_conntrack *u,
 			    struct nf_conntrack *ct,
 			    int query)
 {
-	int len;
+	size_t len;
 	struct nethdr *net;
 
 	if (!state_helper_verdict(query, ct))
@@ -367,7 +368,7 @@ static int overrun_cb(enum nf_conntrack_msg_type type,
 
 	if (!cache_test(STATE_SYNC(internal), ct)) {
 		if ((u = cache_update_force(STATE_SYNC(internal), ct))) {
-			int len;
+			size_t len;
 
 			debug_ct(u->ct, "overrun resync");
 
@@ -391,7 +392,7 @@ static int overrun_purge_step(void *data1, void *data2)
 
 	ret = nfct_query(h, NFCT_Q_GET, u->ct);
 	if (ret == -1 && errno == ENOENT) {
-		int len;
+		size_t len;
 		struct nethdr *net = BUILD_NETMSG(u->ct, NFCT_Q_DESTROY);
 
 		debug_ct(u->ct, "overrun purge resync");


