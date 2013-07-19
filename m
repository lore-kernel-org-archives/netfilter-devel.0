From: Eric Leblond <eric@regit.org>
Subject: Re: [nftables PATCH] Add support for insertion inside rule list
Date: Fri, 19 Jul 2013 16:31:27 +0200
Message-ID: <1374244287.17892.30.camel@ice-age.regit.org>
References: <1373124677-6626-1-git-send-email-eric@regit.org>
	 <1373124837-6857-1-git-send-email-eric@regit.org>
	 <20130719122833.GA30497@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-RqTv358lBJ8tkl7dAUzu"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:40905 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3GSObf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:31:35 -0400
In-Reply-To: <20130719122833.GA30497@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-RqTv358lBJ8tkl7dAUzu
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello,

Le vendredi 19 juillet 2013 =E0 14:28 +0200, Pablo Neira Ayuso a =E9crit :
> Hi Eric,
>=20
> On Sat, Jul 06, 2013 at 05:33:57PM +0200, Eric Leblond wrote:
> > This patch adds support for "insert before" and "add after"
> > rule operation.
> > The rule handle syntax has an new optional after/before field
> > which take a handle as argument.
> > Here is two examples:
> >   nft add rule filter output after 5  ip daddr 1.2.3.1 drop
> >   nft insert rule filter output before 5  ip daddr 1.2.3.1 drop
>=20
> While testing this new feature, I noticed that the parser was
> accepting this:
>=20
> nft add rule filter output after 5  ip daddr 1.2.3.1 drop
> nft insert rule filter output after 5  ip daddr 1.2.3.1 drop
>=20
> Note that 'add' and 'insert' become semantically equivalent, which
> seems inconsistent to me.

Yes, forgot to mention that.

> While fixing it using the 'before' and 'after', I noticed that 'add'
> and 'insert' already tell us where to put the new rule, so 'after' and
> 'before' were repeating again what we want to do. I have reworked this
> patch to change this initial syntax:
>=20
> nft add rule filter output position 5  ip daddr 1.2.3.1 drop
> nft insert rule filter output position 5  ip daddr 1.2.3.1 drop
>=20
> We can support the after and before, but that would imply some extra
> evaluation after the parsing that would make the patch bigger. So I
> prefered to go the simpler solution.

I agree with the following modification. I did not find better than this
so, it is ok for me :)

Patch tested. It works well.

BR,
--
Eric

--=-RqTv358lBJ8tkl7dAUzu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBR6U2/nxA7CdMWjzIRAjzOAJ4yvHMsgqBpOwfcyLDi9g39jK/4RQCeOyYs
lb3fORPyqWKRQe0UeeG75lY=
=jhNW
-----END PGP SIGNATURE-----

--=-RqTv358lBJ8tkl7dAUzu--

