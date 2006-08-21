From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/18]: replace open coded checksum updates
Date: Tue, 22 Aug 2006 00:52:30 +0200 (MEST)
Message-ID: <20060821225229.10288.30059.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: replace open coded checksum updates

Replace open coded checksum update by nf_csum_update calls and clean up
the surrounding code a bit.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 54ba0f09d3cb3d4ce48e4eb8cb9cae3ac60bade1
tree a34a4a57ebe2e4f12711b66f913a81fef9619713
parent 94964e26cff67825112477f3c8bae88539245d72
author Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 21:15:53 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 21:15:53 +0200

 net/ipv4/netfilter/ipt_ECN.c |   22 +++++++++-------------
 net/ipv4/netfilter/ipt_TOS.c |   22 ++++++++--------------
 net/ipv4/netfilter/ipt_TTL.c |    9 +++------
 3 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 35916c7..7e30e6d 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -27,22 +27,18 @@ MODULE_DESCRIPTION("iptables ECN modific
 static inline int
 set_ect_ip(struct sk_buff **pskb, const struct ipt_ECN_info *einfo)
 {
-	if (((*pskb)->nh.iph->tos & IPT_ECN_IP_MASK)
-	    != (einfo->ip_ect & IPT_ECN_IP_MASK)) {
-		u_int16_t diffs[2];
+	struct iphdr *iph = (*pskb)->nh.iph;
+	u_int16_t oldtos;
 
+	if ((iph->tos & IPT_ECN_IP_MASK) != (einfo->ip_ect & IPT_ECN_IP_MASK)) {
 		if (!skb_make_writable(pskb, sizeof(struct iphdr)))
 			return 0;
-
-		diffs[0] = htons((*pskb)->nh.iph->tos) ^ 0xFFFF;
-		(*pskb)->nh.iph->tos &= ~IPT_ECN_IP_MASK;
-		(*pskb)->nh.iph->tos |= (einfo->ip_ect & IPT_ECN_IP_MASK);
-		diffs[1] = htons((*pskb)->nh.iph->tos);
-		(*pskb)->nh.iph->check
-			= csum_fold(csum_partial((char *)diffs,
-						 sizeof(diffs),
-						 (*pskb)->nh.iph->check
-						 ^0xFFFF));
+		iph = (*pskb)->nh.iph;
+		oldtos = iph->tos;
+		iph->tos &= ~IPT_ECN_IP_MASK;
+		iph->tos |= (einfo->ip_ect & IPT_ECN_IP_MASK);
+		iph->check = nf_csum_update(oldtos ^ 0xFFFF, iph->tos,
+					    iph->check);
 	} 
 	return 1;
 }
diff --git a/net/ipv4/netfilter/ipt_TOS.c b/net/ipv4/netfilter/ipt_TOS.c
index 1c7a5ca..52e9d70 100644
--- a/net/ipv4/netfilter/ipt_TOS.c
+++ b/net/ipv4/netfilter/ipt_TOS.c
@@ -30,23 +30,17 @@ target(struct sk_buff **pskb,
        void *userinfo)
 {
 	const struct ipt_tos_target_info *tosinfo = targinfo;
+	struct iphdr *iph = (*pskb)->nh.iph;
+	u_int16_t oldtos;
 
-	if (((*pskb)->nh.iph->tos & IPTOS_TOS_MASK) != tosinfo->tos) {
-		u_int16_t diffs[2];
-
+	if ((iph->tos & IPTOS_TOS_MASK) != tosinfo->tos) {
 		if (!skb_make_writable(pskb, sizeof(struct iphdr)))
 			return NF_DROP;
-
-		diffs[0] = htons((*pskb)->nh.iph->tos) ^ 0xFFFF;
-		(*pskb)->nh.iph->tos
-			= ((*pskb)->nh.iph->tos & IPTOS_PREC_MASK)
-			| tosinfo->tos;
-		diffs[1] = htons((*pskb)->nh.iph->tos);
-		(*pskb)->nh.iph->check
-			= csum_fold(csum_partial((char *)diffs,
-						 sizeof(diffs),
-						 (*pskb)->nh.iph->check
-						 ^0xFFFF));
+		iph = (*pskb)->nh.iph;
+		oldtos = iph->tos;
+		iph->tos = (iph->tos & IPTOS_PREC_MASK) | tosinfo->tos;
+		iph->check = nf_csum_update(oldtos ^ 0xFFFF, iph->tos,
+					    iph->check);
 	}
 	return IPT_CONTINUE;
 }
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index f48892a..2afb2a8 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -27,7 +27,6 @@ ipt_ttl_target(struct sk_buff **pskb,
 {
 	struct iphdr *iph;
 	const struct ipt_TTL_info *info = targinfo;
-	u_int16_t diffs[2];
 	int new_ttl;
 
 	if (!skb_make_writable(pskb, (*pskb)->len))
@@ -55,12 +54,10 @@ ipt_ttl_target(struct sk_buff **pskb,
 	}
 
 	if (new_ttl != iph->ttl) {
-		diffs[0] = htons(((unsigned)iph->ttl) << 8) ^ 0xFFFF;
+		iph->check = nf_csum_update((iph->ttl << 8) ^ 0xFFFF,
+					    new_ttl << 8,
+					    iph->check);
 		iph->ttl = new_ttl;
-		diffs[1] = htons(((unsigned)iph->ttl) << 8);
-		iph->check = csum_fold(csum_partial((char *)diffs,
-						    sizeof(diffs),
-						    iph->check^0xFFFF));
 	}
 
 	return IPT_CONTINUE;
