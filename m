From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER (6/x): connection based accounting
Date: Sat, 24 Jul 2004 10:39:22 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724143922.GO2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LqInKle6vr1NBc7W"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LqInKle6vr1NBc7W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch adds a config option to enable per-flow packet and byte
accounting to ip_conntrack.=20

Signed-off-by: Harald Welte <laforge@netfilter.org>

diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab/include/linux/netf=
ilter_ipv4/ip_conntrack.h linux-2.6.8-rc2-updates-modparm-expslab-ctacct/in=
clude/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.6.8-rc2-updates-modparm-expslab/include/linux/netfilter_ipv4/ip=
_conntrack.h	2004-07-22 11:49:09.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct/include/linux/netfilter_=
ipv4/ip_conntrack.h	2004-07-24 10:36:35.263939680 -0400
@@ -156,6 +156,12 @@
 	union ip_conntrack_expect_help help;
 };
=20
+struct ip_conntrack_counter
+{
+	u_int64_t packets;
+	u_int64_t bytes;
+};
+
 struct ip_conntrack_helper;
=20
 struct ip_conntrack
@@ -173,6 +179,11 @@
 	/* Timer function; drops refcnt when it goes off. */
 	struct timer_list timeout;
=20
+#ifdef CONFIG_IP_NF_CT_ACCT
+	/* Accounting Information (same cache line as other written members) */
+	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
+#endif
+
 	/* If we're expecting another related connection, this will be
            in expected linked list */
 	struct list_head sibling_list;
@@ -245,8 +256,10 @@
 			  const struct ip_conntrack_tuple *orig);
=20
 /* Refresh conntrack for this many jiffies */
