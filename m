From: Christophe Saout <christophe@saout.de>
Subject: [PATCH 0/4] Updated IPSEC NAT patches for 2.6.11
Date: Thu, 17 Feb 2005 20:08:39 +0100
Message-ID: <1108667319.21912.14.camel@leto.cs.pocnet.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-JYw8OxZ1mtqSuNLiDF1n"
To: netfilter-devel@lists.netfilter.org
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


--=-JYw8OxZ1mtqSuNLiDF1n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I've forward-ported Patrick McHardy's patches that make the kernel IPSEC
work with NAT.

Since there probably won't be any more big changes between 2.6.11-rc4
and the final 2.6.11 I'm posting them now.

The biggest change is in the last patch (ipsec-04-policy-checks.diff). I
needed to rewrite nf_nat_decode_session4 due to the big NAT changes. I
hope I got everything right. I couldn't find a situation where it
failed.
I also added a missing return in nat_route_key_compare that made the
kernel fail with certain compiler flags.


--=-JYw8OxZ1mtqSuNLiDF1n
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBCFOu3ZCYBcts5dM0RAuHjAJ4jbzJDuZieRupY+s6PlleuKBkV5gCfW9hA
ccpfNwTV4Ro9BPfDHM2J4wA=
=ri/J
-----END PGP SIGNATURE-----

--=-JYw8OxZ1mtqSuNLiDF1n--
