From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: xt_comment: drop unneeded unsigned qualifier
Date: Sun, 26 Dec 2010 10:22:22 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012261022030.5017@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53897 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab0LZJWY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Dec 2010 04:22:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 0167acf6cbdf1d70d1540e61680d8301c0c388fb (v2.6.37-rc1-237-g0167acf)
commit c21eb58de7b4d9c6bb406fd0b08388e6eb76a106
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Dec 26 10:21:19 2010 +0100

netfilter: xt_comment: drop unneeded unsigned qualifier

Since a string is stored, and not something like a MAC address that
would rely on (un)signedness, drop the qualifier.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/xt_comment.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/xt_comment.h b/include/linux/netfilter/xt_comment.h
index eacfedc..0ea5e79 100644
--- a/include/linux/netfilter/xt_comment.h
+++ b/include/linux/netfilter/xt_comment.h
@@ -4,7 +4,7 @@
 #define XT_MAX_COMMENT_LEN 256
 
 struct xt_comment_info {
-	unsigned char comment[XT_MAX_COMMENT_LEN];
+	char comment[XT_MAX_COMMENT_LEN];
 };
 
 #endif /* XT_COMMENT_H */
-- 
# Created with git-export-patch

