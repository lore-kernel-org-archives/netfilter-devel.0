From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 21:45:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127204546.GZ11761@sunbeam.de.gnumonks.org>
References: <20040124082252.GA19035@alpha.home.local> <20040124092721.GA19140@alpha.home.local> <20040127103917.GC11761@sunbeam.de.gnumonks.org> <200401270811.36973.teastep@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WVf18ZLo9bznw8Mz"
Cc: Willy Tarreau <willy@w.ods.org>, Henrik Nordstrom <hno@marasystems.com>,
	Michal Ludvig <mludvig@suse.cz>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
Content-Disposition: inline
In-Reply-To: <200401270811.36973.teastep@shorewall.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WVf18ZLo9bznw8Mz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > To do this, somewhen between esp_output() is called and the beginning of
> > the modification of the packet payload, we need to call
> > nf_hook(POST_ROUTING).  This way, conntrack would be able to put the
> > connection in the hash, and people can do SNAT-like operations in
> > nat->POSTROUTING.  We could even pass a dummy output device structure
> > with an interface name "esp" so people can SNAT everything heading for
> > esp encapsulation.
>=20
> I like this proposal.=20

Great :)

> I assume that on input, payload packets would also have this dummy
> device as their input device?=20

sure, makes sense.

> And on output that payload packets would have "esp" as their output
> device in the FORWARD and OUTPUT hooks as well?

no, that's way more difficult.  I'm not sure whether it can be done at
all (without adding rediculous kludges to the code).

> I would also like to register my vote for having the AH/ESP packets go
> through INPUT and OUTPUT. This would allow Shorewall to treat IPSEC in
> the same way as it does all other tunnel types:

Mh.  Let's say we stick with the INPUT/OUTPUT chains for now.

However, I would like to introduce new netfilter hooks.  At least for
the beginning (due to lack of better ideas), I'm going to register the
INPUT/OUTPUT chains with those new hooks.

the idea of the new hooks is, that in reality they are at different
locations in the stack.  And at some point we might have some module
that is only interested in xfrm'ed packets.

> -Tom

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WVf18ZLo9bznw8Mz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFs36XaXGVTD0i/8RAqkWAJ9AAOm6Lqc+TNfR2X4/rOpK8NiYDQCfUCiZ
cbQLA7ZKNk0xujv+pj/4xKg=
=ZCWF
-----END PGP SIGNATURE-----

--WVf18ZLo9bznw8Mz--
