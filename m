From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] connection tracking events
Date: Fri, 15 Oct 2004 19:54:06 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041015175406.GK17516@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZQs1kEQY307C4ut"
Cc: Patrick McHardy <kaber@trash.net>
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--YZQs1kEQY307C4ut
Content-Type: multipart/mixed; boundary="ofZMSlrAVk9bLeVm"
Content-Disposition: inline


--ofZMSlrAVk9bLeVm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Since we decided at the netfilter developer workshop that we want to
split conntrack events from the rest of ctnetlink, I've now done that
(and ported it to use percpu allocations).  This is needed mostly for=20
ct_sync.

Totally untested, but seems to compile.  Comments welcome.

As it is quite non-intrusive, I think we should consider it for
post-2.6.9.


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ofZMSlrAVk9bLeVm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="2.6.9-rc3-bk9-conntrack_events.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.9-rc3-bk9-test/include/linux/netfilter_ipv4/ip_c=
onntrack.h linux-2.6.9-rc3-bk9-test-ctevent/include/linux/netfilter_ipv4/ip=
_conntrack.h
--- linux-2.6.9-rc3-bk9-test/include/linux/netfilter_ipv4/ip_conntrack.h	20=
04-10-10 14:00:59.000000000 +0200
+++ linux-2.6.9-rc3-bk9-test-ctevent/include/linux/netfilter_ipv4/ip_conntr=
ack.h	2004-10-15 19:46:19.746327032 +0200
@@ -47,6 +47,10 @@
 	/* Connection is confirmed: originating packet has left box */
 	IPS_CONFIRMED_BIT =3D 3,
 	IPS_CONFIRMED =3D (1 << IPS_CONFIRMED_BIT),
+
+	/* Connection is destroyed (removed from lists), can not be unset. */
+	IPS_DESTROYED_BIT =3D 4,
+	IPS_DESTROYED =3D (1 << IPS_DESTROYED_BIT),
 };
=20
 #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
@@ -290,6 +294,12 @@
 	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
=20
+/* It is destroyed after it has been removed from hash table. */
+static inline int is_destroyed(struct ip_conntrack *ct)
+{
+	return test_bit(IPS_DESTROYED_BIT, &ct->status);
+}
+
 extern unsigned int ip_conntrack_htable_size;
 =20
 struct ip_conntrack_stat
@@ -323,5 +333,69 @@
         extern int needs_ip_conntrack_##name;                           \
         static int *need_ip_conntrack_##name __attribute_used__ =3D &needs=
