From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_ct_selective_cleanup algorithm
Date: Fri, 23 May 2003 22:22:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523202246.GW3077@sunbeam.de.gnumonks.org>
References: <20030523123152.GA20538@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHJAUhyIZkPvF01C"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20030523123152.GA20538@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nHJAUhyIZkPvF01C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2003 at 02:31:52PM +0200, Balazs Scheidler wrote:
> Hi,
>=20
> While reading through the nfnetlink code, I've encountered the
> ip_ct_selective_cleanup() function, which is used to delete entries from =
the
> conntrack table selectively. A comment states that the algorithm is n^2, =
but
> in fact it is even worse:


> get_next_corpse() restarts scanning the hash table every time it is calle=
d.

mh, you are right
=20
> Currently this function is called from:
> - masquerading, when an interface or IP address is removed
> - from nlconntrack when a conntrack entry is removed
> - from NAT when a helper is removed
>=20
> Is it worth changing the behaviour to grab the lock once, traverse the wh=
ole
> hashtable in one go, and then release the lock?

It is certainly not worth the effort for the first and the third case.
How often do you have interfaces for MASQUERADE go up and down?  And how
often do you unload NAT helper modules?

But for the ctnetlink case it might become interesting... depending on
how frequently your application might delete conntrack entries.

> Bazsi
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nHJAUhyIZkPvF01C
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+zoMWXaXGVTD0i/8RAqkEAJ0QyMuo7Qbo6b2W0OwhrQk8+ESirACgqXyL
pJ7Mip/fl3TLt1IzFTgwdgc=
=bm0k
-----END PGP SIGNATURE-----

--nHJAUhyIZkPvF01C--
