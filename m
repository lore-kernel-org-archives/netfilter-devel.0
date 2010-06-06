From: Shan Wei <shanwei@cn.fujitsu.com>
Subject: [NETFILTER] [PATCH] xt_sctp: use WORD_ROUND macro to calculate length
 of multiple of 4 bytes
Date: Mon, 07 Jun 2010 02:08:41 +0800
Message-ID: <4C0BE429.5030902@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63730 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab0FGCIr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jun 2010 22:08:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use  WORD_ROUND to round an int up to the next multiple of 4.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/netfilter/xt_sctp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index c04fcf3..ef36a56 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -3,6 +3,7 @@
 #include <linux/skbuff.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <net/sctp/sctp.h>
 #include <linux/sctp.h>
 
 #include <linux/netfilter/x_tables.h>
@@ -67,7 +68,7 @@ match_packet(const struct sk_buff *skb,
 			 ++i, offset, sch->type, htons(sch->length),
 			 sch->flags);
 #endif
-		offset += (ntohs(sch->length) + 3) & ~3;
+		offset += WORD_ROUND(ntohs(sch->length));
 
 		pr_debug("skb->len: %d\toffset: %d\n", skb->len, offset);
 
-- 
1.6.3.3

