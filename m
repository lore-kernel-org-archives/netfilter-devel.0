From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/13] socket: remove statement with no effect
Date: Sat, 23 Oct 2010 07:44:42 +0200
Message-ID: <1287812691-14470-6-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55111 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab0JWFpE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:04 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/socket.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/src/socket.c b/src/socket.c
index 3322ad1..9250c27 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -235,7 +235,6 @@ int mnl_socket_close(struct mnl_socket *nl)
 {
 	int ret = close(nl->fd);
 	free(nl);
-	nl = NULL;
 	return ret;
 }
 
-- 
1.7.1

