From: Matthew Grant <grantma@anathoth.gen.nz>
Subject: Re: [PATCH]  - ipsecrx match - was Re: Writing iptables
	IPSEC	reception support.
Date: Fri, 02 Apr 2004 11:23:55 +1200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1080861835.3750.17.camel@knox.wgtn.cat-it.co.nz>
References: <1080772179.5070.9.camel@knox.wgtn.cat-it.co.nz>
	 <20040401004343.GS1616@sunbeam.de.gnumonks.org>
	 <406B73E1.6020504@trash.net>
	 <1080793472.1768.14.camel@knox.wgtn.cat-it.co.nz>
	 <406C07B7.90601@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Si2Lud5goxlkR/UspdlO"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <406C07B7.90601@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-Si2Lud5goxlkR/UspdlO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Patrick,

Isn't there room for both ways of doing it?

I have read the Web CVS for the policy match and you have only checked
in IPv4.

There is a security hole with the way iptables has to be set up to allow
traffic in off the 2.6 IPSEC that allows packet injection off the
immediate external ethernet.

The solution I have got is simple, and it also supports IPv6, and it
closes the above hole by matching decapsulated traffic off the IPSEC
tunnel.  We have a VPN network at work that we need to convert to racoon
and the new IPSEC stack, and this problem needs to be sorted because of
security auditing reasons.

The question is, how soon can you get the policy match in the mainline
netfilter releases?  How well is it working? Do you support IPv6 yet? On
reading the code it looks simple, so it should be easy to get right.  I
could if you want get the thing finished if that is the preferred way to
get things done.

Could you please let me know how you are placed.  A good solution is put
the fix I have in now, and then add yours when it is ready.  They both
do not stomp on each others toes, and can coexist together.

Thank you very much for your time and help.

Regards,

Matthew Grant

PS: I am also the Debian Maintainer for ipsec-tools and racoon packages.

On Fri, 2004-04-02 at 00:14, Patrick McHardy wrote:
> Matthew Grant wrote:
> > Patrick,
> >=20
> > Have written new patches.  Basically they just mark packets that came
> > from IPSEC by setting a bit in the nfcache field in the skbuff.=20
> > Inspired by the longstanding nfmark feature.  Had to write quickly as I
> > need a solution to this problem for security reasons.  Far simpler than
> > the secpath stuff you wrote.
> >=20
> > I have attached the patches.  Not ready for patch-o-matic yet, but what
> > do you think?
>=20
> I think we need more flexibility than this. The policy match allows you
> to match --pol ipsec/none, but both ways.
>=20
> Regards
> Patrick
>=20
> >=20
> > Cheers,
> >=20
> > Matthew Grant
>=20

--=-Si2Lud5goxlkR/UspdlO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAbKSLuk55Di7iAnARAhJzAKCUgogeGbkXG1n9EJp4I0R1R9DU/QCaA1Ew
suQmL5ih5dMWPkYJ+bFk+gU=
=U7bu
-----END PGP SIGNATURE-----

--=-Si2Lud5goxlkR/UspdlO--
