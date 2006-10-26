From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] Set mark to 0 from libnetfilter_conntrack
Date: Thu, 26 Oct 2006 23:37:18 +0200
Message-ID: <1161898638.7358.22.camel@localhost.localdomain>
References: <1161801498.12718.22.camel@localhost> <453FF539.3020107@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-vIfxLdmegYmmEX/nE7J4"
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, vincent@inl.fr,
	pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <453FF539.3020107@trash.net>
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


--=-vIfxLdmegYmmEX/nE7J4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

Le jeudi 26 octobre 2006 =E0 01:37 +0200, Patrick McHardy a =E9crit :
> The idea is still the right one, I think the library
> should take care of adding a CTA_MARK attribute without any user bitmask
> fiddling by including it if the value differs from the mark contained in
> the received conntrack. I think Pablo's new API will allow this.

What's the status of this new API ? Current status of
libnetfilter_conntrack code is really disappointing.

We at INL are currently working on using libnetfilter_conntrack to
provide tools for firewall administrators. The first one
pynetfilter_conntrack is already available and a web management
interface will soon be released. By doing this we are trying to improve
the usability of this new system.

We are doing this because we think the new features provided by
libnetfilter_conntrack really improve a lot the way we use and "live"
with a Netfilter firewall.

Sadly, the uncertainty on code evolution and the lack of frequent
releases are wounding the expansion of these ideas.

=46rom my point of view, a decision on libnetfilter_conntrack
developpement should be made quickly :
      * Should pablo's version become the next step in this branch ? or
      * Is it necessary to create a new branch to keep a stable version
        and have compatibility with the few existing applications ?

Best regards,

PS:
pynetfilter_conntrack : http://software.inl.fr/trac/trac.cgi/wiki/pynetfilt=
er_conntrack
--=20
Eric Leblond <eric@inl.fr>

--=-vIfxLdmegYmmEX/nE7J4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFQSqNnxA7CdMWjzIRAq+jAJ933TpzaFJOiU2rKTp+xQ5vYyxDTwCcDVx4
ExRITKhz2/eoUVrZedHcN8E=
=ufp1
-----END PGP SIGNATURE-----

--=-vIfxLdmegYmmEX/nE7J4--
