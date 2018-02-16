From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] netfilter: ipt_CLUSTERIP: put config struct if we can't increment ct refcount
Date: Fri, 16 Feb 2018 12:49:32 +0100
Message-ID: <20180216114933.23667-2-fw@strlen.de>
References: <20180216114933.23667-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50904 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965371AbeBPLve (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 06:51:34 -0500
In-Reply-To: <20180216114933.23667-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This needs to put() the entry to avoid a resource leak in error path.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 4b02ab39ebc5..4c8cfd352687 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -496,12 +496,15 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 				return PTR_ERR(config);
 		}
 	}
-	cipinfo->config = config;
 
 	ret = nf_ct_netns_get(par->net, par->family);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
+		clusterip_config_entry_put(par->net, config);
+		clusterip_config_put(config);
+		return ret;
+	}
 
 	if (!par->net->xt.clusterip_deprecated_warning) {
 		pr_info("ipt_CLUSTERIP is deprecated and it will removed soon, "
@@ -509,6 +512,7 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 		par->net->xt.clusterip_deprecated_warning = true;
 	}
 
+	cipinfo->config = config;
 	return ret;
 }
 
-- 
2.16.1

