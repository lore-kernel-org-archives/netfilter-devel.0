From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 31/47] netfilter: ctnetlink: synproxy support
Date: Fri, 30 Mar 2018 13:44:53 +0200
Message-ID: <20180330114509.18738-2-pablo@netfilter.org>
References: <20180330114509.18738-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114509.18738-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch exposes synproxy information per-conntrack. Moreover, send
sequence adjustment events once server sends us the SYN,ACK packet, so
we can synchronize the sequence adjustment too for packets going as
reply from the server, as part of the synproxy logic.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h |  1 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h | 10 +++
 net/ipv4/netfilter/ipt_SYNPROXY.c                  |  8 +-
 net/ipv6/netfilter/ip6t_SYNPROXY.c                 |  8 +-
 net/netfilter/nf_conntrack_netlink.c               | 87 +++++++++++++++++++++-
 5 files changed, 109 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 9574bd40870b..c712eb6879f1 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -129,6 +129,7 @@ enum ip_conntrack_events {
 	IPCT_NATSEQADJ = IPCT_SEQADJ,
 	IPCT_SECMARK,		/* new security mark has been set */
 	IPCT_LABEL,		/* new connlabel has been set */
+	IPCT_SYNPROXY,		/* synproxy has been set */
 #ifdef __KERNEL__
 	__IPCT_MAX
 #endif
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 7397e022ce6e..77987111cab0 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -54,6 +54,7 @@ enum ctattr_type {
 	CTA_MARK_MASK,
 	CTA_LABELS,
 	CTA_LABELS_MASK,
+	CTA_SYNPROXY,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
@@ -190,6 +191,15 @@ enum ctattr_natseq {
 };
 #define CTA_NAT_SEQ_MAX (__CTA_NAT_SEQ_MAX - 1)
 
+enum ctattr_synproxy {
+	CTA_SYNPROXY_UNSPEC,
+	CTA_SYNPROXY_ISN,
+	CTA_SYNPROXY_ITS,
+	CTA_SYNPROXY_TSOFF,
+	__CTA_SYNPROXY_MAX,
+};
+#define CTA_SYNPROXY_MAX (__CTA_SYNPROXY_MAX - 1)
+
 enum ctattr_expect {
 	CTA_EXPECT_UNSPEC,
 	CTA_EXPECT_MASTER,
diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index f75fc6b53115..690b17ef6a44 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 static struct iphdr *
 synproxy_build_ip(struct net *net, struct sk_buff *skb, __be32 saddr,
@@ -384,6 +385,8 @@ static unsigned int ipv4_synproxy_hook(void *priv,
 		synproxy->isn = ntohl(th->ack_seq);
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy->its = opts.tsecr;
+
+		nf_conntrack_event_cache(IPCT_SYNPROXY, ct);
 		break;
 	case TCP_CONNTRACK_SYN_RECV:
 		if (!th->syn || !th->ack)
@@ -392,8 +395,10 @@ static unsigned int ipv4_synproxy_hook(void *priv,
 		if (!synproxy_parse_options(skb, thoff, th, &opts))
 			return NF_DROP;
 
-		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
+		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP) {
 			synproxy->tsoff = opts.tsval - synproxy->its;
+			nf_conntrack_event_cache(IPCT_SYNPROXY, ct);
+		}
 
 		opts.options &= ~(XT_SYNPROXY_OPT_MSS |
 				  XT_SYNPROXY_OPT_WSCALE |
@@ -403,6 +408,7 @@ static unsigned int ipv4_synproxy_hook(void *priv,
 		synproxy_send_server_ack(net, state, skb, th, &opts);
 
 		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
+		nf_conntrack_event_cache(IPCT_SEQADJ, ct);
 
 		swap(opts.tsval, opts.tsecr);
 		synproxy_send_client_ack(net, skb, th, &opts);
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 437af8c95277..cb6d42b03cb5 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -18,6 +18,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 static struct ipv6hdr *
 synproxy_build_ip(struct net *net, struct sk_buff *skb,
@@ -405,6 +406,8 @@ static unsigned int ipv6_synproxy_hook(void *priv,
 		synproxy->isn = ntohl(th->ack_seq);
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy->its = opts.tsecr;
+
+		nf_conntrack_event_cache(IPCT_SYNPROXY, ct);
 		break;
 	case TCP_CONNTRACK_SYN_RECV:
 		if (!th->syn || !th->ack)
@@ -413,8 +416,10 @@ static unsigned int ipv6_synproxy_hook(void *priv,
 		if (!synproxy_parse_options(skb, thoff, th, &opts))
 			return NF_DROP;
 
-		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
+		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP) {
 			synproxy->tsoff = opts.tsval - synproxy->its;
+			nf_conntrack_event_cache(IPCT_SYNPROXY, ct);
+		}
 
 		opts.options &= ~(XT_SYNPROXY_OPT_MSS |
 				  XT_SYNPROXY_OPT_WSCALE |
@@ -424,6 +429,7 @@ static unsigned int ipv6_synproxy_hook(void *priv,
 		synproxy_send_server_ack(net, state, skb, th, &opts);
 
 		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
+		nf_conntrack_event_cache(IPCT_SEQADJ, ct);
 
 		swap(opts.tsval, opts.tsecr);
 		synproxy_send_client_ack(net, skb, th, &opts);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8884d302d33a..11ef85a57244 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -440,6 +440,31 @@ static int ctnetlink_dump_ct_seq_adj(struct sk_buff *skb, struct nf_conn *ct)
 	return -1;
 }
 
+static int ctnetlink_dump_ct_synproxy(struct sk_buff *skb, struct nf_conn *ct)
+{
+	struct nf_conn_synproxy *synproxy = nfct_synproxy(ct);
+	struct nlattr *nest_parms;
+
+	if (!synproxy)
+		return 0;
+
+	nest_parms = nla_nest_start(skb, CTA_SYNPROXY | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
+
+	if (nla_put_be32(skb, CTA_SYNPROXY_ISN, htonl(synproxy->isn)) ||
+	    nla_put_be32(skb, CTA_SYNPROXY_ITS, htonl(synproxy->its)) ||
+	    nla_put_be32(skb, CTA_SYNPROXY_TSOFF, htonl(synproxy->tsoff)))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest_parms);
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	if (nla_put_be32(skb, CTA_ID, htonl((unsigned long)ct)))
@@ -518,7 +543,8 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
 	    ctnetlink_dump_master(skb, ct) < 0 ||
-	    ctnetlink_dump_ct_seq_adj(skb, ct) < 0)
+	    ctnetlink_dump_ct_seq_adj(skb, ct) < 0 ||
+	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
@@ -730,6 +756,10 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 		if (events & (1 << IPCT_SEQADJ) &&
 		    ctnetlink_dump_ct_seq_adj(skb, ct) < 0)
 			goto nla_put_failure;
+
+		if (events & (1 << IPCT_SYNPROXY) &&
+		    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
+			goto nla_put_failure;
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
@@ -1689,6 +1719,39 @@ ctnetlink_change_seq_adj(struct nf_conn *ct,
 	return ret;
 }
 
+static const struct nla_policy synproxy_policy[CTA_SYNPROXY_MAX + 1] = {
+	[CTA_SYNPROXY_ISN]	= { .type = NLA_U32 },
+	[CTA_SYNPROXY_ITS]	= { .type = NLA_U32 },
+	[CTA_SYNPROXY_TSOFF]	= { .type = NLA_U32 },
+};
+
+static int ctnetlink_change_synproxy(struct nf_conn *ct,
+				     const struct nlattr * const cda[])
+{
+	struct nf_conn_synproxy *synproxy = nfct_synproxy(ct);
+	struct nlattr *tb[CTA_SYNPROXY_MAX + 1];
+	int err;
+
+	if (!synproxy)
+		return 0;
+
+	err = nla_parse_nested(tb, CTA_SYNPROXY_MAX, cda[CTA_SYNPROXY],
+			       synproxy_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (!tb[CTA_SYNPROXY_ISN] ||
+	    !tb[CTA_SYNPROXY_ITS] ||
+	    !tb[CTA_SYNPROXY_TSOFF])
+		return -EINVAL;
+
+	synproxy->isn = ntohl(nla_get_be32(tb[CTA_SYNPROXY_ISN]));
+	synproxy->its = ntohl(nla_get_be32(tb[CTA_SYNPROXY_ITS]));
+	synproxy->tsoff = ntohl(nla_get_be32(tb[CTA_SYNPROXY_TSOFF]));
+
+	return 0;
+}
+
 static int
 ctnetlink_attach_labels(struct nf_conn *ct, const struct nlattr * const cda[])
 {
@@ -1759,6 +1822,12 @@ ctnetlink_change_conntrack(struct nf_conn *ct,
 			return err;
 	}
 
+	if (cda[CTA_SYNPROXY]) {
+		err = ctnetlink_change_synproxy(ct, cda);
+		if (err < 0)
+			return err;
+	}
+
 	if (cda[CTA_LABELS]) {
 		err = ctnetlink_attach_labels(ct, cda);
 		if (err < 0)
@@ -1880,6 +1949,12 @@ ctnetlink_create_conntrack(struct net *net,
 			goto err2;
 	}
 
+	if (cda[CTA_SYNPROXY]) {
+		err = ctnetlink_change_synproxy(ct, cda);
+		if (err < 0)
+			goto err2;
+	}
+
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK])
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
@@ -1991,7 +2066,9 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
 						      (1 << IPCT_HELPER) |
 						      (1 << IPCT_PROTOINFO) |
 						      (1 << IPCT_SEQADJ) |
-						      (1 << IPCT_MARK) | events,
+						      (1 << IPCT_MARK) |
+						      (1 << IPCT_SYNPROXY) |
+						      events,
 						      ct, NETLINK_CB(skb).portid,
 						      nlmsg_report(nlh));
 			nf_ct_put(ct);
@@ -2012,7 +2089,8 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
 						      (1 << IPCT_LABEL) |
 						      (1 << IPCT_PROTOINFO) |
 						      (1 << IPCT_SEQADJ) |
-						      (1 << IPCT_MARK),
+						      (1 << IPCT_MARK) |
+						      (1 << IPCT_SYNPROXY),
 						      ct, NETLINK_CB(skb).portid,
 						      nlmsg_report(nlh));
 		}
@@ -2282,6 +2360,9 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 	    ctnetlink_dump_ct_seq_adj(skb, ct) < 0)
 		goto nla_put_failure;
 
+	if (ctnetlink_dump_ct_synproxy(skb, ct) < 0)
+		goto nla_put_failure;
+
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	if (ct->mark && ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
-- 
2.11.0
