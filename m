From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Thu, 16 Dec 2004 13:31:51 +0100
Message-ID: <20041216123151.GE10165@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="phCU5ROyZO6kBE05"
Cc: netfilter-devel@lists.netfilter.org,
	Grzegorz Piotr Jaskiewicz <gj@pointblue.com.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
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


--phCU5ROyZO6kBE05
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 09, 2004 at 09:34:34AM +0100, Jozsef Kadlecsik wrote:
> Hi,
>=20
> The included patch addresses the following issues:
>=20
> - When the conntrack table is full, we search only in a single hash
>   bucket. We are in trouble anyway, so let's search harder for
>   droppable entries: the patch extends the search to at most the third of
>   all the buckets.

I don't think it's a good idea to increase cpu and especially cache
usage in sucha (likely DoS) case.

> - If the conntrack table is full, the remote management of the machine
>   becomes a little bit complicated :-).=20

That's why you put in a special rule into 'raw' to bypass conntrack for
administrative connections.  I think this is the best way to address the
problem, especially since we're talking about local sockets... and the
local tcp stack should behave just as conntrack itself and reject all
packets that don't match an existing connection.

So from my point of view, even the extra new list is not needed.

We really should think of decreasing complexity of conntrack, not
increasing it more.

And also, all of this new experimentation should definitley be done on
top of nf_conntrack.  I already dislike the amount of changes still
going into ip_conntrack at this time :(

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--phCU5ROyZO6kBE05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBwYA3XaXGVTD0i/8RAk4/AJ453WbBmRLZfTvkMbOAzb24k0MReACfRarF
WM/wO+FToeyk58mjRuQcM2A=
=vNKb
-----END PGP SIGNATURE-----

--phCU5ROyZO6kBE05--
