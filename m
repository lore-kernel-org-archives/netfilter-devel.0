From: Stephen Frost <sfrost@snowman.net>
Subject: Re: Netfilter+IPsec patches
Date: Tue, 17 Aug 2004 23:45:49 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040818034549.GE21419@ns.snowman.net>
References: <20040526033537.GH4402@samad.com.au> <40B53CCE.40704@trash.net> <20040527044613.GC24464@samad.com.au> <20040818024025.GC21419@ns.snowman.net> <4122CCF8.2060203@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zeA3NjBoPLVKqGL6"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <4122CCF8.2060203@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zeA3NjBoPLVKqGL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Philip Craig (philipc@snapgear.com) wrote:
> Stephen Frost wrote:
> >I've run into a rather annoying problem.  I'm not sure if it's due to
> >the IPSEC patches, but I have some suspicion that it is.  Basically the
> >story goes like this:
>=20
> This doesn't sound related to the IPSec patches.  Or did it previously
> work without the patches?

I'm not 100% sure when the breakage occured, unfortunately.  I can tell
you that things were working fine under 2.4.20 or so.  Then I jumped to
2.6.7 w/ the ipsec patches and set up some ipsec stuffs.  I have a
suspicion of the ipsec patches because of what they do and, well, I'd
hope this isn't broken in the base kernel. :)  Check out the changes in
ipsec-03-policy-lookup to ip_nat_standalone.c; the 'nat_route_key' stuff
is what I'm wondering about, but honestly I don't really know.

> >I've got a bunch of network cards in my gateway, in this example we're
> >concerned w/ 3 of them- two connections to the internet, one internal.
> >For this to work I have to have source-based routing working (which it
> >used to, back when I was using 2.4).  It appears to still work fine for
> >connections which are *not* NAT'd.  For connections which are NAT'd it
> >goes like this:
> >
> >eth0 - internet1 (has the 'default' route going out it)
> >eth1 - internet2 (has a seperate route table w/ a default route)
> >eth2 - internal
> >
> >SYN comes in on eth0, NAT'd, goes out eth2, SYN+ACK comes back, that
> >gets NAT'd and goes out eth0.  All's happy there.
>=20
> So a packet with an internal source and a destination on the internet
> is routed out eth0.  (Note that routing is prior to SNAT.)

This is DNAT'ing, btw, I wasn't specific about that before, sorry.
un-NAT'ing should happen pre-routing, I think...  Like this:
Packet shows up on eth1 from 1.1.1.1 -> 1.2.3.4
Gateway NAT's from 1.2.3.4 -> 10.1.2.3 (interal address)
Gateway does routing on NAT'd packet, finds eth2
Gateway sends packet out eth2 to the 10.1.2.3 machine
10.1.2.3 machine sends reply from 10.1.2.3 to 1.1.1.1
Gateway unNAT's from 10.1.2.3 -> 1.2.3.4
Gateway does routing on unNAT'd packet, should find eth1
Gateway sends packet out eth1 to the 1.1.1.1 machine

> >SYN comes in on eth1, NAT'd, goes out eth2, SYN+ACK comes back, that
> >gets NAT'd to the eth1 address but then gets sent out *eth0* instead.
>=20
> And again a packet with an internal source and a destination on the
> internet is still routed out eth0.  Nothing unexpected here, although
> it isn't what you want.

It breaks policy routing...  At least, that's what it seems like to me.
I suppose I can give two internal addresses to the internal machines and
then do source-routing on the internal address but, really, that doesn't
seem quite right to me.

> >pings (which aren't NAT'd) to the eth1 address work fine.  So do
> >traceroute's (again, not NAT'd).  If NAT'ing is turned off and the
> >machine accepts connections directly then TCP connections also work
> >fine.
>=20
> These are all connections to the machine's eth1 address, not internal
> addresses?  So packets with an eth1 source and a destination on the
> internet are routed out eth1.  But this is a different source from
> above, so you can't really compare them.

Hrmpf, I suppose not, but I didn't have an easy way to test the other
case.

> >Policy-based routing is in effect, and is working for things which are
> >not NAT'd.  Things which are NAT'd appear to be going out the main
> >table's default route though instead of being properly routed.
>=20
> I assume that currently you are only using the separate routing table
> if the source address is eth1.  You need to modify this to also use
> the separate routing table for replies to packets that came in eth1.
> You can do this using CONNMARK.  Set the connmark for packets coming
> in eth1, and restore it for packets coming in eth0, then add an ip rule
> to use the separate routing table for that fwmark.

Well, eth1 has a number of different addresses, really, they're all
aliases off of it, but all but 1 of them are NAT'd to other machines.  I
was thinking I could do fwmark routing but, honestly, I thought this was
one of the nice things about policy routing, being able to route based
on the source address.  I'll have to go check, but I could have sworn
this worked for DNAT'ing and was in fact documented in LARTC as being
'how you do it'.

> Alternatively, you could look at using the ROUTE target instead of
> using policy based routing.  I've never tried it though.

Honestly, I don't particularly like the ROUTE target from a conceptual
standpoint.  I suppose it may help in some situations.

	Thanks,

		Stephen

--zeA3NjBoPLVKqGL6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBItDtrzgMPqB3kigRAgfLAJsHPAzlZhjTcwGNgjpRVJukasH+mgCeN8jL
BdKWSG6gVo8h3XLEAUgQHVM=
=kpCg
-----END PGP SIGNATURE-----

--zeA3NjBoPLVKqGL6--