_ip_conntrack_##name
=20
+enum ip_conntrack_events
+{
+	IPCT_NEW,
+	IPCT_DESTROY,
+	IPCT_STATUS,
+	IPCT_REFRESH,
+	IPCT_PROTOINFO,
+	IPCT_PROTOINFO_VOLATILE,
+	IPCT_HELPINFO,
+	IPCT_NATINFO,
+};
+
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+#include <linux/notifier.h>
+
+extern struct notifier_block *ip_conntrack_chain;
+DECLARE_PER_CPU(unsigned long, ip_conntrack_event_cache);
+
+/* register notifier for conntrack events */
+static inline int ip_conntrack_notify_register(struct notifier_block *nb)
+{
+	return notifier_chain_register(&ip_conntrack_chain, nb);
+}
+
+static inline int ip_conntrack_notify_unregister(struct notifier_block *nb)
+{
+	return notifier_chain_unregister(&ip_conntrack_chain, nb);
+}
+
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+				      struct ip_conntrack *ct)
+{
+	if (is_confirmed(ct) && !is_destroyed(ct))
+		notifier_call_chain(&ip_conntrack_chain, 1 << event, ct);
+}
+
+static inline void ip_conntrack_event_cache_init(void)
+{
+	*per_cpu_ptr(ip_conntrack_event_cache, smp_processor_id()) =3D 0UL;
+}
+
+static inline void ip_conntrack_cache_event(void)
+{
+	*per_cpu_ptr(ip_conntrack_event_cache, smp_processor_id()) |=3D 1<<event;
+}
+
+static inline void ip_conntrack_do_cached_events(struct ip_conntrack *ct)
+{
+	unsigned long events =3D *per_cpu_ptr(ip_conntrack_event_cache,
+					    smp_processor_id());
+
+	if (is_confirmed(ct) && !is_destroyed(ct) && events)
+		notifier_call_chain(&ip_conntrack_chain, events, ct);
+}
+#else /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+static inline int ip_conntrack_notify_register(void *nb) { return 0; }
+static inline int ip_conntrack_notify_unregister(void *nb) { return 0; }
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+				      struct ip_conntrack *ct) {}
+static inline void ip_conntrack_event_cache_init(void) {}
+static inline void ip_conntrack_cache_event(enum ip_conntrack_events event=
) {}
+static inline void ip_conntrack_do_cached_events(struct ip_conntrack *ct) =
{}
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+
 #endif /* __KERNEL__ */
 #endif /* _IP_CONNTRACK_H */
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/Kconfig linux-=
2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/Kconfig
--- linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/Kconfig	2004-10-10 14:01:02=
=2E000000000 +0200
+++ linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/Kconfig	2004-10-15 =
19:39:06.483193040 +0200
@@ -20,6 +20,16 @@
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config IP_NF_CONNTRACK_EVENTS
+	bool "Connection tracking events"
+	depends on IP_NF_CONNTRACK
+	help
+	  If this option is enabled, the connection tracking code will
+	  provide a notifier chain that can be used by other kernel code
+	  to get notified about changes in the connection tracking state.
+	 =20
+	  IF unsure, say `N'.
+
 config IP_NF_CT_ACCT
 	bool "Connection tracking flow accounting"
 	depends on IP_NF_CONNTRACK
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_c=
ore.c linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrack_core=
=2Ec
--- linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_core.c	2004-10=
-10 14:01:02.000000000 +0200
+++ linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrack_core.c=
	2004-10-15 19:36:24.910755784 +0200
@@ -15,6 +15,10 @@
  * 16 Jul 2002: Harald Welte <laforge@gnumonks.org>
  * 	- add usage/reference counts to ip_conntrack_expect
  *	- export ip_conntrack[_expect]_{find_get,put} functions
+ * 28 May 2003: Patrick McHardy <kaber@trash.net>
+ * 	- event notifications
+ * 15 Oct 2004: Harald Welte <laforge@netfilter.org>
+ * 	- port event notifications to 2.6.x (use percpu allocations)
  * */
=20
 #include <linux/config.h>
@@ -78,6 +82,11 @@
=20
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
=20
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+struct notifier_block *ip_conntrack_chain =3D NULL
+DEFINE_PER_CPU(unsigned long, ip_conntrack_event_cache);
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+
 inline void=20
 ip_conntrack_put(struct ip_conntrack *ct)
 {
@@ -329,9 +338,11 @@
 	struct ip_conntrack *ct =3D (void *)ul_conntrack;
=20
 	CONNTRACK_STAT_INC(delete_list);
+	ip_conntrack_event(IPCT_DESTROY, ct);
=20
 	WRITE_LOCK(&ip_conntrack_lock);
 	clean_from_lists(ct);
+	set_bit(IPS_DESTROYED_BIT, &ct->status);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 	ip_conntrack_put(ct);
 }
@@ -437,6 +448,7 @@
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		WRITE_UNLOCK(&ip_conntrack_lock);
+		ip_conntrack_event(IPCT_NEW, ct);
 		CONNTRACK_STAT_INC(insert);
 		return NF_ACCEPT;
 	}
@@ -706,6 +718,8 @@
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |=3D NFC_UNKNOWN;
=20
+	ip_conntrack_event_cache_init();
+
 /* Doesn't cover locally-generated broadcast, so not worth it. */
 #if 0
 	/* Ignore broadcast: no `connection'. */
@@ -767,8 +781,12 @@
 			return NF_ACCEPT;
 		}
 	}
-	if (set_reply)
+	if (set_reply && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+		ip_conntrack_cache_event(IPCT_STATUS);
+	}
+=09
+	ip_conntrack_do_cached_events(ct);
=20
 	return ret;
 }
@@ -1052,6 +1070,7 @@
 		remove_expectations(i->ctrack, 0);
 		/* And *then* set helper to NULL */
 		i->ctrack->helper =3D NULL;
+		ip_conntrack_event(IPCT_HELPINFO, i->ctrack);
 	}
 	return 0;
 }
@@ -1099,12 +1118,13 @@
 	if (!is_confirmed(ct)) {
 		ct->timeout.expires =3D extra_jiffies;
 		ct_add_counters(ct, ctinfo, skb);
-	} else {
+	} else if (abs(jiffies + extra_jiffies - ct->timeout.expires >=3D HZ)) {
 		WRITE_LOCK(&ip_conntrack_lock);
 		/* Need del_timer for race avoidance (may already be dying). */
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires =3D jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
+			ip_conntrack_cache_event(IPCT_REFRESH);
 		}
 		ct_add_counters(ct, ctinfo, skb);
 		WRITE_UNLOCK(&ip_conntrack_lock);
@@ -1303,6 +1323,9 @@
 		goto i_see_dead_people;
 	}
=20
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+	free_percpu(ip_conntrack_event_cache);
+#endif
 	kmem_cache_destroy(ip_conntrack_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
 	vfree(ip_conntrack_hash);
@@ -1366,6 +1389,14 @@
 		goto err_free_conntrack_slab;
 	}
=20
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+	ip_conntrack_event_cache =3D alloc_percpu(unsigned long);
+	if (!ip_conntrack_event_cache) {
+		printk(KERN_ERR "Unable to crate ip_conntrack_event_cache\n");
+		goto err_free_exp_slab;
+	}
+#endif
+
 	/* Don't NEED lock here, but good form anyway. */
 	WRITE_LOCK(&ip_conntrack_lock);
 	for (i =3D 0; i < MAX_IP_CT_PROTO; i++)
