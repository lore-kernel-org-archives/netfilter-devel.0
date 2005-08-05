From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] nf_conntrack port of conntrack-event-api
Date: Fri, 5 Aug 2005 18:48:41 +0200
Message-ID: <20050805164841.GB4929@rama.de.gnumonks.org>
References: <20050803213816.GA3819@rama.de.gnumonks.org>
	<42F13C09.6090106@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42F13C09.6090106@trash.net>
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


--O3RTKUHj+75w1tg5
Content-Type: multipart/mixed; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2005 at 11:50:01PM +0200, Patrick McHardy wrote:
> Harald Welte wrote:
> > Hi! I've just committed the following patch to the nf_conntrack branch
> > of my netfilter-2.6.14 tree:
> >=20
> > [NETFILTER] port conntrack-events from ip_conntrack to nf_conntrack
> >=20
> > This adds a notifier chain based event mechanism for nf_conntrack state
> > changes.  As opposed to the previous implementations in patch-o-matic, =
we
> > do no longer need a field in the skb to achieve this.
>=20
> The event cache also needs the fixes I sent in the "atomic counter
> underflow" thread two hours ago.

I've just committed the attached patch to netfilter-2.6.14#nf_conntrack.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nfct-underflow.patch"
Content-Transfer-Encoding: quoted-printable

[NETFILTER]: Fix multiple problems with the conntrack event cache

refcnt underflow: the reference count is decremented when a conntrack
entry is removed from the hash but it is not incremented when entering
new entries.

missing protection of process context against softirq context: all
cache operations need to locally disable softirqs to avoid races.
Additionally the event cache can't be initialized when a packet enteres
the conntrack code but needs to be initialized whenever we cache an event
and the stored conntrack entry doesn't match the current one.

incorrect flushing of the event cache in ip_ct_iterate_cleanup: without
real locking we can't flush the cache for different CPUs without incurring
races. The cache for different CPUs can only be flushed when no packets
are going through the code. ip_ct_iterate_cleanup doesn't need to drop
all references, so flushing is moved to the cleanup path.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 69d90870b705ad24bfab685fc1bb56e2e5d649be
tree 1989bcc9e353b8364155158ec02a743266ae58a8
parent de3cf64608b638e5af3f232383a6eb99f80ceed4
author Harald Welte <laforge@netfilter.org> Fr, 05 Aug 2005 18:46:16 +0200
committer Harald Welte <laforge@netfilter.org> Fr, 05 Aug 2005 18:46:16 +02=
00

 include/linux/netfilter/nf_conntrack.h         |   26 +++---
 include/linux/netfilter/nf_conntrack_core.h    |   14 +--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2=20
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2=20
 net/netfilter/nf_conntrack_core.c              |  106 +++++++++-----------=
----
 net/netfilter/nf_conntrack_standalone.c        |    4 -
 6 files changed, 58 insertions(+), 96 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack.h b/include/linux/netfilt=
er/nf_conntrack.h
--- a/include/linux/netfilter/nf_conntrack.h
+++ b/include/linux/netfilter/nf_conntrack.h
@@ -228,6 +228,7 @@ extern unsigned int nf_conntrack_htable_
=20
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 #include <linux/notifier.h>
+#include <linux/interrupt.h>
=20
 struct nf_conntrack_ecache {
 	struct nf_conn *ct;
@@ -262,26 +263,24 @@ nf_conntrack_expect_unregister_notifier(
 	return notifier_chain_unregister(&nf_conntrack_expect_chain, nb);
 }
=20
+extern void nf_ct_deliver_cached_events(const struct nf_conn *ct);
+extern void __nf_ct_event_cache_init(struct nf_conn *ct);
+
 static inline void
 nf_conntrack_event_cache(enum ip_conntrack_events event,
 			 const struct sk_buff *skb)
 {
-	struct nf_conntrack_ecache *ecache =3D
-					&__get_cpu_var(nf_conntrack_ecache);
+	struct nf_conn *ct =3D (struct nf_conn *)skb->nfct;
+	struct nf_conntrack_ecache *ecache;
=20
-	if (unlikely((struct nf_conn *) skb->nfct !=3D ecache->ct)) {
-		if (net_ratelimit()) {
-			printk(KERN_ERR "ctevent: skb->ct !=3D ecache->ct !!!\n");
-			dump_stack();
-		}
-	}
+	local_bh_disable();
+	ecache =3D &__get_cpu_var(nf_conntrack_ecache);
+	if (ct !=3D ecache->ct)
+		__nf_ct_event_cache_init(ct);
 	ecache->events |=3D event;
+	local_bh_enable();
 }
=20
-extern void
-nf_conntrack_deliver_cached_events_for(const struct nf_conn *ct);
-extern void nf_conntrack_event_cache_init(const struct sk_buff *skb);
-
 static inline void nf_conntrack_event(enum ip_conntrack_events event,
 				      struct nf_conn *ct)
 {
@@ -300,8 +299,7 @@ static inline void nf_conntrack_event_ca
 					    const struct sk_buff *skb) {}
 static inline void nf_conntrack_event(enum ip_conntrack_events event,
 				      struct nf_conn *ct) {}
-static inline void nf_conntrack_deliver_cached_events_for(struct nf_conn *=
ct) {}
-static inline void nf_conntrack_event_cache_init(const struct sk_buff *skb=
) {}
+static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct) {}
 static inline void
 nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
 			  struct nf_conntrack_expect *exp) {}
