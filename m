From: Harald Welte <laforge@netfilter.org>
Subject: Re: "ip_conntrack_core: Frag of proto 17." error
Date: Mon, 22 Sep 2003 12:03:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030922100302.GH31401@sunbeam.de.gnumonks.org>
References: <3F69CFF6.1060505@wp.pl> <20030921144557.GB22223@sunbeam.de.gnumonks.org> <3F6EC037.2040702@wp.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Li7ckgedzMh1NgdW"
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: c0g <c0g@wp.pl>
Content-Disposition: inline
In-Reply-To: <3F6EC037.2040702@wp.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Li7ckgedzMh1NgdW
Content-Type: multipart/mixed; boundary="gKijDXBCEH69PxaN"
Content-Disposition: inline


--gKijDXBCEH69PxaN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2003 at 11:26:15AM +0200, c0g wrote:
=20
> Hi. My setup is simple. This is box with 5 nics, which is primary a PPTP
> server for authorizing LAN users:

thanks.  As already discovered by Martin Josefsson, the problem is the
NOTRACK target.  We have to fix NOTRACK in order to get rid of this bug.

We are waiting for Jozsef (the author of NOTRACK) to comment on this.

Meanwhile, try using the attached (experimental, untested) patch on top
of your (already patched) kernel. Please report back to us if it works.

thanks.


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gKijDXBCEH69PxaN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="notrack-nodefrag-fix.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-notrack/net/ipv4/netfilter/ipt_NOTRACK.c	2003-09-22 12:09:59.0000=
00000 +0200
+++ linux-notrack-nodefrag/net/ipv4/netfilter/ipt_NOTRACK.c	2003-09-22 12:1=
0:44.000000000 +0200
@@ -23,14 +23,8 @@
 	if ((*pskb)->nfct !=3D NULL)
 		return IPT_CONTINUE;
=20
-	proto =3D ip_ct_find_proto((*pskb)->nh.iph->protocol);
-
-	if (ip_conntrack_get_tuple((*pskb)->nh.iph, (*pskb)->len,=20
-		      &tuple, proto)
-	    && !ip_conntrack_tuple_taken(&tuple, NULL)) {
-		(*pskb)->nfct =3D &ip_conntrack_untracked.infos[IP_CT_NEW];
-		nf_conntrack_get((*pskb)->nfct);
-	}
+	(*pskb)->nfct =3D &ip_conntrack_untracked.infos[IP_CT_NEW];
+	nf_conntrack_get((*pskb)->nfct);
=20
 	return IPT_CONTINUE;
 }

--gKijDXBCEH69PxaN--

--Li7ckgedzMh1NgdW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bsjWXaXGVTD0i/8RAqepAKCuqmd8qPKnJihaXjTCFHt/1Zc3AwCdFb7O
w2ISOj3knqzR4bFYBw/CCKY=
=SrAd
-----END PGP SIGNATURE-----

--Li7ckgedzMh1NgdW--
