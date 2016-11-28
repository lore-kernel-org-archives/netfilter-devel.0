From: Anatole Denis <anatole@rezel.net>
Subject: Re : [PATCH nft 1/7] Interpret OP_NEQ against a set as OP_LOOKUP
Date: Mon, 28 Nov 2016 17:49:58 +0100
Message-ID: <O4VLTpqw8hbx9gT5jGdR46@ZLJRbUrx7b2BDfxD/Ctug>
References: <20161128113905.GC1691@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:39650 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932406AbcK1QuC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 11:50:02 -0500
In-Reply-To: <20161128113905.GC1691@salvia> (from pablo@netfilter.org on Mon
 Nov 28 12:39:05 2016)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 28/11/2016 12:39:05, Pablo Neira Ayuso a =E9crit=A0:
> On Thu, Nov 24, 2016 at 03:16:20PM +0100, Anatole Denis wrote:
> > Now that the support for inverted matching is in the kernel and in
> libnftnl, add
> > it to nftables too.
> >=20
> > This fixes bug #888
> >=20
> > Signed-off-by: Anatole Denis <anatole@rezel.net>
> > ---
> > This patch is heavily based off those of Yuxuan Shui from 2014
> > (https://marc.info/?l=3Dnetfilter-devel&m=3D140682484411296)
> >=20
> >  src/evaluate.c            | 14 ++++++++++++++
> >  src/netlink_delinearize.c | 10 ++++++++++
> >  src/netlink_linearize.c   | 14 +++++++++-----
> >  3 files changed, 33 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index 8b113c8..bb46615 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> > @@ -1541,6 +1541,20 @@ static int expr_evaluate_relational(struct
> eval_ctx *ctx, struct expr **expr)
> >  			if (byteorder_conversion(ctx, &rel->right,
> left->byteorder) < 0)
> >  				return -1;
> >  			break;
> > +		case EXPR_SET:
> > +			assert(rel->op =3D=3D OP_NEQ);
> > +			right =3D rel->right =3D
> > +				implicit_set_declaration(ctx,
> "__set%d",
> > +							 left->dtype, left->len,
> > +							 right);
> > +			/* fall through */
> > +		case EXPR_SET_REF:
> > +			assert(rel->op =3D=3D OP_NEQ);
>=20
> Thanks for working on this.
>=20
> I think we're almost there, we need a bit more code here to catch
> these two error cases:
>=20
> "the referenced set does not exist"

I believe this error is not the best way to handle this issue. I sent a pat=
ch to the list with a proposed change to catch it earlier, removing the nee=
d to check for it here. In case that other patch is refused, I will send v2=
 with this check added.

>=20
> and
>=20
> "datatype mismatch, expected %s, set has type %s"

This one is handled for OP_NEQ/OP_FLAGCMP in general at line 1526. The erro=
r messages are almost identical, the lookup one being "Error: datatype mism=
atch, expected %s, set has type %s" while the NEQ error is "Error: datatype=
 mismatch, expected %s, expression has type %s" ("set" vs "expression").

>=20
> See line 1481 in src/evaluate.c for the OP_LOOKUP case.
>=20
> If I'm on the right track, please also test that these errors cases
> work as intended.
>=20

The case for a lookup/inverse lookup into a nonexistent set is tested in ip=
/sets.t and ip6/sets. (somewhere in patches 3 and 4). I'll send a v2 of the=
se tests with a test for datatype mismatch added.
Considering the previous remarks (and the other patches), do you think I st=
ill should change the error handling code ?=
