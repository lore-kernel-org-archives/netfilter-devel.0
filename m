From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] use 32bit counters for connection-based accounting
Date: Mon, 10 Oct 2005 23:36:57 +0200
Message-ID: <20051010213657.GI5627@rama>
References: <20051007105451.GE4719@rama>
	<20051007.132619.129111295.davem@davemloft.net>
	<20051007220435.GJ4450@rama.customers.eurospot.com>
	<20051010051633.GE9644@oknodo.bof.de>
	<20051010083028.GB5091@rama.customers.eurospot.com>
	<20051010085934.GF9644@oknodo.bof.de>
	<20051010094717.GA5347@rama.customers.eurospot.com>
	<20051010163844.GG9644@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuJpT0rwbUevm2bB"
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20051010163844.GG9644@oknodo.bof.de>
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


--IuJpT0rwbUevm2bB
Content-Type: multipart/mixed; boundary="8tUgZ4IE8L4vmMyh"
Content-Disposition: inline


--8tUgZ4IE8L4vmMyh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2005 at 06:38:45PM +0200, Patrick Schaaf wrote:
> > > I have one (ignorant) question left: when a certain byte counter
> > > for some direction/flow overflows, is the packet counter forced
> > > to overflow at the same time? Same question for when the packet
> > > counter overflows - does the associated byte counter wrap, too?
> > > (I intuit such would be desired behaviour. Wouldn't it?)
> >=20
> > no, the counters will overflow independently - and we have no indication
> > that such an event occurred.
>=20
> Could this be discussed a bit? My rationale is that sometimes
> all I'm interested in, is a quick evaluation of average packet
> sizes. With synchronized byte and packet counters, this is
> one divide away. When synchronization cannot be assumed, several
> samples MUST be taken, and differences calculated. Damn.

I'm fixing this up now, see the attached preliminary, untested and
not-yet-fully-finished patch.  As it seems something like this will
still have to go into 2.6.14, even though I feel really sorry about the
necessity of yet another patch in this area.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8tUgZ4IE8L4vmMyh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="counters.diff"
Content-Transfer-Encoding: quoted-printable

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/=
nfnetlink.h
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -27,6 +27,8 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
 	NFNLGRP_CONNTRACK_EXP_DESTROY,
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
+	NFNLGRP_CONNTRACK_CTR_OVERFLOW,
+#define NFNLGRP_CONNTRACK_CTR_OVERFLOW	NFNLGRP_CONNTRACK_CTR_OVERFLOW
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/ne=
tfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -69,6 +69,10 @@ enum ip_conntrack_status {
 	/* Connection is dying (removed from lists), can not be unset. */
 	IPS_DYING_BIT =3D 9,
 	IPS_DYING =3D (1 << IPS_DYING_BIT),
+
+	/* Per connection counters have overflowed at least once */
+	IPS_COUNTER_OVERFLOW_BIT =3D 10,
+	IPS_COUNTER_OVERFLOW =3D (1 << IPS_COUNTER_OVERFLOW_BIT),
 };
=20
 /* Connection tracking event bits */
@@ -119,10 +123,25 @@ enum ip_conntrack_events
 	IPCT_NATINFO =3D (1 << IPCT_NATINFO_BIT),
=20
 	/* Counter highest bit has been set */
-	IPCT_COUNTER_FILLING_BIT =3D 11,
-	IPCT_COUNTER_FILLING =3D (1 << IPCT_COUNTER_FILLING_BIT),
+	IPCT_ACCT_OFLOW_PKTS_ORIG_BIT =3D 11,
+	IPCT_ACCT_OFLOW_PKTS_ORIG =3D (1 << IPCT_ACCT_OFLOW_PKTS_ORIG_BIT),
+#define IPCT_ACCT_OFLOW_PKTS IPCT_ACCT_OFLOW_PKTS_ORIG
+
+	IPCT_ACCT_OFLOW_PKTS_RPLY_BIT =3D 12,
+	IPCT_ACCT_OFLOW_PKTS_RPLY =3D (1 << IPCT_ACCT_OFLOW_PKTS_RPLY_BIT),
+
+	/* Counter highest bit has been set */
+	IPCT_ACCT_OFLOW_BYTES_ORIG_BIT =3D 13,
+	IPCT_ACCT_OFLOW_BYTES_ORIG =3D (1 << IPCT_ACCT_OFLOW_BYTES_ORIG_BIT),
+#define IPCT_ACCT_OFLOW_BYTES IPCT_ACCT_OFLOW_BYTES_ORIG
+
+	IPCT_ACCT_OFLOW_BYTES_RPLY_BIT =3D 14,
+	IPCT_ACCT_OFLOW_BYTES_RPLY =3D (1 << IPCT_ACCT_OFLOW_BYTES_RPLY_BIT),
 };
