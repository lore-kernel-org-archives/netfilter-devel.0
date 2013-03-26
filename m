From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] libmnl: Add filtering support to library as a convienience
Date: Tue, 26 Mar 2013 10:20:43 -0400
Message-ID: <1364307643-21747-1-git-send-email-nhorman@tuxdriver.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Weimer <fweimer@redhat.com>,
	Hushan Jia <hushan.jia@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52610 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934400Ab3CZOVG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:21:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Theres been recent discussion about detecting and discarding unwanted netlink
messages in libmnl, so that we can avoid having applications get spoofed by user
space processes sending messages with malformed netlink headers.  Commonly
applications want to be able to only receive messages from the kernel, but
libmnl currently doesn't offer a mechanism to do that.  This patch adds such a
mechanism.  It creates a function mnl_socket_recvfrom_filter, that adds an
extra function pointer parameter which is used to interrogate recieved frames
and filter them based on a desired criteria.  It also adds a convieninece
function mnl_recvfrom_filter_user which can be passed as the filter agrument in
mnl_socket_recvfrom_filter, so as to prevent individual applications from
re-inventing the wheel over and over again.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Florian Weimer <fweimer@redhat.com>
CC: Hushan Jia <hushan.jia@gmail.com>
---
 include/libmnl/libmnl.h |  3 ++
 src/libmnl.map          |  6 ++++
 src/socket.c            | 84 ++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index a647fd9..2375d25 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -33,6 +33,9 @@ extern int mnl_socket_get_fd(const struct mnl_socket *nl);
 extern unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
 extern ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *req, size_t siz);
 extern ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t siz);
+extern ssize_t mnl_socket_recvfrom_filter(const struct mnl_socket *nl, void *buf, size_t size,
+					  int(*filter)(const struct mnl_socket *, struct msghdr*));
+extern int mnl_recvfrom_filter_user(const struct mnl_socket*, struct msghdr*);
 extern int mnl_socket_setsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t len);
 extern int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t *len);
 
diff --git a/src/libmnl.map b/src/libmnl.map
index dbc332e..ad7dc3d 100644
--- a/src/libmnl.map
+++ b/src/libmnl.map
@@ -72,3 +72,9 @@ local: *;
 LIBMNL_1.1 {
   mnl_attr_parse_payload;
 } LIBMNL_1.0;
+
+
+LIBMNL_1.2 {
+  mnl_socket_recvfrom_filter;
+  mnl_recvfrom_filter_user;
+};
diff --git a/src/socket.c b/src/socket.c
index 6d54563..767eaeb 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -188,6 +188,26 @@ mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
 }
 EXPORT_SYMBOL(mnl_socket_sendto);
 
+static ssize_t
+__mnl_socket_recvfrom(const struct mnl_socket *nl, struct msghdr *msg)
+{
+	ssize_t ret;
+
+	ret = recvmsg(nl->fd, msg, 0);
+	if (ret == -1)
+		return ret;
+
+	if (msg->msg_flags & MSG_TRUNC) {
+		errno = ENOSPC;
+		return -1;
+	}
+	if (msg->msg_namelen != sizeof(struct sockaddr_nl)) {
+		errno = EINVAL;
+		return -1;
+	}
+	return ret;
+}
+
 /**
  * mnl_socket_recvfrom - receive a netlink message
  * \param nl netlink socket obtained via mnl_socket_open()
@@ -205,6 +225,34 @@ EXPORT_SYMBOL(mnl_socket_sendto);
 ssize_t
 mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
 {
+	return mnl_socket_recvfrom_filter(nl, buf, bufsiz, NULL);
+}
+EXPORT_SYMBOL(mnl_socket_recvfrom);
+
+/**
+ * mnl_socket_recvfrom_filter - receive a netlink message after filtering
+ * \param nl netlink socket obtained via mnl_socket_open()
+ * \param buf buffer that you want to use to store the netlink message
+ * \param bufsiz size of the buffer passed to store the netlink message
+ * \param filter function pointer to method to filter messages
+ *
+ * On error, it returns -1 and errno is appropriately set. If errno is set
+ * to ENOSPC, it means that the buffer that you have passed to store the
+ * netlink message is too small, so you have received a truncated message.
+ * To avoid this, you have to allocate a buffer of MNL_SOCKET_BUFFER_SIZE
+ * (which is 8KB, see linux/netlink.h for more information). Using this
+ * buffer size ensures that your buffer is big enough to store the netlink
+ * message without truncating it. For every frame that is successfully received
+ * the filter function is called (if set), a negative return from the filter
+ * function causes the message to be discarded, and the filter error code is
+ * returned to the caller of mnl_socket_recvfrom_filter.  A zero return code
+ * from the filter function returns the message to the caller. 
+ * 
+ */
+ssize_t
+mnl_socket_recvfrom_filter(const struct mnl_socket *nl, void *buf, size_t bufsiz,
+			   int(*filter)(const struct mnl_socket*, struct msghdr*))
+{
 	ssize_t ret;
 	struct sockaddr_nl addr;
 	struct iovec iov = {
@@ -220,21 +268,35 @@ mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
 		.msg_controllen	= 0,
 		.msg_flags	= 0,
 	};
-	ret = recvmsg(nl->fd, &msg, 0);
+retry:
+	ret = __mnl_socket_recvfrom(nl, &msg);
 	if (ret == -1)
 		return ret;
-
-	if (msg.msg_flags & MSG_TRUNC) {
-		errno = ENOSPC;
-		return -1;
-	}
-	if (msg.msg_namelen != sizeof(struct sockaddr_nl)) {
-		errno = EINVAL;
-		return -1;
-	}
+	if (filter)
+		ret = filter(nl, &msg);
 	return ret;
 }
-EXPORT_SYMBOL(mnl_socket_recvfrom);
+EXPORT_SYMBOL(mnl_socket_recvfrom_filter);
+
+/**
+ * mnl_recvfrom_filter_user - helper function to filter user messages
+ * \param nl netlink socket that a message was received on
+ * \param msg - pointer to the msghdr of the received message
+ *
+ * This function is meant to be passed as the filter argument to
+ * mnl_socket_recvfrom_filter.  It is a convienience function to automatically 
+ * filter out messages originating from user space hosts. 
+ *
+ * returns zero, if the message originated from the kernel
+ * returns non-zero if the message did not originate from the kernel
+ */
+int mnl_recvfrom_filter_user(const struct mnl_socket *nl, struct msghdr *msg)
+{
+	struct sockaddr_nl *addr = msg->msg_name;
+
+	return (addr->nl_pid == 0) ? 0 : -1;
+}
+EXPORT_SYMBOL(mnl_recvfrom_filter_user);
 
 /**
  * mnl_socket_close - close a given netlink socket
-- 
1.7.11.7

