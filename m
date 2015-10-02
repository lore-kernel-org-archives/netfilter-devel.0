From: Guillaume Nault <g.nault@alphalink.fr>
Subject: [PATCH libmnl 2/2] examples: use mnl_socket_open2()
Date: Fri, 2 Oct 2015 22:12:52 +0200
Message-ID: <2ab2d3e0182f1e6ab941a4a191442390cbd8bd01.1443815157.git.g.nault@alphalink.fr>
References: <cover.1443815157.git.g.nault@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zimbra.alphalink.fr ([217.15.80.77]:59781 "EHLO
	mail-2-cbv2.admin.alphalink.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751338AbbJBUM6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Oct 2015 16:12:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id B22552B52056
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2015 22:12:56 +0200 (CEST)
Received: from mail-2-cbv2.admin.alphalink.fr ([127.0.0.1])
	by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id sY_FdEVNDpB9 for <netfilter-devel@vger.kernel.org>;
	Fri,  2 Oct 2015 22:12:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 8DE4E2B5218C
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2015 22:12:55 +0200 (CEST)
Received: from mail-2-cbv2.admin.alphalink.fr ([127.0.0.1])
	by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4I6C0ciEx_TJ for <netfilter-devel@vger.kernel.org>;
	Fri,  2 Oct 2015 22:12:55 +0200 (CEST)
Received: from dev-10-pornic.admin.alphalink.fr (94-84-15-217.reverse.alphalink.fr [217.15.84.94])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 5BF802B52056
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2015 22:12:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <cover.1443815157.git.g.nault@alphalink.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Open netlink sockets with the SOCK_CLOEXEC flag to provide sample usage
of the new mnl_socket_open2() function.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
---
 examples/genl/genl-family-get.c        | 4 ++--
 examples/genl/genl-group-events.c      | 4 ++--
 examples/kobject/kobject-event.c       | 4 ++--
 examples/netfilter/nf-log.c            | 4 ++--
 examples/netfilter/nf-queue.c          | 4 ++--
 examples/netfilter/nfct-create-batch.c | 4 ++--
 examples/netfilter/nfct-daemon.c       | 4 ++--
 examples/netfilter/nfct-dump.c         | 4 ++--
 examples/netfilter/nfct-event.c        | 4 ++--
 examples/rtnl/rtnl-addr-dump.c         | 4 ++--
 examples/rtnl/rtnl-link-dump.c         | 4 ++--
 examples/rtnl/rtnl-link-dump2.c        | 4 ++--
 examples/rtnl/rtnl-link-dump3.c        | 4 ++--
 examples/rtnl/rtnl-link-event.c        | 4 ++--
 examples/rtnl/rtnl-link-set.c          | 4 ++--
 examples/rtnl/rtnl-route-add.c         | 4 ++--
 examples/rtnl/rtnl-route-dump.c        | 4 ++--
 examples/rtnl/rtnl-route-event.c       | 4 ++--
 18 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/examples/genl/genl-family-get.c b/examples/genl/genl-family-get.c
index ba8de12..d2ce56f 100644
--- a/examples/genl/genl-family-get.c
+++ b/examples/genl/genl-family-get.c
@@ -206,9 +206,9 @@ int main(int argc, char *argv[])
 	else
 		nlh->nlmsg_flags |= NLM_F_DUMP;
 
-	nl = mnl_socket_open(NETLINK_GENERIC);
+	nl = mnl_socket_open2(NETLINK_GENERIC, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/genl/genl-group-events.c b/examples/genl/genl-group-events.c
index d5f0a18..8a03176 100644
--- a/examples/genl/genl-group-events.c
+++ b/examples/genl/genl-group-events.c
@@ -28,9 +28,9 @@ int main(int argc, char *argv[])
 	}
 	group = atoi(argv[1]);
 
-	nl = mnl_socket_open(NETLINK_GENERIC);
+	nl = mnl_socket_open2(NETLINK_GENERIC, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/kobject/kobject-event.c b/examples/kobject/kobject-event.c
index 97debdf..36d9647 100644
--- a/examples/kobject/kobject-event.c
+++ b/examples/kobject/kobject-event.c
@@ -13,9 +13,9 @@ int main(int argc, char *argv[])
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int ret;
 
-	nl = mnl_socket_open(NETLINK_KOBJECT_UEVENT);
+	nl = mnl_socket_open2(NETLINK_KOBJECT_UEVENT, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/netfilter/nf-log.c b/examples/netfilter/nf-log.c
index 4383b66..ebe4f15 100644
--- a/examples/netfilter/nf-log.c
+++ b/examples/netfilter/nf-log.c
@@ -154,9 +154,9 @@ int main(int argc, char *argv[])
 	}
 	qnum = atoi(argv[1]);
 
-	nl = mnl_socket_open(NETLINK_NETFILTER);
+	nl = mnl_socket_open2(NETLINK_NETFILTER, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/netfilter/nf-queue.c b/examples/netfilter/nf-queue.c
index 957e365..78ed3e3 100644
--- a/examples/netfilter/nf-queue.c
+++ b/examples/netfilter/nf-queue.c
@@ -169,9 +169,9 @@ int main(int argc, char *argv[])
 	}
 	queue_num = atoi(argv[1]);
 
-	nl = mnl_socket_open(NETLINK_NETFILTER);
+	nl = mnl_socket_open2(NETLINK_NETFILTER, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/netfilter/nfct-create-batch.c b/examples/netfilter/nfct-create-batch.c
index 4675789..3278608 100644
--- a/examples/netfilter/nfct-create-batch.c
+++ b/examples/netfilter/nfct-create-batch.c
@@ -139,9 +139,9 @@ int main(void)
 	unsigned int seq, portid;
 	uint16_t i;
 
-	nl = mnl_socket_open(NETLINK_NETFILTER);
+	nl = mnl_socket_open2(NETLINK_NETFILTER, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
diff --git a/examples/netfilter/nfct-daemon.c b/examples/netfilter/nfct-daemon.c
index a97c2ec..a997717 100644
--- a/examples/netfilter/nfct-daemon.c
+++ b/examples/netfilter/nfct-daemon.c
@@ -264,9 +264,9 @@ int main(int argc, char *argv[])
 	nice(-20);
 
 	/* Open netlink socket to operate with netfilter */
-	nl = mnl_socket_open(NETLINK_NETFILTER);
+	nl = mnl_socket_open2(NETLINK_NETFILTER, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/netfilter/nfct-dump.c b/examples/netfilter/nfct-dump.c
index 114af61..7262f04 100644
--- a/examples/netfilter/nfct-dump.c
+++ b/examples/netfilter/nfct-dump.c
@@ -270,9 +270,9 @@ int main(void)
 	uint32_t seq, portid;
 	int ret;
 
-	nl = mnl_socket_open(NETLINK_NETFILTER);
+	nl = mnl_socket_open2(NETLINK_NETFILTER, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/netfilter/nfct-event.c b/examples/netfilter/nfct-event.c
index 94603d4..0c872fa 100644
--- a/examples/netfilter/nfct-event.c
+++ b/examples/netfilter/nfct-event.c
@@ -206,9 +206,9 @@ int main(void)
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int ret;
 
-	nl = mnl_socket_open(NETLINK_NETFILTER);
+	nl = mnl_socket_open2(NETLINK_NETFILTER, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/rtnl/rtnl-addr-dump.c b/examples/rtnl/rtnl-addr-dump.c
index 6b4e52e..0d57df7 100644
--- a/examples/rtnl/rtnl-addr-dump.c
+++ b/examples/rtnl/rtnl-addr-dump.c
@@ -98,9 +98,9 @@ int main(int argc, char *argv[])
 	else if (strcmp(argv[1], "inet6") == 0)
 		rt->rtgen_family = AF_INET6;
 
-	nl = mnl_socket_open(NETLINK_ROUTE);
+	nl = mnl_socket_open2(NETLINK_ROUTE, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/rtnl/rtnl-link-dump.c b/examples/rtnl/rtnl-link-dump.c
index f5d6312..f8013b2 100644
--- a/examples/rtnl/rtnl-link-dump.c
+++ b/examples/rtnl/rtnl-link-dump.c
@@ -95,9 +95,9 @@ int main(void)
 	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
 	rt->rtgen_family = AF_PACKET;
 
-	nl = mnl_socket_open(NETLINK_ROUTE);
+	nl = mnl_socket_open2(NETLINK_ROUTE, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/rtnl/rtnl-link-dump2.c b/examples/rtnl/rtnl-link-dump2.c
index b3ca3fa..88e4a2c 100644
--- a/examples/rtnl/rtnl-link-dump2.c
+++ b/examples/rtnl/rtnl-link-dump2.c
@@ -68,9 +68,9 @@ int main(void)
 	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
 	rt->rtgen_family = AF_PACKET;
 
-	nl = mnl_socket_open(NETLINK_ROUTE);
+	nl = mnl_socket_open2(NETLINK_ROUTE, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/rtnl/rtnl-link-dump3.c b/examples/rtnl/rtnl-link-dump3.c
index 2521214..191b305 100644
--- a/examples/rtnl/rtnl-link-dump3.c
+++ b/examples/rtnl/rtnl-link-dump3.c
@@ -68,9 +68,9 @@ int main(void)
 	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
 	rt->rtgen_family = AF_PACKET;
 
-	nl = mnl_socket_open(NETLINK_ROUTE);
+	nl = mnl_socket_open2(NETLINK_ROUTE, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/rtnl/rtnl-link-event.c b/examples/rtnl/rtnl-link-event.c
index 123fb88..4b9f80e 100644
--- a/examples/rtnl/rtnl-link-event.c
+++ b/examples/rtnl/rtnl-link-event.c
@@ -66,9 +66,9 @@ int main(void)
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int ret;
 
-	nl = mnl_socket_open(NETLINK_ROUTE);
+	nl = mnl_socket_open2(NETLINK_ROUTE, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/rtnl/rtnl-link-set.c b/examples/rtnl/rtnl-link-set.c
index 6086c37..43857ee 100644
--- a/examples/rtnl/rtnl-link-set.c
+++ b/examples/rtnl/rtnl-link-set.c
@@ -46,9 +46,9 @@ int main(int argc, char *argv[])
 
 	mnl_attr_put_str(nlh, IFLA_IFNAME, argv[1]);
 
-	nl = mnl_socket_open(NETLINK_ROUTE);
+	nl = mnl_socket_open2(NETLINK_ROUTE, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/rtnl/rtnl-route-add.c b/examples/rtnl/rtnl-route-add.c
index 97578cd..3465235 100644
--- a/examples/rtnl/rtnl-route-add.c
+++ b/examples/rtnl/rtnl-route-add.c
@@ -92,9 +92,9 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	nl = mnl_socket_open(NETLINK_ROUTE);
+	nl = mnl_socket_open2(NETLINK_ROUTE, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/rtnl/rtnl-route-dump.c b/examples/rtnl/rtnl-route-dump.c
index 17da80b..147a801 100644
--- a/examples/rtnl/rtnl-route-dump.c
+++ b/examples/rtnl/rtnl-route-dump.c
@@ -321,9 +321,9 @@ int main(int argc, char *argv[])
 	else if (strcmp(argv[1], "inet6") == 0)
 		rtm->rtm_family = AF_INET6;
 
-	nl = mnl_socket_open(NETLINK_ROUTE);
+	nl = mnl_socket_open2(NETLINK_ROUTE, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/rtnl/rtnl-route-event.c b/examples/rtnl/rtnl-route-event.c
index 6cad9f0..9c79b0c 100644
--- a/examples/rtnl/rtnl-route-event.c
+++ b/examples/rtnl/rtnl-route-event.c
@@ -311,9 +311,9 @@ int main(int argc, char *argv[])
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int ret;
 
-	nl = mnl_socket_open(NETLINK_ROUTE);
+	nl = mnl_socket_open2(NETLINK_ROUTE, SOCK_CLOEXEC);
 	if (nl == NULL) {
-		perror("mnl_socket_open");
+		perror("mnl_socket_open2");
 		exit(EXIT_FAILURE);
 	}
 
-- 
2.6.0

