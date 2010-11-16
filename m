From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/6] socket: propagate sendto/recvmsg's return types
Date: Tue, 16 Nov 2010 12:43:29 +0100
Message-ID: <1289907814-32706-3-git-send-email-jengelh@medozas.de>
References: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47722 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598Ab0KPLni (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:43:38 -0500
In-Reply-To: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

sendto/recvfrom return ssize_t, so libmnl should not truncate the
result range.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |    4 ++--
 src/socket.c            |    8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index c58635f..01ae484 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -36,8 +36,8 @@ MNL_API int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pi
 MNL_API int mnl_socket_close(struct mnl_socket *nl);
 MNL_API int mnl_socket_get_fd(const struct mnl_socket *nl);
 MNL_API unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
-MNL_API int mnl_socket_sendto(const struct mnl_socket *nl, const void *req, size_t siz);
-MNL_API int mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t siz);
+MNL_API ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *req, size_t siz);
+MNL_API ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t siz);
 MNL_API int mnl_socket_setsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t len);
 MNL_API int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t *len);
 
diff --git a/src/socket.c b/src/socket.c
index cc997df..9b102e7 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -169,7 +169,8 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
  * On error, it returns -1 and errno is appropriately set. Otherwise, it 
  * returns the number of bytes sent.
  */
-int mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
+ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
+			  size_t len)
 {
 	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
@@ -192,9 +193,10 @@ int mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
  * buffer size ensures that your buffer is big enough to store the netlink
  * message without truncating it.
  */
-int mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
+ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
+			    size_t bufsiz)
 {
-	int ret;
+	ssize_t ret;
 	struct sockaddr_nl addr;
 	struct iovec iov = {
 		.iov_base	= buf,
-- 
1.7.1

