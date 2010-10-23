From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/13] src: remove redundant casts
Date: Sat, 23 Oct 2010 07:44:41 +0200
Message-ID: <1287812691-14470-5-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55109 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab0JWFpC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:02 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/attr.c   |    2 +-
 src/socket.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index cafd2c7..fcb5e4a 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -351,7 +351,7 @@ uint64_t mnl_attr_get_u64(const struct nlattr *attr)
  */
 const char *mnl_attr_get_str(const struct nlattr *attr)
 {
-	return (const char *)mnl_attr_get_payload(attr);
+	return mnl_attr_get_payload(attr);
 }
 
 /**
diff --git a/src/socket.c b/src/socket.c
index a9ff053..3322ad1 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -201,7 +201,7 @@ int mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
 		.iov_len	= bufsiz,
 	};
 	struct msghdr msg = {
-		.msg_name	= (void *)&addr,
+		.msg_name	= &addr,
 		.msg_namelen	= sizeof(struct sockaddr_nl),
 		.msg_iov	= &iov,
 		.msg_iovlen	= 1,
-- 
1.7.1

