From: Eric Leblond <eric@inl.fr>
Subject: Re: From where can I get libipq?
Date: Thu, 22 Jun 2006 20:25:57 +0200
Message-ID: <1151000757.7942.5.camel@porky>
References: <1150820919.29962.54.camel@mfarooq-1.tango-networks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-UCgUVOAQweD1DSip6y9R"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mohammad Farooq <mohammadfarooq@tango-networks.com>
In-Reply-To: <1150820919.29962.54.camel@mfarooq-1.tango-networks.com>
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


--=-UCgUVOAQweD1DSip6y9R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Mohammad
On Tue, 2006-06-20 at 11:28 -0500, Mohammad Farooq wrote:
> Hi Eric,
>=20
> I am trying to build an application which filters RTP packets. I am
> planing to use iptables QUEUE to implement this application. I am
> running RedHat enterprise linux WS version 4 on a 64bit hardware. The
> rpc shows me iptables-1.2.11-3.1.RHEL4. But I couldn't find libipq.
> Could you please kindly tell me where to find libipq?

libipq is a bad choice on 64bits system. It has some design problem and
you shoulod try to use libnetfilter_queue.

Nethertheless you should find libipq.a in the iptables devel packet.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-UCgUVOAQweD1DSip6y9R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBEmuC1nxA7CdMWjzIRAv78AJ9/CoQDz2NgDINETJUK51aDd9K4wACgkQsp
LCwtgN9vl9cN1t9JV/2JAJI=
=MNj/
-----END PGP SIGNATURE-----

--=-UCgUVOAQweD1DSip6y9R--
