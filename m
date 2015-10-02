From: Guillaume Nault <g.nault@alphalink.fr>
Subject: [PATCH libmnl 1/2] socket: introduce mnl_socket_open2()
Date: Fri, 2 Oct 2015 22:12:33 +0200
Message-ID: <8ecf77e50d2acd0b20bdd18038b8e25fd6c86ec0.1443815157.git.g.nault@alphalink.fr>
References: <cover.1443815157.git.g.nault@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zimbra.alphalink.fr ([217.15.80.77]:59759 "EHLO
	mail-2-cbv2.admin.alphalink.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751016AbbJBUMj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Oct 2015 16:12:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id A9E902B52056
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2015 22:12:37 +0200 (CEST)
Received: from mail-2-cbv2.admin.alphalink.fr ([127.0.0.1])
	by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id OQYAloDu_-rn for <netfilter-devel@vger.kernel.org>;
	Fri,  2 Oct 2015 22:12:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 5F9082B5218C
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2015 22:12:36 +0200 (CEST)
Received: from mail-2-cbv2.admin.alphalink.fr ([127.0.0.1])
	by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 99nowk0cRuJs for <netfilter-devel@vger.kernel.org>;
	Fri,  2 Oct 2015 22:12:36 +0200 (CEST)
Received: from dev-10-pornic.admin.alphalink.fr (94-84-15-217.reverse.alphalink.fr [217.15.84.94])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 2B35C2B52056
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2015 22:12:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <cover.1443815157.git.g.nault@alphalink.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Define mnl_socket_open2() so that user can pass a set of SOCK_* flags
at socket creation time.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
---
 include/libmnl/libmnl.h |  3 ++-
 src/libmnl.map          |  1 +
 src/socket.c            | 41 ++++++++++++++++++++++++++++++++---------
 3 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 3a589bc..5adb13c 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -21,7 +21,8 @@ extern "C" {
 
 struct mnl_socket;
 
-extern struct mnl_socket *mnl_socket_open(int type);
+extern struct mnl_socket *mnl_socket_open(int bus);
+extern struct mnl_socket *mnl_socket_open2(int bus, int flags);
 extern struct mnl_socket *mnl_socket_fdopen(int fd);
 extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid);
 extern int mnl_socket_close(struct mnl_socket *nl);
diff --git a/src/libmnl.map b/src/libmnl.map
index 3c147a7..e5920e5 100644
--- a/src/libmnl.map
+++ b/src/libmnl.map
@@ -74,5 +74,6 @@ LIBMNL_1.1 {
 } LIBMNL_1.0;
 
 LIBMNL_1.2 {
+  mnl_socket_open2;
   mnl_socket_fdopen;
 } LIBMNL_1.1;
diff --git a/src/socket.c b/src/socket.c
index 86657d4..d63ab87 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -103,14 +103,7 @@ unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
 }
 EXPORT_SYMBOL(mnl_socket_get_portid);
 
-/**
- * mnl_socket_open - open a netlink socket
- * \param bus the netlink socket bus ID (see NETLINK_* constants)
- *
- * On error, it returns NULL and errno is appropriately set. Otherwise, it
- * returns a valid pointer to the mnl_socket structure.
- */
-struct mnl_socket *mnl_socket_open(int bus)
+static struct mnl_socket *__mnl_socket_open(int bus, int flags)
 {
 	struct mnl_socket *nl;
 
@@ -118,7 +111,7 @@ struct mnl_socket *mnl_socket_open(int bus)
 	if (nl == NULL)
 		return NULL;
 
-	nl->fd = socket(AF_NETLINK, SOCK_RAW, bus);
+	nl->fd = socket(AF_NETLINK, SOCK_RAW | flags, bus);
 	if (nl->fd == -1) {
 		free(nl);
 		return NULL;
@@ -126,9 +119,39 @@ struct mnl_socket *mnl_socket_open(int bus)
 
 	return nl;
 }
+
+/**
+ * mnl_socket_open - open a netlink socket
+ * \param bus the netlink socket bus ID (see NETLINK_* constants)
+ *
+ * On error, it returns NULL and errno is appropriately set. Otherwise, it
+ * returns a valid pointer to the mnl_socket structure.
+ */
+struct mnl_socket *mnl_socket_open(int bus)
+{
+	return __mnl_socket_open(bus, 0);
+}
 EXPORT_SYMBOL(mnl_socket_open);
 
 /**
+ * mnl_socket_open2 - open a netlink socket with appropriate flags
+ * \param bus the netlink socket bus ID (see NETLINK_* constants)
+ * \param flags the netlink socket flags (see SOCK_* constants in socket(2))
+ *
+ * This is similar to mnl_socket_open(), but allows to set flags like
+ * SOCK_CLOEXEC at socket creation time (useful for multi-threaded programs
+ * performing exec calls).
+ *
+ * On error, it returns NULL and errno is appropriately set. Otherwise, it
+ * returns a valid pointer to the mnl_socket structure.
+ */
+struct mnl_socket *mnl_socket_open2(int bus, int flags)
+{
+	return __mnl_socket_open(bus, flags);
+}
+EXPORT_SYMBOL(mnl_socket_open2);
+
+/**
  * mnl_socket_fdopen - associates a mnl_socket object with pre-existing socket.
  * \param fd pre-existing socket descriptor.
  *
-- 
2.6.0

