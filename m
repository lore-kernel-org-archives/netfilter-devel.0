From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_conntrack: remove unused ctl_table_path member in nf_conntrack_l3proto
Date: Tue,  6 Sep 2016 22:35:47 +0800
Message-ID: <1473172547-8585-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:51818 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933689AbcIFOg6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Sep 2016 10:36:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After commit adf0516845bc ("netfilter: remove ip_conntrack* sysctl
compat code"), ctl_table_path member in struct nf_conntrack_l3proto{}
is not used anymore, remove it.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 include/net/netfilter/nf_conntrack_l3proto.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index cdc920b..8992e42 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -63,10 +63,6 @@ struct nf_conntrack_l3proto {
 
 	size_t nla_size;
 
-#ifdef CONFIG_SYSCTL
-	const char		*ctl_table_path;
-#endif /* CONFIG_SYSCTL */
-
 	/* Init l3proto pernet data */
 	int (*init_net)(struct net *net);
 
-- 
2.5.5


