From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.4] fix ipt_REJECT when used in OUTPUT
Date: Mon, 22 Sep 2003 14:21:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030922122159.GK31401@sunbeam.de.gnumonks.org>
References: <20030922085326.GF31401@sunbeam.de.gnumonks.org> <20030922020205.6b239e71.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VSVNCtZB1QZ8vhj+"
Cc: diadon@isfera.ru, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030922020205.6b239e71.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--VSVNCtZB1QZ8vhj+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2003 at 02:02:05AM -0700, David S. Miller wrote:
=20
> Already pushed to Marcelo, just send me the fix I should apply
> on top once you have this issue solved.

Ok, here goes the (confirmed to be working) fix. TIA.

diff -Nru linux-2.4.22-laforge/net/ipv4/netfilter/ipt_REJECT.c linux-2.4.22=
-kaber/net/ipv4/netfilter/ipt_REJECT.c
--- linux-2.4.22-laforge/net/ipv4/netfilter/ipt_REJECT.c	2003-09-22 14:29:0=
5.000000000 +0200
+++ linux-2.4.22-kaber/net/ipv4/netfilter/ipt_REJECT.c	2003-09-22 14:26:54.=
000000000 +0200
@@ -34,16 +34,17 @@
 		attach(new_skb, nfct);
 }
=20
-static inline struct rtable *route_reverse(struct sk_buff *skb, int local)
+static inline struct rtable *route_reverse(struct sk_buff *skb, int hook)
 {
 	struct iphdr *iph =3D skb->nh.iph;
 	struct dst_entry *odst;
 	struct rt_key key =3D {};
 	struct rtable *rt;
=20
-	if (local) {
+	if (hook !=3D NF_IP_FORWARD) {
 		key.dst =3D iph->saddr;
-		key.src =3D iph->daddr;
+		if (hook =3D=3D NF_IP_LOCAL_IN)
+			key.src =3D iph->daddr;
 		key.tos =3D RT_TOS(iph->tos);
=20
 		if (ip_route_output_key(&rt, &key) !=3D 0)
@@ -75,7 +76,7 @@
 }
=20
 /* Send RST reply */
-static void send_reset(struct sk_buff *oldskb, int local)
+static void send_reset(struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
 	struct tcphdr *otcph, *tcph;
@@ -104,7 +105,7 @@
 			 csum_partial((char *)otcph, otcplen, 0)) !=3D 0)
 		return;
=20
-	if ((rt =3D route_reverse(oldskb, local)) =3D=3D NULL)
+	if ((rt =3D route_reverse(oldskb, hook)) =3D=3D NULL)
 		return;
=20
 	hh_len =3D (rt->u.dst.dev->hard_header_len + 15)&~15;
@@ -186,8 +187,8 @@
 	nskb->nh.iph->check =3D ip_fast_csum((unsigned char *)nskb->nh.iph,=20
 					   nskb->nh.iph->ihl);
=20
-	/* dst->pmtu can be zero because it is not set for local dst's */
-	if (nskb->dst->pmtu && nskb->len > nskb->dst->pmtu)
+	/* "Never happens" */
+	if (nskb->len > nskb->dst->pmtu)
 		goto free_nskb;
=20
 	connection_attach(nskb, oldskb->nfct);
@@ -372,7 +373,7 @@
 		send_unreach(*pskb, ICMP_PKT_FILTERED);
 		break;
 	case IPT_TCP_RESET:
-		send_reset(*pskb, hooknum =3D=3D NF_IP_LOCAL_IN);
+		send_reset(*pskb, hooknum);
 	case IPT_ICMP_ECHOREPLY:
 		/* Doesn't happen. */
 		break;
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VSVNCtZB1QZ8vhj+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bulnXaXGVTD0i/8RAnLkAJwJXn+cnICwX9zPX6BIr7/Vrlkq7gCgqUm8
IKTZ9WbPC7sXypyJS67Chec=
=mYnj
-----END PGP SIGNATURE-----

--VSVNCtZB1QZ8vhj+--
