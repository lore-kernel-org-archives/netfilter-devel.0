From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/39]: conntrack: fix race condition in early_drop
Date: Wed, 20 Sep 2006 10:24:05 +0200 (MEST)
Message-ID: <20060920082457.14636.39699.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: conntrack: fix race condition in early_drop

On SMP environments the maximum number of conntracks can be overpassed
under heavy stress situations due to an existing race condition.

        CPU A                   CPU B
     atomic_read()               ...
     early_drop()                ...
        ...                  atomic_read()
   allocate conntrack      allocate conntrack
     atomic_inc()             atomic_inc()

This patch moves the counter incrementation before the early drop stage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 56a0ea23e536624ad1ea186289bb5d686ca19425
tree c56f7cbb8b47d1e153440062f34f26604c250aa8
parent 2d7b5900c6ec411811c3ec01ea7caf75dc694f3e
author Pablo Neira Ayuso <pablo@netfilter.org> Wed, 20 Sep 2006 09:28:41 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:41 +0200

 net/ipv4/netfilter/ip_conntrack_core.c |    9 ++++++---
 net/netfilter/nf_conntrack_core.c      |   10 ++++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 2568d48..422a662 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -622,11 +622,15 @@ struct ip_conntrack *ip_conntrack_alloc(
 		ip_conntrack_hash_rnd_initted = 1;
 	}
 
+	/* We don't want any race condition at early drop stage */
+	atomic_inc(&ip_conntrack_count);
+
 	if (ip_conntrack_max
-	    && atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
+	    && atomic_read(&ip_conntrack_count) > ip_conntrack_max) {
 		unsigned int hash = hash_conntrack(orig);
 		/* Try dropping from this hash chain. */
 		if (!early_drop(&ip_conntrack_hash[hash])) {
+			atomic_dec(&ip_conntrack_count);
 			if (net_ratelimit())
 				printk(KERN_WARNING
 				       "ip_conntrack: table full, dropping"
@@ -638,6 +642,7 @@ struct ip_conntrack *ip_conntrack_alloc(
 	conntrack = kmem_cache_alloc(ip_conntrack_cachep, GFP_ATOMIC);
 	if (!conntrack) {
 		DEBUGP("Can't allocate conntrack.\n");
+		atomic_dec(&ip_conntrack_count);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -651,8 +656,6 @@ struct ip_conntrack *ip_conntrack_alloc(
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
-	atomic_inc(&ip_conntrack_count);
-
 	return conntrack;
 }
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 927137b..adeafa2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -848,11 +848,15 @@ __nf_conntrack_alloc(const struct nf_con
 		nf_conntrack_hash_rnd_initted = 1;
 	}
 
+	/* We don't want any race condition at early drop stage */
+	atomic_inc(&nf_conntrack_count);
+
 	if (nf_conntrack_max
-	    && atomic_read(&nf_conntrack_count) >= nf_conntrack_max) {
+	    && atomic_read(&nf_conntrack_count) > nf_conntrack_max) {
 		unsigned int hash = hash_conntrack(orig);
 		/* Try dropping from this hash chain. */
 		if (!early_drop(&nf_conntrack_hash[hash])) {
+			atomic_dec(&nf_conntrack_count);
 			if (net_ratelimit())
 				printk(KERN_WARNING
 				       "nf_conntrack: table full, dropping"
@@ -903,10 +907,12 @@ __nf_conntrack_alloc(const struct nf_con
 	init_timer(&conntrack->timeout);
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
+	read_unlock_bh(&nf_ct_cache_lock);
 
-	atomic_inc(&nf_conntrack_count);
+	return conntrack;
 out:
 	read_unlock_bh(&nf_ct_cache_lock);
+	atomic_dec(&nf_conntrack_count);
 	return conntrack;
 }
 
