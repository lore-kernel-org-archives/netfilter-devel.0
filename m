From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] ipt_multiport invert fix
Date: Sat, 2 Nov 2002 11:44:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021102114420.I8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKyb7OrsUPvA0NLr"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--DKyb7OrsUPvA0NLr
Content-Type: multipart/mixed; boundary="lwi1LpykoG3J8gyB"
Content-Disposition: inline


--lwi1LpykoG3J8gyB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I forgot to cc' netfilter-devel.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--lwi1LpykoG3J8gyB
Content-Type: message/rfc822
Content-Disposition: inline

Date: Sat, 2 Nov 2002 11:43:53 +0100
From: Harald Welte <laforge@gnumonks.org>
To: David Miller <davem@redhat.com>
Subject: [PATCH] ipt_multiport invert fix
Message-ID: <20021102114353.H8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EzkxZBgZHYT9HRVh"
Content-Disposition: inline
User-Agent: Mutt/1.3.17i
X-Operating-System: Linux sunbeam.de.gnumonks.org 2.4.19-pre10-newnat-pptp
X-Date: Today is Pungenday, the 6th day of The Aftermath in the YOLD 3168


--EzkxZBgZHYT9HRVh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Another iptables fix (courtesy of Marcus Sundberg), this time for the
ipt_multiport module, when used in combination with the '!' inversion optio=
n at
the iptables commandline.

Please apply, thanks.


diff -ur linux.current/net/ipv4/netfilter/ipt_multiport.c linux-mine/net/ip=
v4/netfilter/ipt_multiport.c
--- linux-2.4.19-rc1/net/ipv4/netfilter/ipt_multiport.c	Tue Jun 20 23:32:27=
 2000
+++ linux/net/ipv4/netfilter/ipt_multiport.c	Tue Jul  9 10:43:23 2002
@@ -78,7 +78,7 @@
=20
 	/* Must specify proto =3D=3D TCP/UDP, no unknown flags or bad count */
 	return (ip->proto =3D=3D IPPROTO_TCP || ip->proto =3D=3D IPPROTO_UDP)
-		&& !(ip->flags & IPT_INV_PROTO)
+		&& !(ip->invflags & IPT_INV_PROTO)
 		&& matchsize =3D=3D IPT_ALIGN(sizeof(struct ipt_multiport))
 		&& (multiinfo->flags =3D=3D IPT_MULTIPORT_SOURCE
 		    || multiinfo->flags =3D=3D IPT_MULTIPORT_DESTINATION

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--EzkxZBgZHYT9HRVh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9w6xmXaXGVTD0i/8RArrjAJ0XJelAJgnoqVQI92gM3weit4HsAgCgjyXm
rEzJJAAq9fMJtmFIUzqFPI0=
=Kgeb
-----END PGP SIGNATURE-----

--EzkxZBgZHYT9HRVh--

--lwi1LpykoG3J8gyB--

--DKyb7OrsUPvA0NLr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9w6yEXaXGVTD0i/8RAv2PAJ4/cJAxc+HgbC1ZtH8ALw85d7E9QwCfc0Li
LC3pUfW8ZAmEiDco0MYiQgk=
=9PkB
-----END PGP SIGNATURE-----

--DKyb7OrsUPvA0NLr--
