From: Harald Welte <laforge@netfilter.org>
Subject: Re: New match ipt_geoip
Date: Fri, 5 Nov 2004 11:42:18 +0100
Message-ID: <20041105104217.GD5606@sunbeam.de.gnumonks.org>
References: <41899D17.7060800@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5tINJiUS2/Dn5Rhr"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
Content-Disposition: inline
In-Reply-To: <41899D17.7060800@cookinglinux.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--5tINJiUS2/Dn5Rhr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 03, 2004 at 10:08:07PM -0500, Samuel Jean wrote:
> Hi people,

Hi Samuel!

> We've been working on a way to match a packet based on its country.
> We know it's not a 100% reliable way to filter, but it all
> depends on the database one use.

Thanks, I think this is useful for a number of people (although I
generally dislike the concept, since it never works, especially in the
case of tunnels in multinational corporations/organizations...)

It's also nice to see that you implemented the database-part in
userspace, rather than feeding it via /proc into the kernel (yes, there
are people who would do that). =20

On the other hand, I think there is significant overlap between your
ipt_geoip.c kernel part and the ippool/ipset match.

Thus, I argue, rather than inventing a new patch for the kernel, this
can be done in userspace by configuring a pool of address ranges.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--5tINJiUS2/Dn5Rhr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBi1kJXaXGVTD0i/8RAuiWAJ0bMN49ReolaLE9s1u5Oa4qr/xiKwCgirE0
o2+dyvAj1SFDJ80i5avxsHs=
=Grxp
-----END PGP SIGNATURE-----

--5tINJiUS2/Dn5Rhr--
