From: Eric Leblond <eric@regit.org>
Subject: [nftables 2/3] erec: fix logic when reading from file
Date: Wed, 24 Jun 2015 09:51:50 +0200
Message-ID: <1435132311-31452-3-git-send-email-eric@regit.org>
References: <1435132311-31452-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:47463 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbFXHwT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2015 03:52:19 -0400
In-Reply-To: <1435132311-31452-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case we are reading the rules from a file we need to reset the
file descriptor to the original position when calling erec_print.

This was not the case in previous code and was leading to valid
file to be seen as invalid when treated in debug mode.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/erec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/erec.c b/src/erec.c
index 75a3f74..b1456ee 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -86,6 +86,7 @@ void erec_print(FILE *f, const struct error_record *erec)
 	char *pbuf = NULL;
 	unsigned int i, end;
 	int l, ret;
+	int orig_offset = 0;
 
 	switch (indesc->type) {
 	case INDESC_BUFFER:
@@ -94,11 +95,13 @@ void erec_print(FILE *f, const struct error_record *erec)
 		break;
 	case INDESC_FILE:
 		memset(buf, 0, sizeof(buf));
+		orig_offset = lseek(indesc->fd, 0, SEEK_CUR);
 		lseek(indesc->fd, loc->line_offset, SEEK_SET);
 		ret = read(indesc->fd, buf, sizeof(buf) - 1);
 		if (ret > 0)
 			*strchrnul(buf, '\n') = '\0';
 		line = buf;
+		lseek(indesc->fd, orig_offset, SEEK_SET);
 		break;
 	case INDESC_INTERNAL:
 	case INDESC_NETLINK:
-- 
2.1.4

