From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] libxt_connlimit: remove duplicate member that caused size change
Date: Thu, 20 Jan 2011 14:17:01 +0100
Message-ID: <1295529422-25624-2-git-send-email-jengelh@medozas.de>
References: <1295529422-25624-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, jan.rovner@diadema.cz
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37134 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab1ATNRH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:17:07 -0500
In-Reply-To: <1295529422-25624-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/xt_connlimit.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index d6c84c9..ba774d3 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -16,7 +16,7 @@ struct xt_connlimit_info {
 			__be32 v6_mask[4];
 		};
 	};
-	unsigned int limit, inverse;
+	unsigned int limit;
 	union {
 		/* revision 0 */
 		unsigned int inverse;
-- 
1.7.1

