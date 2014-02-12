From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netfilter: nft_reject_inet: fix unintended fall-through in
 switch-statatement
Date: Wed, 12 Feb 2014 21:13:16 +0000
Message-ID: <20140212211313.GB8437@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, davej@redhat.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32913 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbaBLVNg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:13:36 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nft_reject_inet: fix unintended fall-through in switch-statement

For IPv4 packets, we call both IPv4 and IPv6 reject.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_reject_inet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 8a310f2..b718a52 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -21,9 +21,9 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 {
 	switch (pkt->ops->pf) {
 	case NFPROTO_IPV4:
-		nft_reject_ipv4_eval(expr, data, pkt);
+		return nft_reject_ipv4_eval(expr, data, pkt);
 	case NFPROTO_IPV6:
-		nft_reject_ipv6_eval(expr, data, pkt);
+		return nft_reject_ipv6_eval(expr, data, pkt);
 	}
 }
 
-- 
1.8.5.3