=20
+#define IPCT_ACCT_OFLOW_BITS (IPCT_ACCT_OFLOW_BYTES_RPLY|IPCT_ACCT_OFLOW_B=
YTES_ORIG \
+			      IPCT_ACCT_OFLOW_PKTS_RPLY|IPCT_ACCT_OFLOW_PKTS_ORIG)
+
 enum ip_conntrack_expect_events {
 	IPEXP_NEW_BIT =3D 0,
 	IPEXP_NEW =3D (1 << IPEXP_NEW_BIT),
@@ -194,11 +213,21 @@ do {									\
 #define IP_NF_ASSERT(x)
 #endif
=20
+#ifdef CONFIG_IP_NF_CT_ACCT
+#define CTR_HIGHEST_BIT (1 << ((sizeof(ct_ctr_t)*8)-1))
+#ifdef CONFIG_IP_NF_CT_ACCT64
+typedef ct_ctr_t u_int64_t;
+#define ct_ctr_to_be(x) cpu_to_be64(x)
+#else
+typedef ct_ctr_t u_int32_t;
+#define ct_ctr_to_be(x) htonl(x)
+#endif /* CONFIG_IP_NF_CT_ACCT64 */
 struct ip_conntrack_counter
 {
-	u_int32_t packets;
-	u_int32_t bytes;
+	ct_ctr_t packets;
+	ct_ctr_t bytes;
 };
+#endif /* CONFIG_IP_NF_CT_ACCT */
=20
 struct ip_conntrack_helper;
=20
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -32,6 +32,21 @@ config IP_NF_CT_ACCT
=20
 	  If unsure, say `N'.
=20
+config IP_NF_CT_ACCT64
+	bool "Use 64bit counters for flow accounting"
+	depends on IP_NF_CT_ACCT
+	help
+	  The conntrack counters are 32bit by default, which makes them
+	  overflow at more than 4GB of traffic in one direction of a
+	  connection.  This is fine if you have a userspace accounting daemon
+	  that receives the COUNTER_FILLING event message.
+	 =20
+	  However, if you want to use the counters inside the kernel (e.g.
+	  by the connbytes match), you should select this option to increase
+	  their range to 64bits.
+
+	  If unsure, say `N'.
+
 config IP_NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
 	depends on IP_NF_CONNTRACK
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip=
_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1112,6 +1112,35 @@ void ip_conntrack_helper_unregister(stru
 	synchronize_net();
 }
=20
+static inline int __ip_ct_acct(struct ip_conntrack *ct,
+				enum ip_conntrack_info ctinfo,
+				const struct sk_buff *skb)
+{
+	unsigned int ret =3D 0;
+#ifdef CONFIG_IP_NF_CT_ACCT
+	unsigned int dir =3D CTINFO2DIR(ctinfo);
+	ct_ctr_t packets, bytes;
+
+	/* The idea is to just reset the highest bit and continue counting.
+	 * Userspace will then have to add that 'highest bit' to their
+	 * accounting system.  */
+	ct->counters[dir].packets++;
+	if (unlikely(ct->counters[dir].packets > CTR_HIGHEST_BIT)) {
+		set_bit(IPS_COUNTER_OVERFLOW, &ct->status);
+		ct->counters[dir].packets &=3D ~CTR_HIGHEST_BIT;
+		ret |=3D IPCT_ACCT_OFLOW_PKTS + dir;
+	}
+
+	ct->counters[dir].bytes +=3D ntohs(skb->nh.iph->tot_len);
+	if (unlikely(ct->counters[dir].bytes > CTR_HIGHEST_BIT)) {
+		set_bit(IPS_COUNTER_OVERFLOW, &ct->status);
+		ct->counters[dir].bytes &=3D ~CTR_HIGHEST_BIT;
+		ret |=3D IPCT_ACCT_OFLOW_BYTES + dir;
+	}
+#endif
+	return ret;
+}
+
 /* Refresh conntrack for this many jiffies and do accounting if do_acct is=
 1 */
 void __ip_ct_refresh_acct(struct ip_conntrack *ct,=20
 		        enum ip_conntrack_info ctinfo,
@@ -1139,16 +1168,8 @@ void __ip_ct_refresh_acct(struct ip_conn
 		}
 	}
=20
-#ifdef CONFIG_IP_NF_CT_ACCT
-	if (do_acct) {
-		ct->counters[CTINFO2DIR(ctinfo)].packets++;
-		ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D=20
-						ntohs(skb->nh.iph->tot_len);
-		if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
-		    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
-			event |=3D IPCT_COUNTER_FILLING;
-	}
-#endif
+	if (do_acct)
+		event |=3D __ip_ct_acct(ct, ctinfo, skb);
=20
 	write_unlock_bh(&ip_conntrack_lock);
=20
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -168,20 +168,28 @@ nfattr_failure:
 	return -ENOMEM;
 }
=20
-#ifdef CONFIG_IP_NF_CT_ACCT
 static inline int
 ctnetlink_dump_counters(struct sk_buff *skb, const struct ip_conntrack *ct,
-			enum ip_conntrack_dir dir)
+			enum ip_conntrack_dir dir, unsigned int events)
 {
+#ifdef CONFIG_IP_NF_CT_ACCT
 	enum ctattr_type type =3D dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
 	struct nfattr *nest_count =3D NFA_NEST(skb, type);
-	u_int64_t tmp;
+	ct_ctr_t tmp;
=20
-	tmp =3D htonl(ct->counters[dir].packets);
-	NFA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(u_int32_t), &tmp);
+	if (unlikely(events & (IPCT_ACCT_OFLOW_PKTS + dir)))
+		tmp =3D CT_CTR_HIGHEST_BIT;
+	else
+		tmp =3D ct->counters[dir].packets;
+	tmp =3D ct_ctr_to_be(tmp);
+	NFA_PUT(skb, CTA_COUNTERS_PACKETS, sizeof(ct_ctr_t), &tmp);
=20
-	tmp =3D htonl(ct->counters[dir].bytes);
-	NFA_PUT(skb, CTA_COUNTERS32_BYTES, sizeof(u_int32_t), &tmp);
+	if (unlikely(events & (IPCT_ACCT_OFLOW_BYTES + dir)))
+		tmp =3D CT_CTR_HIGHEST_BIT;
+	else
+		tmp =3D ct->counters[dir].bytes;
+	tmp =3D ct_ctr_to_be(tmp);
+	NFA_PUT(skb, CTA_COUNTERS_BYTES, sizeof(ct_ctr_t), &tmp);
=20
 	NFA_NEST_END(skb, nest_count);
