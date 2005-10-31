From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [TRIVIAL PATCH] gcc4 / kill `extern inline` in nf_conntrack.h
Date: Mon, 31 Oct 2005 13:00:38 +0900 (JST)
Message-ID: <200510310400.j9V40dw3023224@toshiba.co.jp>
References: <200508011208.02830.pluto@agmk.net>
	<m2k6j341kv.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Oct_31_13_00_38_2005_933)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: sbellabes@mandriva.com
In-Reply-To: <m2k6j341kv.fsf@cerbere.dyndns.info>
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

----Next_Part(Mon_Oct_31_13_00_38_2005_933)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Samir, sorry for huge latency of replying. I found this at
patchwork.netfilter.org now.

From: Samir Bellabes <sbellabes@mandriva.com>
Date: Wed, 03 Aug 2005 15:00:48 +0200

> >  /* decrement reference count on a conntrack */
> > -extern inline void nf_ct_put(struct nf_conn *ct);
> > +extern void nf_ct_put(struct nf_conn *ct);
> >  
> >  /* call to create an explicit dependency on nf_conntrack. */
> >  extern void need_nf_conntrack(void);
> 
> Why not keeping inline attribut for nf_ct_put ?

Now there is no reason. Maybe it was restriction in old code.

Thank you for patch. but currently, the path of this header was changed to
include/net/netfilter. And I found one more 'extern inline'. Then I've written
new patch.

Harald, could you apply attached patch ?

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,

--- Yasuyuki Kozakai

----Next_Part(Mon_Oct_31_13_00_38_2005_933)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="nfct-inline.patch"

[NETFILTER] use 'static inline' in nf_conntrack

No reason to use inline function for nf_ct_put() as Samir Bellabes pointed
out. And this patch also kills 'extern inline'.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 296d553d2cf7856d37e613ab20b4290dbfe38afa
tree 0143797293aec567d1ae58731e363316feb50e86
parent fd915a969648f21b5690097f130e47826cd9fb9e
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 31 Oct 2005 00:05:39 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 31 Oct 2005 00:05:39 +0900

 include/net/netfilter/nf_conntrack.h    |    8 ++++++--
 net/netfilter/nf_conntrack_core.c       |    7 -------
 net/netfilter/nf_conntrack_standalone.c |    1 -
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -184,7 +184,11 @@ nf_ct_get(const struct sk_buff *skb, enu
 }
 
 /* decrement reference count on a conntrack */
-extern void nf_ct_put(struct nf_conn *ct);
+static inline void nf_ct_put(struct nf_conn *ct)
+{
+	NF_CT_ASSERT(ct);
+	nf_conntrack_put(&ct->ct_general);
+}
 
 /* call to create an explicit dependency on nf_conntrack. */
 extern void need_nf_conntrack(void);
@@ -208,7 +212,7 @@ static inline void nf_ct_refresh_acct(st
 }
 
 /* Refresh conntrack for this many jiffies */
-extern inline void nf_ct_refresh(struct nf_conn *ct,
+static inline void nf_ct_refresh(struct nf_conn *ct,
 				 const struct sk_buff *skb,
 				 unsigned long extra_jiffies)
 {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -192,13 +192,6 @@ nf_ct_find_proto(u_int16_t l3proto, u_in
 	return nf_ct_protos[l3proto][protocol];
 }
 
-void 
-nf_ct_put(struct nf_conn *ct)
-{
-	NF_CT_ASSERT(ct);
-	nf_conntrack_put(&ct->ct_general);
-}
-
 static int nf_conntrack_hash_rnd_initted;
 static unsigned int nf_conntrack_hash_rnd;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -859,7 +859,6 @@ EXPORT_SYMBOL(nf_conntrack_lock);
 EXPORT_SYMBOL(nf_conntrack_hash);
 EXPORT_SYMBOL(nf_conntrack_untracked);
 EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
-EXPORT_SYMBOL_GPL(nf_ct_put);
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 EXPORT_SYMBOL(nf_conntrack_tcp_update);
 #endif

----Next_Part(Mon_Oct_31_13_00_38_2005_933)----
