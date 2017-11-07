From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/23] netfilter: conntrack: add and use nf_ct_l4proto_log_invalid
Date: Tue,  7 Nov 2017 01:51:56 +0100
Message-ID: <20171107005213.22618-7-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We currently pass down the l4 protocol to the conntrack ->packet()
function, but the only user of this is the debug info decision.

Same information can be derived from struct nf_conn.
Add a wrapper for the previous patch that extracs the information
from nf_conn and passes it to nf_l4proto_log_invalid().

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 14 ++++++++------
 net/netfilter/nf_conntrack_proto.c           | 23 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_proto_dccp.c      | 17 +++++------------
 net/netfilter/nf_conntrack_proto_tcp.c       | 25 +++++++++----------------
 4 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 6d79a061d360..5d51255b5bfb 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -149,21 +149,23 @@ int nf_ct_port_nlattr_tuple_size(void);
 extern const struct nla_policy nf_ct_port_nla_policy[];
 
 #ifdef CONFIG_SYSCTL
-#define LOG_INVALID(net, proto)				\
-	((net)->ct.sysctl_log_invalid == (proto) ||	\
-	 (net)->ct.sysctl_log_invalid == IPPROTO_RAW)
-
+__printf(3, 4) __cold
+void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
+			       const struct nf_conn *ct,
+			       const char *fmt, ...);
 __printf(5, 6) __cold
 void nf_l4proto_log_invalid(const struct sk_buff *skb,
 			    struct net *net,
 			    u16 pf, u8 protonum,
 			    const char *fmt, ...);
 #else
-static inline int LOG_INVALID(struct net *net, int proto) { return 0; }
-
 static inline __printf(5, 6) __cold
 void nf_l4proto_log_invalid(const struct sk_buff *skb, struct net *net,
 			    u16 pf, u8 protonum, const char *fmt, ...) {}
+static inline __printf(3, 4) __cold
+void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
+			       const struct nf_conn *ct,
+			       const char *fmt, ...) { }
 #endif /* CONFIG_SYSCTL */
 
 #endif /*_NF_CONNTRACK_PROTOCOL_H*/
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index bcd3ee270d75..83f739e9dc08 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -87,6 +87,29 @@ void nf_l4proto_log_invalid(const struct sk_buff *skb,
 	va_end(args);
 }
 EXPORT_SYMBOL_GPL(nf_l4proto_log_invalid);
+
+__printf(3, 4)
+void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
+			       const struct nf_conn *ct,
+			       const char *fmt, ...)
+{
+	struct va_format vaf;
+	struct net *net;
+	va_list args;
+
+	net = nf_ct_net(ct);
+	if (likely(net->ct.sysctl_log_invalid == 0))
+		return;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	nf_l4proto_log_invalid(skb, net, nf_ct_l3num(ct),
+			       nf_ct_protonum(ct), "%pV", &vaf);
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(nf_ct_l4proto_log_invalid);
 #endif
 
 const struct nf_conntrack_l4proto *
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index ef501c7edb96..49e0abcdc6f4 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -428,13 +428,13 @@ static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	default:
 		dn = dccp_pernet(net);
 		if (dn->dccp_loose == 0) {
-			msg = "nf_ct_dccp: not picking up existing connection ";
+			msg = "not picking up existing connection ";
 			goto out_invalid;
 		}
 	case CT_DCCP_REQUEST:
 		break;
 	case CT_DCCP_INVALID:
-		msg = "nf_ct_dccp: invalid state transition ";
+		msg = "invalid state transition ";
 		goto out_invalid;
 	}
 
@@ -447,9 +447,7 @@ static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 
 out_invalid:
-	if (LOG_INVALID(net, IPPROTO_DCCP))
-		nf_log_packet(net, nf_ct_l3num(ct), 0, skb, NULL, NULL,
-			      NULL, "%s", msg);
+	nf_ct_l4proto_log_invalid(skb, ct, "%s", msg);
 	return false;
 }
 
