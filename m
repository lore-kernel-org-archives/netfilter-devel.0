From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH 2] Re: what's the lockingrules for ip_conntrack_expect_list?
Date: Mon, 14 Oct 2002 13:33:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014133346.Q13233@sunbeam.de.gnumonks.org>
References: <1034286048.25146.40.camel@tux> <Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu> <20021012141737.X13233@sunbeam.de.gnumonks.org> <1034428150.7595.36.camel@tux> <1034429352.7595.48.camel@tux> <20021012163620.C13233@sunbeam.de.gnumonks.org> <1034436775.7595.96.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fd+sk2bWqLlmZvRT"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1034436775.7595.96.camel@tux>; from gandalf@wlug.westbo.se on Sat, Oct 12, 2002 at 05:32:55PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Fd+sk2bWqLlmZvRT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 12, 2002 at 05:32:55PM +0200, Martin Josefsson wrote:
> On Sat, 2002-10-12 at 16:36, Harald Welte wrote:
> > On Sat, Oct 12, 2002 at 03:29:12PM +0200, Martin Josefsson wrote:
> > > Attached patch changes the write-locked tuple_lock to cover the entire
> > > function.
> > > Is this ok with you?
> >=20
> > looks fine.  Now we only need the find_proto() change, and I'll submit=
=20
> > the two combined to the kernel.
>=20
> The find_proto() change is a little trickier... it depends on
> ip_conntrack_protocol.h. I suggest that we move find_proto() to
> ip_conntrack_protocol.h. And then find_proto() also depends on
> listhelp.h... include-dependencies isn't fun.
>=20
> Making find_proto() an inline adds two exported symbols, protocol_list
> and ip_conntrack_generic_protocol.

I didn't think about this, sorry.  So I think we now go for the previous
solution... export an __ function :(

> /Martin
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--Fd+sk2bWqLlmZvRT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qquaXaXGVTD0i/8RAr9uAJ90CryrH+Nqlw/whamTtWJztUm2jQCeOe0I
vTiMLTMQb/9YLs8Tu2KLYaI=
=dv4n
-----END PGP SIGNATURE-----

--Fd+sk2bWqLlmZvRT--
