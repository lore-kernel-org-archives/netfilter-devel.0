From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/22]: Properly use RCU in nf_ct_attach
Date: Mon, 12 Feb 2007 11:36:22 +0100 (MET)
Message-ID: <20070212103622.661.45176.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Properly use RCU in nf_ct_attach

Use rcu_assign_pointer/rcu_dereference for ip_ct_attach pointer instead
of self-made RCU and use rcu_read_lock to make sure the conntrack module
doesn't disappear below us while calling it, since this function can be
called from outside the netfilter hooks.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit aa70e344f883b6fb4283024afa9af13376162ed3
tree f353ef51191c23f210f508b4edf1a7008e164e53
parent 70cdc55ed5432048c25025283f064323e3ae94f4
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:35:23 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:35:23 +0100

 net/ipv4/netfilter/ip_conntrack_core.c |    4 ++--
 net/netfilter/core.c                   |    9 ++++++---
 net/netfilter/nf_conntrack_core.c      |    4 ++--
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 2e6e421..933b878 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1355,7 +1355,7 @@ static void free_conntrack_hash(struct l
    supposed to kill the mall. */
 void ip_conntrack_cleanup(void)
 {
-	ip_ct_attach = NULL;
+	rcu_assign_pointer(ip_ct_attach, NULL);
 
 	/* This makes sure all current packets have passed through
 	   netfilter framework.  Roll on, two-stage module
@@ -1516,7 +1516,7 @@ int __init ip_conntrack_init(void)
 	write_unlock_bh(&ip_conntrack_lock);
 
 	/* For use by ipt_REJECT */
-	ip_ct_attach = ip_conntrack_attach;
+	rcu_assign_pointer(ip_ct_attach, ip_conntrack_attach);
 
 	/* Set up fake conntrack:
 	    - to never be deleted, not in any hashes */
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 291b8c6..ad24d0c 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -248,9 +248,12 @@ void nf_ct_attach(struct sk_buff *new, s
 {
 	void (*attach)(struct sk_buff *, struct sk_buff *);
 
-	if (skb->nfct && (attach = ip_ct_attach) != NULL) {
-		mb(); /* Just to be sure: must be read before executing this */
-		attach(new, skb);
+	if (skb->nfct) {
+		rcu_read_lock();
+		attach = rcu_dereference(ip_ct_attach);
+		if (attach)
+			attach(new, skb);
+		rcu_read_unlock();
 	}
 }
 EXPORT_SYMBOL(nf_ct_attach);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9b02ec4..59bcab1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1105,7 +1105,7 @@ void nf_conntrack_cleanup(void)
 {
 	int i;
 
-	ip_ct_attach = NULL;
+	rcu_assign_pointer(ip_ct_attach, NULL);
 
 	/* This makes sure all current packets have passed through
 	   netfilter framework.  Roll on, two-stage module
@@ -1273,7 +1273,7 @@ int __init nf_conntrack_init(void)
         write_unlock_bh(&nf_conntrack_lock);
 
 	/* For use by REJECT target */
-	ip_ct_attach = __nf_conntrack_attach;
+	rcu_assign_pointer(ip_ct_attach, __nf_conntrack_attach);
 
 	/* Set up fake conntrack:
 	    - to never be deleted, not in any hashes */