@@ -472,7 +470,6 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 		       u_int8_t pf,
 		       unsigned int *timeouts)
 {
-	struct net *net = nf_ct_net(ct);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	struct dccp_hdr _dh, *dh;
 	u_int8_t type, old_state, new_state;
@@ -534,15 +531,11 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 		ct->proto.dccp.last_pkt = type;
 
 		spin_unlock_bh(&ct->lock);
-		if (LOG_INVALID(net, IPPROTO_DCCP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_dccp: invalid packet ignored ");
+		nf_ct_l4proto_log_invalid(skb, ct, "%s", "invalid packet");
 		return NF_ACCEPT;
 	case CT_DCCP_INVALID:
 		spin_unlock_bh(&ct->lock);
-		if (LOG_INVALID(net, IPPROTO_DCCP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_dccp: invalid state transition ");
+		nf_ct_l4proto_log_invalid(skb, ct, "%s", "invalid state transition");
 		return -NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 14198b2a2e2c..dced574f6006 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -702,9 +702,9 @@ static bool tcp_in_window(const struct nf_conn *ct,
 		if (sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL ||
 		    tn->tcp_be_liberal)
 			res = true;
-		if (!res && LOG_INVALID(net, IPPROTO_TCP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-			"nf_ct_tcp: %s ",
+		if (!res) {
+			nf_ct_l4proto_log_invalid(skb, ct,
+			"%s",
 			before(seq, sender->td_maxend + 1) ?
 			in_recv_win ?
 			before(sack, receiver->td_end + 1) ?
@@ -713,6 +713,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			: "ACK is over the upper bound (ACKed data not seen yet)"
 			: "SEQ is under the lower bound (already ACKed data retransmitted)"
 			: "SEQ is over the upper bound (over the window of the receiver)");
+		}
 	}
 
 	pr_debug("tcp_in_window: res=%u sender end=%u maxend=%u maxwin=%u "
@@ -937,10 +938,8 @@ static int tcp_packet(struct nf_conn *ct,
 					IP_CT_EXP_CHALLENGE_ACK;
 		}
 		spin_unlock_bh(&ct->lock);
-		if (LOG_INVALID(net, IPPROTO_TCP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				  "nf_ct_tcp: invalid packet ignored in "
-				  "state %s ", tcp_conntrack_names[old_state]);
+		nf_ct_l4proto_log_invalid(skb, ct, "invalid packet ignored in "
+					  "state %s ", tcp_conntrack_names[old_state]);
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Special case for SYN proxy: when the SYN to the server or
@@ -962,9 +961,7 @@ static int tcp_packet(struct nf_conn *ct,
 		pr_debug("nf_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
 			 dir, get_conntrack_index(th), old_state);
 		spin_unlock_bh(&ct->lock);
-		if (LOG_INVALID(net, IPPROTO_TCP))
-			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				  "nf_ct_tcp: invalid state ");
+		nf_ct_l4proto_log_invalid(skb, ct, "invalid state");
 		return -NF_ACCEPT;
 	case TCP_CONNTRACK_TIME_WAIT:
 		/* RFC5961 compliance cause stack to send "challenge-ACK"
@@ -979,9 +976,7 @@ static int tcp_packet(struct nf_conn *ct,
 			/* Detected RFC5961 challenge ACK */
 			ct->proto.tcp.last_flags &= ~IP_CT_EXP_CHALLENGE_ACK;
 			spin_unlock_bh(&ct->lock);
-			if (LOG_INVALID(net, IPPROTO_TCP))
-				nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-				      "nf_ct_tcp: challenge-ACK ignored ");
+			nf_ct_l4proto_log_invalid(skb, ct, "challenge-ack ignored");
 			return NF_ACCEPT; /* Don't change state */
 		}
 		break;
@@ -991,9 +986,7 @@ static int tcp_packet(struct nf_conn *ct,
 		    && before(ntohl(th->seq), ct->proto.tcp.seen[!dir].td_maxack)) {
 			/* Invalid RST  */
 			spin_unlock_bh(&ct->lock);
-			if (LOG_INVALID(net, IPPROTO_TCP))
-				nf_log_packet(net, pf, 0, skb, NULL, NULL,
-					      NULL, "nf_ct_tcp: invalid RST ");
+			nf_ct_l4proto_log_invalid(skb, ct, "invalid rst");
 			return -NF_ACCEPT;
 		}
 		if (index == TCP_RST_SET
-- 
2.11.0
