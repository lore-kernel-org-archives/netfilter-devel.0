From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Wed, 30 Jan 2008 21:17:59 +0100 (MET)
Message-ID: <20080130201757.29874.54202.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60743 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbYA3USA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:00 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: optimize hash_conntrack()

Avoid calling jhash three times and hash the entire tuple in one go.

  __hash_conntrack | -485 # 760 -> 275, # inlines: 3 -> 1, size inlines: 717 -> 252
 1 function changed, 485 bytes removed

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2f75544ea729329074f86020b4524179cc82c219
tree e4dc132f189625ad5bd28e043e348f0deb825c47
parent 18fd2bf273954b4fa527e5d630049f40acc29fca
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:15 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:08 +0100

 net/netfilter/nf_conntrack_core.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ce4c4ba..24a0863 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -73,15 +73,19 @@ static unsigned int nf_conntrack_hash_rnd;
 static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
 				  unsigned int size, unsigned int rnd)
 {
-	unsigned int a, b;
+	unsigned int n;
+	u_int32_t h;
 
-	a = jhash2(tuple->src.u3.all, ARRAY_SIZE(tuple->src.u3.all),
-		   (tuple->src.l3num << 16) | tuple->dst.protonum);
-	b = jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
-		   ((__force __u16)tuple->src.u.all << 16) |
-		    (__force __u16)tuple->dst.u.all);
+	/* The direction must be ignored, so we hash everything up to the
+	 * destination ports (which is a multiple of 4) and treat the last
+	 * three bytes manually.
+	 */
+	n = (sizeof(tuple->src) + sizeof(tuple->dst.u3)) / sizeof(u32);
+	h = jhash2((u32 *)tuple, n,
+		   rnd ^ (((__force __u16)tuple->dst.u.all << 16) |
+		   	  tuple->dst.protonum));
 
-	return ((u64)jhash_2words(a, b, rnd) * size) >> 32;
+	return ((u64)h * size) >> 32;
 }
 
 static inline u_int32_t hash_conntrack(const struct nf_conntrack_tuple *tuple)