-extern void ip_ct_refresh(struct ip_conntrack *ct,
-			  unsigned long extra_jiffies);
+extern void ip_ct_refresh_acct(struct ip_conntrack *ct,
+			       enum ip_conntrack_info ctinfo,
+			       const struct sk_buff *skb,
+			       unsigned long extra_jiffies);
=20
 /* These are for NAT.  Icky. */
 /* Call me when a conntrack is destroyed. */
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter=
/Kconfig linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/ipv4/netfilter/=
Kconfig
--- linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter/Kconfig	2004=
-07-22 11:49:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/ipv4/netfilter/Kconf=
ig	2004-07-24 10:36:35.244942568 -0400
@@ -628,5 +628,9 @@
 	  If you want to compile it as a module, say M here and read
 	  Documentation/modules.txt.  If unsure, say `N'.
=20
+config IP_NF_CT_ACCT
+	bool "Connection tracking flow accounting"
+	depends on IP_NF_CONNTRACK
+
 endmenu
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter=
/ip_conntrack_amanda.c linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/i=
pv4/netfilter/ip_conntrack_amanda.c
--- linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter/ip_conntrack=
_amanda.c	2004-07-24 10:10:55.139074000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/ipv4/netfilter/ip_co=
nntrack_amanda.c	2004-07-24 10:36:35.264939528 -0400
@@ -59,7 +59,7 @@
=20
 	/* increase the UDP timeout of the master connection as replies from
 	 * Amanda clients to the server can be quite delayed */
-	ip_ct_refresh(ct, master_timeout * HZ);
+	ip_ct_refresh_acct(ct, ctinfo, NULL, master_timeout * HZ);
=20
 	/* No data? */
 	dataoff =3D skb->nh.iph->ihl*4 + sizeof(struct udphdr);
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter=
/ip_conntrack_core.c linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/ipv=
4/netfilter/ip_conntrack_core.c
--- linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter/ip_conntrack=
_core.c	2004-07-24 10:30:14.003900016 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/ipv4/netfilter/ip_co=
nntrack_core.c	2004-07-24 10:36:35.267939072 -0400
@@ -1165,21 +1165,39 @@
 	synchronize_net();
 }
=20
-/* Refresh conntrack for this many jiffies. */
-void ip_ct_refresh(struct ip_conntrack *ct, unsigned long extra_jiffies)
+static inline void ct_add_counters(struct ip_conntrack *ct,
+				   enum ip_conntrack_info ctinfo,
+				   const struct sk_buff *skb)
+{
+#ifdef CONFIG_IP_NF_CT_ACCT
+	if (skb) {
+		ct->counters[CTINFO2DIR(ctinfo)].packets++;
+		ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D=20
+					ntohs(skb->nh.iph->tot_len);
+	}
+#endif
+}
+
+/* Refresh conntrack for this many jiffies and do accounting (if skb !=3D =
NULL) */
+void ip_ct_refresh_acct(struct ip_conntrack *ct,=20
+		        enum ip_conntrack_info ctinfo,
+			const struct sk_buff *skb,
+			unsigned long extra_jiffies)
 {
 	IP_NF_ASSERT(ct->timeout.data =3D=3D (unsigned long)ct);
=20
 	/* If not in hash table, timer will not be active yet */
-	if (!is_confirmed(ct))
+	if (!is_confirmed(ct)) {
 		ct->timeout.expires =3D extra_jiffies;
-	else {
+		ct_add_counters(ct, ctinfo, skb);
+	} else {
 		WRITE_LOCK(&ip_conntrack_lock);
 		/* Need del_timer for race avoidance (may already be dying). */
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires =3D jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
 		}
+		ct_add_counters(ct, ctinfo, skb);
 		WRITE_UNLOCK(&ip_conntrack_lock);
 	}
 }
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter=
/ip_conntrack_proto_generic.c linux-2.6.8-rc2-updates-modparm-expslab-ctacc=
t/net/ipv4/netfilter/ip_conntrack_proto_generic.c
--- linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter/ip_conntrack=
_proto_generic.c	2004-06-16 01:19:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/ipv4/netfilter/ip_co=
nntrack_proto_generic.c	2004-07-24 10:36:35.268938920 -0400
@@ -50,9 +50,9 @@
 /* Returns verdict for packet, or -1 for invalid. */
 static int packet(struct ip_conntrack *conntrack,
 		  const struct sk_buff *skb,
-		  enum ip_conntrack_info conntrackinfo)
+		  enum ip_conntrack_info ctinfo)
 {
-	ip_ct_refresh(conntrack, ip_ct_generic_timeout);
+	ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_generic_timeout);
 	return NF_ACCEPT;
 }
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter=
/ip_conntrack_proto_icmp.c linux-2.6.8-rc2-updates-modparm-expslab-ctacct/n=
et/ipv4/netfilter/ip_conntrack_proto_icmp.c
--- linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter/ip_conntrack=
_proto_icmp.c	2004-06-16 01:18:52.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/ipv4/netfilter/ip_co=
nntrack_proto_icmp.c	2004-07-24 10:36:35.269938768 -0400
@@ -94,7 +94,7 @@
 			ct->timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
-		ip_ct_refresh(ct, ip_ct_icmp_timeout);
+		ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
 	}
=20
 	return NF_ACCEPT;
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter=
/ip_conntrack_proto_tcp.c linux-2.6.8-rc2-updates-modparm-expslab-ctacct/ne=
t/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter/ip_conntrack=
_proto_tcp.c	2004-07-22 11:49:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/ipv4/netfilter/ip_co=
nntrack_proto_tcp.c	2004-07-24 10:36:35.270938616 -0400
@@ -225,7 +225,7 @@
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
=20
 out:	WRITE_UNLOCK(&tcp_lock);
-	ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
+	ip_ct_refresh_acct(conntrack, ctinfo, skb, *tcp_timeouts[newconntrack]);
=20
 	return NF_ACCEPT;
 }
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter=
/ip_conntrack_proto_udp.c linux-2.6.8-rc2-updates-modparm-expslab-ctacct/ne=
t/ipv4/netfilter/ip_conntrack_proto_udp.c
--- linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter/ip_conntrack=
_proto_udp.c	2004-06-16 01:18:37.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/ipv4/netfilter/ip_co=
nntrack_proto_udp.c	2004-07-24 10:36:35.271938464 -0400
@@ -60,16 +60,17 @@
 /* Returns verdict for packet, and may modify conntracktype */
 static int udp_packet(struct ip_conntrack *conntrack,
 		      const struct sk_buff *skb,
-		      enum ip_conntrack_info conntrackinfo)
+		      enum ip_conntrack_info ctinfo)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
-		ip_ct_refresh(conntrack, ip_ct_udp_timeout_stream);
+		ip_ct_refresh_acct(conntrack, ctinfo, skb,=20
+				   ip_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 	} else
-		ip_ct_refresh(conntrack, ip_ct_udp_timeout);
+		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
=20
 	return NF_ACCEPT;
 }
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter=
/ip_conntrack_standalone.c linux-2.6.8-rc2-updates-modparm-expslab-ctacct/n=
et/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.6.8-rc2-updates-modparm-expslab/net/ipv4/netfilter/ip_conntrack=
_standalone.c	2004-07-22 11:49:13.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct/net/ipv4/netfilter/ip_co=
nntrack_standalone.c	2004-07-24 10:36:35.273938160 -0400
@@ -83,6 +83,17 @@
 	return len;
 }
=20
+#ifdef CONFIG_IP_NF_CT_ACCT
+static unsigned int
+print_counters(char *buffer, struct ip_conntrack_counter *counter)
+{
+	return sprintf(buffer, "packets=3D%llu bytes=3D%llu ",=20
+			counter->packets, counter->bytes);
+}
+#else
+#define print_counters(x, y)	0
+#endif
+
 static unsigned int
 print_conntrack(char *buffer, struct ip_conntrack *conntrack)
 {
@@ -102,11 +113,15 @@
 	len +=3D print_tuple(buffer + len,
 			   &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 			   proto);
+	len +=3D print_counters(buffer + len,=20
+			      &conntrack->counters[IP_CT_DIR_ORIGINAL]);
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
 		len +=3D sprintf(buffer + len, "[UNREPLIED] ");
 	len +=3D print_tuple(buffer + len,
 			   &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple,
 			   proto);
+	len +=3D print_counters(buffer + len,=20
+			      &conntrack->counters[IP_CT_DIR_REPLY]);
 	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))
 		len +=3D sprintf(buffer + len, "[ASSURED] ");
 	len +=3D sprintf(buffer + len, "use=3D%u ",
@@ -638,7 +653,7 @@
 EXPORT_SYMBOL(ip_conntrack_helper_register);
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
 EXPORT_SYMBOL(ip_ct_selective_cleanup);
-EXPORT_SYMBOL(ip_ct_refresh);
+EXPORT_SYMBOL(ip_ct_refresh_acct);
 EXPORT_SYMBOL(ip_ct_find_proto);
 EXPORT_SYMBOL(__ip_ct_find_proto);
 EXPORT_SYMBOL(ip_ct_find_helper);
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LqInKle6vr1NBc7W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAnSZXaXGVTD0i/8RAizYAKCZ3HZ+1Gf0/RHaR0wfSrTqS7bnYwCglT5V
aaE4KOMuHvEvb9wxLD0syBc=
=VRA/
-----END PGP SIGNATURE-----

--LqInKle6vr1NBc7W--