diff --git a/include/linux/netfilter/nf_conntrack_core.h b/include/linux/ne=
tfilter/nf_conntrack_core.h
--- a/include/linux/netfilter/nf_conntrack_core.h
+++ b/include/linux/netfilter/nf_conntrack_core.h
@@ -60,18 +60,14 @@ static inline int nf_conntrack_confirm(s
 	struct nf_conn *ct =3D (struct nf_conn *)(*pskb)->nfct;
 	int ret =3D NF_ACCEPT;
=20
-	if (ct && !nf_ct_is_confirmed(ct))
-		ret =3D __nf_conntrack_confirm(pskb);
-	nf_conntrack_deliver_cached_events_for(ct);
-
+	if (ct) {
+		if (!nf_ct_is_confirmed(ct))
+			ret =3D __nf_conntrack_confirm(pskb);
+		nf_ct_deliver_cached_events(ct);
+	}
 	return ret;
 }
=20
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-struct nf_conntrack_ecache;
-extern void __nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ec);
-#endif
-
 extern void __nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *sk=
b);
=20
 extern struct list_head *nf_conntrack_hash;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netf=
ilter/nf_conntrack_l3proto_ipv4.c
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -129,7 +129,6 @@ static unsigned int ipv4_confirm(unsigne
 				 const struct net_device *out,
 				 int (*okfn)(struct sk_buff *))
 {
-	nf_conntrack_event_cache_init(*pskb);
 	/* We've seen it coming out the other side: confirm it */
 	return nf_conntrack_confirm(pskb);
 }
