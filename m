From: Oskar Andreasson <oan@frozentux.net>
Subject: Re: RFC1812 and CLUSTERIP
Date: Thu, 26 Oct 2006 13:41:12 +0200
Message-ID: <1161862872.6634.26.camel@LAPTOP4.MSHOME>
References: <1161777918.8705.63.camel@LAPTOP4.MSHOME>
	<453FE484.9090705@trash.net>
Reply-To: oan@frozentux.net
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-CrEz/Zu15IsgebQoD4Vr"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <453FE484.9090705@trash.net>
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


--=-CrEz/Zu15IsgebQoD4Vr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

It seems to me that the CLUSTERIP target relies on multicast mac to
receive packets to several hosts at the same time. Without it, only a
single machine would actually get the data? According to RFC 1812, as
you could see in the snippet, this seems to be a prohibited behavior,
more or less.=20

According to the RFC 1812 snippet below, it is prohibited for a router
to handle or believe in ARP replies from another (in this case) host
that basically says, send data for this host ip address to this
multicast mac address.=20

If a router is perfectly RFC 1812 compliant, it should to my
understanding simply not send the packets to the host in this case. It
does however not state what to do with the packets from what i've seen.=20

I guess this isn't a big deal yet (maybe never, who knows), but I'd
wander and make a guess that it would be a bugger to try and find out
what the hell is going on if you actually did find yourself in the
situation?

How about either document that the (possible) problem exists,
alternatively to write some kind of check for iptables to only allow
multicast ip addresses together with the CLUSTERIP target? Since the
second suggestion probably will break some users implementations, i'd at
least suggest documenting it and/or give off a warning if people do it?

On Thu, 2006-10-26 at 00:26 +0200, Patrick McHardy wrote:
> Oskar Andreasson wrote:
> > Hi all again,
> >=20
> > I've snowed in on the CLUSTERIP target to some extent, and I am still
> > figuring it out to some extent.=20
> >=20
> > One question that came to mind is its use of multicast MAC addresses. I=
s
> > it really allowed to make use of them in the way that it is right now?
> >=20
> > From RFC 1812 section 3.3.2:
> >=20
> > ------
> >    A router MUST not believe any ARP reply that claims that the Link
> >    Layer address of another host or router is a broadcast or multicast
> >    address.
> > ------
> >=20
> > As I understand it, this is exactly what the CLUSTERIP target does?=20
> > Behaves as if a single host has a multicast address?
>=20
> I'm not too familiar with the CLUSTERIP target, what behaviour
> exactly are you refering to?

--=-CrEz/Zu15IsgebQoD4Vr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFQJ7YGadwPDPpB60RAmP7AKDAVyyH4hi6b/ROvwJSduyjB0Q2FACgsX+c
XtXFSdCWBF8WK52ZrBTJvNM=
=9H3/
-----END PGP SIGNATURE-----

--=-CrEz/Zu15IsgebQoD4Vr--
