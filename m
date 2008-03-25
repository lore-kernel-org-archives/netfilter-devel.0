From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/32]: nf_nat_sip: fix NAT setup order
Date: Tue, 25 Mar 2008 15:15:02 +0100 (MET)
Message-ID: <20080325141501.10539.17795.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32911 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYCYOPD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:03 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat_sip: fix NAT setup order

We need to set up the destination NAT mapping before the source NAT
mapping, so the NAT core gets to see the final tuple and can decide
whether the source port needs to be remapped.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b76b0afe5818cb9aac50d57e0be319935f58ed64
tree aecf418e8d77a75e0fdbf8250a2e9fe028131c13
parent 14d510e3026c99ebd8531e8ea0acb574545b5c42
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:44:48 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:53 +0100

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
