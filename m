From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] nf_conntrack port of conntrack-event-api
Date: Wed, 3 Aug 2005 23:38:16 +0200
Message-ID: <20050803213816.GA3819@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Cc: Patrick McHardy <kaber@trash.net>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi! I've just committed the following patch to the nf_conntrack branch
of my netfilter-2.6.14 tree:

[NETFILTER] port conntrack-events from ip_conntrack to nf_conntrack

This adds a notifier chain based event mechanism for nf_conntrack state
changes.  As opposed to the previous implementations in patch-o-matic, we
do no longer need a field in the skb to achieve this.

Thanks to the valuable input from Patrick McHardy and Rusty on the idea
of a per_cpu implementation.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit c911fa4cf2d2ba954eeeb81c486a3c856afd22ba
tree 6a430a735a417cf3223fc30b2493357680824ca9
parent feece338f857e94078aac5ada027ecc35d96d4d3
author Harald Welte <laforge@netfilter.org> Mi, 03 Aug 2005 22:40:10 +0200
committer Harald Welte <laforge@netfilter.org> Mi, 03 Aug 2005 22:40:10 +02=
00

 include/linux/netfilter/nf_conntrack.h         |   88 +++++++++++++++++
 include/linux/netfilter/nf_conntrack_core.h    |   17 +++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    3 +
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    1=20
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    3 +
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    1=20
 net/netfilter/Kconfig                          |   10 ++
 net/netfilter/nf_conntrack_core.c              |  123 ++++++++++++++++++++=
+++-
 net/netfilter/nf_conntrack_ftp.c               |   12 ++
 net/netfilter/nf_conntrack_proto_sctp.c        |    2=20
 net/netfilter/nf_conntrack_proto_tcp.c         |    4 +
 net/netfilter/nf_conntrack_proto_udp.c         |    3 -
 net/netfilter/nf_conntrack_standalone.c        |    9 ++
 13 files changed, 261 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack.h b/include/linux/netfilt=
er/nf_conntrack.h
--- a/include/linux/netfilter/nf_conntrack.h
+++ b/include/linux/netfilter/nf_conntrack.h
@@ -168,7 +168,7 @@ nf_conntrack_tuple_taken(const struct nf
=20
 /* Return conntrack_info and tuple hash for given skb. */
 static inline struct nf_conn *
-nf_ct_get(struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
+nf_ct_get(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
 {
 	*ctinfo =3D skb->nfctinfo;
 	return (struct nf_conn *)skb->nfct;
@@ -214,10 +214,96 @@ static inline int nf_ct_is_confirmed(str
 	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
=20
+static inline int nf_ct_is_dying(struct nf_conn *ct)
+{
+	return test_bit(IPS_DYING_BIT, &ct->status);
+}
+
 extern unsigned int nf_conntrack_htable_size;
=20
 #define NF_CT_STAT_INC(count) (__get_cpu_var(nf_conntrack_stat).count++)
=20
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+#include <linux/notifier.h>
+
+struct nf_conntrack_ecache {
+	struct nf_conn *ct;
+	unsigned int events;
+};
+DECLARE_PER_CPU(struct nf_conntrack_ecache, nf_conntrack_ecache);
+
+#define CONNTRACK_ECACHE(x)	(__get_cpu_var(nf_conntrack_ecache).x)
+
+extern struct notifier_block *nf_conntrack_chain;
+extern struct notifier_block *nf_conntrack_expect_chain;
+
+static inline int nf_conntrack_register_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_register(&nf_conntrack_chain, nb);
+}
+
+static inline int nf_conntrack_unregister_notifier(struct notifier_block *=
nb)
+{
+	return notifier_chain_unregister(&nf_conntrack_chain, nb);
+}
+
+static inline int
+nf_conntrack_expect_register_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_register(&nf_conntrack_expect_chain, nb);
+}
+
+static inline int
+nf_conntrack_expect_unregister_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_unregister(&nf_conntrack_expect_chain, nb);
+}
+
+static inline void
+nf_conntrack_event_cache(enum ip_conntrack_events event,
+			 const struct sk_buff *skb)
+{
+	struct nf_conntrack_ecache *ecache =3D
+					&__get_cpu_var(nf_conntrack_ecache);
+
+	if (unlikely((struct nf_conn *) skb->nfct !=3D ecache->ct)) {
+		if (net_ratelimit()) {
+			printk(KERN_ERR "ctevent: skb->ct !=3D ecache->ct !!!\n");
+			dump_stack();
+		}
+	}
+	ecache->events |=3D event;
+}
+
+extern void
+nf_conntrack_deliver_cached_events_for(const struct nf_conn *ct);
+extern void nf_conntrack_event_cache_init(const struct sk_buff *skb);
+
+static inline void nf_conntrack_event(enum ip_conntrack_events event,
+				      struct nf_conn *ct)
+{
+	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
+		notifier_call_chain(&nf_conntrack_chain, event, ct);
+}
+
+static inline void
+nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
+			  struct nf_conntrack_expect *exp)
+{
+	notifier_call_chain(&nf_conntrack_expect_chain, event, exp);
+}
+#else /* CONFIG_NF_CONNTRACK_EVENTS */
+static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
+					    const struct sk_buff *skb) {}
+static inline void nf_conntrack_event(enum ip_conntrack_events event,
+				      struct nf_conn *ct) {}
+static inline void nf_conntrack_deliver_cached_events_for(struct nf_conn *=
ct) {}
+static inline void nf_conntrack_event_cache_init(const struct sk_buff *skb=
) {}
+static inline void
+nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
+			  struct nf_conntrack_expect *exp) {}
+#endif /* CONFIG_NF_CONNTRACK_EVENTS */
+
 /* eg. PROVIDES_CONNTRACK(ftp); */
 #define PROVIDES_CONNTRACK(name)                        \
         int needs_nf_conntrack_##name;                  \
