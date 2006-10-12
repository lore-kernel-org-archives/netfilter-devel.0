From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/06]: ipt_ECN/ipt_TOS: fix incorrect checksum update
Date: Thu, 12 Oct 2006 11:54:22 +0200 (MEST)
Message-ID: <20061012095551.11462.57093.sendpatchset@localhost.localdomain>
References: <20061012095547.11462.58507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061012095547.11462.58507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_ECN/ipt_TOS: fix incorrect checksum update

Even though the tos field is only a single byte large, the values need to
be converted to net-endian for the checkum update so they are in the
corrent byte position. Also fix incorrect endian annotations.

Reported by Stephane Chazelas <Stephane_Chazelas@yahoo.fr>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 889d786a9211434b29e402a501d01a590b072d31
tree 2290ec865a25bb99171ab4c44ea6c463df13a3b1
parent 7f7a882296c917251a7936b41ee001e545a09e6c
author Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 10:07:57 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 10:07:57 +0200

 net/ipv4/netfilter/ipt_ECN.c |    6 +++---
 net/ipv4/netfilter/ipt_TOS.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 12a818a..1aa4517 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -28,7 +28,7 @@ static inline int
 set_ect_ip(struct sk_buff **pskb, const struct ipt_ECN_info *einfo)
 {
 	struct iphdr *iph = (*pskb)->nh.iph;
-	__be16 oldtos;
+	u_int16_t oldtos;
 
 	if ((iph->tos & IPT_ECN_IP_MASK) != (einfo->ip_ect & IPT_ECN_IP_MASK)) {
 		if (!skb_make_writable(pskb, sizeof(struct iphdr)))
@@ -37,8 +37,8 @@ set_ect_ip(struct sk_buff **pskb, const 
 		oldtos = iph->tos;
 		iph->tos &= ~IPT_ECN_IP_MASK;
 		iph->tos |= (einfo->ip_ect & IPT_ECN_IP_MASK);
-		iph->check = nf_csum_update(oldtos ^ htons(0xFFFF), iph->tos,
-					    iph->check);
+		iph->check = nf_csum_update(htons(oldtos) ^ htons(0xFFFF),
+					    htons(iph->tos), iph->check);
 	} 
 	return 1;
 }
diff --git a/net/ipv4/netfilter/ipt_TOS.c b/net/ipv4/netfilter/ipt_TOS.c
index 6b8b14c..83b80b3 100644
--- a/net/ipv4/netfilter/ipt_TOS.c
+++ b/net/ipv4/netfilter/ipt_TOS.c
@@ -30,7 +30,7 @@ target(struct sk_buff **pskb,
 {
 	const struct ipt_tos_target_info *tosinfo = targinfo;
 	struct iphdr *iph = (*pskb)->nh.iph;
-	__be16 oldtos;
+	u_int16_t oldtos;
 
 	if ((iph->tos & IPTOS_TOS_MASK) != tosinfo->tos) {
 		if (!skb_make_writable(pskb, sizeof(struct iphdr)))
@@ -38,8 +38,8 @@ target(struct sk_buff **pskb,
 		iph = (*pskb)->nh.iph;
 		oldtos = iph->tos;
 		iph->tos = (iph->tos & IPTOS_PREC_MASK) | tosinfo->tos;
-		iph->check = nf_csum_update(oldtos ^ htons(0xFFFF), iph->tos,
-					    iph->check);
+		iph->check = nf_csum_update(htons(oldtos) ^ htons(0xFFFF),
+					    htons(iph->tos), iph->check);
 	}
 	return IPT_CONTINUE;
 }
