From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/22]: nf_conntrack: use jhash2 in __hash_conntrack
Date: Wed, 14 Mar 2007 09:50:40 +0100 (MET)
Message-ID: <20070314085024.15282.45771.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: use jhash2 in __hash_conntrack

Now it uses jhash, but using jhash2 would be around 3-4 times faster
(on P4).

Signed-off-by: Sami Farin <safari-netfilter@safari.iki.fi>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a36f33350b8220397ac33ee98c26e808289a302b
tree d505586b3eb93b7cfb9990a892ca9538325fb57d
parent 2fdc283757d6f33fda2d4d86a51abce3d155bb22
author Sami Farin <safari-netfilter@safari.iki.fi> Thu, 08 Mar 2007 18:26:17 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:31:52 +0100

 net/netfilter/nf_conntrack_core.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9858bcb..2b0cc7a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -128,10 +128,11 @@ static u_int32_t __hash_conntrack(const 
 				  unsigned int size, unsigned int rnd)
 {
 	unsigned int a, b;
-	a = jhash((void *)tuple->src.u3.all, sizeof(tuple->src.u3.all),
-		  ((tuple->src.l3num) << 16) | tuple->dst.protonum);
-	b = jhash((void *)tuple->dst.u3.all, sizeof(tuple->dst.u3.all),
-			(tuple->src.u.all << 16) | tuple->dst.u.all);
+
+	a = jhash2(tuple->src.u3.all, ARRAY_SIZE(tuple->src.u3.all),
+		   (tuple->src.l3num << 16) | tuple->dst.protonum);
+	b = jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
+		   (tuple->src.u.all << 16) | tuple->dst.u.all);
 
 	return jhash_2words(a, b, rnd) % size;
 }
