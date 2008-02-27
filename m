From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/05]: nf_nat: always select same SNAT source for same host
Date: Wed, 27 Feb 2008 14:14:24 +0100 (MET)
Message-ID: <20080227131432.26831.2125.sendpatchset@localhost.localdomain>
References: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53809 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbYB0NOZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:14:25 -0500
In-Reply-To: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: always select same SNAT source for same host

We've removed the SAME target in 2.6.25-rc since it had 32/64 bit compat
problems and the NAT core provides the same behaviour regarding IP
selection. This turned out to be not entirely correct though, the
NAT core only selects the same IP from a range for the same src,dst
combination. Some people need the same IP for all destinations however.

The easiest way to do this is to ignore the destination IP when
doing SNAT. Since we're using jhash, we still get good distribution
for multiple source IPs.

Tested-by: David Lau <mintypickle@gmail.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c31b70def66807822dc973e66757507a5fd4c3b6
tree c0a635a5e75bbce4e234ca53d3f12e9af963e741
parent 54b4910d81a787d932d0a3237a8a15879f8eb8b8
author Patrick McHardy <kaber@trash.net> Wed, 27 Feb 2008 13:23:57 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 27 Feb 2008 13:23:57 +0100

 net/ipv4/netfilter/nf_nat_core.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 0d5fa3a..8e1cae2 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -188,15 +188,19 @@ find_best_ips_proto(struct nf_conntrack_tuple *tuple,
 	__be32 *var_ipp;
 	/* Host order */
 	u_int32_t minip, maxip, j;
+	__be32 dst;
 
 	/* No IP mapping?  Do nothing. */
 	if (!(range->flags & IP_NAT_RANGE_MAP_IPS))
 		return;
 
-	if (maniptype == IP_NAT_MANIP_SRC)
+	if (maniptype == IP_NAT_MANIP_SRC) {
 		var_ipp = &tuple->src.u3.ip;
-	else
+		dst = 0;
+	} else {
 		var_ipp = &tuple->dst.u3.ip;
+		dst = tuple->dst.u3.ip;
+	}
 
 	/* Fast path: only one choice. */
 	if (range->min_ip == range->max_ip) {
@@ -212,8 +216,7 @@ find_best_ips_proto(struct nf_conntrack_tuple *tuple,
 	 * like this), even across reboots. */
 	minip = ntohl(range->min_ip);
 	maxip = ntohl(range->max_ip);
-	j = jhash_2words((__force u32)tuple->src.u3.ip,
-			 (__force u32)tuple->dst.u3.ip, 0);
+	j = jhash_2words((__force u32)tuple->src.u3.ip, (__force u32)dst, 0);
 	j = ((u64)j * (maxip - minip + 1)) >> 32;
 	*var_ipp = htonl(minip + j);
 }
