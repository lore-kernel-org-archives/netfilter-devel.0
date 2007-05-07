From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/5]: nf_conntrack: Removes unused destroy operation of
 l3proto
Date: Mon, 07 May 2007 12:01:03 +0900 (JST)
Message-ID: <200705070301.l47314D7010243@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/nf_conntrack_l3proto.h |    3 ---
 net/netfilter/nf_conntrack_core.c            |    5 -----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index f32f714..96a58d8 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -56,9 +56,6 @@ struct nf_conntrack_l3proto
 	 */
 	int (*new)(struct nf_conn *conntrack, const struct sk_buff *skb);
 
-	/* Called when a conntrack entry is destroyed */
-	void (*destroy)(struct nf_conn *conntrack);
-
 	/*
 	 * Called before tracking. 
 	 *	*dataoff: offset of protocol header (TCP, UDP,...) in *pskb
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e132c8a..94000a4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -299,7 +299,6 @@ destroy_conntrack(struct nf_conntrack *n
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 	struct nf_conn_help *help = nfct_help(ct);
-	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
 	typeof(nf_conntrack_destroyed) destroyed;
 
@@ -317,10 +316,6 @@ destroy_conntrack(struct nf_conntrack *n
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
 	rcu_read_lock();
-	l3proto = __nf_ct_l3proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num);
-	if (l3proto && l3proto->destroy)
-		l3proto->destroy(ct);
-
 	l4proto = __nf_ct_l4proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num,
 				       ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
 	if (l4proto && l4proto->destroy)
-- 
1.4.4
