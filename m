Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF08B149C7C;
	Thu, 11 Apr 2024 11:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712834956; cv=none; b=pOl3323Myog8i6XgzbRZKIepdtuVrMdYbT9MwAXE3MOCbOjdoAgbl7hT+x1OtwoSDdbcurdlqg/C0eFZ1nN2UIBOo+qpM/aHV7vOipoq3F7MJj5Yklf+eagKv2wjOHSD4qpNr2AsewUNowfBm8qMeZWiO0v+4Khp5Tkd9sK2siM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712834956; c=relaxed/simple;
	bh=kGUgJd6e6+P0WN8i92jlD09S0lZpUbzQuW+E7LhwQIY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XzgzejfN0mVIN57IjzTsEIxFiCbYbUWSINl/7Nc8a8JE6ijz0dIxcAGubypnaoOKYmKacCETFZmRR64fdnXtmyGvv25piZ7y3YSbLlN8aYKBXsSYxF9aTRr26CFCTcsDzaSifMxlN1QgsBLZPytJM41ahWyPILiq3vrqDf/O8vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 6/7] netfilter: flowtable: validate pppoe header
Date: Thu, 11 Apr 2024 13:28:59 +0200
Message-Id: <20240411112900.129414-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240411112900.129414-1-pablo@netfilter.org>
References: <20240411112900.129414-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ensure there is sufficient room to access the protocol field of the
PPPoe header. Validate it once before the flowtable lookup, then use a
helper function to access protocol field.

Reported-by: syzbot+b6f07e1c07ef40199081@syzkaller.appspotmail.com
Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 12 +++++++++++-
 net/netfilter/nf_flow_table_inet.c    |  3 ++-
 net/netfilter/nf_flow_table_ip.c      |  8 +++++---
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a763dd327c6e..9abb7ee40d72 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -336,7 +336,7 @@ int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 int nf_flow_table_offload_init(void);
 void nf_flow_table_offload_exit(void);
 
-static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
+static inline __be16 __nf_flow_pppoe_proto(const struct sk_buff *skb)
 {
 	__be16 proto;
 
@@ -352,6 +352,16 @@ static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
 	return 0;
 }
 
+static inline bool nf_flow_pppoe_proto(struct sk_buff *skb, __be16 *inner_proto)
+{
+	if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
+		return false;
+
+	*inner_proto = __nf_flow_pppoe_proto(skb);
+
+	return true;
+}
+
 #define NF_FLOW_TABLE_STAT_INC(net, count) __this_cpu_inc((net)->ft.stat->count)
 #define NF_FLOW_TABLE_STAT_DEC(net, count) __this_cpu_dec((net)->ft.stat->count)
 #define NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count)	\
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 9505f9d188ff..6eef15648b7b 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -21,7 +21,8 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 		proto = veth->h_vlan_encapsulated_proto;
 		break;
 	case htons(ETH_P_PPP_SES):
-		proto = nf_flow_pppoe_proto(skb);
+		if (!nf_flow_pppoe_proto(skb, &proto))
+			return NF_ACCEPT;
 		break;
 	default:
 		proto = skb->protocol;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index e45fade76409..9e9e105052da 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -273,10 +273,11 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
+static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 				       u32 *offset)
 {
 	struct vlan_ethhdr *veth;
+	__be16 inner_proto;
 
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
@@ -287,7 +288,8 @@ static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
 		}
 		break;
 	case htons(ETH_P_PPP_SES):
-		if (nf_flow_pppoe_proto(skb) == proto) {
+		if (nf_flow_pppoe_proto(skb, &inner_proto) &&
+		    inner_proto == proto) {
 			*offset += PPPOE_SES_HLEN;
 			return true;
 		}
@@ -316,7 +318,7 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 			skb_reset_network_header(skb);
 			break;
 		case htons(ETH_P_PPP_SES):
-			skb->protocol = nf_flow_pppoe_proto(skb);
+			skb->protocol = __nf_flow_pppoe_proto(skb);
 			skb_pull(skb, PPPOE_SES_HLEN);
 			skb_reset_network_header(skb);
 			break;
-- 
2.30.2

