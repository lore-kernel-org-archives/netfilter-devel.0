From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/17]: x_tables: add SCTP/DCCP support where missing
Date: Tue, 30 May 2006 00:34:08 +0200 (MEST)
Message-ID: <20060529223408.24834.36562.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: add SCTP/DCCP support where missing

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d8913efd2c5ec04b2b0447394c8ecdff37abe3c5
tree 405fc65eb82832af883bd5de9be421b739588c15
parent 36e1d2c1e439bf08da7406cc82b01e18062a437e
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:37 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:37 +0200

 net/ipv4/netfilter/ipt_CLUSTERIP.c |   20 +++--------
 net/ipv4/netfilter/ipt_hashlimit.c |   64 +++++++++---------------------------
 net/netfilter/xt_multiport.c       |    7 ++--
 3 files changed, 26 insertions(+), 65 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index aad9d28..dbc83c5 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -241,25 +241,17 @@ clusterip_hashfn(struct sk_buff *skb, st
 	struct iphdr *iph = skb->nh.iph;
 	unsigned long hashval;
 	u_int16_t sport, dport;
-	struct tcphdr *th;
-	struct udphdr *uh;
-	struct icmphdr *ih;
+	u_int16_t *ports;
 
 	switch (iph->protocol) {
 	case IPPROTO_TCP:
-		th = (void *)iph+iph->ihl*4;
-		sport = ntohs(th->source);
-		dport = ntohs(th->dest);
-		break;
 	case IPPROTO_UDP:
-		uh = (void *)iph+iph->ihl*4;
-		sport = ntohs(uh->source);
-		dport = ntohs(uh->dest);
-		break;
+	case IPPROTO_SCTP:
+	case IPPROTO_DCCP:
 	case IPPROTO_ICMP:
-		ih = (void *)iph+iph->ihl*4;
-		sport = ntohs(ih->un.echo.id);
-		dport = (ih->type<<8)|ih->code;
+		ports = (void *)iph+iph->ihl*4;
+		sport = ports[0];
+		dport = ports[1];
 		break;
 	default:
 		if (net_ratelimit()) {
diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
index b88adc7..85edfb7 100644
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -28,9 +28,6 @@ #include <linux/random.h>
 #include <linux/jhash.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/tcp.h>
-#include <linux/udp.h>
-#include <linux/sctp.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/list.h>
@@ -381,49 +378,6 @@ static inline void rateinfo_recalc(struc
 		dh->rateinfo.credit = dh->rateinfo.credit_cap;
 }
 
-static inline int get_ports(const struct sk_buff *skb, int offset, 
-			    u16 ports[2])
-{
-	union {
-		struct tcphdr th;
-		struct udphdr uh;
-		sctp_sctphdr_t sctph;
-	} hdr_u, *ptr_u;
-
-	/* Must not be a fragment. */
-	if (offset)
-		return 1;
-
-	/* Must be big enough to read ports (both UDP and TCP have
-	   them at the start). */
-	ptr_u = skb_header_pointer(skb, skb->nh.iph->ihl*4, 8, &hdr_u); 
-	if (!ptr_u)
-		return 1;
-
-	switch (skb->nh.iph->protocol) {
-		case IPPROTO_TCP:
-			ports[0] = ptr_u->th.source;
-			ports[1] = ptr_u->th.dest;
-			break;
-		case IPPROTO_UDP:
-			ports[0] = ptr_u->uh.source;
-			ports[1] = ptr_u->uh.dest;
-			break;
-		case IPPROTO_SCTP:
-			ports[0] = ptr_u->sctph.source;
-			ports[1] = ptr_u->sctph.dest;
-			break;
-		default:
-			/* all other protocols don't supprot per-port hash
-			 * buckets */
-			ports[0] = ports[1] = 0;
-			break;
-	}
-
-	return 0;
-}
-
-
 static int
 hashlimit_match(const struct sk_buff *skb,
 		const struct net_device *in,
@@ -449,8 +403,22 @@ hashlimit_match(const struct sk_buff *sk
 		dst.src_ip = skb->nh.iph->saddr;
 	if (hinfo->cfg.mode & IPT_HASHLIMIT_HASH_DPT
 	    ||hinfo->cfg.mode & IPT_HASHLIMIT_HASH_SPT) {
-		u_int16_t ports[2];
-		if (get_ports(skb, offset, ports)) {
+		u_int16_t _ports[2], *ports;
+
+		switch (skb->nh.iph->protocol) {
+		case IPPROTO_TCP:
+		case IPPROTO_UDP:
+		case IPPROTO_SCTP:
+		case IPPROTO_DCCP:
+			ports = skb_header_pointer(skb, skb->nh.iph->ihl*4,
+						   sizeof(_ports), &_ports);
+			break;
+		default:
+			_ports[0] = _ports[1] = 0;
+			ports = _ports;
+			break;
+		}
+		if (!ports) {
 			/* We've been asked to examine this packet, and we
 		 	  can't.  Hence, no choice but to drop. */
 			*hotdrop = 1;
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index b56cd2b..1ff0a25 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -1,4 +1,4 @@
-/* Kernel module to match one of a list of TCP/UDP ports: ports are in
+/* Kernel module to match one of a list of TCP/UDP/SCTP/DCCP ports: ports are in
    the same place so we can treat them as equal. */
 
 /* (C) 1999-2001 Paul `Rusty' Russell
@@ -160,8 +160,9 @@ check(u_int16_t proto,
       u_int8_t match_flags,
       u_int8_t count)
 {
-	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
-	return (proto == IPPROTO_TCP || proto == IPPROTO_UDP)
+	/* Must specify supported protocol, no unknown flags or bad count */
+	return (proto == IPPROTO_TCP || proto == IPPROTO_UDP
+		|| proto == IPPROTO_SCTP || proto == IPPROTO_DCCP)
 		&& !(ip_invflags & XT_INV_PROTO)
 		&& (match_flags == XT_MULTIPORT_SOURCE
 		    || match_flags == XT_MULTIPORT_DESTINATION
