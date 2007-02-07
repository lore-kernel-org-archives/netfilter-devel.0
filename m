From: Patrick McHardy <kaber@trash.net>
Subject: [NET 07/15]: Add UDPLITE support in a few missing spots
Date: Wed,  7 Feb 2007 09:22:48 +0100 (MET)
Message-ID: <20070207082247.27478.39679.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NET]: Add UDPLITE support in a few missing spots

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 25236bad10d061ba7fce42608ae3db8369f33bd0
tree 1ff1e6c42740d9000e4bd3b1d761503e347b76d2
parent bcefbe8fd50b101d89a8cab0a7fe251213a88e70
author Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 07:36:55 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:37:36 +0100

 net/bridge/netfilter/ebt_ip.c      |    1 +
 net/bridge/netfilter/ebt_log.c     |    1 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    1 +
 net/netfilter/xt_hashlimit.c       |    1 +
 net/sched/sch_sfq.c                |    2 ++
 5 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index e4c6424..6afa4d0 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -93,6 +93,7 @@ static int ebt_ip_check(const char *tabl
 			return -EINVAL;
 		if (info->protocol != IPPROTO_TCP &&
 		    info->protocol != IPPROTO_UDP &&
+		    info->protocol != IPPROTO_UDPLITE &&
 		    info->protocol != IPPROTO_SCTP &&
 		    info->protocol != IPPROTO_DCCP)
 			 return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index a184f87..985df82 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -96,6 +96,7 @@ ebt_log_packet(unsigned int pf, unsigned
 		       NIPQUAD(ih->daddr), ih->tos, ih->protocol);
 		if (ih->protocol == IPPROTO_TCP ||
 		    ih->protocol == IPPROTO_UDP ||
+		    ih->protocol == IPPROTO_UDPLITE ||
 		    ih->protocol == IPPROTO_SCTP ||
 		    ih->protocol == IPPROTO_DCCP) {
 			struct tcpudphdr _ports, *pptr;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index b1c1116..018fea3 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -247,6 +247,7 @@ clusterip_hashfn(struct sk_buff *skb, st
 	switch (iph->protocol) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
 	case IPPROTO_SCTP:
 	case IPPROTO_DCCP:
 	case IPPROTO_ICMP:
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index f28bf69..bd1f7a2 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -414,6 +414,7 @@ #endif
 	switch (nexthdr) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
 	case IPPROTO_SCTP:
 	case IPPROTO_DCCP:
 		ports = skb_header_pointer(skb, protoff, sizeof(_ports),
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 459cda2..8284480 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -143,6 +143,7 @@ static unsigned sfq_hash(struct sfq_sche
 		if (!(iph->frag_off&htons(IP_MF|IP_OFFSET)) &&
 		    (iph->protocol == IPPROTO_TCP ||
 		     iph->protocol == IPPROTO_UDP ||
+		     iph->protocol == IPPROTO_UDPLITE ||
 		     iph->protocol == IPPROTO_SCTP ||
 		     iph->protocol == IPPROTO_DCCP ||
 		     iph->protocol == IPPROTO_ESP))
@@ -156,6 +157,7 @@ static unsigned sfq_hash(struct sfq_sche
 		h2 = iph->saddr.s6_addr32[3]^iph->nexthdr;
 		if (iph->nexthdr == IPPROTO_TCP ||
 		    iph->nexthdr == IPPROTO_UDP ||
+		    iph->nexthdr == IPPROTO_UDPLITE ||
 		    iph->nexthdr == IPPROTO_SCTP ||
 		    iph->nexthdr == IPPROTO_DCCP ||
 		    iph->nexthdr == IPPROTO_ESP)
