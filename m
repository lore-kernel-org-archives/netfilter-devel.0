From: Christophe Saout <christophe@saout.de>
Subject: Re: NAT behind IPSEC GW working OK - please review patch
Date: Mon, 21 Mar 2005 20:15:09 +0100
Message-ID: <1111432509.32237.4.camel@leto.cs.pocnet.net>
References: <DB15CAD558452949A35006D66C5C5A99010F8B@nav-post.navcorp.com>
	<1111256850.19630.11.camel@leto.cs.pocnet.net>
	<423DA104.7000402@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-xAf1zyfn1LX9gcBmxe9J"
Cc: Robert Borger <bborger@navcorp.com>, netfilter-devel@lists.netfilter.org,
	Andrew Hall <temp02@bluereef.com.au>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <423DA104.7000402@trash.net>
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


--=-xAf1zyfn1LX9gcBmxe9J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Sonntag, den 20.03.2005, 17:12 +0100 schrieb Patrick McHardy:

> This is not correct, the reason why the packets are dropped
> is most likely a missing forward policy. If this is not the
> case, there must be a bug somewhere in nf_nat_decode_session4().

You were right. Actually it's working without the patch, I was just too
stupid to allow forwarding in the other direction when I tested it the
first time.

And there actually was a bug in my nf_nat_decode_session4 when using
both SNAT and DNAT.

The updated version of ipsec-04-policy-checks.diff can be found at
http://www.saout.de/misc/linux-2.6.12-rc1-ipsec-nat/

The patches are against linux-2.6.12-rc1, but the only change compared
to linux-2.6.11 is ipsec-01-output-hooks.diff.


--=-xAf1zyfn1LX9gcBmxe9J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBCPx08ZCYBcts5dM0RAiz4AJ45DfkTdl0ooBSUOrmHAlQQ2B7NugCfc7G9
kAtDExGB/Tp7SBEBmG0j+kg=
=hxJT
-----END PGP SIGNATURE-----

--=-xAf1zyfn1LX9gcBmxe9J--
