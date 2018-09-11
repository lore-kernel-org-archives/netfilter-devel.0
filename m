From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/12] netfilter: conntrack: place 'new' timeout in first location too
Date: Tue, 11 Sep 2018 02:20:36 +0200
Message-ID: <20180911002044.9100-5-pablo@netfilter.org>
References: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911002044.9100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

tcp, sctp and dccp trackers re-use the userspace ctnetlink states
to index their timeout arrays, which means timeout[0] is never
used.  Copy the 'new' state (syn-sent, dccp-request, ..) to 0 as well
so external users can simply read it off timeouts[0] without need to
differentiate dccp/sctp/tcp and udp/icmp/gre/generic.

The alternative is to map all array accesses to 'i - 1', but that
is a much more intrusive change.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 7 +++++++
 net/netfilter/nf_conntrack_proto_sctp.c | 7 +++++++
 net/netfilter/nf_conntrack_proto_tcp.c  | 7 +++++++
 3 files changed, 21 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 8c58f96b59e7..b81f70039828 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -697,6 +697,8 @@ static int dccp_timeout_nlattr_to_obj(struct nlattr *tb[],
 			timeouts[i] = ntohl(nla_get_be32(tb[i])) * HZ;
 		}
 	}
+
+	timeouts[CTA_TIMEOUT_DCCP_UNSPEC] = timeouts[CTA_TIMEOUT_DCCP_REQUEST];
 	return 0;
 }
 
@@ -827,6 +829,11 @@ static int dccp_init_net(struct net *net, u_int16_t proto)
 		dn->dccp_timeout[CT_DCCP_CLOSEREQ]	= 64 * HZ;
 		dn->dccp_timeout[CT_DCCP_CLOSING]	= 64 * HZ;
 		dn->dccp_timeout[CT_DCCP_TIMEWAIT]	= 2 * DCCP_MSL;
+
+		/* timeouts[0] is unused, make it same as SYN_SENT so
+		 * ->timeouts[0] contains 'new' timeout, like udp or icmp.
+		 */
+		dn->dccp_timeout[CT_DCCP_NONE] = dn->dccp_timeout[CT_DCCP_REQUEST];
 	}
 
 	return dccp_kmemdup_sysctl_table(net, pn, dn);
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 8d1e085fc14a..5eddfd32b852 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -613,6 +613,8 @@ static int sctp_timeout_nlattr_to_obj(struct nlattr *tb[],
 			timeouts[i] = ntohl(nla_get_be32(tb[i])) * HZ;
 		}
 	}
+
+	timeouts[CTA_TIMEOUT_SCTP_UNSPEC] = timeouts[CTA_TIMEOUT_SCTP_CLOSED];
 	return 0;
 }
 
@@ -743,6 +745,11 @@ static int sctp_init_net(struct net *net, u_int16_t proto)
 
 		for (i = 0; i < SCTP_CONNTRACK_MAX; i++)
 			sn->timeouts[i] = sctp_timeouts[i];
+
+		/* timeouts[0] is unused, init it so ->timeouts[0] contains
+		 * 'new' timeout, like udp or icmp.
+		 */
+		sn->timeouts[0] = sctp_timeouts[SCTP_CONNTRACK_CLOSED];
 	}
 
 	return sctp_kmemdup_sysctl_table(pn, sn);
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index d80d322b9d8b..3e2dc56a96c3 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1301,6 +1301,7 @@ static int tcp_timeout_nlattr_to_obj(struct nlattr *tb[],
 		timeouts[TCP_CONNTRACK_SYN_SENT] =
 			ntohl(nla_get_be32(tb[CTA_TIMEOUT_TCP_SYN_SENT]))*HZ;
 	}
+
 	if (tb[CTA_TIMEOUT_TCP_SYN_RECV]) {
 		timeouts[TCP_CONNTRACK_SYN_RECV] =
 			ntohl(nla_get_be32(tb[CTA_TIMEOUT_TCP_SYN_RECV]))*HZ;
@@ -1341,6 +1342,8 @@ static int tcp_timeout_nlattr_to_obj(struct nlattr *tb[],
 		timeouts[TCP_CONNTRACK_UNACK] =
 			ntohl(nla_get_be32(tb[CTA_TIMEOUT_TCP_UNACK]))*HZ;
 	}
+
+	timeouts[CTA_TIMEOUT_TCP_UNSPEC] = timeouts[CTA_TIMEOUT_TCP_SYN_SENT];
 	return 0;
 }
 
@@ -1518,6 +1521,10 @@ static int tcp_init_net(struct net *net, u_int16_t proto)
 		for (i = 0; i < TCP_CONNTRACK_TIMEOUT_MAX; i++)
 			tn->timeouts[i] = tcp_timeouts[i];
 
+		/* timeouts[0] is unused, make it same as SYN_SENT so
+		 * ->timeouts[0] contains 'new' timeout, like udp or icmp.
+		 */
+		tn->timeouts[0] = tcp_timeouts[TCP_CONNTRACK_SYN_SENT];
 		tn->tcp_loose = nf_ct_tcp_loose;
 		tn->tcp_be_liberal = nf_ct_tcp_be_liberal;
 		tn->tcp_max_retrans = nf_ct_tcp_max_retrans;
-- 
2.11.0
