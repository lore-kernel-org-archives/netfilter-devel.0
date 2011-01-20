From: kaber@trash.net
Subject: [PATCH 3/7] netfilter: xtables: remove duplicate member
Date: Thu, 20 Jan 2011 21:22:42 +0100
Message-ID: <1295554966-5263-4-git-send-email-kaber@trash.net>
References: <1295554966-5263-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44103 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1ATU0Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:26:16 -0500
In-Reply-To: <1295554966-5263-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

Accidentally missed removing the old out-of-union "inverse" member,
which caused the struct size to change which then gives size mismatch
warnings when using an old iptables.

It is interesting to see that gcc did not warn about this before.
(Filed http://gcc.gnu.org/bugzilla/show_bug.cgi?id=47376 )

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/xt_connlimit.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 8884efc..ab1d3b5 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -18,7 +18,7 @@ struct xt_connlimit_info {
 		};
 #endif
 	};
-	unsigned int limit, inverse;
+	unsigned int limit;
 	union {
 		/* revision 0 */
 		unsigned int inverse;
-- 
1.7.3.4

