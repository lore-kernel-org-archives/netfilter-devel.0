From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] socket: constify a struct sockaddr_nl
Date: Thu, 11 Nov 2010 00:08:00 +0100
Message-ID: <1289430485-16467-2-git-send-email-jengelh@medozas.de>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56305 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab0KJXIH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:08:07 -0500
In-Reply-To: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/socket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/socket.c b/src/socket.c
index c9afd34..cc997df 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -171,7 +171,7 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
  */
 int mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
 {
-	struct sockaddr_nl snl = {
+	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
 	};
 	return sendto(nl->fd, buf, len, 0, 
-- 
1.7.1

