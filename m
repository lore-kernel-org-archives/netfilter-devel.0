From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] 2.5.x ipt_REJECT bugfix for TCP RST packets + asymm. routing
Date: Sun, 30 Mar 2003 21:47:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030330194756.GV7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kbZGpL0ScFxCd8mt"
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


--kbZGpL0ScFxCd8mt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

This fixes a bug (oops) in the generation of TCP RST packets in the
ipt_REJECT target in the case of asymmetric routing, where the hardware
header length of the outgoing interface is bigger than the hardware
header length of the incoming interface.

Please apply to 2.5.x (2.4.x sent previously), thanks.


--- linux-2.5.63-nfpending/net/ipv4/netfilter/ipt_REJECT.c	Mon Feb 24 20:05=
:40 2003
+++ linux-2.5.63-nfpending-harder/net/ipv4/netfilter/ipt_REJECT.c	Tue Mar  =
4 23:37:44 2003
@@ -44,6 +44,7 @@
 	u_int16_t tmp_port;
 	u_int32_t tmp_addr;
 	int needs_ack;
+	int hh_len;
=20
 	/* IP header checks: fragment, too short. */
 	if (oldskb->nh.iph->frag_off & htons(IP_OFFSET)
@@ -63,13 +64,36 @@
 			 csum_partial((char *)otcph, otcplen, 0)) !=3D 0)
 		return;
=20
+
+	{
+		struct flowi fl =3D { .nl_u =3D { .ip4_u =3D
+					      { .daddr =3D oldskb->nh.iph->saddr,
+						.saddr =3D (local ?
+							  oldskb->nh.iph->daddr :
+							  0),
+						.tos =3D (RT_TOS(oldskb->nh.iph->tos) |
+							RTO_CONN) } } };
+
+		/* Routing: if not headed for us, route won't like source */
+		if (ip_route_output_key(&rt, &fl))
+			return;
+=09
+		hh_len =3D (rt->u.dst.dev->hard_header_len + 15)&~15;
+	}
+
+
 	/* Copy skb (even if skb is about to be dropped, we can't just
            clone it because there may be other things, such as tcpdump,
-           interested in it) */
-	nskb =3D skb_copy(oldskb, GFP_ATOMIC);
+           interested in it). We also need to expand headroom in case
+	   hh_len of incoming interface < hh_len of outgoing interface */
+	nskb =3D skb_copy_expand(oldskb, hh_len, skb_tailroom(oldskb),
+			       GFP_ATOMIC);
 	if (!nskb)
 		return;
=20
+	dst_release(nskb->dst);
+	nskb->dst =3D &rt->u.dst;
+
 	/* This packet will not be the same as the other: clear nf fields */
 	nf_conntrack_put(nskb->nfct);
 	nskb->nfct =3D NULL;
@@ -131,23 +155,6 @@
 	nskb->nh.iph->check =3D 0;
 	nskb->nh.iph->check =3D ip_fast_csum((unsigned char *)nskb->nh.iph,=20
 					   nskb->nh.iph->ihl);
-
-	{
-		struct flowi fl =3D { .nl_u =3D { .ip4_u =3D
-					      { .daddr =3D nskb->nh.iph->daddr,
-						.saddr =3D (local ?
-							  nskb->nh.iph->saddr :
-							  0),
-						.tos =3D (RT_TOS(nskb->nh.iph->tos) |
-							RTO_CONN) } } };
-
-		/* Routing: if not headed for us, route won't like source */
-		if (ip_route_output_key(&rt, &fl))
-			goto free_nskb;
-	}
-
-	dst_release(nskb->dst);
-	nskb->dst =3D &rt->u.dst;
=20
 	/* "Never happens" */
 	if (nskb->len > dst_pmtu(nskb->dst))
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kbZGpL0ScFxCd8mt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+h0nsXaXGVTD0i/8RApOdAJ0UaUafgT5m14VcSmLD4wtWPGOFcgCeJWO1
Nl4bsJaP86ygQWxtG7QDiiM=
=PKZa
-----END PGP SIGNATURE-----

--kbZGpL0ScFxCd8mt--
