From: Harald Welte <laforge@netfilter.org>
Subject: Fun for netfilter developers :)
Date: Tue, 6 May 2003 18:15:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030506161515.GH14822@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AzNpbZlgThVzWita"
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


--AzNpbZlgThVzWita
Content-Type: multipart/mixed; boundary="eVzOFob/8UvintSX"
Content-Disposition: inline


--eVzOFob/8UvintSX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Fun for netfilter developers :)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eVzOFob/8UvintSX
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: X-Sieve: cmu-sieve 2.0
Return-path: <davem@redhat.com>
Received: from mail by coruscant.gnumonks.org with spam-scanned (Exim 3.34 #1)
	id 19D3eG-0001zU-00
	for laforge@gnumonks.org; Tue, 06 May 2003 16:42:28 +0200
Received: from netfilter-sponsored-by.noris.net ([62.128.28.62] helo=kashyyyk.netfilter.org)
	by coruscant.gnumonks.org with esmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 3.34 #1)
	id 19D3eG-0001zR-00
	for laforge@gnumonks.org; Tue, 06 May 2003 16:42:28 +0200
Received: from pizda.ninka.net ([216.101.162.242])
	by kashyyyk.netfilter.org with esmtp (Exim 3.35 #1 (Debian))
	id 19D3ch-0002Xo-00
	for <laforge@netfilter.org>; Tue, 06 May 2003 16:40:52 +0200
Received: from localhost (IDENT:davem@localhost.localdomain [127.0.0.1])
	by pizda.ninka.net (8.9.3/8.9.3) with ESMTP id GAA19132;
	Tue, 6 May 2003 06:33:26 -0700
Date: Tue, 06 May 2003 06:33:25 -0700 (PDT)
Message-Id: <20030506.063325.73668384.davem@redhat.com>
To: laforge@netfilter.org
CC: rusty@rustcorp.com.au, jmorris@intercode.com, au@redhat.com,
        kuznet@ms2.inr.ac.ru
Subject: sometimes I have to wonder
From: "David S. Miller" <davem@redhat.com>
X-FalunGong: Information control.
X-Mailer: Mew version 2.1 on Emacs 21.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Check this thing out:

	http://lwn.net/Articles/31207/

Basically, it's a SCO "security fix" in the form of a netfilter
module that blocks all TCP packets with SYN and FIN set at the
same time.

I don't know whether to laugh or cry. :(



--eVzOFob/8UvintSX--

--AzNpbZlgThVzWita
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+t9+TXaXGVTD0i/8RAmo9AJ9JRQNiRIrDLf5MhfJI7yfwxfLHagCdF1Q2
eSLiXVpPeRt2yhJKdXjqfIo=
=BQPw
-----END PGP SIGNATURE-----

--AzNpbZlgThVzWita--
