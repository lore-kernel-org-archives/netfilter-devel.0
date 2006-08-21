From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3][CONNTRACK] Fix race condition in early drop
Date: Mon, 21 Aug 2006 10:47:49 +0200
Message-ID: <44E97335.1080105@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060509000403030206010304"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------060509000403030206010304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

[CONNTRACK] Fix race condition in early drop

On SMP environments the maximum number of conntracks can be overpassed 
under heavy stress situations due to an existing race condition.

        CPU A                   CPU B
     atomic_read()               ...
     early_drop()                ...
        ...                  atomic_read()
   allocate conntrack      allocate conntrack
     atomic_inc()             atomic_inc()

This patch uses an optimistic approach to solve the concurrency problem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------060509000403030206010304
Content-Type: text/plain;
 name="09race.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09race.patch"

[CONNTRACK] Fix race condition in early drop

On SMP environments the maximum number of conntracks can be overpassed
under heavy stress situations due to an existing race condition.

       CPU A                   CPU B
    atomic_read()               ...
    early_drop()                ...
       ...                  atomic_read()
  allocate conntrack      allocate conntrack
    atomic_inc()             atomic_inc()

This patch uses an optimistic approach to solve the concurrency problem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c	2006-08-17 15:50:33.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2006-08-17 17:52:27.000000000 +0200
@@ -642,21 +642,32 @@ struct ip_conntrack *ip_conntrack_alloc(
 	}
 
 	if (ip_conntrack_max
-	    && atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
+	    && !atomic_add_unless(&ip_conntrack_count, 1, ip_conntrack_max)) {
 		unsigned int hash = hash_conntrack(orig);
 		/* Try dropping from this hash chain. */
-		if (!early_drop(&ip_conntrack_hash[hash])) {
-			if (net_ratelimit())
-				printk(KERN_WARNING
-				       "ip_conntrack: table full, dropping"
-				       " packet.\n");
-			return ERR_PTR(-ENOMEM);
-		}
+		do {
+			if (!early_drop(&ip_conntrack_hash[hash])) {
+				if (net_ratelimit())
+					printk(KERN_WARNING
+					       "ip_conntrack: table full, "
+					       "dropping packet.\n");
+				return ERR_PTR(-ENOMEM);
+			}
+			/*
+			 * On SMP environments, if the table is full and we
+			 * early drop a conntrack to make some place for this
+			 * new one then we have to ensure that no other
+			 * conntrack slips through.
+			 */
+		} while (!atomic_add_unless(&ip_conntrack_count, 
+					    1, 
+					    ip_conntrack_max));
 	}
 
 	conntrack = kmem_cache_alloc(ip_conntrack_cachep, GFP_ATOMIC);
 	if (!conntrack) {
 		DEBUGP("Can't allocate conntrack.\n");
+		atomic_dec(&ip_conntrack_count);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -670,8 +681,6 @@ struct ip_conntrack *ip_conntrack_alloc(
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
-	atomic_inc(&ip_conntrack_count);
-
 	return conntrack;
 }
 
Index: net-2.6/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_core.c	2006-08-18 19:23:19.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_core.c	2006-08-18 20:20:08.000000000 +0200
@@ -868,16 +868,26 @@ __nf_conntrack_alloc(const struct nf_con
 	}
 
 	if (nf_conntrack_max
-	    && atomic_read(&nf_conntrack_count) >= nf_conntrack_max) {
+	    && !atomic_add_unless(&nf_conntrack_count, 1, nf_conntrack_max)) {
 		unsigned int hash = hash_conntrack(orig);
 		/* Try dropping from this hash chain. */
-		if (!early_drop(&nf_conntrack_hash[hash])) {
-			if (net_ratelimit())
-				printk(KERN_WARNING
-				       "nf_conntrack: table full, dropping"
-				       " packet.\n");
-			return ERR_PTR(-ENOMEM);
-		}
+		do {
+			if (!early_drop(&nf_conntrack_hash[hash])) {
+				if (net_ratelimit())
+					printk(KERN_WARNING
+					       "ip_conntrack: table full, "
+					       "dropping packet.\n");
+				return ERR_PTR(-ENOMEM);
+			}
+			/*
+			 * On SMP environments, if the table is full and we
+			 * early drop a conntrack to make some place for this
+			 * new one then we have to ensure that no other
+			 * conntrack slips through.
+			 */
+		} while (!atomic_add_unless(&nf_conntrack_count, 
+					    1, 
+					    nf_conntrack_max));
 	}
 
 	/*  find features needed by this conntrack. */
@@ -923,9 +933,12 @@ __nf_conntrack_alloc(const struct nf_con
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
-	atomic_inc(&nf_conntrack_count);
+	read_unlock_bh(&nf_ct_cache_lock);
+	return conntrack;
+
 out:
 	read_unlock_bh(&nf_ct_cache_lock);
+	atomic_dec(&nf_conntrack_count);
 	return conntrack;
 }
 

--------------060509000403030206010304--