=20
@@ -189,10 +197,10 @@ ctnetlink_dump_counters(struct sk_buff *
=20
 nfattr_failure:
 	return -ENOMEM;
-}
 #else
-#define ctnetlink_dump_counters(a, b, c) (0)
+	return 0;
 #endif
+}
=20
 #ifdef CONFIG_IP_NF_CONNTRACK_MARK
 static inline int
@@ -268,8 +276,8 @@ ctnetlink_fill_info(struct sk_buff *skb,
=20
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
 	    ctnetlink_dump_timeout(skb, ct) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0 ||
+	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL, event) < 0 ||
+	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY, event) < 0 ||
 	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
@@ -325,6 +333,14 @@ static int ctnetlink_conntrack_event(str
 		group =3D NFNLGRP_CONNTRACK_UPDATE;
 		goto alloc_skb;
 	}=20
+	/* FIXME: what if we have a status update _and_ an overflow event
+	 * at the same time? */
+	if (events & IPCT_ACCT_OFLOW_BITS) {
+		type =3D IPCTNL_MSG_CT_NEW;
+		group =3D NFNLGRP_CONNTRACK_CTR_OVERFLOW;
+		goto alloc_skb;
+	}
+
 =09
 	return NOTIFY_DONE;
=20
@@ -370,8 +386,8 @@ alloc_skb:
 	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nfattr_failure;
=20
-	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
+	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL, events) < 0 ||
+	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY, events) < 0)
 		goto nfattr_failure;
=20
 	nlh->nlmsg_len =3D skb->tail - b;

--8tUgZ4IE8L4vmMyh--

--IuJpT0rwbUevm2bB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSt75XaXGVTD0i/8RAsgCAJ9JISycA77/q2mXH2xk7Ut8/zoEjQCeJfju
saf4GN/iSD1H63dr8VuBENc=
=d0Zs
-----END PGP SIGNATURE-----

--IuJpT0rwbUevm2bB--