@@ -147,7 +146,6 @@ static unsigned int ipv4_conntrack_help(
 	ct =3D nf_ct_get(*pskb, &ctinfo);
 	if (ct && ct->helper) {
 		unsigned int ret;
-		nf_conntrack_event_cache_init(*pskb);
 		ret =3D ct->helper->help(pskb,
 				       (*pskb)->nh.raw - (*pskb)->data
 						       + (*pskb)->nh.iph->ihl*4,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netf=
ilter/nf_conntrack_l3proto_ipv6.c
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -182,8 +182,6 @@ static unsigned int ipv6_confirm(unsigne
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
=20
-	nf_conntrack_event_cache_init(*pskb);
-
 	/* This is where we call the helper: as the packet goes out. */
 	ct =3D nf_ct_get(*pskb, &ctinfo);
 	if (ct && ct->helper) {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack=
_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -88,75 +88,65 @@ struct notifier_block *nf_conntrack_expe
=20
 DEFINE_PER_CPU(struct nf_conntrack_ecache, nf_conntrack_ecache);
=20
-static inline void __deliver_cached_events(struct nf_conntrack_ecache *eca=
che)
+/* deliver cached events and clear cache entry - must be called with local=
ly
+ * disabled softirqs */
+static inline void
+__nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
 {
+	DEBUGP("ecache: delivering events for %p\n", ecache->ct);
 	if (nf_ct_is_confirmed(ecache->ct) && !nf_ct_is_dying(ecache->ct)
 	    && ecache->events)
 		notifier_call_chain(&nf_conntrack_chain, ecache->events,
 				    ecache->ct);
=20
 	ecache->events =3D 0;
-}
-
-void __nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
-{
-	__deliver_cached_events(ecache);
+	nf_ct_put(ecache->ct);
+	ecache->ct =3D NULL;
 }
=20
 /* Deliver all cached events for a particular conntrack. This is called
  * by code prior to async packet handling for freeing the skb */
-void
-nf_conntrack_deliver_cached_events_for(const struct nf_conn *ct)
+void nf_ct_deliver_cached_events(const struct nf_conn *ct)
 {
-	struct nf_conntrack_ecache *ecache =3D
-					&__get_cpu_var(nf_conntrack_ecache);
-
-	if (!ct)
-		return;
-
-	if (ecache->ct =3D=3D ct) {
-		DEBUGP("ecache: delivering event for %p\n", ct);
-		__deliver_cached_events(ecache);
-	} else {
-		if (net_ratelimit())
-			printk(KERN_WARNING "ecache: want to deliver for %p, "
-				"but cache has %p\n", ct, ecache->ct);
-	}
+	struct nf_conntrack_ecache *ecache;
=20
-	/* signalize that events have already been delviered */
-	ecache->ct =3D NULL;
+	local_bh_disable();
+	ecache =3D &__get_cpu_var(nf_conntrack_ecache);
+	if (ecache->ct =3D=3D ct)
+		__nf_ct_deliver_cached_events(ecache);
+	local_bh_enable();
 }
=20
 /* Deliver cached events for old pending events, if current conntrack !=3D=
 old */
-void nf_conntrack_event_cache_init(const struct sk_buff *skb)
+void __nf_ct_event_cache_init(struct nf_conn *ct)
 {
-	struct nf_conn *ct =3D (struct nf_conn *) skb->nfct;
-	struct nf_conntrack_ecache *ecache =3D
-					&__get_cpu_var(nf_conntrack_ecache);
-
+	struct nf_conntrack_ecache *ecache;
+=09
 	/* take care of delivering potentially old events */
-	if (ecache->ct !=3D ct) {
-		enum ip_conntrack_info ctinfo;
-		/* we have to check, since at startup the cache is NULL */
-		if (likely(ecache->ct)) {
-			DEBUGP("ecache: entered for different conntrack: "
-			       "ecache->ct=3D%p, skb->nfct=3D%p. delivering "
-			       "events\n", ecache->ct, ct);
-			__deliver_cached_events(ecache);
+	ecache =3D &__get_cpu_var(nf_conntrack_ecache);
+	BUG_ON(ecache->ct =3D=3D ct);
+	if (ecache->ct)
+		__nf_ct_deliver_cached_events(ecache);
+	/* initialize for this conntrack/packet */
+	ecache->ct =3D ct;
+	nf_conntrack_get(&ct->ct_general);
+}
+
+/* flush the event cache - touches other CPU's data and must not be called
+ * while packets are still passing through the code */
+static void nf_ct_event_cache_flush(void)
+{
+	struct nf_conntrack_ecache *ecache;
+	int cpu;
+
+	for_each_cpu(cpu) {
+		ecache =3D &per_cpu(nf_conntrack_ecache, cpu);
+		if (ecache->ct)
 			nf_ct_put(ecache->ct);
-		} else {
-			DEBUGP("ecache: entered for conntrack %p, "
-			       "cache was clean before\n", ct);
-		}
-	=09
-		/* initialize for this conntrack/packet */
-		ecache->ct =3D nf_ct_get(skb, &ctinfo);
-		/* ecache->events cleared by __deliver_cached_events() */
-	} else {
-		DEBUGP("ecache: re-entered for conntrack %p.\n", ct);
 	}
 }
-
+#else
+static inline void nf_ct_event_cache_flush(void) {}
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
=20
 DEFINE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
@@ -981,8 +971,6 @@ nf_conntrack_in(int pf, unsigned int hoo
=20
 	NF_CT_ASSERT((*pskb)->nfct);
=20
-	nf_conntrack_event_cache_init(*pskb);
-
 	ret =3D proto->packet(ct, *pskb, dataoff, ctinfo, pf, hooknum);
 	if (ret < 0) {
 		/* Invalid: inverse of the return code tells
@@ -1345,23 +1333,6 @@ nf_ct_iterate_cleanup(int (*iter)(struct
=20
 		nf_ct_put(ct);
 	}
-
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	{
-		/* we need to deliver all cached events in order to drop
-		 * the reference counts */
-		int cpu;
-		for_each_cpu(cpu) {
-			struct nf_conntrack_ecache *ecache =3D
-					&per_cpu(nf_conntrack_ecache, cpu);
-			if (ecache->ct) {
-				__nf_ct_deliver_cached_events(ecache);
-				nf_ct_put(ecache->ct);
-				ecache->ct =3D NULL;
-			}
-		}
-	}
-#endif
 }
=20
 static int kill_all(struct nf_conn *i, void *data)
@@ -1390,6 +1361,7 @@ void nf_conntrack_cleanup(void)
 	   delete... */
 	synchronize_net();
=20
+	nf_ct_event_cache_flush();
  i_see_dead_people:
 	nf_ct_iterate_cleanup(kill_all, NULL);
 	if (atomic_read(&nf_conntrack_count) !=3D 0) {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_con=
ntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -830,9 +830,9 @@ EXPORT_SYMBOL_GPL(nf_conntrack_chain);
 EXPORT_SYMBOL_GPL(nf_conntrack_expect_chain);
 EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
 EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
+EXPORT_SYMBOL_GPL(__nf_ct_event_cache_init);
 EXPORT_PER_CPU_SYMBOL_GPL(nf_conntrack_ecache);
-EXPORT_SYMBOL_GPL(nf_conntrack_event_cache_init);
-EXPORT_SYMBOL_GPL(nf_conntrack_deliver_cached_events_for);
+EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 #endif
 EXPORT_SYMBOL(nf_conntrack_l3proto_register);
 EXPORT_SYMBOL(nf_conntrack_l3proto_unregister);

--WYTEVAkct0FjGQmd--

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC85hpXaXGVTD0i/8RAlI3AKCJZFP9cYGUt5dFsjn3N6tnmNRVUwCfUrK5
Ch5IJmJY/zZXnFkfb4taNQs=
=n0ks
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
