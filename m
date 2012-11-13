From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netfilter: ipv6: only provide sk_bound_dev_if for link-local addr
Date: Tue, 13 Nov 2012 11:17:24 +0100
Message-ID: <1352801844-23852-1-git-send-email-fw@strlen.de>
Cc: yoshfuji@linux-ipv6.org, Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58554 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614Ab2KMKPd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:15:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

yoshfuji points out that sk_bound_dev_if should only be provided
for link-local addresses.

IPv6 getpeer/sockname also has this test, i.e. we will now
only set sin6_scope_id if the original(!) destination
was a link-local address.

Reported-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 02dcafd..e5f6cf7 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -334,9 +334,14 @@ ipv6_getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 	memcpy(&sin6.sin6_addr,
 		&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.in6,
 					sizeof(sin6.sin6_addr));
-	sin6.sin6_scope_id = sk->sk_bound_dev_if;
 
 	nf_ct_put(ct);
+
+	if (ipv6_addr_type(&sin6.sin6_addr) & IPV6_ADDR_LINKLOCAL)
+		sin6.sin6_scope_id = sk->sk_bound_dev_if;
+	else
+		sin6.sin6_scope_id = 0;
+
 	return copy_to_user(user, &sin6, sizeof(sin6)) ? -EFAULT : 0;
 }
 
-- 
1.7.8.6

