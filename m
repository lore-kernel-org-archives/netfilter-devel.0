From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/32]: nf_nat_sip: fix NAT setup order
Date: Thu, 28 Feb 2008 13:00:09 +0100 (MET)
Message-ID: <20080228120000.29267.73156.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49983 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115AbYB1MAK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:10 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat_sip: fix NAT setup order

We need to set up the destination NAT mapping before the source NAT
mapping, so the NAT core gets to see the final tuple and can decide
whether the source port needs to be remapped.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2d4b798a4a54565722b4022ab08d1d97f01badbc
tree 95c9c90a6f5b61b1e74550e31b87f7045708a043
parent 2d238255870c937f703d8ccbf60e7be8924e1ff2
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:16 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:16 +0100

 net/ipv4/netfilter/nf_nat_sip.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index b4c8d49..84d8b49 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -224,17 +224,17 @@ static void ip_nat_sdp_expect(struct nf_conn *ct,
 	/* This must be a fresh one. */
 	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
 
-	/* Change src to where master sends to */
-	range.flags = IP_NAT_RANGE_MAP_IPS;
-	range.min_ip = range.max_ip
-		= ct->master->tuplehash[!exp->dir].tuple.dst.u3.ip;
-	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_SRC);
-
 	/* For DST manip, map port here to where it's expected. */
 	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
 	range.min = range.max = exp->saved_proto;
 	range.min_ip = range.max_ip = exp->saved_ip;
 	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_DST);
+
+	/* Change src to where master sends to */
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+	range.min_ip = range.max_ip
+		= ct->master->tuplehash[!exp->dir].tuple.dst.u3.ip;
+	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_SRC);
 }
 
 /* So, this packet has hit the connection tracking matching code.
