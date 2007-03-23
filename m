From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2]: conntrack: kill destroy() in struct nf_conntrack
 for diet
Date: Fri, 23 Mar 2007 14:59:01 +0100
Message-ID: <4603DD25.7070306@trash.net>
References: <200703200607.l2K67Piq025156@toshiba.co.jp>
	<45FF807C.3020801@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010007090903010001000003"
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FF807C.3020801@trash.net>
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
--------------010007090903010001000003
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Yasuyuki KOZAKAI wrote:
> 
>> #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
>>-static inline void nf_conntrack_put(struct nf_conntrack *nfct)
>>-{
>>-	if (nfct && atomic_dec_and_test(&nfct->use))
>>-		nfct->destroy(nfct);
>>-}
> 
> 
> 
> Also applied. I wonder whether we should keep this inline and
> just have the final destruction be performed out of line, its
> called in a few quite performance critical paths.


I've changed your patch so nf_conntrack_put is still an inline
function and just the destruction is out-of-line.



--------------010007090903010001000003
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nf_conntrack: kill destroy() in struct nf_conntrack for diet

The destructor per conntrack is unnecessary, then this replaces it with
system wide destructor.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3435a23f0ddf1b795860e4cf03ce50a9092d34e7
tree 1246d9a480c0e15884fd43a664fe478afb5ee5f1
parent 91dab4ecb495f0988cc36adee4674d7ea087fbc4
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 22 Mar 2007 23:03:28 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 14:57:19 +0100

 include/linux/netfilter.h         |    1 +
 include/linux/skbuff.h            |    4 ++--
 net/netfilter/core.c              |   17 ++++++++++++++++-
 net/netfilter/nf_conntrack_core.c |    4 +++-
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 4777f1b..10b5c62 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -393,6 +393,7 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, int family) {}
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 extern void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
 extern void nf_ct_attach(struct sk_buff *, struct sk_buff *);
+extern void (*nf_ct_destroy)(struct nf_conntrack *);
 #else
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4a1ffa4..630443a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -91,7 +91,6 @@ struct net_device;
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 struct nf_conntrack {
 	atomic_t use;
-	void (*destroy)(struct nf_conntrack *);
 };
 #endif
 
@@ -1554,10 +1553,11 @@ static inline unsigned int skb_checksum_complete(struct sk_buff *skb)
 }
 
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+extern void nf_conntrack_destroy(struct nf_conntrack *nfct);
 static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
 	if (nfct && atomic_dec_and_test(&nfct->use))
-		nfct->destroy(nfct);
+		nf_conntrack_destroy(nfct);
 }
 static inline void nf_conntrack_get(struct nf_conntrack *nfct)
 {
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index fe5f22d..a84478e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -260,7 +260,22 @@ void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb)
 	}
 }
 EXPORT_SYMBOL(nf_ct_attach);
-#endif
+
+void (*nf_ct_destroy)(struct nf_conntrack *);
+EXPORT_SYMBOL(nf_ct_destroy);
+
+void nf_conntrack_destroy(struct nf_conntrack *nfct)
+{
+	void (*destroy)(struct nf_conntrack *);
+
+	rcu_read_lock();
+	destroy = rcu_dereference(nf_ct_destroy);
+	BUG_ON(destroy == NULL);
+	destroy(nfct);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(nf_conntrack_destroy);
+#endif /* CONFIG_NF_CONNTRACK */
 
 #ifdef CONFIG_PROC_FS
 struct proc_dir_entry *proc_net_netfilter;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 6f2aac1..e132c8a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -616,7 +616,6 @@ __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 	memset(conntrack, 0, nf_ct_cache[features].size);
 	conntrack->features = features;
 	atomic_set(&conntrack->ct_general.use, 1);
-	conntrack->ct_general.destroy = destroy_conntrack;
 	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *repl;
 	/* Don't set timer yet: wait for confirmation */
@@ -1122,6 +1121,8 @@ void nf_conntrack_cleanup(void)
 	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
 		schedule();
 
+	rcu_assign_pointer(nf_ct_destroy, NULL);
+
 	for (i = 0; i < NF_CT_F_NUM; i++) {
 		if (nf_ct_cache[i].use == 0)
 			continue;
@@ -1259,6 +1260,7 @@ int __init nf_conntrack_init(void)
 
 	/* For use by REJECT target */
 	rcu_assign_pointer(ip_ct_attach, __nf_conntrack_attach);
+	rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
 
 	/* Set up fake conntrack:
 	    - to never be deleted, not in any hashes */

--------------010007090903010001000003--
