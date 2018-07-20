From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 24/38] ipvs: provide just conn to ip_vs_state_name
Date: Fri, 20 Jul 2018 15:08:52 +0200
Message-ID: <20180720130906.27687-25-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

In preparation for followup patches, provide just the cp
ptr to ip_vs_state_name.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h              | 2 +-
 net/netfilter/ipvs/ip_vs_conn.c  | 8 ++++----
 net/netfilter/ipvs/ip_vs_proto.c | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index a0bec23c6d5e..4d76abcf1c41 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1221,7 +1221,7 @@ struct ip_vs_conn *ip_vs_conn_new(const struct ip_vs_conn_param *p, int dest_af,
 				  struct ip_vs_dest *dest, __u32 fwmark);
 void ip_vs_conn_expire_now(struct ip_vs_conn *cp);
 
-const char *ip_vs_state_name(__u16 proto, int state);
+const char *ip_vs_state_name(const struct ip_vs_conn *cp);
 
 void ip_vs_tcp_conn_listen(struct ip_vs_conn *cp);
 int ip_vs_check_template(struct ip_vs_conn *ct, struct ip_vs_dest *cdest);
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 99e0aa350dc5..de5a64e42ebd 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1107,7 +1107,7 @@ static int ip_vs_conn_seq_show(struct seq_file *seq, void *v)
 				&cp->caddr.in6, ntohs(cp->cport),
 				&cp->vaddr.in6, ntohs(cp->vport),
 				dbuf, ntohs(cp->dport),
-				ip_vs_state_name(cp->protocol, cp->state),
+				ip_vs_state_name(cp),
 				(cp->timer.expires-jiffies)/HZ, pe_data);
 		else
 #endif
@@ -1118,7 +1118,7 @@ static int ip_vs_conn_seq_show(struct seq_file *seq, void *v)
 				ntohl(cp->caddr.ip), ntohs(cp->cport),
 				ntohl(cp->vaddr.ip), ntohs(cp->vport),
 				dbuf, ntohs(cp->dport),
-				ip_vs_state_name(cp->protocol, cp->state),
+				ip_vs_state_name(cp),
 				(cp->timer.expires-jiffies)/HZ, pe_data);
 	}
 	return 0;
@@ -1169,7 +1169,7 @@ static int ip_vs_conn_sync_seq_show(struct seq_file *seq, void *v)
 				&cp->caddr.in6, ntohs(cp->cport),
 				&cp->vaddr.in6, ntohs(cp->vport),
 				dbuf, ntohs(cp->dport),
-				ip_vs_state_name(cp->protocol, cp->state),
+				ip_vs_state_name(cp),
 				ip_vs_origin_name(cp->flags),
 				(cp->timer.expires-jiffies)/HZ);
 		else
@@ -1181,7 +1181,7 @@ static int ip_vs_conn_sync_seq_show(struct seq_file *seq, void *v)
 				ntohl(cp->caddr.ip), ntohs(cp->cport),
 				ntohl(cp->vaddr.ip), ntohs(cp->vport),
 				dbuf, ntohs(cp->dport),
-				ip_vs_state_name(cp->protocol, cp->state),
+				ip_vs_state_name(cp),
 				ip_vs_origin_name(cp->flags),
 				(cp->timer.expires-jiffies)/HZ);
 	}
diff --git a/net/netfilter/ipvs/ip_vs_proto.c b/net/netfilter/ipvs/ip_vs_proto.c
index ca880a3ad033..85c446621758 100644
--- a/net/netfilter/ipvs/ip_vs_proto.c
+++ b/net/netfilter/ipvs/ip_vs_proto.c
@@ -193,13 +193,13 @@ ip_vs_create_timeout_table(int *table, int size)
 }
 
 
-const char * ip_vs_state_name(__u16 proto, int state)
+const char *ip_vs_state_name(const struct ip_vs_conn *cp)
 {
-	struct ip_vs_protocol *pp = ip_vs_proto_get(proto);
+	struct ip_vs_protocol *pp = ip_vs_proto_get(cp->protocol);
 
 	if (pp == NULL || pp->state_name == NULL)
-		return (IPPROTO_IP == proto) ? "NONE" : "ERR!";
-	return pp->state_name(state);
+		return (cp->protocol == IPPROTO_IP) ? "NONE" : "ERR!";
+	return pp->state_name(cp->state);
 }
 
 
-- 
2.11.0
