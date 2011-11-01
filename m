From: pablo@netfilter.org
Subject: [PATCH 12/14] netfilter: ipv6: fix afinfo->route refcnt leak on error
Date: Tue,  1 Nov 2011 10:11:34 +0100
Message-ID: <1320138696-28048-13-git-send-email-pablo@netfilter.org>
References: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37274 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab1KAJMO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:12:14 -0400
In-Reply-To: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Several callers (h323 conntrack, xt_addrtype) assume that the
returned **dst only needs to be released if the function returns 0.

This is true for the ipv4 implementation, but not for the ipv6 one.

Instead of changing the users, change the ipv6 implementation
to behave like the ipv4 version by only providing the dst_entry result
in the success case.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
1.7.2.5

