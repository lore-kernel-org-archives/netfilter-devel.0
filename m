From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] memory leak with IP connection tracking and IP forwarding
Date: Mon, 17 May 2004 09:14:53 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20040517071453.GE26147@obroa-skai.de.gnumonks.org>
References: <200405041305.55627.tspat@de.ibm.com> <20040504115808.GJ6345@sunbeam.de.gnumonks.org> <200405041602.26635.tspat@de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+SfteS7bOf3dGlBC"
Cc: linux-net@vger.kernel.org, coreteam@netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-net-owner@vger.kernel.org>
To: tspat@gmx.de
Content-Disposition: inline
In-Reply-To: <200405041602.26635.tspat@de.ibm.com>
List-Id: netfilter-devel.vger.kernel.org


--+SfteS7bOf3dGlBC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 04, 2004 at 04:02:26PM +0200, Thomas Spatzier wrote:
> > > I'm experiencing a major memory leak if I run a router with IP connec=
tion
> > > tracking enabled and packets larger than MTU size.
> >
> > How do you observe such a memory leak?  What exact values are you
> > looking at?
>=20
> On the router I issue a 'watch -n 1 cat /proc/meminfo'.
> Then I do a 'ping -f -s 64000' from one host to another host via the rout=
er.
> On each update of my watch above there are about 10 MB of memory
> (MemFree) missing.

MemFree is not significant in this case.  please refer to your favourite
linux kernel FAQ.

> I also watched /proc/slabinfo and noticed the increasing size of the
> skbuff_head_cache slab.

does it increase and stay at a certain value, or increase indefinitely?
my guess is that you are observing quite normal behaviour, after getting
used, the slab cache allocates some memory which is then re-used again
and again.

Interesting is also not the sizze of the SLAB, but the number of objects
in use from a particular slab.

> Regards,
> Thomas.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+SfteS7bOf3dGlBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAqGZsXaXGVTD0i/8RAtuZAJ9ezTrO9R1dE2bIimG8lDcNeb0djwCeMXMx
2YXYLF551DW4pUewPCWrbto=
=XMVB
-----END PGP SIGNATURE-----

--+SfteS7bOf3dGlBC--
