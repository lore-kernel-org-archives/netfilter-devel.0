From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER (1/X): ip_nat_snmp call skb_make_writable()
Date: Sat, 24 Jul 2004 10:04:53 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724140453.GI2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2WS97oupGEGbYNpW"
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


--2WS97oupGEGbYNpW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The snmp helper needs an explicit call to skb_ip_make_writable.
Please apply.

Signed-off-by: James Morris <jmorris@redhat.com>
Signed-off-by: Harald Welte <laforge@netfilter.org>

diff -urN -X dontdiff linux-2.6.7-rc1.o/net/ipv4/netfilter/ip_nat_snmp_basi=
c.c linux-2.6.7-rc1.w/net/ipv4/netfilter/ip_nat_snmp_basic.c
--- linux-2.6.7-rc1.o/net/ipv4/netfilter/ip_nat_snmp_basic.c	2004-05-09 22:=
33:13.000000000 -0400
+++ linux-2.6.7-rc1.w/net/ipv4/netfilter/ip_nat_snmp_basic.c	2004-05-27 22:=
00:23.000000000 -0400
@@ -1252,6 +1252,9 @@
 	int dir =3D CTINFO2DIR(ctinfo);
 	struct iphdr *iph =3D (*pskb)->nh.iph;
 	struct udphdr *udph =3D (struct udphdr *)((u_int32_t *)iph + iph->ihl);
+=09
+	if (!skb_ip_make_writable(pskb, (*pskb)->len))
+		return NF_DROP;
=20
 	spin_lock_bh(&snmp_lock);
 =09

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2WS97oupGEGbYNpW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAmyEXaXGVTD0i/8RAma8AJ97vPR7wFFen7E1VDbAlWeK5YZfaQCgn6uX
jkJ4QggV7H4YfruKKZgbsk0=
=YWg7
-----END PGP SIGNATURE-----

--2WS97oupGEGbYNpW--
