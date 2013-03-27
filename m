From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] libmnl: Add filtering support to library as a convienience
Date: Wed, 27 Mar 2013 10:21:03 +0100
Message-ID: <5152B9FF.7050705@redhat.com>
References: <1364307643-21747-1-git-send-email-nhorman@tuxdriver.com> <20130326205028.GA7117@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070709040108070903030101"
Cc: Neil Horman <nhorman@tuxdriver.com>,
	netfilter-devel@vger.kernel.org, Hushan Jia <hushan.jia@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab3C0JVc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:21:32 -0400
In-Reply-To: <20130326205028.GA7117@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070709040108070903030101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/26/2013 09:50 PM, Pablo Neira Ayuso wrote:

> I remember that report from Florian. After some discussion, I proposed
> this solution:
>
> commit 20e1db19db5d6b9e4e83021595eab0dc8f107bef
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Thu Aug 23 02:09:11 2012 +0000
>
>      netlink: fix possible spoofing from non-root processes
>
> Basically, it disables netlink-to-netlink communications between
> non-root processes (with the exception of NETLINK_USERSOCK), so
> non-root processes cannot spoof messages anymore.

We are a bit in a bind here because we need to support kernels without 
this patch, and we don't want to add symbols to libmnl which aren't part 
of upstream.

Perhaps an interface to access the sender socket address would be an 
acceptable compromise, like the attached patch?  That would be useful 
independently.

-- 
Florian Weimer / Red Hat Product Security Team

--------------070709040108070903030101
Content-Type: text/x-patch;
 name="0001-Functions-which-modify-state-should-not-take-const-a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Functions-which-modify-state-should-not-take-const-a.pa";
 filename*1="tch"

>From 2a6246b9158df6c4ef1000a5a92b599a1f393f7f Mon Sep 17 00:00:00 2001
From: Florian Weimer <fweimer@redhat.com>
Date: Wed, 27 Mar 2013 10:10:01 +0100
Subject: [PATCH 1/2] Functions which modify state should not take const
 arguments

Sending and receiving packets and changing socket options
modify the internal socket state, which was not reflected in the
prototype.  mnl_socket_get_fd provides access to the underlying
file descriptor, which indirectly allows modification.

Signed-off-by: Florian Weimer <fweimer@redhat.com>
---
 include/libmnl/libmnl.h | 8 ++++----
 src/socket.c            | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index a647fd9..5145ba5 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -29,11 +29,11 @@ struct mnl_socket;
 extern struct mnl_socket *mnl_socket_open(int type);
 extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid);
 extern int mnl_socket_close(struct mnl_socket *nl);
-extern int mnl_socket_get_fd(const struct mnl_socket *nl);
+extern int mnl_socket_get_fd(struct mnl_socket *nl);
 extern unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
-extern ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *req, size_t siz);
-extern ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t siz);
-extern int mnl_socket_setsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t len);
+extern ssize_t mnl_socket_sendto(struct mnl_socket *nl, const void *req, size_t siz);
+extern ssize_t mnl_socket_recvfrom(struct mnl_socket *nl, void *buf, size_t siz);
+extern int mnl_socket_setsockopt(struct mnl_socket *nl, int type, void *buf, socklen_t len);
 extern int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t *len);
 
 /*
diff --git a/src/socket.c b/src/socket.c
index 6d54563..c77af91 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -82,7 +82,7 @@ struct mnl_socket {
  *
  * This function returns the file descriptor of a given netlink socket.
  */
-int mnl_socket_get_fd(const struct mnl_socket *nl)
+int mnl_socket_get_fd(struct mnl_socket *nl)
 {
 	return nl->fd;
 }
@@ -178,7 +178,7 @@ EXPORT_SYMBOL(mnl_socket_bind);
  * returns the number of bytes sent.
  */
 ssize_t
-mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
+mnl_socket_sendto(struct mnl_socket *nl, const void *buf, size_t len)
 {
 	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
@@ -203,7 +203,7 @@ EXPORT_SYMBOL(mnl_socket_sendto);
  * message without truncating it.
  */
 ssize_t
-mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
+mnl_socket_recvfrom(struct mnl_socket *nl, void *buf, size_t bufsiz)
 {
 	ssize_t ret;
 	struct sockaddr_nl addr;
@@ -276,7 +276,7 @@ EXPORT_SYMBOL(mnl_socket_close);
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
+int mnl_socket_setsockopt(struct mnl_socket *nl, int type,
 			  void *buf, socklen_t len)
 {
 	return setsockopt(nl->fd, SOL_NETLINK, type, buf, len);
-- 
1.8.1.4


--------------070709040108070903030101
Content-Type: text/x-patch;
 name="0002-mnl_socket_peer_address-Add-function-to-retrieve-the.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-mnl_socket_peer_address-Add-function-to-retrieve-the.pa";
 filename*1="tch"

>From 7da5a365c9908972726243b12b91666352c1ee31 Mon Sep 17 00:00:00 2001
From: Florian Weimer <fweimer@redhat.com>
Date: Wed, 27 Mar 2013 10:19:35 +0100
Subject: [PATCH 2/2] mnl_socket_peer_address: Add function to retrieve the
 sender address

This allows callers of mnl_socket_recvfrom to examine the address,
for instance, to give special treatment to messages sent by the kernel.

Signed-off-by: Florian Weimer <fweimer@redhat.com>
---
 include/libmnl/libmnl.h |  1 +
 src/libmnl.map          |  4 ++++
 src/socket.c            | 24 ++++++++++++++++++++----
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 5145ba5..74995fa 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -33,6 +33,7 @@ extern int mnl_socket_get_fd(struct mnl_socket *nl);
 extern unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
 extern ssize_t mnl_socket_sendto(struct mnl_socket *nl, const void *req, size_t siz);
 extern ssize_t mnl_socket_recvfrom(struct mnl_socket *nl, void *buf, size_t siz);
+extern struct sockaddr_nl *mnl_socket_peer_address(struct mnl_socket *nl);
 extern int mnl_socket_setsockopt(struct mnl_socket *nl, int type, void *buf, socklen_t len);
 extern int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t *len);
 
diff --git a/src/libmnl.map b/src/libmnl.map
index dbc332e..626ea87 100644
--- a/src/libmnl.map
+++ b/src/libmnl.map
@@ -69,6 +69,10 @@ global:
 local: *;
 };
 
+LIBMNL_1.0.3 {
+  mnl_socket_peer_address;
+};
+
 LIBMNL_1.1 {
   mnl_attr_parse_payload;
 } LIBMNL_1.0;
diff --git a/src/socket.c b/src/socket.c
index c77af91..1d956a0 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -8,6 +8,7 @@
  */
 
 #include <libmnl/libmnl.h>
+#include <string.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <stdlib.h>
@@ -69,6 +70,7 @@
 struct mnl_socket {
 	int 			fd;
 	struct sockaddr_nl	addr;
+	struct sockaddr_nl	peer;
 };
 
 /**
@@ -206,14 +208,13 @@ ssize_t
 mnl_socket_recvfrom(struct mnl_socket *nl, void *buf, size_t bufsiz)
 {
 	ssize_t ret;
-	struct sockaddr_nl addr;
 	struct iovec iov = {
 		.iov_base	= buf,
 		.iov_len	= bufsiz,
 	};
 	struct msghdr msg = {
-		.msg_name	= &addr,
-		.msg_namelen	= sizeof(struct sockaddr_nl),
+		.msg_name	= &nl->peer,
+		.msg_namelen	= sizeof(nl->peer),
 		.msg_iov	= &iov,
 		.msg_iovlen	= 1,
 		.msg_control	= NULL,
@@ -221,8 +222,10 @@ mnl_socket_recvfrom(struct mnl_socket *nl, void *buf, size_t bufsiz)
 		.msg_flags	= 0,
 	};
 	ret = recvmsg(nl->fd, &msg, 0);
-	if (ret == -1)
+	if (ret == -1) {
+		memset(&nl->peer, 0, sizeof(nl->peer));
 		return ret;
+	}
 
 	if (msg.msg_flags & MSG_TRUNC) {
 		errno = ENOSPC;
@@ -237,6 +240,19 @@ mnl_socket_recvfrom(struct mnl_socket *nl, void *buf, size_t bufsiz)
 EXPORT_SYMBOL(mnl_socket_recvfrom);
 
 /**
+ * mnl_socket_peer_address - return the sender of the last message
+ *
+ * The address is only valid after a successful call to
+ * mnl_socket_recvfrom().  The returned pointer is valid until
+ * mnl_socket_close() is called; it must not be freed by the caller.
+ */
+struct sockaddr_nl *
+mnl_socket_peer_address(struct mnl_socket *nl)
+{
+	return &nl->peer;
+}
+
+/**
  * mnl_socket_close - close a given netlink socket
  * \param nl netlink socket obtained via mnl_socket_open()
  *
-- 
1.8.1.4


--------------070709040108070903030101--
