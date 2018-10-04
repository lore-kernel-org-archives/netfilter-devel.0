From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC,net-next 2/3] net: act_tunnel_key: support for tunnel type
Date: Thu,  4 Oct 2018 02:03:44 +0200
Message-ID: <20181004000345.2380-3-pablo@netfilter.org>
References: <20181004000345.2380-1-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, roopa@cumulusnetworks.com,
        amir@vadai.me, pshelar@ovn.org, u9012063@gmail.com
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181004000345.2380-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch allows you to set an explicit tunnel driver type in the
metadata template. In case of misconfiguration, ie. if the packets ends
up in the wrong tunnel device, the packet is dropped.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/tc_act/tc_tunnel_key.h | 10 ++++++++++
 net/sched/act_tunnel_key.c                |  9 +++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/linux/tc_act/tc_tunnel_key.h
index be384d63e1b5..f6471549a085 100644
--- a/include/uapi/linux/tc_act/tc_tunnel_key.h
+++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
@@ -41,9 +41,19 @@ enum {
 					 */
 	TCA_TUNNEL_KEY_ENC_TOS,		/* u8 */
 	TCA_TUNNEL_KEY_ENC_TTL,		/* u8 */
+	TCA_TUNNEL_KEY_ENC_TYPE,	/* u32 */
 	__TCA_TUNNEL_KEY_MAX,
 };
 
+/* 1:1 mapping with the internal enum ip_tunnel_type. */
+enum tc_tunnel_type {
+	TC_TUNNEL_TYPE_UNSPEC   = 0,
+	TC_TUNNEL_TYPE_GRE,
+	TC_TUNNEL_TYPE_VXLAN,
+	TC_TUNNEL_TYPE_GENEVE,
+	TC_TUNNEL_TYPE_ERSPAN,
+};
+
 #define TCA_TUNNEL_KEY_MAX (__TCA_TUNNEL_KEY_MAX - 1)
 
 enum {
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 4cca8f274662..e3a1306c7ea8 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -195,6 +195,7 @@ static const struct nla_policy tunnel_key_policy[TCA_TUNNEL_KEY_MAX + 1] = {
 	[TCA_TUNNEL_KEY_ENC_OPTS]     = { .type = NLA_NESTED },
 	[TCA_TUNNEL_KEY_ENC_TOS]      = { .type = NLA_U8 },
 	[TCA_TUNNEL_KEY_ENC_TTL]      = { .type = NLA_U8 },
+	[TCA_TUNNEL_KEY_ENC_TYPE]     = { .type = NLA_U32 },
 };
 
 static int tunnel_key_init(struct net *net, struct nlattr *nla,
@@ -215,6 +216,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	__be16 flags;
 	u8 tos, ttl;
 	int ret = 0;
+	u32 type;
 	int err;
 
 	if (!nla) {
@@ -278,6 +280,10 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 		if (tb[TCA_TUNNEL_KEY_ENC_TTL])
 			ttl = nla_get_u8(tb[TCA_TUNNEL_KEY_ENC_TTL]);
 
+		type = TC_TUNNEL_TYPE_UNSPEC;
+		if (tb[TCA_TUNNEL_KEY_ENC_TYPE])
+			type = nla_get_u32(tb[TCA_TUNNEL_KEY_ENC_TYPE]);
+
 		if (tb[TCA_TUNNEL_KEY_ENC_IPV4_SRC] &&
 		    tb[TCA_TUNNEL_KEY_ENC_IPV4_DST]) {
 			__be32 saddr;
@@ -320,6 +326,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 				goto release_tun_meta;
 		}
 
+		metadata->u.tun_info.type = type;
 		metadata->u.tun_info.mode |= IP_TUNNEL_INFO_TX;
 		break;
 	default:
@@ -522,6 +529,8 @@ static int tunnel_key_dump(struct sk_buff *skb, struct tc_action *a,
 
 		if (key->ttl && nla_put_u8(skb, TCA_TUNNEL_KEY_ENC_TTL, key->ttl))
 			goto nla_put_failure;
+		if (nla_put_u32(skb, TCA_TUNNEL_KEY_ENC_TYPE, info->type))
+			goto nla_put_failure;
 	}
 
 	tcf_tm_dump(&tm, &t->tcf_tm);
-- 
2.11.0
