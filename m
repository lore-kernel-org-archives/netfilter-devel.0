From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] IP sets
Date: Tue, 17 Feb 2004 16:00:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040217150045.GO981@sunbeam.de.gnumonks.org>
References: <20040214212340.GC7756@sunbeam.de.gnumonks.org> <Pine.LNX.4.33.0402171052590.10727-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DFFMAMYvrfM3lt66"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0402171052590.10727-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DFFMAMYvrfM3lt66
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jozsef!

On Tue, Feb 17, 2004 at 10:58:21AM +0100, Jozsef Kadlecsik wrote:
> OK!

It's now a seperate module called 'ipset' in CVS.
http://cvs.netfilter.org/ipset/

However, you still have to fix the ipset Makefile to accomodate the
missing 'Rules.make' (maybe do your own copy, ...)

btw: best to move ippool out of the iptables tree, too.  Any volunteers?

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DFFMAMYvrfM3lt66
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAMiydXaXGVTD0i/8RAiLHAJ4luzEkx6Z8EPEpBQ6E3cUfbcyjLACeKr9W
xybHwKyH0jpQY9BC4nIg4Qo=
=d9ki
-----END PGP SIGNATURE-----

--DFFMAMYvrfM3lt66--
