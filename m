From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 25/38] ipvs: add assured state for conn templates
Date: Fri, 20 Jul 2018 15:08:53 +0200
Message-ID: <20180720130906.27687-26-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

cp->state was not used for templates. Add support for state bits
and for the first "assured" bit which indicates that some
connection controlled by this template was established or assured
by the real server. In a followup patch we will use it to drop
templates under SYN attack.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h                   | 16 ++++++++++++++++
 net/netfilter/ipvs/ip_vs_proto.c      | 17 +++++++++++++++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c |  2 ++
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |  2 ++
 net/netfilter/ipvs/ip_vs_proto_udp.c  |  2 ++
 net/netfilter/ipvs/ip_vs_sync.c       | 18 ++++++------------
 6 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 4d76abcf1c41..a0d2e0bb9a94 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -335,6 +335,11 @@ enum ip_vs_sctp_states {
 	IP_VS_SCTP_S_LAST
 };
 
+/* Connection templates use bits from state */
+#define IP_VS_CTPL_S_NONE		0x0000
+#define IP_VS_CTPL_S_ASSURED		0x0001
+#define IP_VS_CTPL_S_LAST		0x0002
+
 /* Delta sequence info structure
  * Each ip_vs_conn has 2 (output AND input seq. changes).
  * Only used in the VS/NAT.
@@ -1289,6 +1294,17 @@ ip_vs_control_add(struct ip_vs_conn *cp, struct ip_vs_conn *ctl_cp)
 	atomic_inc(&ctl_cp->n_control);
 }
 
+/* Mark our template as assured */
+static inline void
+ip_vs_control_assure_ct(struct ip_vs_conn *cp)
+{
+	struct ip_vs_conn *ct = cp->control;
+
+	if (ct && !(ct->state & IP_VS_CTPL_S_ASSURED) &&
+	    (ct->flags & IP_VS_CONN_F_TEMPLATE))
+		ct->state |= IP_VS_CTPL_S_ASSURED;
+}
+
 /* IPVS netns init & cleanup functions */
 int ip_vs_estimator_net_init(struct netns_ipvs *ipvs);
 int ip_vs_control_net_init(struct netns_ipvs *ipvs);
diff --git a/net/netfilter/ipvs/ip_vs_proto.c b/net/netfilter/ipvs/ip_vs_proto.c
index 85c446621758..54ee84adf0bd 100644
--- a/net/netfilter/ipvs/ip_vs_proto.c
+++ b/net/netfilter/ipvs/ip_vs_proto.c
@@ -42,6 +42,11 @@
 
 static struct ip_vs_protocol *ip_vs_proto_table[IP_VS_PROTO_TAB_SIZE];
 
+/* States for conn templates: NONE or words separated with ",", max 15 chars */
+static const char *ip_vs_ctpl_state_name_table[IP_VS_CTPL_S_LAST] = {
+	[IP_VS_CTPL_S_NONE]			= "NONE",
+	[IP_VS_CTPL_S_ASSURED]			= "ASSURED",
+};
 
 /*
  *	register an ipvs protocol
@@ -195,11 +200,19 @@ ip_vs_create_timeout_table(int *table, int size)
 
 const char *ip_vs_state_name(const struct ip_vs_conn *cp)
 {
-	struct ip_vs_protocol *pp = ip_vs_proto_get(cp->protocol);
+	unsigned int state = cp->state;
+	struct ip_vs_protocol *pp;
+
+	if (cp->flags & IP_VS_CONN_F_TEMPLATE) {
 
+		if (state >= IP_VS_CTPL_S_LAST)
+			return "ERR!";
+		return ip_vs_ctpl_state_name_table[state] ? : "?";
+	}
+	pp = ip_vs_proto_get(cp->protocol);
 	if (pp == NULL || pp->state_name == NULL)
 		return (cp->protocol == IPPROTO_IP) ? "NONE" : "ERR!";
-	return pp->state_name(cp->state);
+	return pp->state_name(state);
 }
 
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index 3250c4a1111e..b0cd7d08f2a7 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -461,6 +461,8 @@ set_sctp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 				cp->flags &= ~IP_VS_CONN_F_INACTIVE;
 			}
 		}
+		if (next_state == IP_VS_SCTP_S_ESTABLISHED)
+			ip_vs_control_assure_ct(cp);
 	}
 	if (likely(pd))
 		cp->timeout = pd->timeout_table[cp->state = next_state];
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 80d10ad12a15..1770fc6ce960 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -569,6 +569,8 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 				cp->flags &= ~IP_VS_CONN_F_INACTIVE;
 			}
 		}
+		if (new_state == IP_VS_TCP_S_ESTABLISHED)
+			ip_vs_control_assure_ct(cp);
 	}
 
 	if (likely(pd))
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index e0ef11c3691e..0f53c49025f8 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -460,6 +460,8 @@ udp_state_transition(struct ip_vs_conn *cp, int direction,
 	}
 
 	cp->timeout = pd->timeout_table[IP_VS_UDP_S_NORMAL];
+	if (direction == IP_VS_DIR_OUTPUT)
+		ip_vs_control_assure_ct(cp);
 }
 
 static int __udp_init(struct netns_ipvs *ipvs, struct ip_vs_proto_data *pd)
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 001501e25625..d4020c5e831d 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1003,12 +1003,9 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
 				continue;
 			}
 		} else {
-			/* protocol in templates is not used for state/timeout */
-			if (state > 0) {
-				IP_VS_DBG(2, "BACKUP v0, Invalid template state %u\n",
-					state);
-				state = 0;
-			}
+			if (state >= IP_VS_CTPL_S_LAST)
+				IP_VS_DBG(7, "BACKUP v0, Invalid tpl state %u\n",
+					  state);
 		}
 
 		ip_vs_conn_fill_param(ipvs, AF_INET, s->protocol,
@@ -1166,12 +1163,9 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
 			goto out;
 		}
 	} else {
-		/* protocol in templates is not used for state/timeout */
-		if (state > 0) {
-			IP_VS_DBG(3, "BACKUP, Invalid template state %u\n",
-				state);
-			state = 0;
-		}
+		if (state >= IP_VS_CTPL_S_LAST)
+			IP_VS_DBG(7, "BACKUP, Invalid tpl state %u\n",
+				  state);
 	}
 	if (ip_vs_conn_fill_param_sync(ipvs, af, s, &param, pe_data,
 				       pe_data_len, pe_name, pe_name_len)) {
-- 
2.11.0
