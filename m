From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/06]: nf_nat: use HW checksumming when possible
Date: Fri, 13 Apr 2007 05:00:12 +0200 (MEST)
Message-ID: <20070413025927.29875.3347.sendpatchset@localhost.localdomain>
References: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: use HW checksumming when possible

When mangling packets forwarded to a HW checksumming capable device,
offload recalculation of the checksum instead of doing it in software.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 794931007064900f96c05544fbed41ef194884c8
tree c2ee02fe0ac4767e289382b008050ebaf2e1da1f
parent 801b6d278e6e78a2a58b6729eb8f799de6ed74d0
author Patrick McHardy <kaber@trash.net> Fri, 13 Apr 2007 04:43:14 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 13 Apr 2007 04:43:14 +0200

 net/ipv4/netfilter/nf_nat_helper.c |   49 +++++++++++++++++++++++++++---------
 1 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index 8a40fbe..15b6e5c 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -153,6 +153,7 @@ nf_nat_mangle_tcp_packet(struct sk_buff **pskb,
 			 const char *rep_buffer,
 			 unsigned int rep_len)
 {
+	struct rtable *rt = (struct rtable *)(*pskb)->dst;
 	struct iphdr *iph;
 	struct tcphdr *tcph;
 	int oldlen, datalen;
@@ -176,11 +177,22 @@ nf_nat_mangle_tcp_packet(struct sk_buff **pskb,
 
 	datalen = (*pskb)->len - iph->ihl*4;
 	if ((*pskb)->ip_summed != CHECKSUM_PARTIAL) {
-		tcph->check = 0;
-		tcph->check = tcp_v4_check(datalen,
-					   iph->saddr, iph->daddr,
-					   csum_partial((char *)tcph,
-							datalen, 0));
+		if (!(rt->rt_flags & RTCF_LOCAL) &&
+		    (*pskb)->dev->features & NETIF_F_ALL_CSUM) {
+			(*pskb)->ip_summed = CHECKSUM_PARTIAL;
+			(*pskb)->csum_start = skb_headroom(*pskb) +
+					      skb_network_offset(*pskb) +
+					      iph->ihl * 4;
+			(*pskb)->csum_offset = offsetof(struct tcphdr, check);
+			tcph->check = ~tcp_v4_check(datalen,
+						    iph->saddr, iph->daddr, 0);
+		} else {
+			tcph->check = 0;
+			tcph->check = tcp_v4_check(datalen,
+						   iph->saddr, iph->daddr,
+						   csum_partial((char *)tcph,
+								datalen, 0));
+		}
 	} else
 		nf_proto_csum_replace2(&tcph->check, *pskb,
 				       htons(oldlen), htons(datalen), 1);
@@ -217,6 +229,7 @@ nf_nat_mangle_udp_packet(struct sk_buff **pskb,
 			 const char *rep_buffer,
 			 unsigned int rep_len)
 {
+	struct rtable *rt = (struct rtable *)(*pskb)->dst;
 	struct iphdr *iph;
 	struct udphdr *udph;
 	int datalen, oldlen;
@@ -251,13 +264,25 @@ nf_nat_mangle_udp_packet(struct sk_buff **pskb,
 		return 1;
 
 	if ((*pskb)->ip_summed != CHECKSUM_PARTIAL) {
-		udph->check = 0;
-		udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
-						datalen, IPPROTO_UDP,
-						csum_partial((char *)udph,
-							     datalen, 0));
-		if (!udph->check)
-			udph->check = CSUM_MANGLED_0;
+		if (!(rt->rt_flags & RTCF_LOCAL) &&
+		    (*pskb)->dev->features & NETIF_F_ALL_CSUM) {
+			(*pskb)->ip_summed = CHECKSUM_PARTIAL;
+			(*pskb)->csum_start = skb_headroom(*pskb) +
+					      skb_network_offset(*pskb) +
+					      iph->ihl * 4;
+			(*pskb)->csum_offset = offsetof(struct udphdr, check);
+			udph->check = ~csum_tcpudp_magic(iph->saddr, iph->daddr,
+							 datalen, IPPROTO_UDP,
+							 0);
+		} else {
+			udph->check = 0;
+			udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
+							datalen, IPPROTO_UDP,
+							csum_partial((char *)udph,
+								     datalen, 0));
+			if (!udph->check)
+				udph->check = CSUM_MANGLED_0;
+		}
 	} else
 		nf_proto_csum_replace2(&udph->check, *pskb,
 				       htons(oldlen), htons(datalen), 1);
