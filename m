From: Harald Welte <laforge@netfilter.org>
Subject: CVS Export problems (was Re: [netfilter-core] Re: [ANNOUNCE] Release of iptables-1.2.9)
Date: Sat, 8 Nov 2003 13:44:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031108124415.GK5741@sunbeam.de.gnumonks.org>
References: <20031107184405.GX5741@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0311072210240.13825-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i+iWqY68NNxfGGlH"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311072210240.13825-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--i+iWqY68NNxfGGlH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2003 at 10:12:08PM +0100, Henrik Nordstrom wrote:
> On Fri, 7 Nov 2003, Harald Welte wrote:
>=20
> > yes, that's what I used to do all the time.  unfortunately something in
> > our cvs repositorry seems to be broken, and all I get are failed
> > assertions of the cvs binary :(  Something like "assertion failed: "
> > followed by about 4kbytes of source code mangled into a single line).
>=20
> Try contacting the CVS developer team. They have been very helpful to us=
=20
> in the past when having odd internal errors in CVS.

It's actually a known (and partially fixed) issue, just not in their
stable branch:

http://ccvs.cvshome.org/issues/show_bug.cgi?id=3D142

So for now I have a workaround: manually adding the tags to
CVSROOT/val-tags - and suddenly it works.


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

--i+iWqY68NNxfGGlH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/rOUfXaXGVTD0i/8RAgekAJ9yvBzrHHL/M37R0YG8iRJTs7e8sACgr5qH
6eLHl9zYWiXK+UM5us1B9MI=
=ttSP
-----END PGP SIGNATURE-----

--i+iWqY68NNxfGGlH--
