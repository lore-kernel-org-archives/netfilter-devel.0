From: Stephen Frost <sfrost@snowman.net>
Subject: Re: NAT behind IPSEC GW working OK - please review patch
Date: Wed, 6 Apr 2005 11:04:40 -0400
Message-ID: <20050406150439.GS8725@ns.snowman.net>
References: <DB15CAD558452949A35006D66C5C5A99010F8B@nav-post.navcorp.com>
	<1111256850.19630.11.camel@leto.cs.pocnet.net>
	<423DA104.7000402@trash.net>
	<1111432509.32237.4.camel@leto.cs.pocnet.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CX2kZGZwrCIhBPP7"
Cc: Robert Borger <bborger@navcorp.com>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Andrew Hall <temp02@bluereef.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christophe Saout <christophe@saout.de>
Content-Disposition: inline
In-Reply-To: <1111432509.32237.4.camel@leto.cs.pocnet.net>
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


--CX2kZGZwrCIhBPP7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Christophe Saout (christophe@saout.de) wrote:
> Am Sonntag, den 20.03.2005, 17:12 +0100 schrieb Patrick McHardy:
> > This is not correct, the reason why the packets are dropped
> > is most likely a missing forward policy. If this is not the
> > case, there must be a bug somewhere in nf_nat_decode_session4().
>=20
> You were right. Actually it's working without the patch, I was just too
> stupid to allow forwarding in the other direction when I tested it the
> first time.
>=20
> And there actually was a bug in my nf_nat_decode_session4 when using
> both SNAT and DNAT.
>=20
> The updated version of ipsec-04-policy-checks.diff can be found at
> http://www.saout.de/misc/linux-2.6.12-rc1-ipsec-nat/
>=20
> The patches are against linux-2.6.12-rc1, but the only change compared
> to linux-2.6.11 is ipsec-01-output-hooks.diff.

Using these patches (except w/ ipsec-01-output-hooks.diff from the prior
thread w/ 2.6.11 since the one from the URL above didn't patch cleanly)
I seem to still be having a problem with certain situations.  Hopefully
you all might be able to shed some light on it.  This is the situation:

IPSEC tunnels using strongswan for:
A <--> B
A <--> B/subnet *
subnet/A <--> B *
subnet/A <--> B/subnet

This all worked just fine under 2.6.10 w/ the 2.6.10 ipsec/netfilter
patches.  Using 2.6.11.6 the two *'d tunnels don't seem to be working. =20
When trying to ping from A to B/subnet what I see happening is this:

Packet from A is encrypted using the appropriate tunnel going from=20
A to B.  On B I see the packet going through the firewall rules I have
set up in iptables and see the appropriate response is generated and
according to tcpdump on B the return packet is encrypted and sent out
the correct B -> A tunnel.  I don't see that encrypted return packet=20
on A though, again according to tcpdump.  I also see both the icmp=20
return packet and the encrypted packet pass through the OUTPUT chain=20
of B, which is what I'd expect.  I also don't see the encrypted or=20
unencrypted return packet from B to A in the chains of netfilter=20
on A (checked INPUT and nat/PREROUTING).

subnet/A and B/subnet are subnets on the localhost interface of the
associated machine using aliases, technically.  This didn't seem to
bother 2.6.10 at all and I wouldn't expect 2.6.11.6 to care but I wanted
to put that out there too in case it makes a difference.  I could test
w/ real interfaces if necessary but what I actually want working is with
them on localhost.  Additionally, I'm using Vserver 1.9.5 (which is why
I want things on localhost to work in this setup).  Again, worked fine
under 2.6.10 and wouldn't expect it to be a problem.

I understand that people using 2.6.11 have this working w/o the
netfilter patches (at least the A <--> B/subnet part, don't know if
they've tried it w/ using localhost but wouldn't expect that to make a
difference...)..

I've also tried disabling all the firewall rules on both systems and
still the same problem.  I'm probably going to try w/o the patches but
I'd really like to have them..

Any thoughts?

	Thanks,

		Stephen

--CX2kZGZwrCIhBPP7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCU/qHrzgMPqB3kigRAirCAJ0bztBQb+siyZENFW6Ql4Y1X5B01gCfZ53E
hCRjqjZvwMUpMXZuIFvSJBw=
=qU/P
-----END PGP SIGNATURE-----

--CX2kZGZwrCIhBPP7--
