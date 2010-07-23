From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] xt_statistic: add the comment
Date: Fri, 23 Jul 2010 16:26:54 +0800
Message-ID: <1279873614-15628-1-git-send-email-xiaosuo@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56544 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0GWI07 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jul 2010 04:26:59 -0400
Received: by pwi5 with SMTP id 5so3409071pwi.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jul 2010 01:26:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

add the comment to improve the readability.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 include/linux/netfilter/xt_statistic.h |    2 ++
 1 file changed, 2 insertions(+)
diff --git a/include/linux/netfilter/xt_statistic.h b/include/linux/netfilter/xt_statistic.h
index 4e983ef..827edee 100644
--- a/include/linux/netfilter/xt_statistic.h
+++ b/include/linux/netfilter/xt_statistic.h
@@ -30,6 +30,8 @@ struct xt_statistic_info {
 			__u32	count; /* unused */
 		} nth;
 	} u;
+
+	/* Used internally by the kernel */
 	struct xt_statistic_priv *master __attribute__((aligned(8)));
 };
 
