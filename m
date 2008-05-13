From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 1/2]: nf_conntrack: padding breaks conntrack hash
 on ARM
Date: Tue, 13 May 2008 13:39:13 +0200
Message-ID: <48297DE1.901@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080904070604040609030902"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39820 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYEMLjv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 07:39:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080904070604040609030902
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

These patches for stable-2.6.25 fix two netfilter bugs:

- a hashing change broke on ARM because of holes in struct
   nf_conntrack. Fixed by 1/2 by memsetting the entire struct
   to make sure the holes are initialized to zero.

- netfilter queueing might panic when enlarging packets,
   fixed by 2/2 by using the proper size for the skb.

Please apply, thanks.

--------------080904070604040609030902
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

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

---
commit 90364383ef3b7de3812e933c91cb3ac3928cdfaa
tree e4ed0a0b6076437d11123f60389bff6b78e0bb27
parent d8447b287c252e02f135618ed4a8781fd3b8797f
author Philip Craig <philipc@snapgear.com> Tue, 13 May 2008 13:35:02 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 13 May 2008 13:35:02 +0200

 include/net/netfilter/nf_conntrack_tuple.h     |   10 ----------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/netfilter/nf_conntrack_core.c              |    4 ++--
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index e69ab2e..d9a4f7f 100644
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
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index a65b845..50ad6ef 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -305,7 +305,7 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 	const struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 
-	NF_CT_TUPLE_U_BLANK(&tuple);
+	memset(&tuple, 0, sizeof(tuple));
 	tuple.src.u3.ip = inet->rcv_saddr;
 	tuple.src.u.tcp.port = inet->sport;
 	tuple.dst.u3.ip = inet->daddr;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b77eb56..4147de6 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -104,7 +104,7 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 		const struct nf_conntrack_l3proto *l3proto,
 		const struct nf_conntrack_l4proto *l4proto)
 {
-	NF_CT_TUPLE_U_BLANK(tuple);
+	memset(tuple, 0, sizeof(*tuple));
 
 	tuple->src.l3num = l3num;
 	if (l3proto->pkt_to_tuple(skb, nhoff, tuple) == 0)
@@ -153,7 +153,7 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 		   const struct nf_conntrack_l3proto *l3proto,
 		   const struct nf_conntrack_l4proto *l4proto)
 {
-	NF_CT_TUPLE_U_BLANK(inverse);
+	memset(inverse, 0, sizeof(*inverse));
 
 	inverse->src.l3num = orig->src.l3num;
 	if (l3proto->invert_tuple(inverse, orig) == 0)

--------------080904070604040609030902--
