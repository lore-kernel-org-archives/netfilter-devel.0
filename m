From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] l7-filter for pom
Date: Thu, 19 Aug 2004 12:44:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819104443.GG3921@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.60.0408151944550.15521@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TME3aayZmn2Ikqb"
Cc: netfilter-devel@lists.netfilter.org, l7-filter-developers@lists.sf.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthew Strait <quadong@users.sf.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0408151944550.15521@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6TME3aayZmn2Ikqb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 15, 2004 at 07:51:16PM -0500, Matthew Strait wrote:
> Here is the l7-filter match from http://l7-filter.sf.net as a patch to=20
> patch-o-matic.  It adds the ability to match on regular expressions in th=
e=20
> application layer data of connections.
>=20
> (I'm submitting this in what appears to be the prefered manner, but if=20
> another format would be preferable, let me know.)

No, this format is just fine.

First of all, I am not really a friend of the idea of layer7 filtering.
(not your implementation, but the idea of doing this in the kernel)

Anyway, there is a need for it, and we need to deal with this need.

I will integrate your patch, if you consider the following recommendations:
=20
- You don't deal with nonlinear skb's at all.  You cannot make the
  assumption that the packet payload is linear in memory.  The options
  you have is=20
	1) skb_linearize (which linearizes the whole skb and sucks)
	2) implement nonlinear-aware pattern matching using skb_iter()
	3) wait for me until I have finished my skb_iter() based generic
	   in-kernel pattern matchig API (baed on qsearch).

  I suggest you go for '1' until '3' shows up.
- Don't have printk() in per-packet codepath without net_ratelimit() or
  you will be DoS'ed
- The number of packets for each direction is now accounted for if you
  use the conntrack-acct patch (will show up in 2.6.9, is in
  patch-o-matic), please use this value.
- Consider using a slab cache instead of kmalloc for your dat_len
  allocations

> -matthew

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6TME3aayZmn2Ikqb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJISbXaXGVTD0i/8RAlMzAJ9RjQq+H9QuPYtD+ytVnNgtuu7JEQCeJkY+
2FKFv2epBXwxx0QzBFaCTZc=
=x1KE
-----END PGP SIGNATURE-----

--6TME3aayZmn2Ikqb--
