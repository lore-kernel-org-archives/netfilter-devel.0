From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] nftables: reject nat hook registration if prio is before conntrack
Date: Fri,  8 Dec 2017 17:01:55 +0100
Message-ID: <20171208160155.968-4-fw@strlen.de>
References: <20171208160155.968-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52230 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754319AbdLHQC3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 11:02:29 -0500
In-Reply-To: <20171208160155.968-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

No problem for iptables as priorities are fixed values defined in the
nat modules, but in nftables the priority its coming from userspace.

Reject in case we see that such a hook would not work.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f000d4399c7a..4ed66f1b40b5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1303,6 +1303,11 @@ static int nft_chain_parse_hook(struct net *net,
 	}
 	if (!(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
+
+	if (type->type == NFT_CHAIN_T_NAT &&
+	    hook->priority <= NF_IP_PRI_CONNTRACK)
+		return -EINVAL;
+
 	if (!try_module_get(type->owner))
 		return -ENOENT;
 
-- 
2.13.6

