From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/41]: nf_nat: fix random mode not to overwrite port rover
Date: Mon, 14 Apr 2008 12:16:43 +0200 (MEST)
Message-ID: <20080414101639.32717.6494.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36286 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbYDNKQo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:44 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: fix random mode not to overwrite port rover

The port rover should not get overwritten when using random mode,
otherwise other rules will also use more or less random ports.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2cfcdfef4681d3fc734f0c8e11c78425098731c6
tree 6f5afd7336e5325273ce6d38bddfffaa1f0767ae
parent 731ef46408d23bce8b9e0fc908b619a5a58cfd87
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:48 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:48 +0200

 net/ipv4/netfilter/nf_nat_proto_common.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_proto_common.c b/net/ipv4/netfilter/nf_nat_proto_common.c
index a124213..871ab0e 100644
--- a/net/ipv4/netfilter/nf_nat_proto_common.c
+++ b/net/ipv4/netfilter/nf_nat_proto_common.c
@@ -42,6 +42,7 @@ int nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 {
 	unsigned int range_size, min, i;
 	__be16 *portptr;
+	u_int16_t off;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
 		portptr = &tuple->src.u.all;
@@ -72,13 +73,17 @@ int nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 		range_size = ntohs(range->max.all) - min + 1;
 	}
 
+	off = *rover;
 	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
-		*rover = net_random();
+		off = net_random();
 
-	for (i = 0; i < range_size; i++, (*rover)++) {
-		*portptr = htons(min + *rover % range_size);
-		if (!nf_nat_used_tuple(tuple, ct))
-			return 1;
+	for (i = 0; i < range_size; i++, off++) {
+		*portptr = htons(min + off % range_size);
+		if (nf_nat_used_tuple(tuple, ct))
+			continue;
+		if (!(range->flags & IP_NAT_RANGE_PROTO_RANDOM))
+			*rover = off;
+		return 1;
 	}
 	return 0;
 }
