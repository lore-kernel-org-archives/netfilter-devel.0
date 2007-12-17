From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 41/64]: nf_nat_proto_gre: add missing module reference
Date: Tue, 18 Dec 2007 00:47:09 +0100 (MET)
Message-ID: <20071217234708.23601.33362.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39008 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbXLQXrK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:10 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat_proto_gre: add missing module reference

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 11f11327057d79cd000efab9e70585fb3a356fa6
tree 27e7b6cb7d92fa39cff8de80f0bcbe2e2231128f
parent 56ffe07f8708058c5aab185ea4658257a5b9f709
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:28 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:57 +0100

 net/ipv4/netfilter/nf_nat_proto_gre.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index b820f99..945e0ae 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -138,6 +138,7 @@ gre_manip_pkt(struct sk_buff *skb, unsigned int iphdroff,
 static struct nf_nat_protocol gre __read_mostly = {
 	.name			= "GRE",
 	.protonum		= IPPROTO_GRE,
+	.me			= THIS_MODULE,
 	.manip_pkt		= gre_manip_pkt,
 	.in_range		= gre_in_range,
 	.unique_tuple		= gre_unique_tuple,
