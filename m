From: Harald Welte <laforge@netfilter.org>
Subject: Comments on iptstate
Date: Sun, 15 Feb 2004 20:07:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040215190757.GC15567@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CPaaJmjEtnx7DmsZ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: phil@ipom.com
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


--CPaaJmjEtnx7DmsZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I recently found out about your tool 'iptstate'.

First of all, I think it serves a good purpose, and it is definitely
something that netfilter/iptables users need.

However, two comments:

1) reading /proc/net/ip_conntrack is currently (still) racy on SMP
   boxes.  This means it cannot be used as reliable source.

2) reading /proc/net/ip_conntrack has a huge impact on the performance
   of the conntrack system

It would be fine if you could inform your users about those issues.
Feel free to blame the netfilter/iptables developers, since it's our
fault to offer such a broken interface in the first place.

I suggest to consider porting your application on top of ctnetlink (see
libctnetlink in netfilter cvs and the nfnetlink-ctnetlink patch in
patch-o-matic).

3) The name of the application is misleading. iptables itself does not
   track any state information.  it is ip_conntrack who does.  There is
   almost no relation between both of them.

Thanks for your attention,

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--CPaaJmjEtnx7DmsZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAL8ONXaXGVTD0i/8RArvRAJ49IdFgVredwIW67gb94wZzsgbG3gCbB010
ZQXdX9JhecMDrf8fytPmaY4=
=3h5C
-----END PGP SIGNATURE-----

--CPaaJmjEtnx7DmsZ--
