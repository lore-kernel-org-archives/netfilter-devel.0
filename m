From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] Re: [ANNOUNCE] Release of iptables-1.2.9
Date: Fri, 7 Nov 2003 19:44:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031107184405.GX5741@sunbeam.de.gnumonks.org>
References: <20031107135520.GM5741@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0311071901580.12681-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="309evMHi/619oHyA"
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311071901580.12681-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--309evMHi/619oHyA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2003 at 07:09:38PM +0100, Henrik Nordstrom wrote:

> It is always a good idea to use "cvs export" when making releases. This=
=20
> makes sure there is no crap left over in the directory, and also=20
> automatically gets rid of those CVS directories..

yes, that's what I used to do all the time.  unfortunately something in
our cvs repositorry seems to be broken, and all I get are failed
assertions of the cvs binary :(  Something like "assertion failed: "
followed by about 4kbytes of source code mangled into a single line).

> The procedure we use for Squid is something like this once the release is=
=20
> decided by the core team:

yup, that's exactly what I used to do (and still do for other projects
like ulogd).

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--309evMHi/619oHyA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/q+f1XaXGVTD0i/8RAg+aAJ0Xpe08mIutnwMZ3j8vVoeWuA9pDQCghVSh
mIYYRjrWJaYis4wJFwOU714=
=Kiqy
-----END PGP SIGNATURE-----

--309evMHi/619oHyA--
