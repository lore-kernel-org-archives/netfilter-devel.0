From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] memory leak with IP connection tracking and IP forwarding
Date: Tue, 4 May 2004 13:58:08 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20040504115808.GJ6345@sunbeam.de.gnumonks.org>
References: <200405041305.55627.tspat@de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B3XPdYri2NuANWBV"
Cc: linux-net@vger.kernel.org, coreteam@netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-net-owner@vger.kernel.org>
To: tspat@gmx.de
Content-Disposition: inline
In-Reply-To: <200405041305.55627.tspat@de.ibm.com>
List-Id: netfilter-devel.vger.kernel.org


--B3XPdYri2NuANWBV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 04, 2004 at 01:05:55PM +0200, Thomas Spatzier wrote:
> Hi all,
>=20
> I'm experiencing a major memory leak if I run a router with IP connection
> tracking enabled and packets larger than MTU size.

How do you observe such a memory leak?  What exact values are you
looking at?

> If I do a 'ping -f -s 64000 <Host B>' from host A via the router, the
> router is losing more then 10 MB of memory per second.
> Without connection tracking everything works fine.
>=20
> My only glue so far is that the skbuff_head_cache is growing. Connection
> tracking has a hook in the IP stack, where it gets hold of packets. If th=
ese
> packets are fragmented (due to the packet size being larger than MTU size)
> they are reassembled by ip_conntrack. So I guess the memory leak might
> be somewhere in there.

Did you enable support for bridging?

There was a bug in the bridging (bridging firewall) code which made it
'forget' to drop the reference count (and thus introduced a memory
leak).

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

--B3XPdYri2NuANWBV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAl4VQXaXGVTD0i/8RAuAIAKCWtwPUpPcRRUEBFIDRz9JNoUJMzQCfTfI2
XbNhtLwxYSlprDsOWYJw3XE=
=YdK6
-----END PGP SIGNATURE-----

--B3XPdYri2NuANWBV--
