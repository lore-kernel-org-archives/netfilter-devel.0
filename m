From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 24/31] netfilter: ctnetlink: must check mark attributes vs NULL
Date: Tue,  9 Oct 2018 01:01:18 +0200
Message-ID: <20181008230125.2330-25-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

else we will oops (null deref) when the attributes aren't present.

Also add back the EOPNOTSUPP in case MARK filtering is requested but
kernel doesn't support it.

Fixes: 59c08c69c2788 ("netfilter: ctnetlink: Support L3 protocol-filter on flush")
Reported-by: syzbot+e45eda8eda6e93a03959@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 099a450e26be..4ae8e528943a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -832,6 +832,11 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 {
 	struct ctnetlink_filter *filter;
 
+#ifndef CONFIG_NF_CONNTRACK_MARK
+	if (cda[CTA_MARK] && cda[CTA_MARK_MASK])
+		return ERR_PTR(-EOPNOTSUPP);
+#endif
+
 	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
 	if (filter == NULL)
 		return ERR_PTR(-ENOMEM);
@@ -839,8 +844,10 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 	filter->family = family;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
-	filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+	if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
+		filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
+		filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+	}
 #endif
 	return filter;
 }
-- 
2.11.0
