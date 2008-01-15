From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 37/38]: nf_conntrack: remove print_conntrack function from l3protos
Date: Tue, 15 Jan 2008 07:20:02 +0100 (MET)
Message-ID: <20080115061957.3184.21883.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62274 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYAOGUD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:20:03 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: remove print_conntrack function from l3protos

Its unused and unlikely to ever be used.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 254624c5e171625a66d68b7ff457940b131de765
tree e17da32e0596fe4a1fb9bb46deaedd9158b7c469
parent acb619184a16c40b0f24fa7a66464a7494421b1f
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:31 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:31 +0100

 include/net/netfilter/nf_conntrack_l3proto.h       |    3 ---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |    7 -------
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    3 ---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |    7 -------
 net/netfilter/nf_conntrack_l3proto_generic.c       |    7 -------
 net/netfilter/nf_conntrack_standalone.c            |    3 ---
 6 files changed, 0 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 875c6d4..d5526bc 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -42,9 +42,6 @@ struct nf_conntrack_l3proto
 	int (*print_tuple)(struct seq_file *s,
 			   const struct nf_conntrack_tuple *);
 
-	/* Print out the private part of the conntrack. */
-	int (*print_conntrack)(struct seq_file *s, const struct nf_conn *);
-
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 78e6495..ac3d61d 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -56,12 +56,6 @@ static int ipv4_print_tuple(struct seq_file *s,
 			  NIPQUAD(tuple->dst.u3.ip));
 }
 
-static int ipv4_print_conntrack(struct seq_file *s,
-				const struct nf_conn *conntrack)
-{
-	return 0;
-}
-
 /* Returns new sk_buff, or NULL */
 static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 {
@@ -403,7 +397,6 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 	.pkt_to_tuple	 = ipv4_pkt_to_tuple,
 	.invert_tuple	 = ipv4_invert_tuple,
 	.print_tuple	 = ipv4_print_tuple,
-	.print_conntrack = ipv4_print_conntrack,
 	.get_l4proto	 = ipv4_get_l4proto,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr = ipv4_tuple_to_nlattr,
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 741f3df..acde995 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -121,9 +121,6 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		      ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
 		return -ENOSPC;
 
-	if (l3proto->print_conntrack(s, ct))
-		return -ENOSPC;
-
 	if (l4proto->print_conntrack(s, ct))
 		return -ENOSPC;
 
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 97a5530..cf42f5c 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -60,12 +60,6 @@ static int ipv6_print_tuple(struct seq_file *s,
 			  NIP6(*((struct in6_addr *)tuple->dst.u3.ip6)));
 }
 
-static int ipv6_print_conntrack(struct seq_file *s,
-				const struct nf_conn *conntrack)
-{
-	return 0;
-}
-
 /*
  * Based on ipv6_skip_exthdr() in net/ipv6/exthdr.c
  *
@@ -376,7 +370,6 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 __read_mostly = {
 	.pkt_to_tuple		= ipv6_pkt_to_tuple,
 	.invert_tuple		= ipv6_invert_tuple,
 	.print_tuple		= ipv6_print_tuple,
-	.print_conntrack	= ipv6_print_conntrack,
 	.get_l4proto		= ipv6_get_l4proto,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= ipv6_tuple_to_nlattr,
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 991c52c..8e914e5 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -55,12 +55,6 @@ static int generic_print_tuple(struct seq_file *s,
 	return 0;
 }
 
-static int generic_print_conntrack(struct seq_file *s,
-				const struct nf_conn *conntrack)
-{
-	return 0;
-}
-
 static int generic_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 			       unsigned int *dataoff, u_int8_t *protonum)
 {
@@ -75,7 +69,6 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_generic __read_mostly = {
 	.pkt_to_tuple	 = generic_pkt_to_tuple,
 	.invert_tuple	 = generic_invert_tuple,
 	.print_tuple	 = generic_print_tuple,
-	.print_conntrack = generic_print_conntrack,
 	.get_l4proto	 = generic_get_l4proto,
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_generic);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2ad4933..d54ca78 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -142,9 +142,6 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		       ? (long)(conntrack->timeout.expires - jiffies)/HZ : 0) != 0)
 		return -ENOSPC;
 
-	if (l3proto->print_conntrack(s, conntrack))
-		return -ENOSPC;
-
 	if (l4proto->print_conntrack(s, conntrack))
 		return -ENOSPC;
 
