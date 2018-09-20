From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: ctnetlink: must check mark attributes vs NULL
Date: Thu, 20 Sep 2018 23:53:06 +0200
Message-ID: <20180920215306.10018-1-fw@strlen.de>
References: <000000000000f4bf02057653dc0a@google.com>
Cc: syzbot+e45eda8eda6e93a03959@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        kristian.evensen@gmail.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <000000000000f4bf02057653dc0a@google.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

else we will oops (null deref) when the attributes aren't present.

Also add back the EOPNOTSUPP in case MARK filtering is requested but
kernel doesn't support it.

Fixes: 59c08c69c2788 ("netfilter: ctnetlink: Support L3 protocol-filter on flush")
Reported-by: syzbot+e45eda8eda6e93a03959@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 only affects nf-next and linux-next.

 net/netfilter/nf_conntrack_netlink.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f8c74f31aa36..b7a6984c74d0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -833,6 +833,11 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
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
@@ -840,8 +845,10 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
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
2.16.4
