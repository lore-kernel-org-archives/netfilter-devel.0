From: Harald Welte <laforge@netfilter.org>
Subject: Re: Using iptables with x86_64 static kernel (module problems)?
Date: Mon, 6 Oct 2003 13:05:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031006110509.GH5758@sunbeam.de.gnumonks.org>
References: <20031003102156.GV5758@sunbeam.de.gnumonks.org> <20031005001333.GA8589@cc.jyu.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9vtvPJo8mpgWPkkI"
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jani Averbach <jaa@cc.jyu.fi>
Content-Disposition: inline
In-Reply-To: <20031005001333.GA8589@cc.jyu.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--9vtvPJo8mpgWPkkI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 05, 2003 at 03:13:33AM +0300, Jani Averbach wrote:

> > yes, please.   I have no idea what you are talking about, sorry.
>=20
> Here is the transcript of what I have done, I hope it will bring some
> light to this issue. If this is not a result of some kind of stupidity
> what I have done, and this is real issue, I could test patch etc.

I have installed a 2.4.23-pre5-x86_64-1 kernel on my Redhat Taroon Beta
Dual Opteron box, downloaded iptables-1.2.8, compiled it and it is
running without any problems.

Which distribution are you running?  Debian?  The Debian compiler
behaves inconsistent with all other x86_64 distributions wrt. 32/64bit
code generation - but this is a well-known and well-documented fact.=20

> BR, Jani
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9vtvPJo8mpgWPkkI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/gUxkXaXGVTD0i/8RAh70AJsHkp1V1VlPxJP99jx8Heu2iQh6aACgg4Lk
GUNII/8BtPVdWFD9AgGnePQ=
=6EEC
-----END PGP SIGNATURE-----

--9vtvPJo8mpgWPkkI--
