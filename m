From: Eric Leblond <eric@inl.fr>
Subject: limit and negation
Date: Tue, 09 Nov 2004 11:13:07 +0100
Message-ID: <1099995187.4318.15.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-smuDy5UC2syHdEgux0I+"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--=-smuDy5UC2syHdEgux0I+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

On a discussion yesterday on #netfilter, someone point out that the
limit seems to have problem with negation.
Man page announce it is supported, but when doing this test :
iptables rules set :
iptables -A OUTPUT -m limit --limit 1/s -j LOG --log-prefix "under"
iptables -A OUTPUT -m limit ! --limit 1/s -j LOG --log-prefix "over"

It seems that the rules match the same packets (same ID on tcp flows).

I never had to use limit with a negation, but there's at least a problem
in the man page.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-smuDy5UC2syHdEgux0I+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBkJgynxA7CdMWjzIRArMDAJ9L9ZXR8KzHK1o1xrW4oO/Sth7WJgCbBi/E
UbQp9lCvENX19n5mmB/Chro=
=Dm7X
-----END PGP SIGNATURE-----

--=-smuDy5UC2syHdEgux0I+--
