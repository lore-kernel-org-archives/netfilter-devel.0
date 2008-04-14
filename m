From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 27/41]: nf_nat: remove obsolete check for ICMP redirects
Date: Mon, 14 Apr 2008 12:16:55 +0200 (MEST)
Message-ID: <20080414101651.32717.42291.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36318 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYDNKQ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:56 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: remove obsolete check for ICMP redirects

Locally generated ICMP packets have a reference to the conntrack entry
of the original packet manually attached by icmp_send(). Therefore the
check for locally originated untracked ICMP redirects can never be
true.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 021e7d24124820256a4789b5576bdbd1dbc1a274
tree 630ba00d0946c177a9528157cfed74ca8359ec4a
parent a5d5b6924c527ebc0a64791a198257c3ffe98a5a
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:54 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:54 +0200

 net/ipv4/netfilter/nf_nat_standalone.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 4a3e0f8..c362f67 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -93,21 +93,8 @@ nf_nat_fn(unsigned int hooknum,
 	   have dropped it.  Hence it's the user's responsibilty to
 	   packet filter it out, or implement conntrack/NAT for that
 	   protocol. 8) --RR */
-	if (!ct) {
-		/* Exception: ICMP redirect to new connection (not in
-		   hash table yet).  We must not let this through, in
-		   case we're doing NAT to the same network. */
-		if (ip_hdr(skb)->protocol == IPPROTO_ICMP) {
-			struct icmphdr _hdr, *hp;
-
-			hp = skb_header_pointer(skb, ip_hdrlen(skb),
-						sizeof(_hdr), &_hdr);
-			if (hp != NULL &&
-			    hp->type == ICMP_REDIRECT)
-				return NF_DROP;
-		}
+	if (!ct)
 		return NF_ACCEPT;
-	}
 
 	/* Don't try to NAT if this packet is not conntracked */
 	if (ct == &nf_conntrack_untracked)
