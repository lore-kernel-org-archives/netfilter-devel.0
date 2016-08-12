From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next V2] netfilter: conntrack: simplify the code by
 using nf_conntrack_get_ht
Date: Fri, 12 Aug 2016 13:49:39 +0200
Message-ID: <20160812114939.GA3794@salvia>
References: <1469878973-15201-1-git-send-email-zlpnobody@163.com>
 <20160812103442.GA3484@salvia>
 <CAML_gOf4_Gc-KzdGmakdtg+2a3EvRbdpcf=r=Z2GhpFGwocEuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Cc: Liping Zhang <zlpnobody@163.com>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48866 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbcHLLtp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 07:49:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 42A30D1640
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 13:49:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 344A61B3358
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 13:49:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7DBEF1B3346
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 13:49:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOf4_Gc-KzdGmakdtg+2a3EvRbdpcf=r=Z2GhpFGwocEuQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 12, 2016 at 07:12:32PM +0800, Liping Zhang wrote:
> 2016-08-12 18:34 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
> >
> > I think it is a good time to kill compat /proc/net/ip_conntrack*. That
> > has been there for so long already. So we can inline this function,
> > this is the only one that needs it to export it, right?
> 
> If just for the purpose of using nf_conntrack_get_ht to simply the source code,
> I'm not sure is it worth to delete the compat /proc/net/ip_conntrack*?
> 
> So I'm inclined to keep the original source codes unchanged :)

Just sent a patch to kill that compat code. It is also missing new
supported layer 4 protocols, as well as IPv6. We have too many
interfaces already, actually I'd be happy to kill nf_conntrack sysctl
entries at some point and leave just the ctnetlink interface.

I'm attaching an incomplete patch that moves nf_conntrack_get_ht() as
inline. It applies on top of:

        http://patchwork.ozlabs.org/patch/658620/

Feel free to take it over and finish it. Thanks.

--mYCpIKhGyMATD0i+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

commit 4e3a8f9347923d39392660c150068e1b8f937dfe
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Fri Aug 12 13:20:56 2016 +0200

    x
    
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 445b019..a817575 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -303,9 +303,29 @@ struct kernel_param;
 
 int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp);
 int nf_conntrack_hash_resize(unsigned int hashsize);
+
+extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
+extern seqcount_t nf_conntrack_generation;
 extern unsigned int nf_conntrack_max;
 
+/* must be called with rcu read lock held. */
+static inline void nf_conntrack_get_ht(struct hlist_nulls_head **hash,
+                                       unsigned int *hsize)
+{
+	struct hlist_nulls_head *hptr;
+	unsigned int sequence, hsz;
+
+	do {
+		sequence = read_seqcount_begin(&nf_conntrack_generation);
+		hsz = nf_conntrack_htable_size;
+		hptr = nf_conntrack_hash;
+	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
+
+	*hash = hptr;
+	*hsize = hsz;
+}
+
 struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 				 const struct nf_conntrack_zone *zone,
 				 gfp_t flags);
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 79d7ac5..23db857 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -83,7 +83,6 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 
 #define CONNTRACK_LOCKS 1024
 
-extern struct hlist_nulls_head *nf_conntrack_hash;
 extern spinlock_t nf_conntrack_locks[CONNTRACK_LOCKS];
 void nf_conntrack_lock(spinlock_t *lock);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 22558b7..497d037 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -74,7 +74,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
 static __read_mostly spinlock_t nf_conntrack_locks_all_lock;
-static __read_mostly seqcount_t nf_conntrack_generation;
 static __read_mostly DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
@@ -162,6 +161,7 @@ static void nf_conntrack_all_unlock(void)
 
 unsigned int nf_conntrack_htable_size __read_mostly;
 unsigned int nf_conntrack_max __read_mostly;
+seqcount_t nf_conntrack_generation __read_mostly;
 
 DEFINE_PER_CPU(struct nf_conn, nf_conntrack_untracked);
 EXPORT_PER_CPU_SYMBOL(nf_conntrack_untracked);
@@ -478,23 +478,6 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
 	       net_eq(net, nf_ct_net(ct));
 }
 
-/* must be called with rcu read lock held */
-void nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize)
-{
-	struct hlist_nulls_head *hptr;
-	unsigned int sequence, hsz;
-
-	do {
-		sequence = read_seqcount_begin(&nf_conntrack_generation);
-		hsz = nf_conntrack_htable_size;
-		hptr = nf_conntrack_hash;
-	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
-
-	*hash = hptr;
-	*hsize = hsz;
-}
-EXPORT_SYMBOL_GPL(nf_conntrack_get_ht);
-
 /*
  * Warning :
  * - Caller must take a reference on returned object

--mYCpIKhGyMATD0i+--