@@ -1390,6 +1421,10 @@
=20
 	return ret;
=20
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+err_free_exp_slab:
+	kmem_cache_destroy(ip_conntrack_expect_cachep);
+#endif
 err_free_conntrack_slab:
 	kmem_cache_destroy(ip_conntrack_cachep);
 err_free_hash:
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_f=
tp.c linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-10-=
10 14:01:02.000000000 +0200
+++ linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrack_ftp.c	=
2004-10-15 18:53:24.558266576 +0200
@@ -300,6 +300,7 @@
 			ct_ftp_info->seq_aft_nl[dir] =3D=20
 						ntohl(th->seq) + datalen;
 			ct_ftp_info->seq_aft_nl_set[dir] =3D 1;
+			ip_conntrack_cache_event(IPCT_HELPINFO);
 		}
 	}
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_p=
roto_sctp.c linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrac=
k_proto_sctp.c
--- linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2=
004-10-10 14:01:02.000000000 +0200
+++ linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrack_proto_=
sctp.c	2004-10-15 19:02:20.176840176 +0200
@@ -405,6 +405,9 @@
 		}
=20
 		conntrack->proto.sctp.state =3D newconntrack;
+		if (oldsctpstate !=3D newconntrack)
+			ip_conntrack_cache_event(IPCT_PROTOINFO);
+
 		WRITE_UNLOCK(&sctp_lock);
 	}
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_p=
roto_tcp.c linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrack=
_proto_tcp.c
--- linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	20=
04-10-10 14:01:02.000000000 +0200
+++ linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrack_proto_=
tcp.c	2004-10-15 18:59:39.121324336 +0200
@@ -694,6 +694,8 @@
=20
 		res =3D ip_ct_tcp_be_liberal && !tcph->rst;
   	}
+
+	ip_conntrack_cache_event(IPCT_PROTOINFO_VOLATILE);
  =20
 	DEBUGP("tcp_in_window: res=3D%i sender end=3D%u maxend=3D%u maxwin=3D%u "
 	       "receiver end=3D%u maxend=3D%u maxwin=3D%u\n",
@@ -939,6 +941,9 @@
 		old_state, new_state);
=20
 	conntrack->proto.tcp.state =3D new_state;
+	if (new_state !=3D old_state)
+		ip_conntrack_cache_event(IPCT_PROTOINFO);
+
 	timeout =3D conntrack->proto.tcp.retrans >=3D ip_ct_tcp_max_retrans
 		  && *tcp_timeouts[new_state] > ip_ct_tcp_timeout_max_retrans
 		  ? ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_p=
roto_udp.c linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrack=
_proto_udp.c
--- linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_proto_udp.c	20=
04-10-10 14:01:02.000000000 +0200
+++ linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrack_proto_=
udp.c	2004-10-15 19:00:07.219052832 +0200
@@ -74,6 +74,7 @@
 				   ip_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		ip_conntrack_cache_event(IPCT_STATUS);
 	} else
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_s=
tandalone.c linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrac=
k_standalone.c
--- linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_conntrack_standalone.c	2=
004-10-10 14:01:02.000000000 +0200
+++ linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_conntrack_standa=
lone.c	2004-10-15 19:16:16.328488216 +0200
@@ -903,3 +903,7 @@
 EXPORT_SYMBOL(ip_conntrack_untracked);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_put);
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+EXPORT_SYMBOL_GPL(ip_conntrack_chain);
+EXPORT_PER_CPU_SYMBOL_GPL(ip_conntrack_event_cache);
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_nat_core.c =
linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.6.9-rc3-bk9-test/net/ipv4/netfilter/ip_nat_core.c	2004-10-10 14=
:01:02.000000000 +0200
+++ linux-2.6.9-rc3-bk9-test-ctevent/net/ipv4/netfilter/ip_nat_core.c	2004-=
10-15 19:00:40.953924352 +0200
@@ -608,6 +608,8 @@
 		IP_NF_ASSERT(info->num_manips <=3D IP_NAT_MAX_MANIPS);
 	}
=20
+	ip_conntrack_event(IPCT_NATINFO, conntrack);
+
 	/* If there's a helper, assign it; based on new tuple. */
 	if (!conntrack->master)
 		info->helper =3D __ip_nat_find_helper(&reply);

--ofZMSlrAVk9bLeVm--

--YZQs1kEQY307C4ut
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBcA69XaXGVTD0i/8RAkSGAJ9BSVtM8QXnLkgI0izwmrDoiDEWjgCcDC4c
jpHakKVY+ZjvCbcpepYSyzc=
=Zptw
-----END PGP SIGNATURE-----

--YZQs1kEQY307C4ut--
