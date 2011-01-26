From: Thomas Jacob <jacob@internet24.de>
Subject: [PATCH 1/2] Typo in IPv4 match debug print code
Date: Wed, 26 Jan 2011 18:22:50 +0100
Message-ID: <1296062571-2644-1-git-send-email-jacob@internet24.de>
Cc: Thomas Jacob <jacob@internet24.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:36915 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab1AZRW6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:22:58 -0500
Received: from [192.168.1.112] (helo=mailin03.ims-firmen.de)
	by mailout02.ims-firmen.de with esmtp (Exim 4.72)
	(envelope-from <jacob@internet24.de>)
	id 1Pi954-000772-IX
	for netfilter-devel@vger.kernel.org; Wed, 26 Jan 2011 18:22:54 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Thomas Jacob <jacob@internet24.de>
---
 net/netfilter/xt_iprange.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 73c33a4..5c14308 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -31,7 +31,7 @@ iprange_mt4(const struct sk_buff *skb, struct xt_action_param *par)
 			pr_debug("src IP %pI4 NOT in range %s%pI4-%pI4\n",
 			         &iph->saddr,
 			         (info->flags & IPRANGE_SRC_INV) ? "(INV) " : "",
-			         &info->src_max.ip,
+			         &info->src_min.ip,
 			         &info->src_max.ip);
 			return false;
 		}
-- 
1.5.6.5

