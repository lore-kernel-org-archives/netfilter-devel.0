From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH 2/2] Rule comment is now stored into a TLV attribute.
Date: Fri, 5 Feb 2016 08:30:57 +0100
Message-ID: <CAOkSjBgA-4FfKWT1vFHoaW2qwdRfsmS7+FgO0X8=0s0UQ+4UPg@mail.gmail.com>
References: <1454614720-8126-1-git-send-email-carlosfg@riseup.net> <1454614720-8126-2-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: =?UTF-8?Q?Carlos_Falgueras_Garc=C3=ADa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35737 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbcBEHbR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2016 02:31:17 -0500
Received: by mail-wm0-f54.google.com with SMTP id r129so14178113wmr.0
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Feb 2016 23:31:17 -0800 (PST)
In-Reply-To: <1454614720-8126-2-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 February 2016 at 20:38, Carlos Falgueras Garc=C3=ADa
<carlosfg@riseup.net> wrote:
> Modify the rule structure and the parser to store the comment string =
into a TLV
> attribute. This way more data of any type could be stored with a rule=
=2E
>
> Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
> ---
>  include/rule.h            |  4 +++-
>  src/netlink_delinearize.c | 10 ++++++++--
>  src/netlink_linearize.c   |  4 +++-
>  src/parser_bison.y        | 19 ++++++++++++++++---
>  src/rule.c                | 12 +++++++++---
>  5 files changed, 39 insertions(+), 10 deletions(-)
>
> diff --git a/include/rule.h b/include/rule.h
> index c848f0f..7a18c50 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -163,9 +163,11 @@ struct rule {
>         struct location         location;
>         struct list_head        stmts;
>         unsigned int            num_stmts;
> -       const char              *comment;
> +       struct nftnl_attrbuf    *comment;
>  };
>
> +#define RULE_COMMENT_MAX_LEN 256
> +
>  extern struct rule *rule_alloc(const struct location *loc,
>                                const struct handle *h);
>  extern void rule_free(struct rule *rule);
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index ae6abb0..d0d85aa 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -25,6 +25,7 @@
>  #include <utils.h>
>  #include <erec.h>
>  #include <sys/socket.h>
> +#include <libnftnl/attr.h>
>
>  struct netlink_parse_ctx {
>         struct list_head        *msgs;
> @@ -1734,12 +1735,17 @@ struct rule *netlink_delinearize_rule(struct =
netlink_ctx *ctx,
>         assert(pctx->table !=3D NULL);
>
>         if (nftnl_rule_is_set(nlr, NFTNL_RULE_USERDATA)) {
> +               struct nftnl_attrbuf *attrbuf;
>                 const void *data;
>                 uint32_t len;
>
>                 data =3D nftnl_rule_get_data(nlr, NFTNL_RULE_USERDATA=
, &len);
> -               pctx->rule->comment =3D xmalloc(len);
> -               memcpy((char *)pctx->rule->comment, data, len);
> +               if (!(attrbuf =3D nftnl_attrbuf_alloc(len))) {

If I understand correctly above, you alloc here with length 'len'.

> +                       perror("Error allocating memory for attrbuf: =
");

Minor thing here regarding perror: from the manpage <<the argument
string is printed, followed by a colon and a blank>>. So you would be
printing something like 'attrbuf: : '

> +                       exit(EXIT_FAILURE);
> +               }
> +               pctx->rule->comment =3D nftnl_attrbuf_alloc(len);

Another alloc above with length 'len', memleak warning.

> +               nftnl_attrbuf_set_data(pctx->rule->comment, data, len=
);
>         }
>
>         nftnl_expr_foreach((struct nftnl_rule *)nlr, netlink_parse_ex=
pr, pctx);


--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
