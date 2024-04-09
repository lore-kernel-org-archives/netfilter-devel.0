Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B50A153574
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712680667; cv=none; b=dVNltTW94LoG20VlrGPOD+Hqli0obQi99J5AiaJs4jDEt8PTIg3+6nLLCZ3kHKSPCBkM+PQ+DDSTZmwxEXSwQxS/PRpfmggyJq+Kgn5byayXpZFoLRFfL4uVTn61X22HT34T7q6BKE8wmXO0/nIHW/wKTi3qh4HOIHAVz4lyjt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712680667; c=relaxed/simple;
	bh=zzfoORLiwAewHoOwd5rNikoMsERSjleQi9LKj7l6CZU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RSW3Tbs4sY1JDCgvL04didegO1XEDJKHP4+iMnR7EltUJKZgEWLPHh0VHRRmTwje+lMrm4+UwmW4+xWmSQxTPPUNmsvQzLQujALZ5SBid+l+l6w+UbkL2tWwnHMbqrLGqhfFgfuagPfsbk8KZOAG2gj5DwK0lXuoauygGdLGeAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: syzbot+b6f07e1c07ef40199081@syzkaller.appspotmail.com
Subject: [PATCH nf,v2] netfilter: flowtable: validate PPPoe header
Date: Tue,  9 Apr 2024 18:37:31 +0200
Message-Id: <20240409163731.9587-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
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
v2: adjust inet flowtable nf_flow_pppoe_proto() call too.

 include/net/netfilter/nf_flow_table.h | 12 +++++++++++-
 net/netfilter/nf_flow_table_inet.c    |  3 ++-
 net/netfilter/nf_flow_table_ip.c      |  8 +++++---
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a763dd327c6e..cb2fca8075df 100644
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
 
+static inline int nf_flow_pppoe_proto(struct sk_buff *skb, __be16 *inner_proto)
+{
+	if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
+		return -1;
+
+	*inner_proto = __nf_flow_pppoe_proto(skb);
+
+	return 0;
+}
+
 #define NF_FLOW_TABLE_STAT_INC(net, count) __this_cpu_inc((net)->ft.stat->count)
 #define NF_FLOW_TABLE_STAT_DEC(net, count) __this_cpu_dec((net)->ft.stat->count)
 #define NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count)	\
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 9505f9d188ff..4a33eb934ec7 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -21,7 +21,8 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 		proto = veth->h_vlan_encapsulated_proto;
 		break;
 	case htons(ETH_P_PPP_SES):
-		proto = nf_flow_pppoe_proto(skb);
+		if (nf_flow_pppoe_proto(skb, &proto) < 0)
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

