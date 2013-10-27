From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH libmnl] socket: Enable specifying receiver of a netlink messages
Date: Sun, 27 Oct 2013 12:03:55 +0100
Message-ID: <1382871835-2491-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:43009 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3J0LED (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:04:03 -0400
Received: by mail-la0-f47.google.com with SMTP id ep20so4381901lab.34
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2013 04:04:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

This patch adds the mnl_socket_sendto2()-call, which enables applications to
specify the receiving pid/netlink multicast group of a netlink message. This
functionality is useful when using Netlink to communicate between application
running in userspace, for example over the NETLINK_USERSOCK netlink-family.

A new inline function, __mnl_socket_sendto(), sends the data. This function is
called by both mnl_socket_sendto() and mnl_socket_sendto2().

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/libmnl/libmnl.h |  2 ++
 src/libmnl.map          |  1 +
 src/socket.c            | 39 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 223709c..f953129 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -27,6 +27,8 @@ extern int mnl_socket_close(struct mnl_socket *nl);
 extern int mnl_socket_get_fd(const struct mnl_socket *nl);
 extern unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
 extern ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *req, size_t siz);
+extern ssize_t mnl_socket_sendto2(const struct mnl_socket *nl, const void *req, size_t siz,
+				   const pid_t pid, const unsigned int group);
 extern ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t siz);
 extern int mnl_socket_setsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t len);
 extern int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t *len);
diff --git a/src/libmnl.map b/src/libmnl.map
index dbc332e..295b160 100644
--- a/src/libmnl.map
+++ b/src/libmnl.map
@@ -71,4 +71,5 @@ local: *;
 
 LIBMNL_1.1 {
   mnl_attr_parse_payload;
+  mnl_socket_sendto2;
 } LIBMNL_1.0;
diff --git a/src/socket.c b/src/socket.c
index 6d54563..d6236e7 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -168,6 +168,19 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
 }
 EXPORT_SYMBOL(mnl_socket_bind);
 
+static inline ssize_t
+__mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len,
+		     const pid_t pid, const unsigned int group)
+{
+	struct sockaddr_nl snl = {
+		.nl_family	= AF_NETLINK,
+		.nl_pid		= pid,
+		.nl_groups	= group,
+	};
+	return sendto(nl->fd, buf, len, 0,
+		      (struct sockaddr *) &snl, sizeof(snl));
+}
+
 /**
  * mnl_socket_sendto - send a netlink message of a certain size
  * \param nl netlink socket obtained via mnl_socket_open()
@@ -180,15 +193,31 @@ EXPORT_SYMBOL(mnl_socket_bind);
 ssize_t
 mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
 {
-	static const struct sockaddr_nl snl = {
-		.nl_family = AF_NETLINK
-	};
-	return sendto(nl->fd, buf, len, 0, 
-		      (struct sockaddr *) &snl, sizeof(snl));
+	return __mnl_socket_sendto(nl, buf, len, 0, 0);
 }
 EXPORT_SYMBOL(mnl_socket_sendto);
 
 /**
+ * mnl_socket_sendto2 - send a netlink message of a certain size to a given
+ * receiver.
+ * \param nl netlink socket obtained via mnl_socket_open()
+ * \param buf buffer containing the netlink message to be sent
+ * \param len number of bytes in the buffer that you want to send
+ * \param pid pid to send message to
+ * \param group netlink multicast group to send message to
+ *
+ * On error, it returns -1 and errno is appropriately set. Otherwise, it
+ * returns the number of bytes sent.
+ */
+ssize_t
+mnl_socket_sendto2(const struct mnl_socket *nl, const void *buf, size_t len,
+		    const pid_t pid, const unsigned int group)
+{
+	return __mnl_socket_sendto(nl, buf, len, pid, group);
+}
+EXPORT_SYMBOL(mnl_socket_sendto2);
+
+/**
  * mnl_socket_recvfrom - receive a netlink message
  * \param nl netlink socket obtained via mnl_socket_open()
  * \param buf buffer that you want to use to store the netlink message
-- 
1.8.3.2

