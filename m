From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [NEW EXTENSION] Condition Match
Date: Wed, 30 Oct 2002 10:04:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030100457.X8635@sunbeam.de.gnumonks.org>
References: <3DBED94E.1030107@videotron.ca> <200210292243.07631.aef@prismnet.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x3ENEa1yd42KAyDQ"
Cc: Stephane Ouellette <ouellettes@videotron.ca>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: allen <aef@prismnet.com>
Content-Disposition: inline
In-Reply-To: <200210292243.07631.aef@prismnet.com>; from aef@prismnet.com on Tue, Oct 29, 2002 at 10:43:07PM -0600
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--x3ENEa1yd42KAyDQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2002 at 10:43:07PM -0600, allen wrote:
>=20
>=20
> On Tuesday 29 October 2002 12:54 pm, Stephane Ouellette wrote:
> >    I developped last week a new extension to Netfilter in order to
> > enable or disable a set of rules using /proc files.
>=20
>=20
> Yeah, as others have said, the idea is definitely cool.

Though the idea is cool, I think we are solving a problem the wrong way.  W=
hy
add complexity to the kernel for a problem which can be solved without
any problem from userspace?

Where is the problem in having a couple of different rulesets (e.g. created
with iptables-save) which are then loaded using an iptables-restore
commandline or a script at the shell of the firewall?


--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--x3ENEa1yd42KAyDQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v6C5XaXGVTD0i/8RAvVoAJ93j3N4UTR0Nm+UKEfiivsavQm6RQCgo/Gd
3b/TvEzYauTs9uQdkPiSEIs=
=FZTP
-----END PGP SIGNATURE-----

--x3ENEa1yd42KAyDQ--
