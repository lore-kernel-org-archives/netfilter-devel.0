From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] src: remove redundant casts
Date: Sat, 18 Dec 2010 21:17:31 +0100
Message-ID: <1292703453-16324-3-git-send-email-jengelh@medozas.de>
References: <1292703453-16324-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47414 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0LRURg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:17:36 -0500
In-Reply-To: <1292703453-16324-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/libipulog_compat.c |    2 +-
 utils/ulog_test.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/libipulog_compat.c b/src/libipulog_compat.c
index 8c90cdb..a25cde9 100644
--- a/src/libipulog_compat.c
+++ b/src/libipulog_compat.c
@@ -91,7 +91,7 @@ struct ipulog_handle *ipulog_create_handle(u_int32_t gmask,
 	struct ipulog_handle *h;
 	unsigned int group = gmask2group(gmask);
 
-	h = (struct ipulog_handle *) malloc(sizeof(*h)+PAYLOAD_SIZE);
+	h = malloc(sizeof(*h)+PAYLOAD_SIZE);
 	if (! h) {
 		ipulog_errno = IPULOG_ERR_HANDLE;
 		return NULL;
diff --git a/utils/ulog_test.c b/utils/ulog_test.c
index 142846b..d568aa4 100644
--- a/utils/ulog_test.c
+++ b/utils/ulog_test.c
@@ -53,7 +53,7 @@ int main(int argc, char *argv[])
 	}
 
 	/* allocate a receive buffer */
-	buf = (unsigned char *) malloc(MYBUFSIZ);
+	buf = malloc(MYBUFSIZ);
 	if (!buf)
 		exit(1);
 	
-- 
1.7.1

