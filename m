From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/22]: ip_conntrack: properly use RCU for
	ip_conntrack_destroyed callback
Date: Mon, 12 Feb 2007 11:36:42 +0100 (MET)
Message-ID: <20070212103642.661.65722.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip_conntrack: properly use RCU for ip_conntrack_destroyed callback

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 26462f9a42bcf2230a68d84dec3a048bc5a9a1af
tree 89f615281c88a2f541583337f1fb700a7a3c1874
parent bab7afccc8d458cc09b3a5bb4224358cbd4f188a
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:06:55 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:06:55 +0100

 net/ipv4/netfilter/ip_conntrack_core.c |    9 ++++++---
 net/ipv4/netfilter/ip_nat_core.c       |    7 ++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index d1368db..5e9caaf 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -303,6 +303,7 @@ destroy_conntrack(struct nf_conntrack *n
 	struct ip_conntrack *ct = (struct ip_conntrack *)nfct;
 	struct ip_conntrack_protocol *proto;
 	struct ip_conntrack_helper *helper;
+	typeof(ip_conntrack_destroyed) destroyed;
 
 	DEBUGP("destroy_conntrack(%p)\n", ct);
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
@@ -322,10 +323,12 @@ destroy_conntrack(struct nf_conntrack *n
 	proto = __ip_conntrack_proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
 	if (proto && proto->destroy)
 		proto->destroy(ct);
-	rcu_read_unlock();
 
-	if (ip_conntrack_destroyed)
-		ip_conntrack_destroyed(ct);
+	destroyed = rcu_dereference(ip_conntrack_destroyed);
+	if (destroyed)
+		destroyed(ct);
+
+	rcu_read_unlock();
 
 	write_lock_bh(&ip_conntrack_lock);
 	/* Expectations will have been removed in clean_from_lists,
diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
index 18daabc..40737fd 100644
--- a/net/ipv4/netfilter/ip_nat_core.c
+++ b/net/ipv4/netfilter/ip_nat_core.c
@@ -604,8 +604,8 @@ static int __init ip_nat_init(void)
 	}
 
 	/* FIXME: Man, this is a hack.  <SIGH> */
-	IP_NF_ASSERT(ip_conntrack_destroyed == NULL);
-	ip_conntrack_destroyed = &ip_nat_cleanup_conntrack;
+	IP_NF_ASSERT(rcu_dereference(ip_conntrack_destroyed) == NULL);
+	rcu_assign_pointer(ip_conntrack_destroyed, ip_nat_cleanup_conntrack);
 
 	/* Initialize fake conntrack so that NAT will skip it */
 	ip_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
@@ -623,7 +623,8 @@ static int clean_nat(struct ip_conntrack
 static void __exit ip_nat_cleanup(void)
 {
 	ip_ct_iterate_cleanup(&clean_nat, NULL);
-	ip_conntrack_destroyed = NULL;
+	rcu_assign_pointer(ip_conntrack_destroyed, NULL);
+	synchronize_rcu();
 	vfree(bysource);
 }
 
