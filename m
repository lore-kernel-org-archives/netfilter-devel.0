From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 libmnl] socket: creating a struct mnl_socket from a
 pre-existing socket
Date: Thu, 25 Sep 2014 09:33:27 +0900
Message-ID: <20140925003327.GB20985@gmail.com>
References: <20140920060536.GA15209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35819 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaIYAde (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 20:33:34 -0400
Received: by mail-pa0-f49.google.com with SMTP id lf10so9625758pab.8
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2014 17:33:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140920060536.GA15209@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch defines a new function mnl_socket_fdopen() which creates a
struct mnl_socket object from a pre-existing socket like obtained from
other process, different domain/type from the same prodess.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/libmnl/libmnl.h |  1 +
 src/libmnl.map          |  4 ++++
 src/socket.c            | 31 +++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

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
index dbc332e..3c147a7 100644
--- a/src/libmnl.map
+++ b/src/libmnl.map
@@ -72,3 +72,7 @@ local: *;
 LIBMNL_1.1 {
   mnl_attr_parse_payload;
 } LIBMNL_1.0;
+
+LIBMNL_1.2 {
+  mnl_socket_fdopen;
+} LIBMNL_1.1;
diff --git a/src/socket.c b/src/socket.c
index 676a08a..0542f8f 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -129,6 +129,37 @@ struct mnl_socket *mnl_socket_open(int bus)
 EXPORT_SYMBOL(mnl_socket_open);
 
 /**
+ * mnl_socket_fdopen - associates a mnl_socket object with pre-existing socket.
+ * \param fd pre-existing socket descriptor.
+ *
+ * On error, it returns NULL and errno is appropriately set. Otherwise, it
+ * returns a valid pointer to the mnl_socket structure. It also set address if
+ * the fd is AF_NETLINK.
+ */
+struct mnl_socket *mnl_socket_fdopen(int fd)
+{
+	int ret;
+	struct mnl_socket *nl;
+	struct sockaddr_nl addr;
+	socklen_t addr_len = sizeof(struct sockaddr_nl);
+
+	ret = getsockname(fd, (struct sockaddr *) &addr, &addr_len);
+	if (ret == -1)
+		return NULL;
+
+	nl = calloc(sizeof(struct mnl_socket), 1);
+	if (nl == NULL)
+		return NULL;
+
+	nl->fd = fd;
+	if (addr.nl_family == AF_NETLINK)
+		nl->addr = addr;
+
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

