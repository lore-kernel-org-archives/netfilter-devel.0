From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH 2] Re: what's the lockingrules for ip_conntrack_expect_list?
Date: Sat, 12 Oct 2002 16:36:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021012163620.C13233@sunbeam.de.gnumonks.org>
References: <1034286048.25146.40.camel@tux> <Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu> <20021012141737.X13233@sunbeam.de.gnumonks.org> <1034428150.7595.36.camel@tux> <1034429352.7595.48.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aDKukjHEfhu1+b5Q"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1034429352.7595.48.camel@tux>; from gandalf@wlug.westbo.se on Sat, Oct 12, 2002 at 03:29:12PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aDKukjHEfhu1+b5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 12, 2002 at 03:29:12PM +0200, Martin Josefsson wrote:
> Attached patch changes the write-locked tuple_lock to cover the entire
> function.
> Is this ok with you?

looks fine.  Now we only need the find_proto() change, and I'll submit=20
the two combined to the kernel.

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

--aDKukjHEfhu1+b5Q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qDNkXaXGVTD0i/8RAnYzAJ4uR9daeoulWZRcwzgPKtVDn+FL/QCfSDg4
LJvXr1N6u1puX2eDNzonJsk=
=HhCM
-----END PGP SIGNATURE-----

--aDKukjHEfhu1+b5Q--