diff --git a/include/linux/netfilter/nf_conntrack_core.h b/include/linux/ne=
tfilter/nf_conntrack_core.h
--- a/include/linux/netfilter/nf_conntrack_core.h
+++ b/include/linux/netfilter/nf_conntrack_core.h
@@ -57,12 +57,21 @@ extern int __nf_conntrack_confirm(struct
 /* Confirm a connection: returns NF_DROP if packet must be dropped. */
 static inline int nf_conntrack_confirm(struct sk_buff **pskb)
 {
-	if ((*pskb)->nfct
-	    && !nf_ct_is_confirmed((struct nf_conn *)(*pskb)->nfct))
-		return __nf_conntrack_confirm(pskb);
-	return NF_ACCEPT;
+	struct nf_conn *ct =3D (struct nf_conn *)(*pskb)->nfct;
+	int ret =3D NF_ACCEPT;
+
+	if (ct && !nf_ct_is_confirmed(ct))
+		ret =3D __nf_conntrack_confirm(pskb);
+	nf_conntrack_deliver_cached_events_for(ct);
+
+	return ret;
 }
=20
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+struct nf_conntrack_ecache;
+extern void __nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ec);
+#endif
+
 extern void __nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *sk=
b);
=20
 extern struct list_head *nf_conntrack_hash;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netf=
ilter/nf_conntrack_l3proto_ipv4.c
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -129,6 +129,7 @@ static unsigned int ipv4_confirm(unsigne
 				 const struct net_device *out,
 				 int (*okfn)(struct sk_buff *))
 {
+	nf_conntrack_event_cache_init(*pskb);
 	/* We've seen it coming out the other side: confirm it */
 	return nf_conntrack_confirm(pskb);
 }
