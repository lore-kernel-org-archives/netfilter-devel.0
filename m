From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] ipt_unclean.c:  fix for UDP zero source port check
Date: Mon, 14 Oct 2002 13:17:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014131748.M13233@sunbeam.de.gnumonks.org>
References: <20021011230813.GA5516@morinfr.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMMtlwleeRJSevFd"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20021011230813.GA5516@morinfr.org>; from guillaume@morinfr.org on Sat, Oct 12, 2002 at 01:08:13AM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--NMMtlwleeRJSevFd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 12, 2002 at 01:08:13AM +0200, Guillaume Morin wrote:
> Hi folks,
>=20
> RFC768 allows the source port of an UDP packet to be zero. Currently,
> the unclean match reports such a packet as unclean. This is bogus. Here
> is the patch which fixes that :

you are totally correct. I'll forward this for kernel inclusion.
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--NMMtlwleeRJSevFd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qqfcXaXGVTD0i/8RArkNAKCnih6u0PtbQe0NaGIzWxsmyIfUiwCgmR30
OOQbi1I+1Ffo64X7SssHnfI=
=5mh6
-----END PGP SIGNATURE-----

--NMMtlwleeRJSevFd--
