From: Christophe Saout <christophe@saout.de>
Subject: Re: NAT behind IPSEC GW working OK - please review patch
Date: Sat, 19 Mar 2005 19:27:29 +0100
Message-ID: <1111256850.19630.11.camel@leto.cs.pocnet.net>
References: <DB15CAD558452949A35006D66C5C5A99010F8B@nav-post.navcorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-Op5rRGHg/Tu9rVq3bjmc"
Cc: netfilter-devel@lists.netfilter.org, Andrew Hall <temp02@bluereef.com.au>
To: Robert Borger <bborger@navcorp.com>
In-Reply-To: <DB15CAD558452949A35006D66C5C5A99010F8B@nav-post.navcorp.com>
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


--=-Op5rRGHg/Tu9rVq3bjmc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Freitag, den 11.03.2005, 11:38 -0600 schrieb Robert Borger:

> After the patches where applied, the packets
> got out the tunnel and returned via the tunnel
> as expected, but were dropped during forwarding.
>=20
> It appeared that the packet was still considered
> to be an part of the encrypted stream and there
> was no policy to forward it to the local subnet.
>=20
> I changed the "xfrm_policy_check" function in
> "./include/net/xfrm.h" to allow forwarding if
> the "decap_done" flag is set.
>=20
> [...]

> Then I made this change to "xfrm.h":
>=20
> static inline int xfrm_policy_check(struct sock *sk, int dir, struct sk_b=
uff
> *skb, unsigned short family)
> {
>   if (sk && sk->sk_policy[XFRM_POLICY_IN])
>     return __xfrm_policy_check(sk, dir, skb, family);
> 	=09
>   return(!xfrm_policy_list[dir] && !skb->sp) ||
>     (skb->sp && skb->sp->decap_done) || /* Added this line */
>     (skb->dst->flags & DST_NOPOLICY) ||
>     __xfrm_policy_check(sk, dir, skb, family);
> }

I can confirm that this fixes the problem you described.
(I'm using the IPSEC+NAT patches I forward-ported for 2.6.11).

The line you added should be enclosed in an pair of #ifdef
CONFIG_NETFILTER and #endif.


--=-Op5rRGHg/Tu9rVq3bjmc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBCPG8RZCYBcts5dM0RAv9iAJ9h0YpnYmUfkNQ9rLfkCLzR50OYUQCeI15S
sjoOY9Jqz5ACr2vg6IismUo=
=efIu
-----END PGP SIGNATURE-----

--=-Op5rRGHg/Tu9rVq3bjmc--
