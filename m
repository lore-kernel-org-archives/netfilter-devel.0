From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH 09/12] netlink_delinearize: remove implied meta expressions
Date: Thu, 9 Jan 2014 22:48:41 +0100
Message-ID: <CAOkSjBh-eVG_EaTc+v7R4X_9584aBLTd1kL-5CL+joqTzK9eTA@mail.gmail.com>
References: <1389186543-6919-1-git-send-email-kaber@trash.net> <1389186543-6919-10-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:48931 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbaAIVtE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:49:04 -0500
Received: by mail-lb0-f181.google.com with SMTP id z5so436139lbh.40
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jan 2014 13:49:02 -0800 (PST)
In-Reply-To: <1389186543-6919-10-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 8 January 2014 14:09, Patrick McHardy <kaber@trash.net> wrote:
>
> -static void meta_match_postprocess(struct proto_ctx *ctx,
> +static void meta_match_postprocess(struct rule_pp_ctx *ctx,
> +                                  struct stmt *stmt,
>                                    const struct expr *expr)

Hi Patrick,

I noticed something. When compiling here, I get:

$ make clean && make -j8
[...]
src/netlink_delinearize.c: In function =91meta_match_postprocess=92:
src/netlink_delinearize.c:660:3: warning: passing argument 1 of
=91expr-><U 390>.<Ua8e8>.left->ops->pctx_update=92 from incompatible
pointer type [enabled by default]
src/netlink_delinearize.c:660:3: note: expected =91struct proto_ctx *=92
but argument is of type =91struct rule_pp_ctx *=92
[...]

The last commit I have in my local tree is:

*   01cd6fa (HEAD, origin/next-3.14, next-3.14) Merge remote-tracking
branch 'origin/master' into next-3.14

regards
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
