From: Alexander Samad <alex@samad.com.au>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Fri, 5 Mar 2004 10:42:36 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040304234236.GB4995@samad.com.au>
References: <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net> <20040304231141.GA1782@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>,
	Henrik Nordstrom <hno@marasystems.com>,
	Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
	guillaume@morinfr.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
Content-Disposition: inline
In-Reply-To: <20040304231141.GA1782@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 05, 2004 at 12:11:41AM +0100, Willy Tarreau wrote:
> Hi Patrick,
>=20
> On Thu, Mar 04, 2004 at 11:30:38PM +0100, Patrick McHardy wrote:
> > (long CC list, if anyone doesn't want to be on it anymore please say so)
>=20
> no pb, please keep me in :-)
>=20
> > - hook-traversal on input is symetrical to output now. This means
> > packets will traverse PRE_ROUTING/LOCAL_IN before decryption and
> > PRE_REROUTING/LOCAL_IN or PRE_ROUTING/FORWARD afterwards.
>=20
> This is excellent. So if I understand it right, a packet now passes this =
way
> (please excuse the ascii-art, it seems I'll never take the time to start =
xfig)
>=20
>             [incoming packet]
>                     |<-----------------.=20
>                     v                  |
>                PREROUTING              |
>     dest!=3Dlocal?  /  \  dest=3D=3Dlocal?   |
>                 /      \               |
>          FORWARD        LOCAL_IN       |
>              |            |            |
>              |      (ipsec?decrypt:nop)|
>              |            |   \        / dest!=3Dlocal ? nf_postxfrm_nonl=
ocal()
>              |            |    `------'
>              v            v  dest=3D=3Dlocal ? ip_local_deliver_finish()
>=20

Willy thanks for the diagram, too lazy to do one myself.

Q do I understand right that encrypted packets can or can't be acted
upon by the hooks in LOCAL_IN.

Or another way of putting it does a packet travel the tables twice once
as an encrypted packet and once as a de crypted packet ?

Alex

>=20
> So if it behaves like this (which is what seems the best solution to me),=
 is
> there a risk that a carefully crafted packet loops many times on the right
> side (multiple encapsulation with local DIP) ? And if so, is it risky or =
not,
> wrt resource leak, multiple locks, etc... ?
>=20
> > The only problem with this approach I'm currently aware of is that
> > one of the ip-protocol handlers marked with xfrm_prot
> > (xfrm4_tunnel.c) is also responsible for dispatching packets to
> > ipip.c; the encapsulated packets heading for a ipip-tunnel won't
> > traverse the netfilter hooks on input.
>=20
> I don't know well the internals of IPSEC (bought the book but didn't read=
 it
> yet). Are IPIP tunnels often used ? or are they simply used according to a
> negociation, in which case the ipsec implementation on the netfilter side
> could refuse them ?
>=20
> > - new match "policy" for matching the policy that was used during
> > decapsulation (well, the used SAs, policy checks come later), and the
> > policy that will be used for encapsulation.
>=20
> Even more interesting... Now we can for sure check that packets coming fr=
om
> a tunnel have not been spoofed by another tunnel.
>=20
> Thanks a lot Patrick.
> My main goal is to use this on 2.4 with davem/herbert xu's ipsec backport.
> I will soon check if your patches apply on top of their implementation.
>=20
> Cheers,
> Willy
>=20

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAR77skZz88chpJ2MRAqLBAKCZvLyjFJmMytHHcGDP2En+UGfCjgCfbALa
etmj99xnXn5G82iogLyyT3s=
=zf/s
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
