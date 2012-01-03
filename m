From: Richard Weinberger <richard@nod.at>
Subject: xt_physdev has no effect if net.bridge.bridge-nf-call-iptables=0
Date: Tue, 03 Jan 2012 02:29:43 +0100
Message-ID: <4F025A07.2000304@nod.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig82A5B17EB603B64ACD598FD0"
To: netfilter-devel@vger.kernel.org, linux-netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab2ACB3r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jan 2012 20:29:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig82A5B17EB603B64ACD598FD0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

If net.bridge.bridge-nf-call-iptables is set to zero (which is the
default setting in Fedroa and RHEL6) xt_physdev has no effect.

A rule like this one will never match:
iptables -t nat -A PREROUTING -i bridge0 -m physdev --physdev-in eth0 -p
tcp --dport 80 -j DNAT --to-destination :8080

IMHO the cause of the problem is in net/bridge/br_netfilter.c,
br_nf_pre_routing() returns NF_ACCEPT before skb->nf_bridge is allocated
and skb->nf_bridge->physindev set to skb->dev.

Thanks,
//richard


--------------enig82A5B17EB603B64ACD598FD0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPAloHAAoJEN9758yqZn9eBV8H/0iPa+vfqRzkc7r9xXoJyC9t
djqsm5l60ZKdIZSn6S/gujDSeIMmNhVBE4yXQET7BFhgP8Uwz06DUJOihmGBp+I+
WSJC2ieIMXL/MKN0gdIEtuSorNBNzoCb7gJce9RSnLtRkRjmzx4ocJAOWCLnh8/q
LRi8iOwp1QJ5xA2KdQ0WXvxfHySYhxV+EgPPiJKZMks6cTjN1sowqkCnu8WoRKJy
fJwBzvlgP1ymoZ3i9DbcNQsJwyz2/aY18ylChZqxTE6+G/eKS7CoM4pyZydcu6Tg
JxwjDpGtzlFhjUQK+R+jxhUTsZNbID9uXKaKY/Ar2yhqloqdG3lc/YfOlWpSmkc=
=MWbi
-----END PGP SIGNATURE-----

--------------enig82A5B17EB603B64ACD598FD0--
