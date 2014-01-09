From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 09/12] netlink_delinearize: remove implied meta
 expressions
Date: Thu, 9 Jan 2014 22:01:07 +0000
Message-ID: <20140109220106.GA11124@macbook.localnet>
References: <1389186543-6919-1-git-send-email-kaber@trash.net>
 <1389186543-6919-10-git-send-email-kaber@trash.net>
 <CAOkSjBh-eVG_EaTc+v7R4X_9584aBLTd1kL-5CL+joqTzK9eTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53065 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaAIWBL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:01:11 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBh-eVG_EaTc+v7R4X_9584aBLTd1kL-5CL+joqTzK9eTA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 09, 2014 at 10:48:41PM +0100, Arturo Borrero Gonzalez wrote=
:
> On 8 January 2014 14:09, Patrick McHardy <kaber@trash.net> wrote:
> >
> > -static void meta_match_postprocess(struct proto_ctx *ctx,
> > +static void meta_match_postprocess(struct rule_pp_ctx *ctx,
> > +                                  struct stmt *stmt,
> >                                    const struct expr *expr)
>=20
> Hi Patrick,
>=20
> I noticed something. When compiling here, I get:
>=20
> $ make clean && make -j8
> [...]
> src/netlink_delinearize.c: In function =E2=80=98meta_match_postproces=
s=E2=80=99:
> src/netlink_delinearize.c:660:3: warning: passing argument 1 of
> =E2=80=98expr-><U 390>.<Ua8e8>.left->ops->pctx_update=E2=80=99 from i=
ncompatible
> pointer type [enabled by default]
> src/netlink_delinearize.c:660:3: note: expected =E2=80=98struct proto=
_ctx *=E2=80=99
> but argument is of type =E2=80=98struct rule_pp_ctx *=E2=80=99
> [...]
>=20
> The last commit I have in my local tree is:
>=20
> *   01cd6fa (HEAD, origin/next-3.14, next-3.14) Merge remote-tracking
> branch 'origin/master' into next-3.14

Thanks, for some reason gcc didn't warn me about this. I just pushed
this patch to fix this:

commit 488196551e5e34af3df5d92358f3efa5a08f5730
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jan 9 21:59:29 2014 +0000

    netlink_delinearize: fix compiler warning
   =20
    src/netlink_delinearize.c: In function =E2=80=98meta_match_postproc=
ess=E2=80=99:
    src/netlink_delinearize.c:660:3: warning: passing argument 1 of =E2=
=80=98expr->left->ops->pctx_update=E2=80=99 from incompatible pointer t=
ype [enabled by default]
    src/netlink_delinearize.c:660:3: note: expected =E2=80=98struct pro=
to_ctx *=E2=80=99 but argument is of type =E2=80=98struct rule_pp_ctx *=
=E2=80=99
   =20
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5a6cbfa..8f6ee38 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -657,7 +657,7 @@ static void meta_match_postprocess(struct rule_pp_c=
tx *ctx,
=20
 	switch (expr->op) {
 	case OP_EQ:
-		expr->left->ops->pctx_update(ctx, expr);
+		expr->left->ops->pctx_update(&ctx->pctx, expr);
=20
 		if (ctx->pbase =3D=3D PROTO_BASE_INVALID &&
 		    left->flags & EXPR_F_PROTOCOL)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
