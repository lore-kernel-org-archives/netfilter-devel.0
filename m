From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack hash function comparison
Date: Sun, 2 Feb 2003 23:45:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030202224531.GS27870@sunbeam.de.gnumonks.org>
References: <15916.59019.853598.788888@isis.cs3-inc.com> <Pine.LNX.4.33.0301211136020.19820-100000@blackhole.kfki.hu> <15917.31840.767508.76359@isis.cs3-inc.com> <20030131114145.GS9073@naboo.cybercafe42> <15931.6072.971476.262073@isis.cs3-inc.com> <20030201065701.GC23640@oknodo.bof.de> <15931.32301.797460.620368@isis.cs3-inc.com> <20030201083703.GL27870@sunbeam.de.gnumonks.org> <15932.6802.868766.543518@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DQpa7ozeLWh50je8"
Cc: Patrick Schaaf <bof@bof.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15932.6802.868766.543518@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DQpa7ozeLWh50je8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 01, 2003 at 11:05:54AM -0800, Don Cohen wrote:
> Harald Welte writes:
>=20
>  > > Not that it would be so hard to change [hash table size]
>      at run time, but is that really so useful?
>  > Especially in the case where it is not a kernel module ;)
>=20
> Well, then you need a way to initialize it.  Is there a standard
> solution to this problem?  Or is the inability to choose such values
> just the penalty you pay for choosing Y instead of M?

no, there is no standard solution.  And yes, compilng conntrack into the
kernel instead of dynamically loading it as a module _is_ a performance
improvement.  On x86 it's negligible - but on ppc it should make a
measurable difference.

>  > yes, I agree.  and that's why i like the idea of a 'min rehash interva=
l'
>  > proc parameter.  If you set this to '0', kernel will rehash never.  '1'
>  > means maximum of one rehash per second, ...
>=20
> I think I finally understand what this is all about.
> It's not to automatically rehash after time t, but rather to=20
> make sure you don't spend all of your time rehashing.=20

exactly.

> This seems reasonable.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--DQpa7ozeLWh50je8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+PZ+LXaXGVTD0i/8RAlWvAJsF3w3hALIucOUa+X/sYlAq7qY24wCePCI0
rrrNx6iM9WWkiLxfdLaZS8Q=
=X9W7
-----END PGP SIGNATURE-----

--DQpa7ozeLWh50je8--
