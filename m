From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] Re: what's the lockingrules for ip_conntrack_expect_list?
Date: Sat, 12 Oct 2002 14:25:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021012142502.Y13233@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.33.0210111559050.29766-100000@blackhole.kfki.hu> <1034361771.25973.65.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5adDe+nHDi68q/7x"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1034361771.25973.65.camel@tux>; from gandalf@wlug.westbo.se on Fri, Oct 11, 2002 at 08:42:51PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--5adDe+nHDi68q/7x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2002 at 08:42:51PM +0200, Martin Josefsson wrote:

> Harald, is this something you would accept and forward for inclusion?

See my other mail, I don't agree with everything said in the thread before.
Sorry for my late comments, I should have sent that mail two days earlier.

> And while we're at it, I still think we should change exp_for_packet to
> use __find_proto instead of ip_ct_find_proto to avoid the ASSERT's that
> people are complaining about.=20

It's always ugly to export a non-locking __foo function as API to another
module.

> Sure they are harmless but users don't know that and send reports. (this
> problem goes away with Rustys patches for 2.5, exp_for_packet is complete=
ly
> removed)

Yes I agree with the problem, but not with the style of the solution.=20
*sigh*.=20

__find_proto should be inlined anyway. So if we put it into a header file,
which is included by conntrack and nat (ip_conntrack.h), we would avoid
exporting it as a symbol.

> --=20
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

--5adDe+nHDi68q/7x
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qBSeXaXGVTD0i/8RAjh+AJ97iYb/QAoPhhJoXaSpcl2Ev1KNRQCZAenb
/vowwLtgw4eiH47bAwLypaU=
=uHA7
-----END PGP SIGNATURE-----

--5adDe+nHDi68q/7x--
