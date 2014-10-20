From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/4 v2] evaluate: fix a crash if we check the
 transport protocol
Date: Mon, 20 Oct 2014 11:46:47 +0200
Message-ID: <20141020094647.GA5804@salvia>
References: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
 <1413548677-10287-2-git-send-email-alvaroneay@gmail.com>
 <20141020085906.GA4578@salvia>
 <5444D881.6000306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: =?iso-8859-1?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42602 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbaJTJpV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:45:21 -0400
Content-Disposition: inline
In-Reply-To: <5444D881.6000306@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 20, 2014 at 11:40:17AM +0200, =C1lvaro Neira Ayuso wrote:
> El 20/10/14 10:59, Pablo Neira Ayuso escribi=F3:
> >On Fri, Oct 17, 2014 at 02:24:35PM +0200, Alvaro Neira Ayuso wrote:
> >>Example:
> >>
> >>nft add rule inet filter input meta l4proto udp reject with tcp res=
et
> >>
> >>When we check if the transport protocol is tcp, we use the network =
context.
> >>If we don't have this network context, we have a crash.
> >>
> >>Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> >>---
> >>[no changes in v2]
> >>
> >>  src/evaluate.c |    7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >>diff --git a/src/evaluate.c b/src/evaluate.c
> >>index 4b7bda9..2f71e9b 100644
> >>--- a/src/evaluate.c
> >>+++ b/src/evaluate.c
> >>@@ -1339,6 +1339,13 @@ static int stmt_evaluate_reset(struct eval_c=
tx *ctx, struct stmt *stmt)
> >>  	if (desc =3D=3D NULL)
> >>  		return 0;
> >>
> >>+	if (base =3D=3D NULL) {
> >>+		if (strcmp(desc->name, "tcp") =3D=3D 0)
> >>+			return 0;
> >>+		else
> >>+			return stmt_error(ctx, stmt,
> >>+				 "you cannot use tcp reset with this protocol");
> >>+	}
> >
> >Can you give a try to this?
> >
> >         if (base =3D=3D NULL &&
> >             ctx->table.handle.family =3D=3D NFPROTO_INET)
> >                 base =3D &proto_inet_service;
>=20
> It works. That was another solution that I thought. But we don't
> need to compare the family because the base can be NULL only with
> Inet and Bridge tables.

OK, but better you still check for bridge and inet there. We may
introduce changes later on that may easily break this code because of
this assumption.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
