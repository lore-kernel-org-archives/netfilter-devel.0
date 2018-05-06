From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 50/51] netfilter: ctnetlink: export nf_conntrack_max
Date: Mon,  7 May 2018 00:47:08 +0200
Message-ID: <20180506224709.29100-51-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florent Fourcot <florent.fourcot@wifirst.fr>

IPCTNL_MSG_CT_GET_STATS netlink command allow to monitor current number
of conntrack entries. However, if one wants to compare it with the
maximum (and detect exhaustion), the only solution is currently to read
sysctl value.

This patch add nf_conntrack_max value in netlink message, and simplify
monitoring for application built on netlink API.

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink_conntrack.h | 1 +
 net/netfilter/nf_conntrack_core.c                  | 1 +
 net/netfilter/nf_conntrack_netlink.c               | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 77987111cab0..1d41810d17e2 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -262,6 +262,7 @@ enum ctattr_stats_cpu {
 enum ctattr_stats_global {
 	CTA_STATS_GLOBAL_UNSPEC,
 	CTA_STATS_GLOBAL_ENTRIES,
+	CTA_STATS_GLOBAL_MAX_ENTRIES,
 	__CTA_STATS_GLOBAL_MAX,
 };
 #define CTA_STATS_GLOBAL_MAX (__CTA_STATS_GLOBAL_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 41ff04ee2554..605441727008 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -186,6 +186,7 @@ unsigned int nf_conntrack_htable_size __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 
 unsigned int nf_conntrack_max __read_mostly;
+EXPORT_SYMBOL_GPL(nf_conntrack_max);
 seqcount_t nf_conntrack_generation __read_mostly;
 static unsigned int nf_conntrack_hash_rnd __read_mostly;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4c1d0c5bc268..d807b8770be3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2205,6 +2205,9 @@ ctnetlink_stat_ct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_be32(skb, CTA_STATS_GLOBAL_ENTRIES, htonl(nr_conntracks)))
 		goto nla_put_failure;
 
+	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(nf_conntrack_max)))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return skb->len;
 
-- 
2.11.0
