From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] src: declare non-modified data as const
Date: Sat, 18 Dec 2010 21:17:32 +0100
Message-ID: <1292703453-16324-4-git-send-email-jengelh@medozas.de>
References: <1292703453-16324-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47418 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0LRURh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:17:37 -0500
In-Reply-To: <1292703453-16324-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libnetfilter_log/libipulog.h |    2 +-
 src/libipulog_compat.c               |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/libnetfilter_log/libipulog.h b/include/libnetfilter_log/libipulog.h
index bb6736a..6917ee7 100644
--- a/include/libnetfilter_log/libipulog.h
+++ b/include/libnetfilter_log/libipulog.h
@@ -48,7 +48,7 @@ ulog_packet_msg_t *ipulog_get_packet(struct ipulog_handle *h,
 				     const unsigned char *buf,
 				     size_t len);
 
-char *ipulog_strerror(int errcode);
+const char *ipulog_strerror(int errcode);
 
 void ipulog_perror(const char *s);
 
diff --git a/src/libipulog_compat.c b/src/libipulog_compat.c
index a25cde9..6703c99 100644
--- a/src/libipulog_compat.c
+++ b/src/libipulog_compat.c
@@ -28,10 +28,10 @@ struct ipulog_handle
 	struct ulog_packet_msg upmsg;	/* has to be last in structure */
 };
 
-struct ipulog_errmap_t 
+static const struct ipulog_errmap_t
 {
 	int errcode;
-	char *message;
+	const char *message;
 } ipulog_errmap[] = 
 {
 	{ IPULOG_ERR_NONE, "No error" },
@@ -65,7 +65,7 @@ static unsigned int gmask2group(unsigned int gmask)
 
 int ipulog_errno = IPULOG_ERR_NONE;
 
-char *ipulog_strerror(int errcode)
+const char *ipulog_strerror(int errcode)
 {
 	if (errcode < 0 || errcode > IPULOG_MAXERR)
 		errcode = IPULOG_ERR_IMPL;
-- 
1.7.1

