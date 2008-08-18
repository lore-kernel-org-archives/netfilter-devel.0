From: Patrick McHardy <kaber@trash.net>
Subject: nf_nat 06/06: use secure_ipv4_port_ephemeral() for NAT port randomization
Date: Mon, 18 Aug 2008 18:51:56 +0200 (MEST)
Message-ID: <20080818165155.18978.32057.sendpatchset@localhost.localdomain>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59357 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbYHRQv5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:51:57 -0400
In-Reply-To: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_nat: use secure_ipv4_port_ephemeral() for NAT port randomization

Use incoming network tuple as seed for NAT port randomization.
This avoids concerns of leaking net_random() bits, and also gives better
port distribution. Don't have NAT server, compile tested only.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

[ added missing EXPORT_SYMBOL_GPL ]

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 288787c6d3d50245d718537142800762d7ff1181
tree da622065f39a1adeb8323ab2549f8638adaffbd6
parent be6e3721aa813e40f20d84d7925f9cf5cd8eef2d
author Stephen Hemminger <shemminger@vyatta.com> Mon, 18 Aug 2008 18:35:09 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 18 Aug 2008 18:35:09 +0200

 drivers/char/random.c                    |    1 +
 net/ipv4/netfilter/nf_nat_proto_common.c |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e0d0e37..1838aa3 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1571,6 +1571,7 @@ u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 
 	return half_md4_transform(hash, keyptr->secret);
 }
+EXPORT_SYMBOL_GPL(secure_ipv4_port_ephemeral);
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
diff --git a/net/ipv4/netfilter/nf_nat_proto_common.c b/net/ipv4/netfilter/nf_nat_proto_common.c
index 91537f1..6c4f11f 100644
--- a/net/ipv4/netfilter/nf_nat_proto_common.c
+++ b/net/ipv4/netfilter/nf_nat_proto_common.c
@@ -73,9 +73,13 @@ bool nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 		range_size = ntohs(range->max.all) - min + 1;
 	}
 
-	off = *rover;
 	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
-		off = net_random();
+		off = secure_ipv4_port_ephemeral(tuple->src.u3.ip, tuple->dst.u3.ip,
+						 maniptype == IP_NAT_MANIP_SRC
+						 ? tuple->dst.u.all
+						 : tuple->src.u.all);
+	else
+		off = *rover;
 
 	for (i = 0; i < range_size; i++, off++) {
 		*portptr = htons(min + off % range_size);
