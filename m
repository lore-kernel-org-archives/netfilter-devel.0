From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/49]: nf_conntrack_proto_icmp: kill extern declaration in .c file
Date: Tue,  4 Dec 2007 13:02:25 +0100 (MET)
Message-ID: <20071204120224.2442.33581.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62164 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbXLDMC0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:26 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_proto_icmp: kill extern declaration in .c file

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1e1064d63bca1c55c2c5f9b91cc6fb5fb3fb3d71
tree 8fcf714acc6f30f0e56caad2bb3a3777ac7196bf
parent 7ec6f2c4596936e092f8597908e325b189169cf7
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:13 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:29:29 +0100

 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 0e2c448..4153e04 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -128,7 +128,6 @@ static int icmp_new(struct nf_conn *conntrack,
 	return 1;
 }
 
-extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
 /* Returns conntrack if it dealt with ICMP, and filled in skb fields */
 static int
 icmp_error_message(struct sk_buff *skb,
