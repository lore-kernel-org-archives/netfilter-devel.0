From: Samir Bellabes <sbellabes@mandriva.com>
Subject: Re: [TRIVIAL PATCH] gcc4 / kill `extern inline` in nf_conntrack.h
Date: Wed, 03 Aug 2005 15:00:48 +0200
Message-ID: <m2k6j341kv.fsf@cerbere.dyndns.info>
References: <200508011208.02830.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@agmk.net>
In-Reply-To: <200508011208.02830.pluto@agmk.net> (Pawel Sikora's message of
	"Mon, 1 Aug 2005 12:08:02 +0200")
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

Pawel Sikora <pluto@agmk.net> writes:

> Index: linux-2.6/include/linux/netfilter/nf_conntrack.h
> ===================================================================
> --- linux-2.6/include/linux/netfilter/nf_conntrack.h	(revision 4208)
> +++ linux-2.6/include/linux/netfilter/nf_conntrack.h	(working copy)
> @@ -218,7 +218,7 @@
>  }
>  
>  /* decrement reference count on a conntrack */
> -extern inline void nf_ct_put(struct nf_conn *ct);
> +extern void nf_ct_put(struct nf_conn *ct);
>  
>  /* call to create an explicit dependency on nf_conntrack. */
>  extern void need_nf_conntrack(void);

Why not keeping inline attribut for nf_ct_put ?

diff --git a/include/linux/netfilter/nf_conntrack.h b/include/linux/netfilter/nf_conntrack.h
--- a/include/linux/netfilter/nf_conntrack.h
+++ b/include/linux/netfilter/nf_conntrack.h
@@ -218,7 +218,10 @@ nf_ct_get(struct sk_buff *skb, enum nf_c
 }
 
 /* decrement reference count on a conntrack */
-extern inline void nf_ct_put(struct nf_conn *ct);
+extern inline void nf_ct_put(struct nf_conn *ct) {
+       NF_CT_ASSERT(ct);
+       nf_conntrack_put(&ct->ct_general);
+};
 
 /* call to create an explicit dependency on nf_conntrack. */
 extern void need_nf_conntrack(void);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -125,13 +125,6 @@ nf_ct_find_proto(u_int16_t l3proto, u_in
        return nf_ct_protos[l3proto][protocol];
 }
 
-void 
-nf_ct_put(struct nf_conn *ct)
-{
-       NF_CT_ASSERT(ct);
-       nf_conntrack_put(&ct->ct_general);
-}
-
 static int nf_conntrack_hash_rnd_initted;
 static unsigned int nf_conntrack_hash_rnd;
