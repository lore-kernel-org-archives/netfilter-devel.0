From: Florian Westphal <fw@strlen.de>
Subject: [PATCH][RESEND] netfilter: ipv6: fix afinfo->route refcnt leak on
 error
Date: Wed, 19 Oct 2011 13:23:06 +0200
Message-ID: <20111019112305.GC10691@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35646 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979Ab1JSLXH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Oct 2011 07:23:07 -0400
Received: id: fw by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1RGUEk-0006Uc-6k
	for netfilter-devel@vger.kernel.org; Wed, 19 Oct 2011 13:23:06 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Several callers (h323 conntrack, xt_addrtype) assume that the
returned **dst only needs to be released if the function returns 0.

This is true for the ipv4 implementation, but not for the ipv6 one.

Instead of changing the users, change the ipv6 implementation
to behave like the ipv4 version by only providing the dst_entry result
in the success case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 30fcee4..8992cf6 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -100,9 +100,16 @@ static int nf_ip6_route(struct net *net, struct dst_entry **dst,
 		.pinet6 = (struct ipv6_pinfo *) &fake_pinfo,
 	};
 	const void *sk = strict ? &fake_sk : NULL;
-
-	*dst = ip6_route_output(net, sk, &fl->u.ip6);
-	return (*dst)->error;
+	struct dst_entry *result;
+	int err;
+
+	result = ip6_route_output(net, sk, &fl->u.ip6);
+	err = result->error;
+	if (err)
+		dst_release(result);
+	else
+		*dst = result;
+	return err;
 }
 
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
-- 
1.7.3.4

