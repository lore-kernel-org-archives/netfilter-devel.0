From: <gregkh@suse.de>
Subject: patch nf_conntrack-padding-breaks-conntrack-hash-on-arm.patch added to 2.6.25-stable tree
Date: Tue, 13 May 2008 10:55:10 -0700
Message-ID: <20080513175702.F2C9C1454476@imap.suse.de>
References: <48297DE1.901@trash.net>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: philipc@snapgear.com, davem@davemloft.net, gregkh@suse.de,
	kaber@trash.net, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757169AbYEMR5F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 13:57:05 -0400
In-Reply-To: <48297DE1.901@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

     Subject: nf_conntrack: padding breaks conntrack hash on ARM

to the 2.6.25-stable tree.  Its filename is

     nf_conntrack-padding-breaks-conntrack-hash-on-arm.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue May 13 05:11:11 2008
From: Philip Craig <philipc@snapgear.com>
Date: Tue, 13 May 2008 13:39:13 +0200
Subject: nf_conntrack: padding breaks conntrack hash on ARM
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Message-ID: <48297DE1.901@trash.net>

From: Philip Craig <philipc@snapgear.com>

[NETFILTER]: nf_conntrack: padding breaks conntrack hash on ARM

Upstream commit 443a70d50:

commit 0794935e "[NETFILTER]: nf_conntrack: optimize hash_conntrack()"
results in ARM platforms hashing uninitialised padding.  This padding
doesn't exist on other architectures.

Fix this by replacing NF_CT_TUPLE_U_BLANK() with memset() to ensure
everything is initialised.  There were only 4 bytes that
NF_CT_TUPLE_U_BLANK() wasn't clearing anyway (or 12 bytes on ARM).

Signed-off-by: Philip Craig <philipc@snapgear.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/netfilter/nf_conntrack_tuple.h     |   10 ----------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/netfilter/nf_conntrack_core.c              |    4 ++--
 3 files changed, 3 insertions(+), 13 deletions(-)

--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
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
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -305,7 +305,7 @@ getorigdst(struct sock *sk, int optval, 
 	const struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 
-	NF_CT_TUPLE_U_BLANK(&tuple);
+	memset(&tuple, 0, sizeof(tuple));
 	tuple.src.u3.ip = inet->rcv_saddr;
 	tuple.src.u.tcp.port = inet->sport;
 	tuple.dst.u3.ip = inet->daddr;
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
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


Patches currently in stable-queue which might be from philipc@snapgear.com are

queue-2.6.25/nf_conntrack-padding-breaks-conntrack-hash-on-arm.patch
