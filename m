From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: ipv6: fix afinfo->route refcnt leak on error
Date: Tue,  6 Sep 2011 20:59:11 +0200
Message-ID: <1315335551-1659-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60945 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173Ab1IFTBI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:01:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Several callers (conntrack_h323, xt_addrtype) assume that the
returned **dst only needs to be released if the function returns 0.

Instead of changing the callers, fix the ipv6 implementation
to behave like the ipv4 version by only providing *dst result
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

