From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] netbios broadcast connection tracking module
Date: Tue, 19 Oct 2004 19:23:41 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1098206621.1108.105.camel@tux.rsn.bth.se>
References: <1098175785.6562.60.camel@greebo.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-2f528wgfSIThBiE29WW7"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexander Larsson <alexl@redhat.com>
In-Reply-To: <1098175785.6562.60.camel@greebo.homeip.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-2f528wgfSIThBiE29WW7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-10-19 at 10:49, Alexander Larsson wrote:

Hi Alexander

> What happens here is that the smb browser client sends a local udp
> broadcast to port 137, and then local servers reply to this from port
> 137 to the port the broadcast was sent to. However, since these replies
> come from another address than the broadcast was sent to, the udp
> conntrack module doesn't help here.

So both source and destination port is 137 in the replies?
And by looking at your code, it's the same in the broadcast as well.
(since the source port of the broadcast is what is used as
destinationport in the reply)

> So, I've written a small conntrack helper that makes replies to such a
> broadcast package be reported as a RELATED connection. This means the
> default firewall will allow them through.

s/replies/the first reply/

The expectation will get removed from the expectation-list when a packet
matches the expectation.

And it's not possible to register multiple identical expectations since
when only thing that happens then is that the timeout of the first
expectation is updated.

> The module code is below. This is my first ever look at the netfilter cod=
e,=20
> so please look for stupid mistakes. Also, is there any other possible
> solution to this problem that I've missed? I tried using the "recent"
> module, but that doesn't save/match against the port, so i couldn't use
> that.

I think it should be possible to use recent, maybe something like this?

iptables -A OUTPUT -p udp -d $broadcast --sport 137 --dport 137 -m recent -=
-set --rsource --name netbios_ns -j ACCEPT
iptables -A INPUT -p udp --sport 137 --dport 137 -m pkttype --pkt-type unic=
ast -m recent --rcheck --rdest --seconds 20 --name netbios_ns -j ACCEPT

That should add the sourceaddress of the outgoing broadcast to the
recent list called "netbios_ns". Unfortunately we can't use the pkttype
match for outgoing packets, that would have been neat for only adding
broadcast packets automatically without having to specify the broadcast
address.

And then destination ip of incoming udp packets from port 137 to port
137 that are unicast packets are checked against the same recent list
and if the ipaddresses match we accept the packet.
(the pkttype match isn't really needed)

Would that work?

[snip]

> static int __init init(void)
> {
> 	memset(&netbios_ns, 0, sizeof(struct ip_conntrack_helper));
>=20
> 	netbios_ns.name =3D "netbios-ns";
> 	netbios_ns.max_expected =3D 0; /* No maximum */
> 	netbios_ns.timeout =3D NETBIOS_NS_REPLY_TIMEOUT;
> 	netbios_ns.flags =3D IP_CT_HELPER_F_REUSE_EXPECT;

IP_CT_HELPER_F_REUSE_EXPECT is only used if you have set max_expected to
a nonzero value, there's nothing to reuse when there's no maximum.

--=20
/Martin

--=-2f528wgfSIThBiE29WW7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBdU2cWm2vlfa207ERAsSpAJ4srBfSC2xaT5HNpGFH9yINEhbPywCdGjIi
xfo2nZphFRFz6eKVsYv/nH4=
=ZWAM
-----END PGP SIGNATURE-----

--=-2f528wgfSIThBiE29WW7--
