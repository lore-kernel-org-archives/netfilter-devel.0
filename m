From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/8] netfilter: remove ifdef around cttimeout in struct nf_conntrack_l4proto
Date: Fri, 10 Aug 2018 13:16:18 +0200
Message-ID: <20180810111622.3981-5-pablo@netfilter.org>
References: <20180810111622.3981-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810111622.3981-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Simplify this, include it inconditionally in this structure layout as we
do with ctnetlink.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 6068c6da3eac..8465263b297d 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -77,7 +77,6 @@ struct nf_conntrack_l4proto {
 			       struct nf_conntrack_tuple *t);
 	const struct nla_policy *nla_policy;
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
 	struct {
 		int (*nlattr_to_obj)(struct nlattr *tb[],
 				     struct net *net, void *data);
@@ -87,7 +86,6 @@ struct nf_conntrack_l4proto {
 		u16 nlattr_max;
 		const struct nla_policy *nla_policy;
 	} ctnl_timeout;
-#endif
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	/* Print out the private part of the conntrack. */
 	void (*print_conntrack)(struct seq_file *s, struct nf_conn *);
-- 
2.11.0
