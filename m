From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH libmnl] socket: creating a struct mnl_socket from a
 pre-existing socket
Date: Sat, 20 Sep 2014 15:05:37 +0900
Message-ID: <20140920060536.GA15209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64330 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaITGFp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Sep 2014 02:05:45 -0400
Received: by mail-pd0-f182.google.com with SMTP id p10so1059293pdj.27
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Sep 2014 23:05:45 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch defines a new function mnl_socket_fdopen() which
creates a struct mnl_socket object from a pre-existing netlink
socket obtained from other process. Now I think of the socket
is obtained from child process via send/recvmsg().

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/libmnl/libmnl.h |  1 +
 src/libmnl.map          |  1 +
 src/socket.c            | 20 ++++++++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 223709c..0de6678 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -22,6 +22,7 @@ extern "C" {
 struct mnl_socket;
 
 extern struct mnl_socket *mnl_socket_open(int type);
+extern struct mnl_socket *mnl_socket_fdopen(int fd);
 extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid);
 extern int mnl_socket_close(struct mnl_socket *nl);
 extern int mnl_socket_get_fd(const struct mnl_socket *nl);
diff --git a/src/libmnl.map b/src/libmnl.map
index dbc332e..1ea8b8e 100644
--- a/src/libmnl.map
+++ b/src/libmnl.map
@@ -71,4 +71,5 @@ local: *;
 
 LIBMNL_1.1 {
   mnl_attr_parse_payload;
+  mnl_socket_fdopen;
 } LIBMNL_1.0;
diff --git a/src/socket.c b/src/socket.c
index 676a08a..bb9db18 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -129,6 +129,26 @@ struct mnl_socket *mnl_socket_open(int bus)
 EXPORT_SYMBOL(mnl_socket_open);
 
 /**
+ * mnl_socket_fdopen - associates a mnl_socket object with netlink socket.
+ * \param fd pre-existing netlink socket, obtained from other process.
+ *
+ * On error, it returns NULL and errno is appropriately set. Otherwise, it
+ * returns a valid pointer to the mnl_socket structure.
+ */
+struct mnl_socket *mnl_socket_fdopen(int fd)
+{
+	struct mnl_socket *nl;
+
+	nl = calloc(sizeof(struct mnl_socket), 1);
+	if (nl == NULL)
+		return NULL;
+
+	nl->fd = fd;
+	return nl;
+}
+EXPORT_SYMBOL(mnl_socket_fdopen);
+
+/**
  * mnl_socket_bind - bind netlink socket
  * \param nl netlink socket obtained via mnl_socket_open()
  * \param groups the group of message you're interested in
-- 
2.1.0