@@ -146,6 +147,7 @@ static unsigned int ipv4_conntrack_help(
 	ct =3D nf_ct_get(*pskb, &ctinfo);
 	if (ct && ct->helper) {
 		unsigned int ret;
+		nf_conntrack_event_cache_init(*pskb);
 		ret =3D ct->helper->help(pskb,
 				       (*pskb)->nh.raw - (*pskb)->data
 						       + (*pskb)->nh.iph->ihl*4,
@@ -506,6 +508,7 @@ static int init_or_cleanup(int init)
 	return ret;
=20
  cleanup:
+	synchronize_net();
 	ip_ct_attach =3D NULL;
 #ifdef CONFIG_SYSCTL
  	unregister_sysctl_table(nf_ct_ipv4_sysctl_header);
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfil=
ter/nf_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -109,6 +109,7 @@ static int icmp_packet(struct nf_conn *c
 			ct->timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
+		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
 		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
 	}
=20
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netf=
ilter/nf_conntrack_l3proto_ipv6.c
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -182,6 +182,8 @@ static unsigned int ipv6_confirm(unsigne
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
=20
+	nf_conntrack_event_cache_init(*pskb);
+
 	/* This is where we call the helper: as the packet goes out. */
 	ct =3D nf_ct_get(*pskb, &ctinfo);
 	if (ct && ct->helper) {
@@ -499,6 +501,7 @@ static int init_or_cleanup(int init)
 	return ret;
=20
  cleanup:
+	synchronize_net();
 #ifdef CONFIG_SYSCTL
  	unregister_sysctl_table(nf_ct_ipv6_sysctl_header);
  cleanup_localinops:
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netf=
ilter/nf_conntrack_proto_icmpv6.c
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -113,6 +113,7 @@ static int icmpv6_packet(struct nf_conn=20
 			ct->timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
+		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
 		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmpv6_timeout);
 	}
=20
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -57,6 +57,16 @@ config NF_CONNTRACK_MARK
 	  of packets, but this mark value is kept in the conntrack session
 	  instead of the individual packets.
=20
+config NF_CONNTRACK_EVENTS
+	bool "Connection tracking events"
+	depends on NF_CONNTRACK
+	help
+	  If this option is enabled, the connection tracking code will
+	  provide a notifier chain that can be used by other kernel code
+	  to get notified aboutchanges in the connection tracking state.
+
+	  If unsure, say `N'.
+
 config NF_CT_PROTO_SCTP
 	tristate 'SCTP protocol on new connection tracking support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack=
_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -38,6 +38,7 @@
 #include <linux/err.h>
 #include <linux/percpu.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/socket.h>
@@ -54,7 +55,7 @@
 #include <linux/netfilter/nf_conntrack_core.h>
 #include <linux/netfilter_ipv4/listhelp.h>
=20
-#define NF_CONNTRACK_VERSION	"0.3.1"
+#define NF_CONNTRACK_VERSION	"0.4.1"
=20
 #if 0
 #define DEBUGP printk
@@ -81,6 +82,83 @@ unsigned int nf_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc;
=20
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+struct notifier_block *nf_conntrack_chain;
+struct notifier_block *nf_conntrack_expect_chain;
+
+DEFINE_PER_CPU(struct nf_conntrack_ecache, nf_conntrack_ecache);
+
+static inline void __deliver_cached_events(struct nf_conntrack_ecache *eca=
che)
+{
+	if (nf_ct_is_confirmed(ecache->ct) && !nf_ct_is_dying(ecache->ct)
+	    && ecache->events)
+		notifier_call_chain(&nf_conntrack_chain, ecache->events,
+				    ecache->ct);
+
+	ecache->events =3D 0;
+}
+
+void __nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
+{
+	__deliver_cached_events(ecache);
+}
+
+/* Deliver all cached events for a particular conntrack. This is called
+ * by code prior to async packet handling for freeing the skb */
+void
+nf_conntrack_deliver_cached_events_for(const struct nf_conn *ct)
+{
+	struct nf_conntrack_ecache *ecache =3D
+					&__get_cpu_var(nf_conntrack_ecache);
+
+	if (!ct)
+		return;
+
+	if (ecache->ct =3D=3D ct) {
+		DEBUGP("ecache: delivering event for %p\n", ct);
+		__deliver_cached_events(ecache);
+	} else {
+		if (net_ratelimit())
+			printk(KERN_WARNING "ecache: want to deliver for %p, "
+				"but cache has %p\n", ct, ecache->ct);
+	}
+
+	/* signalize that events have already been delviered */
+	ecache->ct =3D NULL;
+}
+
+/* Deliver cached events for old pending events, if current conntrack !=3D=
 old */
+void nf_conntrack_event_cache_init(const struct sk_buff *skb)
+{
+	struct nf_conn *ct =3D (struct nf_conn *) skb->nfct;
+	struct nf_conntrack_ecache *ecache =3D
+					&__get_cpu_var(nf_conntrack_ecache);
+
+	/* take care of delivering potentially old events */
+	if (ecache->ct !=3D ct) {
+		enum ip_conntrack_info ctinfo;
+		/* we have to check, since at startup the cache is NULL */
+		if (likely(ecache->ct)) {
+			DEBUGP("ecache: entered for different conntrack: "
+			       "ecache->ct=3D%p, skb->nfct=3D%p. delivering "
+			       "events\n", ecache->ct, ct);
+			__deliver_cached_events(ecache);
+			nf_ct_put(ecache->ct);
+		} else {
+			DEBUGP("ecache: entered for conntrack %p, "
+			       "cache was clean before\n", ct);
+		}
+	=09
+		/* initialize for this conntrack/packet */
+		ecache->ct =3D nf_ct_get(skb, &ctinfo);
+		/* ecache->events cleared by __deliver_cached_events() */
+	} else {
+		DEBUGP("ecache: re-entered for conntrack %p.\n", ct);
+	}
+}
+
+#endif /* CONFIG_NF_CONNTRACK_EVENTS */
+
 DEFINE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 EXPORT_PER_CPU_SYMBOL(nf_conntrack_stat);
=20
@@ -457,6 +535,8 @@ destroy_conntrack(struct nf_conntrack *n
 	NF_CT_ASSERT(atomic_read(&nfct->use) =3D=3D 0);
 	NF_CT_ASSERT(!timer_pending(&ct->timeout));
=20
+	set_bit(IPS_DYING_BIT, &ct->status);
+
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
@@ -500,6 +580,7 @@ static void death_by_timeout(unsigned lo
 {
 	struct nf_conn *ct =3D (void *)ul_conntrack;
=20
+	nf_conntrack_event(IPCT_DESTROY, ct);
 	write_lock_bh(&nf_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */
@@ -613,6 +694,15 @@ __nf_conntrack_confirm(struct sk_buff **
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		NF_CT_STAT_INC(insert);
 		write_unlock_bh(&nf_conntrack_lock);
+		if (ct->helper)
+			nf_conntrack_event_cache(IPCT_HELPER, *pskb);
+#ifdef CONFIG_NF_NAT_NEEDED
+		if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status) ||
+		    test_bit(IPS_DST_NAT_DONE_BIT, &ct->status))
+			nf_conntrack_event_cache(IPCT_NATINFO, *pskb);
+#endif
+		nf_conntrack_event_cache(master_ct(ct) ?
+					 IPCT_RELATED : IPCT_NEW, *pskb);
 		return NF_ACCEPT;
 	}
=20
@@ -855,7 +945,7 @@ nf_conntrack_in(int pf, unsigned int hoo
 	struct nf_conntrack_protocol *proto;
 	unsigned int dataoff;
 	u_int8_t protonum;
-	int set_reply;
+	int set_reply =3D 0;
 	int ret;
=20
 	/* Previously seen (loopback or untracked)?  Ignore. */
@@ -898,6 +988,8 @@ nf_conntrack_in(int pf, unsigned int hoo
=20
 	NF_CT_ASSERT((*pskb)->nfct);
=20
+	nf_conntrack_event_cache_init(*pskb);
+
 	ret =3D proto->packet(ct, *pskb, dataoff, ctinfo, pf, hooknum);
 	if (ret < 0) {
 		/* Invalid: inverse of the return code tells
@@ -909,8 +1001,8 @@ nf_conntrack_in(int pf, unsigned int hoo
 		return -ret;
 	}
=20
-	if (set_reply)
-		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+	if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
+		nf_conntrack_event_cache(IPCT_STATUS, *pskb);
=20
 	return ret;
 }
@@ -1067,6 +1159,7 @@ int nf_conntrack_expect_related(struct n
 		evict_oldest_expect(expect->master);
=20
 	nf_conntrack_expect_insert(expect);
+	nf_conntrack_expect_event(IPEXP_NEW, expect);
 	ret =3D 0;
 out:
 	write_unlock_bh(&nf_conntrack_lock);
@@ -1115,8 +1208,10 @@ int nf_conntrack_helper_register(struct=20
 static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 			 const struct nf_conntrack_helper *me)
 {
-	if (nf_ct_tuplehash_to_ctrack(i)->helper =3D=3D me)
+	if (nf_ct_tuplehash_to_ctrack(i)->helper =3D=3D me) {
+		nf_conntrack_event(IPCT_HELPER, nf_ct_tuplehash_to_ctrack(i));
 		nf_ct_tuplehash_to_ctrack(i)->helper =3D NULL;
+	}
 	return 0;
 }
=20
@@ -1181,6 +1276,7 @@ void nf_ct_refresh_acct(struct nf_conn *
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires =3D jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
+			nf_conntrack_event_cache(IPCT_REFRESH, skb);
 		}
 		ct_add_counters(ct, ctinfo, skb);
 		write_unlock_bh(&nf_conntrack_lock);
@@ -1253,6 +1349,23 @@ nf_ct_iterate_cleanup(int (*iter)(struct
=20
 		nf_ct_put(ct);
 	}
+
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	{
+		/* we need to deliver all cached events in order to drop
+		 * the reference counts */
+		int cpu;
+		for_each_cpu(cpu) {
+			struct nf_conntrack_ecache *ecache =3D
+					&per_cpu(nf_conntrack_ecache, cpu);
+			if (ecache->ct) {
+				__nf_ct_deliver_cached_events(ecache);
+				nf_ct_put(ecache->ct);
+				ecache->ct =3D NULL;
+			}
+		}
+	}
+#endif
 }
=20
 static int kill_all(struct nf_conn *i, void *data)
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_=
ftp.c
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -404,7 +404,8 @@ static int find_nl_seq(u32 seq, const st
 }
=20
 /* We don't update if it's older than what we have. */
-static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int d=
ir)
+static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int d=
ir,
+			  struct sk_buff *skb)
 {
 	unsigned int i, oldest =3D NUM_SEQ_TO_REMEMBER;
=20
@@ -418,10 +419,13 @@ static void update_nl_seq(u32 nl_seq, st
 			oldest =3D i;
 	}
=20
-	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER)
+	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] =3D nl_seq;
-	else if (oldest !=3D NUM_SEQ_TO_REMEMBER)
+		nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
+	} else if (oldest !=3D NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][oldest] =3D nl_seq;
+		nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
+	}
 }
=20
 static int help(struct sk_buff **pskb,
@@ -609,7 +613,7 @@ out_update_nl:
 	/* Now if this ends in \n, update ftp info.  Seq may have been
 	 * adjusted by NAT code. */
 	if (ends_in_nl)
-		update_nl_seq(seq, ct_ftp_info,dir);
+		update_nl_seq(seq, ct_ftp_info, dir, *pskb);
  out:
 	spin_unlock_bh(&nf_ftp_lock);
 	return ret;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_con=
ntrack_proto_sctp.c
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -412,6 +412,8 @@ static int sctp_packet(struct nf_conn *c
 		}
=20
 		conntrack->proto.sctp.state =3D newconntrack;
+		if (oldsctpstate !=3D newconntrack)
+			nf_conntrack_event_cache(IPCT_PROTOINFO, skb);
 		write_unlock_bh(&sctp_lock);
 	}
=20
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conn=
track_proto_tcp.c
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1013,6 +1013,10 @@ static int tcp_packet(struct nf_conn *co
 		  ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
 	write_unlock_bh(&tcp_lock);
=20
+	nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
+	if (new_state !=3D old_state)
+		nf_conntrack_event_cache(IPCT_PROTOINFO, skb);
+
 	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
 		/* If only reply is a RST, we can consider ourselves not to
 		   have an established connection: this is a fairly common
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conn=
track_proto_udp.c
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -83,7 +83,8 @@ static int udp_packet(struct nf_conn *co
 		nf_ct_refresh_acct(conntrack, ctinfo, skb,
 				   nf_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		if (!test_and_set_bit(IPS_ASSURED_BIT, &conntrack->status))
+			nf_conntrack_event_cache(IPCT_STATUS, skb);
 	} else
 		nf_ct_refresh_acct(conntrack, ctinfo, skb, nf_ct_udp_timeout);
=20
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_con=
ntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -825,6 +825,15 @@ void need_nf_conntrack(void)
 {
 }
=20
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+EXPORT_SYMBOL_GPL(nf_conntrack_chain);
+EXPORT_SYMBOL_GPL(nf_conntrack_expect_chain);
+EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
+EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
+EXPORT_PER_CPU_SYMBOL_GPL(nf_conntrack_ecache);
+EXPORT_SYMBOL_GPL(nf_conntrack_event_cache_init);
+EXPORT_SYMBOL_GPL(nf_conntrack_deliver_cached_events_for);
+#endif
 EXPORT_SYMBOL(nf_conntrack_l3proto_register);
 EXPORT_SYMBOL(nf_conntrack_l3proto_unregister);
 EXPORT_SYMBOL(nf_conntrack_protocol_register);
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC8TlIXaXGVTD0i/8RAgjIAJ4hjtmFtX8fNJqQZFUDtDQgHxlPOACfXQ9Z
7tr/iptzQVOdbFSdRIaSsmg=
=LvUJ
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
