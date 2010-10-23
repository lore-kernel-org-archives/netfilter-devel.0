From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/13] socket: use more appropriate types for mnl_socket_bind
Date: Sat, 23 Oct 2010 07:44:47 +0200
Message-ID: <1287812691-14470-11-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55126 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0JWFpK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:10 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

groups, being a bitmask, should be unsigned; and let's also use pid_t
for pid.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |    2 +-
 src/socket.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index d35e1c1..d766183 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -16,7 +16,7 @@
 struct mnl_socket;
 
 extern struct mnl_socket *mnl_socket_open(int type);
-extern int mnl_socket_bind(struct mnl_socket *nl, int groups, int pid);
+extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid);
 extern int mnl_socket_close(struct mnl_socket *nl);
 extern int mnl_socket_get_fd(const struct mnl_socket *nl);
 extern unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
diff --git a/src/socket.c b/src/socket.c
index 6ca3d3e..c9afd34 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -131,7 +131,7 @@ struct mnl_socket *mnl_socket_open(int bus)
  * success, 0 is returned. You can use MNL_SOCKET_AUTOPID which is 0 for
  * automatic port ID selection.
  */
-int mnl_socket_bind(struct mnl_socket *nl, int groups, int pid)
+int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
 {
 	int ret;
 	socklen_t addr_len;
-- 
1.7.1

