From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 11:30:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040128103000.GP11761@sunbeam.de.gnumonks.org>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ht+/lPZLak6eP81R"
Cc: Henrik Nordstrom <hno@marasystems.com>, Willy Tarreau <willy@w.ods.org>,
	Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <401777B4.9020000@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Ht+/lPZLak6eP81R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2004 at 09:49:56AM +0100, Patrick McHardy wrote:
> I see two problems with this approach. The dummy devices don't have
> any ip config, so f.e. REDIRECT will fail.=20

Ok, let's ignore that for now.  dunno if the dummydev idea was so good
at all.

> The bigger problem is hooking in output routines that return
> NET_XMIT_BYPASS. dst_output loops until the return code of
> skb->dst->output !=3D NET_XMIT_BYPASS.  These output routines replace
> skb->dst when finished by calling dst_pop.
>
> If we pass the packet through netfilter in between, the dst_entry
> might get replaced in ip_route_me_harder or elsewhere and not all
> transformations will be applied.=20

I see.   So we would have to modify all code that changes skb->dst to
check if there is a dst stack.  If yes, it would have to iterate over
all of them and just change the last one.  Shouldn't be too hard to
intergrate that change.

However, it is hard to tell what is the correct behaviour in that case.

In POST_ROUTING of the original, unencapsulated packet, I would say it
is correct to not apply those transformations, in case rerouting of the
packet occurs.  If somebody reroutes here, he wants to affect the
original packet, not the encapsulated one.

However, once we did do the first encapsulation, it doesn't make sense
to encapsulate further layers until we've reached the real dst.  At this
point, LOCAL_OUT would be called with the heading-for-the-wire packet
and rerouting will and should affect the final device.

However, exposing all those intermediate steps to the
netfilter-hook-attached code is not so bad.  It enables people to do
whatever they want... they just need to be careful with their rules.
If there's too much interference with normal OUTPUT/POSTROUTING rules,
we could still go for new hooks+new chains.

> If NAT is used, ip_route_{input,output} might even return a different
> policy bundle.

The question is, again: What ist the desired behaviour?  Should the
policy be determined on the un-NAT'ed packet or on the NAT'ed one?

> Anyways, I'm testing it (slightly hacked) as soon as the compile finishes=
 ;)

good luck :)

> Regards,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Ht+/lPZLak6eP81R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAF48oXaXGVTD0i/8RAt3AAKCh/nQnZXyU+4s+ADIiH/15Rj+MEACfXFbJ
YLtabYK1UBOzPZ+jID0bjgc=
=HKK5
-----END PGP SIGNATURE-----

--Ht+/lPZLak6eP81R--
