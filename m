From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 14:07:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127130739.GR11761@sunbeam.de.gnumonks.org>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wr1Q/2bz0MCWWNYv"
Cc: Willy Tarreau <willy@w.ods.org>, Tom Eastep <teastep@shorewall.net>,
	Michal Ludvig <mludvig@suse.cz>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wr1Q/2bz0MCWWNYv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2004 at 12:57:10PM +0100, Henrik Nordstrom wrote:
> For me it is easier to grasp what is happending with the packet if it is=
=20
> viewed like the original packet is forwarded to the ipsec engine and the=
=20
> ipsec engine then generates a new packet.

agreed.

> What may be interesting in netfilter is to preserve some kind of
> inheritance, allowing "OUTPUT" rules to know important details about the
> original packet when seeing an ESP packet.

yes, but that's again another chapter (like how to preserve that kind of
information, ..

> My view of where hooks should be for IPSec:
>=20
> (Client) -> Gateway -> (Gateway)
>=20
>   1. PREROUTING, original client packet
>   2. FORWARD, original client packet. Destination the IPSec SPI
>   3. POSTROUTING, original client packet. Destination the IPSec SPI
>   4. OUTPUT, ESP packet. Preferably with some preserved information about=
=20
> the original packet attached.
>   5. POSTROUTING, ESP packet.

I agree to all but 4.    My proposal was PREROUTING, yours OUTPUT.  In
the end, none of them really fits.  But I would consider this a minor
issue.  We could also create a new hook 'POSTENCAP' or whatever...
Maybe we could agree at that point, that there is a new hook
NF_IP_POST_XFRM.  It's a matter of iptable_nat/... which chain they want
to attach to that hook.

> If the packet is rerouted in POSTROUTING then this should include IPSec
> routing. If the new route is to an IPSec SPI then it is. If not then it is
> not.

You are talking about the first POSTROUTING, Number 3?  Then I would
definitely agree.

> (Gateway) -> Gateway -> (client)
>=20
>   1. PREROUTING, ESP packet
>   2. FORWARD, ESP packet. Destination the IPSec SPI
>   3. POSTROUTING, ESP packet. Destination the IPSec SPI.
>   4. PREROUTING, decapsulated packet. With reference to the IPSec SPI.
>   5. FORWARD, decapsulated packet. With reference to the IPSec SPI.
>   6. POSTROUTING, decapsulated packet. With reference to the IPSec SPI.

This is not symmetric, despite being the exact opposite of the previous
case.  I don't like that.  If we make it similar to the previous case,
it would be:

1. PREROUTING, ESP packet
2. INPUT, ESP packet
3. PREROUTING, decapsulated packet
4. FORWARD, decapsulated packet
5. POSTROUTING, decapsulated packet.

So here we have the analgy of a locally received (INPUT) packet, as the
opposite of the locally received (OUTPUT) packet in your previous case.

> Host -> (Gateway)
>=20
>   1. OUTPUT, original packet
>   2. POSTROUTING, original packet. Destination the IPSec SPI
>   3. OUTPUT, ESP packet. Preferably with some preserved information about
> the original packet attached.
>   4. POSTROUTING, ESP packet. Preferably with some preserved information=
=20
> about the original packet attached.

this would make it similar to the case #1.

> (Gateway) -> Host
>  =20
>   1. PREROUTING, ESP packet.
>   2. INPUT, ESP packet.
>   3. PREROUTING, Decapsulated packet, with reference to the IPSec SPI
>   4. INPUT, Decapsulated packet, with reference to the IPSec SPI

agreed.

=20
> Ah, we agree! ;-)

yes, at least in the largest part.

> I save myself from diging into exacly where the hooks need to be in the
> kernel as I have not looked in detail at the 2.6 IPSec implementation, but
> I take for granted that several need to be at the corresponding locations
> in the IPSec protocol kernel. =20

I guess I cannot save myself from doing so.  Unfortunately I have very
limited time at this moment, so don't expect it to be done today.

> I also see it likely there needs to be some skb extensions to add the
> requires SPI tracking information to allow rulesets a better view of
> what is going on (optional).

yes, but let's that make step 2.  First we have to agree on the first
step, do a decent implementation and then submit it to netdev.

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wr1Q/2bz0MCWWNYv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFmKbXaXGVTD0i/8RAv1iAKCm/8sm9QZqZ08s7g8u/wD/kbtq5ACfdsZx
LQWGMZdKfyfU2GBoKd8ile4=
=05gp
-----END PGP SIGNATURE-----

--wr1Q/2bz0MCWWNYv--
