From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3][CONNTRACK] Fix race condition in early drop #2
Date: Fri, 25 Aug 2006 00:57:57 +0200
Message-ID: <44EE2EF5.90006@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050206050005080007030305"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------050206050005080007030305
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch follows from:
http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3722

I have rework the patch based on Yasuyuki's and Patrick's comments.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------050206050005080007030305
Content-Type: text/plain;
 name="09race-earlydrop.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09race-earlydrop.patch"

CONNTRACK] Fix race condition in early drop

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

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c	2006-08-24 16:45:25.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2006-08-24 16:47:51.000000000 +0200
@@ -641,11 +641,15 @@ struct ip_conntrack *ip_conntrack_alloc(
 		ip_conntrack_hash_rnd_initted = 1;
 	}
 
+	/* We don't want any race condition at early drop stage */
+	atomic_inc(&ip_conntrack_count);
+
 	if (ip_conntrack_max
 	    && atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
 		unsigned int hash = hash_conntrack(orig);
 		/* Try dropping from this hash chain. */
 		if (!early_drop(&ip_conntrack_hash[hash])) {
+			atomic_dec(&ip_conntrack_count);
 			if (net_ratelimit())
 				printk(KERN_WARNING
 				       "ip_conntrack: table full, dropping"
@@ -657,6 +661,7 @@ struct ip_conntrack *ip_conntrack_alloc(
 	conntrack = kmem_cache_alloc(ip_conntrack_cachep, GFP_ATOMIC);
 	if (!conntrack) {
 		DEBUGP("Can't allocate conntrack.\n");
+		atomic_dec(&ip_conntrack_count);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -670,8 +675,6 @@ struct ip_conntrack *ip_conntrack_alloc(
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
-	atomic_inc(&ip_conntrack_count);
-
 	return conntrack;
 }
 
Index: net-2.6/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_core.c	2006-08-24 16:50:51.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_core.c	2006-08-24 16:54:20.000000000 +0200
@@ -867,11 +867,15 @@ __nf_conntrack_alloc(const struct nf_con
 		nf_conntrack_hash_rnd_initted = 1;
 	}
 
+	/* We don't want any race condition at early drop stage */
+	atomic_inc(&nf_conntrack_count);
+
 	if (nf_conntrack_max
 	    && atomic_read(&nf_conntrack_count) >= nf_conntrack_max) {
 		unsigned int hash = hash_conntrack(orig);
 		/* Try dropping from this hash chain. */
 		if (!early_drop(&nf_conntrack_hash[hash])) {
+			atomic_dec(&nf_conntrack_count);
 			if (net_ratelimit())
 				printk(KERN_WARNING
 				       "nf_conntrack: table full, dropping"
@@ -922,10 +926,12 @@ __nf_conntrack_alloc(const struct nf_con
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
 

--------------050206050005080007030305--
