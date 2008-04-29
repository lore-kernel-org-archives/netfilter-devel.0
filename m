From: Philip Craig <philipc@snapgear.com>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Tue, 29 Apr 2008 18:40:32 +1000
Message-ID: <4816DF00.8060704@snapgear.com>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain> <20080130201757.29874.54202.sendpatchset@localhost.localdomain> <481589D2.2050901@snapgear.com> <4815D842.8010303@trash.net> <4816A89B.7050300@snapgear.com> <4816B5A1.8050906@snapgear.com> <4816B829.9080206@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090400050504040303000700"
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
	Russell King <rmk@arm.linux.org.uk>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:52607 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753992AbYD2Ikg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:40:36 -0400
In-Reply-To: <4816B829.9080206@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090400050504040303000700
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> I think the memset-solution is preferrable, using byte-wise
> accesses to the entire tuple would really suck.

Here's the memset patch.


--------------090400050504040303000700
Content-Type: text/x-diff;
 name="conntrack-hash-blank.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conntrack-hash-blank.patch"

[NETFILTER]: nf_conntrack: padding breaks conntrack hash on ARM

commit 0794935e "[NETFILTER]: nf_conntrack: optimize hash_conntrack()"
results in ARM platforms hashing uninitialised padding.  This padding
doesn't exist on other architectures.

Fix this by replacing NF_CT_TUPLE_U_BLANK() with memset() to ensure
everything is initialised.  There were only 4 bytes that
NF_CT_TUPLE_U_BLANK() wasn't clearing anyway (or 12 bytes on ARM).

Signed-off-by: Philip Craig <philipc@snapgear.com>

--- linux-2.6.25/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	22 Apr 2008 01:38:00 -0000	1.1.1.10
+++ linux-2.6.25/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	29 Apr 2008 08:20:31 -0000
@@ -305,7 +305,7 @@ getorigdst(struct sock *sk, int optval, 
 	const struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 
-	NF_CT_TUPLE_U_BLANK(&tuple);
+	memset(&tuple, 0, sizeof(tuple));
 	tuple.src.u3.ip = inet->rcv_saddr;
 	tuple.src.u.tcp.port = inet->sport;
 	tuple.dst.u3.ip = inet->daddr;
--- linux-2.6.25/net/netfilter/nf_conntrack_core.c	22 Apr 2008 01:38:00 -0000	1.1.1.11
+++ linux-2.6.25/net/netfilter/nf_conntrack_core.c	29 Apr 2008 08:20:31 -0000
@@ -104,7 +104,7 @@ nf_ct_get_tuple(const struct sk_buff *sk
 		const struct nf_conntrack_l3proto *l3proto,
 		const struct nf_conntrack_l4proto *l4proto)
 {
-	NF_CT_TUPLE_U_BLANK(tuple);
+	memset(tuple, 0, sizeof(*tuple));
 
 	tuple->src.l3num = l3num;
 	if (l3proto->pkt_to_tuple(skb, nhoff, tuple) == 0)
@@ -153,7 +153,7 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 		   const struct nf_conntrack_l3proto *l3proto,
 		   const struct nf_conntrack_l4proto *l4proto)
 {
-	NF_CT_TUPLE_U_BLANK(inverse);
+	memset(inverse, 0, sizeof(*inverse));
 
 	inverse->src.l3num = orig->src.l3num;
 	if (l3proto->invert_tuple(inverse, orig) == 0)
--- linux-2.6.25/include/net/netfilter/nf_conntrack_tuple.h	22 Apr 2008 01:36:51 -0000	1.1.1.5
+++ linux-2.6.25/include/net/netfilter/nf_conntrack_tuple.h	29 Apr 2008 08:20:31 -0000
@@ -101,16 +101,6 @@ struct nf_conntrack_tuple_mask
 	} src;
 };
 
-/* This is optimized opposed to a memset of the whole structure.  Everything we
- * really care about is the  source/destination unions */
-#define NF_CT_TUPLE_U_BLANK(tuple)                              	\
-        do {                                                    	\
-                (tuple)->src.u.all = 0;                         	\
-                (tuple)->dst.u.all = 0;                         	\
-		memset(&(tuple)->src.u3, 0, sizeof((tuple)->src.u3));	\
-		memset(&(tuple)->dst.u3, 0, sizeof((tuple)->dst.u3));	\
-        } while (0)
-
 #ifdef __KERNEL__
 
 #define NF_CT_DUMP_TUPLE(tp)						     \

--------------090400050504040303000700--
