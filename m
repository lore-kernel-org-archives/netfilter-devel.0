From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/03]: xt_TCPMSS: remove network triggerable WARN_ON
Date: Fri, 30 Nov 2007 00:57:13 +0100 (MET)
Message-ID: <20071129235705.10108.90889.sendpatchset@localhost.localdomain>
References: <20071129235703.10108.7960.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60349 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763569AbXK2X5O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:57:14 -0500
In-Reply-To: <20071129235703.10108.7960.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: xt_TCPMSS: remove network triggerable WARN_ON

ipv6_skip_exthdr() returns -1 for invalid packets. don't WARN_ON
that.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6d3d8a9e26a4322f7f6f2601742f7a669585f338
tree 742b7f78ffcb24a6400a95db1dca419228b3e23e
parent 09f345da758fca1222b0971b65b2fddbdf78bb83
author Patrick McHardy <kaber@trash.net> Thu, 29 Nov 2007 09:04:39 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 29 Nov 2007 09:04:39 +0100

 net/netfilter/xt_TCPMSS.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 07435a6..8e76d1f 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -174,10 +174,8 @@ xt_tcpmss_target6(struct sk_buff *skb,
 
 	nexthdr = ipv6h->nexthdr;
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr);
-	if (tcphoff < 0) {
-		WARN_ON(1);
+	if (tcphoff < 0)
 		return NF_DROP;
-	}
 	ret = tcpmss_mangle_packet(skb, targinfo, tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
 	if (ret < 0)
