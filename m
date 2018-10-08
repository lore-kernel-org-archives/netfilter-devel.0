From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/31] netfilter: cttimeout: remove superfluous check on layer 4 netlink functions
Date: Tue,  9 Oct 2018 01:01:06 +0200
Message-ID: <20181008230125.2330-13-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

We assume they are always set accordingly since a874752a10da
("netfilter: conntrack: timeout interface depend on
CONFIG_NF_CONNTRACK_TIMEOUT"), so we can get rid of this checks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 48 ++++++++++++++-----------------------
 net/netfilter/nft_ct.c              |  3 ---
 2 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index a30f8ba4b89a..6ca0df7f416f 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -53,9 +53,6 @@ ctnl_timeout_parse_policy(void *timeout,
 	struct nlattr **tb;
 	int ret = 0;
 
-	if (!l4proto->ctnl_timeout.nlattr_to_obj)
-		return 0;
-
 	tb = kcalloc(l4proto->ctnl_timeout.nlattr_max + 1, sizeof(*tb),
 		     GFP_KERNEL);
 
@@ -167,6 +164,8 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	struct nfgenmsg *nfmsg;
 	unsigned int flags = portid ? NLM_F_MULTI : 0;
 	const struct nf_conntrack_l4proto *l4proto = timeout->timeout.l4proto;
+	struct nlattr *nest_parms;
+	int ret;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK_TIMEOUT, event);
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*nfmsg), flags);
@@ -186,22 +185,15 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 			 htonl(refcount_read(&timeout->refcnt))))
 		goto nla_put_failure;
 
-	if (likely(l4proto->ctnl_timeout.obj_to_nlattr)) {
-		struct nlattr *nest_parms;
-		int ret;
-
-		nest_parms = nla_nest_start(skb,
-					    CTA_TIMEOUT_DATA | NLA_F_NESTED);
-		if (!nest_parms)
-			goto nla_put_failure;
+	nest_parms = nla_nest_start(skb, CTA_TIMEOUT_DATA | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
 
-		ret = l4proto->ctnl_timeout.obj_to_nlattr(skb,
-							&timeout->timeout.data);
-		if (ret < 0)
-			goto nla_put_failure;
+	ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, &timeout->timeout.data);
+	if (ret < 0)
+		goto nla_put_failure;
 
-		nla_nest_end(skb, nest_parms);
-	}
+	nla_nest_end(skb, nest_parms);
 
 	nlmsg_end(skb, nlh);
 	return skb->len;
@@ -397,6 +389,8 @@ cttimeout_default_fill_info(struct net *net, struct sk_buff *skb, u32 portid,
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	unsigned int flags = portid ? NLM_F_MULTI : 0;
+	struct nlattr *nest_parms;
+	int ret;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK_TIMEOUT, event);
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*nfmsg), flags);
@@ -412,21 +406,15 @@ cttimeout_default_fill_info(struct net *net, struct sk_buff *skb, u32 portid,
 	    nla_put_u8(skb, CTA_TIMEOUT_L4PROTO, l4proto->l4proto))
 		goto nla_put_failure;
 
-	if (likely(l4proto->ctnl_timeout.obj_to_nlattr)) {
-		struct nlattr *nest_parms;
-		int ret;
-
-		nest_parms = nla_nest_start(skb,
-					    CTA_TIMEOUT_DATA | NLA_F_NESTED);
-		if (!nest_parms)
-			goto nla_put_failure;
+	nest_parms = nla_nest_start(skb, CTA_TIMEOUT_DATA | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
 
-		ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, NULL);
-		if (ret < 0)
-			goto nla_put_failure;
+	ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, NULL);
+	if (ret < 0)
+		goto nla_put_failure;
 
-		nla_nest_end(skb, nest_parms);
-	}
+	nla_nest_end(skb, nest_parms);
 
 	nlmsg_end(skb, nlh);
 	return skb->len;
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 5dd87748afa8..17ae5059c312 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -776,9 +776,6 @@ nft_ct_timeout_parse_policy(void *timeouts,
 	struct nlattr **tb;
 	int ret = 0;
 
-	if (!l4proto->ctnl_timeout.nlattr_to_obj)
-		return 0;
-
 	tb = kcalloc(l4proto->ctnl_timeout.nlattr_max + 1, sizeof(*tb),
 		     GFP_KERNEL);
 
-- 
2.11.0
