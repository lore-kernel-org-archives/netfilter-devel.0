From: Harald Welte <laforge@netfilter.org>
Subject: Re: oops in replace_in_hashes
Date: Fri, 25 Jul 2003 22:16:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725201650.GJ10897@naboo>
References: <20030725085731.GA5776@balabit.hu> <Pine.LNX.4.52.0307251104001.5333@tux.rsn.bth.se> <20030725135020.GA6433@balabit.hu> <20030725173555.GA7458@balabit.hu> <1059157364.21504.23.camel@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hk6Zb6cduJ+I0Tmj"
Cc: Balazs Scheidler <bazsi@balabit.hu>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <1059157364.21504.23.camel@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hk6Zb6cduJ+I0Tmj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2003 at 08:22:44PM +0200, Henrik Nordstrom wrote:
> fre 2003-07-25 klockan 19.35 skrev Balazs Scheidler:
>=20
> > One little addition, which might prove to be important, is that the
> > bogus next pointer which is tried to be dereferenced contains the IP
> > address of the last SNAT mapping that was being made. The manips
> > array of the ip_nat_info structure is only a couple of bytes away,
> > hm...=20
>=20
> And addressed as an array IIRC...

yes.

> this kind of overwrite pretty much rules out reuse-after-free, unless
> caused by array reference going wrong due to zeroed index data.
>=20
> A quick grep of the source for ip_nat_info manipulations does not give
> any obvious lead to such corruption on reuse-after-free.. all accesses
> seem to be "fine" to my eyes even if assuming a reuse-after-free
> condition.

yes, I can confirm that.  I've also re-read the code again.

> Assuming this is a reuse after free overwrite by bogus array index
> thereby hitting an unexpected element in the structure you should be
> able to find the source of this by identifying all array type positions
> where the IP address may have been legally written into the
> ip_conntrack. Check if the overwriten location is reachable via the
> array. Then look for assignments of this member and you have a likely
> victim.

num_manips is set to 0 while we memset a newly-allocated conntrack.
After that, it is only incremented.  The array is only accessed via the
num_manips used as index. And after every increment, we have a
IP_NF_ASSERT().

So I doubt that this might be the cause either.

> Regards
> Henrik
> (who is back to netfilter hacking after a long period of other tasks)

welcome back :)

> Henrik Nordstrom <hno@marasystems.com>

btw: What compiler are you using?  Since we've had a couple of strange
reports with gcc-3.x recently, could you try a gcc-2.95?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--hk6Zb6cduJ+I0Tmj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/IZAxXaXGVTD0i/8RAj8LAJ48wYU3Z7FXUxoasSlmRvVfAZ0cNQCglLmL
1SP/cxV+k5scINBE8lO8MQg=
=z+VE
-----END PGP SIGNATURE-----

--hk6Zb6cduJ+I0Tmj--
