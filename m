From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/37] netfilter: ctnetlink: always honor CTA_MARK_MASK
Date: Fri, 21 Dec 2018 01:28:08 +0100
Message-ID: <20181221002841.28587-5-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Andreas Jaggi <andreas.jaggi@waterwave.ch>

Useful to only set a particular range of the conntrack mark while
leaving existing parts of the value alone, e.g. when updating
conntrack marks via netlink from userspace.

For NFQUEUE it was already implemented in commit 534473c6080e
("netfilter: ctnetlink: honor CTA_MARK_MASK when setting ctmark").

This now adds the same functionality also for the other netlink
conntrack mark changes.

Signed-off-by: Andreas Jaggi <andreas.jaggi@waterwave.ch>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4ae8e528943a..4f54c4355d33 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1688,6 +1688,22 @@ static int ctnetlink_change_timeout(struct nf_conn *ct,
 	return 0;
 }
 
+#if defined(CONFIG_NF_CONNTRACK_MARK)
+static void ctnetlink_change_mark(struct nf_conn *ct,
+				    const struct nlattr * const cda[])
+{
+	u32 mark, newmark, mask = 0;
+
+	if (cda[CTA_MARK_MASK])
+		mask = ~ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+
+	mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+	newmark = (ct->mark & mask) ^ mark;
+	if (newmark != ct->mark)
+		ct->mark = newmark;
+}
+#endif
+
 static const struct nla_policy protoinfo_policy[CTA_PROTOINFO_MAX+1] = {
 	[CTA_PROTOINFO_TCP]	= { .type = NLA_NESTED },
 	[CTA_PROTOINFO_DCCP]	= { .type = NLA_NESTED },
@@ -1883,7 +1899,7 @@ ctnetlink_change_conntrack(struct nf_conn *ct,
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK])
-		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+		ctnetlink_change_mark(ct, cda);
 #endif
 
 	if (cda[CTA_SEQ_ADJ_ORIG] || cda[CTA_SEQ_ADJ_REPLY]) {
@@ -2027,7 +2043,7 @@ ctnetlink_create_conntrack(struct net *net,
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK])
-		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+		ctnetlink_change_mark(ct, cda);
 #endif
 
 	/* setup master conntrack: this is a confirmed expectation */
@@ -2524,14 +2540,7 @@ ctnetlink_glue_parse_ct(const struct nlattr *cda[], struct nf_conn *ct)
 	}
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK]) {
-		u32 mask = 0, mark, newmark;
-		if (cda[CTA_MARK_MASK])
-			mask = ~ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
-
-		mark = ntohl(nla_get_be32(cda[CTA_MARK]));
-		newmark = (ct->mark & mask) ^ mark;
-		if (newmark != ct->mark)
-			ct->mark = newmark;
+		ctnetlink_change_mark(ct, cda);
 	}
 #endif
 	return 0;
-- 
2.11.0
