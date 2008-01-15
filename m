From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 38/38]: nf_conntrack: make print_conntrack function optional for l4protos
Date: Tue, 15 Jan 2008 07:20:03 +0100 (MET)
Message-ID: <20080115061958.3184.97678.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62272 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYAOGUF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:20:05 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: make print_conntrack function optional for l4protos

Allows to remove five empty implementations.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1b92cbe78d5e84fcc50ab1f890f23628dbd36f69
tree c336f72850df23d7eaa8be943697aebb3a23f56f
parent 254624c5e171625a66d68b7ff457940b131de765
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:31 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:31 +0100

 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |    8 --------
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |    8 --------
 net/netfilter/nf_conntrack_proto_generic.c         |    8 --------
 net/netfilter/nf_conntrack_proto_udp.c             |    9 ---------
 net/netfilter/nf_conntrack_proto_udplite.c         |    9 ---------
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 7 files changed, 2 insertions(+), 44 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index acde995..543c02b 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -121,7 +121,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		      ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
 		return -ENOSPC;
 
-	if (l4proto->print_conntrack(s, ct))
+	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
 		return -ENOSPC;
 
 	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index cd0d669..4004a04 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -74,13 +74,6 @@ static int icmp_print_tuple(struct seq_file *s,
 			  ntohs(tuple->src.u.icmp.id));
 }
 
-/* Print out the private part of the conntrack. */
-static int icmp_print_conntrack(struct seq_file *s,
-				const struct nf_conn *conntrack)
-{
-	return 0;
-}
-
 /* Returns verdict for packet, or -1 for invalid. */
 static int icmp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
@@ -309,7 +302,6 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp __read_mostly =
 	.pkt_to_tuple		= icmp_pkt_to_tuple,
 	.invert_tuple		= icmp_invert_tuple,
 	.print_tuple		= icmp_print_tuple,
-	.print_conntrack	= icmp_print_conntrack,
 	.packet			= icmp_packet,
 	.new			= icmp_new,
 	.error			= icmp_error,
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 02d60df..da924c6 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -75,13 +75,6 @@ static int icmpv6_print_tuple(struct seq_file *s,
 			  ntohs(tuple->src.u.icmp.id));
 }
 
-/* Print out the private part of the conntrack. */
-static int icmpv6_print_conntrack(struct seq_file *s,
-				  const struct nf_conn *conntrack)
-{
-	return 0;
-}
-
 /* Returns verdict for packet, or -1 for invalid. */
 static int icmpv6_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
@@ -275,7 +268,6 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 __read_mostly =
 	.pkt_to_tuple		= icmpv6_pkt_to_tuple,
 	.invert_tuple		= icmpv6_invert_tuple,
 	.print_tuple		= icmpv6_print_tuple,
-	.print_conntrack	= icmpv6_print_conntrack,
 	.packet			= icmpv6_packet,
 	.new			= icmpv6_new,
 	.error			= icmpv6_error,
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 13f8191..22c5dcb 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -40,13 +40,6 @@ static int generic_print_tuple(struct seq_file *s,
 	return 0;
 }
 
-/* Print out the private part of the conntrack. */
-static int generic_print_conntrack(struct seq_file *s,
-				   const struct nf_conn *state)
-{
-	return 0;
-}
-
 /* Returns verdict for packet, or -1 for invalid. */
 static int packet(struct nf_conn *conntrack,
 		  const struct sk_buff *skb,
@@ -104,7 +97,6 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_generic __read_mostly =
 	.pkt_to_tuple		= generic_pkt_to_tuple,
 	.invert_tuple		= generic_invert_tuple,
 	.print_tuple		= generic_print_tuple,
-	.print_conntrack	= generic_print_conntrack,
 	.packet			= packet,
 	.new			= new,
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 7ac6073..3848754 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -60,13 +60,6 @@ static int udp_print_tuple(struct seq_file *s,
 			  ntohs(tuple->dst.u.udp.port));
 }
 
-/* Print out the private part of the conntrack. */
-static int udp_print_conntrack(struct seq_file *s,
-			       const struct nf_conn *conntrack)
-{
-	return 0;
-}
-
 /* Returns verdict for packet, and may modify conntracktype */
 static int udp_packet(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
@@ -193,7 +186,6 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 __read_mostly =
 	.pkt_to_tuple		= udp_pkt_to_tuple,
 	.invert_tuple		= udp_invert_tuple,
 	.print_tuple		= udp_print_tuple,
-	.print_conntrack	= udp_print_conntrack,
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error,
@@ -221,7 +213,6 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 __read_mostly =
 	.pkt_to_tuple		= udp_pkt_to_tuple,
 	.invert_tuple		= udp_invert_tuple,
 	.print_tuple		= udp_print_tuple,
-	.print_conntrack	= udp_print_conntrack,
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error,
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 6518bcd..070056d 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -59,13 +59,6 @@ static int udplite_print_tuple(struct seq_file *s,
 			  ntohs(tuple->dst.u.udp.port));
 }
 
-/* Print out the private part of the conntrack. */
-static int udplite_print_conntrack(struct seq_file *s,
-				   const struct nf_conn *conntrack)
-{
-	return 0;
-}
-
 /* Returns verdict for packet, and may modify conntracktype */
 static int udplite_packet(struct nf_conn *conntrack,
 			  const struct sk_buff *skb,
@@ -198,7 +191,6 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 __read_mostly =
 	.pkt_to_tuple		= udplite_pkt_to_tuple,
 	.invert_tuple		= udplite_invert_tuple,
 	.print_tuple		= udplite_print_tuple,
-	.print_conntrack	= udplite_print_conntrack,
 	.packet			= udplite_packet,
 	.new			= udplite_new,
 	.error			= udplite_error,
@@ -222,7 +214,6 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
 	.pkt_to_tuple		= udplite_pkt_to_tuple,
 	.invert_tuple		= udplite_invert_tuple,
 	.print_tuple		= udplite_print_tuple,
-	.print_conntrack	= udplite_print_conntrack,
 	.packet			= udplite_packet,
 	.new			= udplite_new,
 	.error			= udplite_error,
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index d54ca78..696074a 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -142,7 +142,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		       ? (long)(conntrack->timeout.expires - jiffies)/HZ : 0) != 0)
 		return -ENOSPC;
 
-	if (l4proto->print_conntrack(s, conntrack))
+	if (l4proto->print_conntrack && l4proto->print_conntrack(s, conntrack))
 		return -ENOSPC;
 
 	if (print_tuple(s, &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
