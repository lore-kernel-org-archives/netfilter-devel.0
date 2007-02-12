From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/22]: nf_conntrack: properly use RCU for
	nf_conntrack_destroyed callback
Date: Mon, 12 Feb 2007 11:36:43 +0100 (MET)
Message-ID: <20070212103643.661.15242.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: properly use RCU for nf_conntrack_destroyed callback

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2428570e4fc9d689faeb4a96ba7b34352f0a6e2c
tree 7224fd0620ed1a49075a55da0c3b08cd77334313
parent 26462f9a42bcf2230a68d84dec3a048bc5a9a1af
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:07:18 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:07:18 +0100

 net/ipv4/netfilter/nf_nat_core.c  |    7 ++++---
 net/netfilter/nf_conntrack_core.c |    9 ++++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 5156d5d..2c01378 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -617,8 +617,8 @@ static int __init nf_nat_init(void)
 	}
 
 	/* FIXME: Man, this is a hack.  <SIGH> */
-	NF_CT_ASSERT(nf_conntrack_destroyed == NULL);
-	nf_conntrack_destroyed = &nf_nat_cleanup_conntrack;
+	NF_CT_ASSERT(rcu_dereference(nf_conntrack_destroyed) == NULL);
+	rcu_assign_pointer(nf_conntrack_destroyed, nf_nat_cleanup_conntrack);
 
 	/* Initialize fake conntrack so that NAT will skip it */
 	nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
@@ -642,7 +642,8 @@ static int clean_nat(struct nf_conn *i, 
 static void __exit nf_nat_cleanup(void)
 {
 	nf_ct_iterate_cleanup(&clean_nat, NULL);
-	nf_conntrack_destroyed = NULL;
+	rcu_assign_pointer(nf_conntrack_destroyed, NULL);
+	synchronize_rcu();
 	vfree(bysource);
 	nf_ct_l3proto_put(l3proto);
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d59640e..0cc1505 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -318,6 +318,7 @@ destroy_conntrack(struct nf_conntrack *n
 	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
+	typeof(nf_conntrack_destroyed) destroyed;
 
 	DEBUGP("destroy_conntrack(%p)\n", ct);
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
@@ -341,10 +342,12 @@ destroy_conntrack(struct nf_conntrack *n
 				       ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
 	if (l4proto && l4proto->destroy)
 		l4proto->destroy(ct);
-	rcu_read_unlock();
 
-	if (nf_conntrack_destroyed)
-		nf_conntrack_destroyed(ct);
+	destroyed = rcu_dereference(nf_conntrack_destroyed);
+	if (destroyed)
+		destroyed(ct);
+
+	rcu_read_unlock();
 
 	write_lock_bh(&nf_conntrack_lock);
 	/* Expectations will have been removed in clean_from_lists,
