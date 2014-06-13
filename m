From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 1/5] expr: queue: Add nft_rule_expr_queue_snprinf_*
 functions
Date: Fri, 13 Jun 2014 12:16:35 +0200
Message-ID: <CAOkSjBhO+jYw34eaKVgTCP_x3ikHqGYwBN=fvrfoXyBaSsUdpQ@mail.gmail.com>
References: <1402651913-15065-1-git-send-email-anarey@gmail.com> <1402651913-15065-2-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44402 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaFMKQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:16:57 -0400
Received: by mail-lb0-f179.google.com with SMTP id u10so1410188lbd.38
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 03:16:56 -0700 (PDT)
In-Reply-To: <1402651913-15065-2-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13 June 2014 11:31, Ana Rey <anarey@gmail.com> wrote:
[...]
> diff --git a/src/expr/queue.c b/src/expr/queue.c
> index 9f269e7..5dad84a 100644
> --- a/src/expr/queue.c
> +++ b/src/expr/queue.c
> @@ -194,46 +194,66 @@ nft_rule_expr_queue_xml_parse(struct nft_rule_e=
xpr *e, mxml_node_t *tree,
>  #endif
>  }
>
> -static int
> -nft_rule_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
> -                             uint32_t flags, struct nft_rule_expr *e=
)
> +static int nft_rule_expr_queue_snprintf_default(char *buf, size_t le=
n,
> +                                               struct nft_rule_expr =
*e)

As I see this in my email client, It seems that this is not correctly
aligned. But I don't really know, as I'm reviewing without pushing the
patch to my stack.

>  {
>         struct nft_expr_queue *queue =3D nft_expr_data(e);
>         int ret;
>         int one =3D 0;
>
> +       ret =3D snprintf(buf, len, "num %u total %u", queue->queuenum=
,
> +                      queue->queues_total);
> +       if (queue->flags) {
> +               ret +=3D snprintf(buf + ret, len - ret, " options ");
> +               if (queue->flags & NFT_QUEUE_FLAG_BYPASS) {
> +                       ret +=3D snprintf(buf + ret, len - ret, "bypa=
ss");
> +                       one =3D 1;
> +               }
> +               if (queue->flags & NFT_QUEUE_FLAG_CPU_FANOUT) {
> +                       if (one)
> +                               ret +=3D snprintf(buf + ret, len - re=
t, ",");
> +                       ret +=3D snprintf(buf + ret, len - ret, "fano=
ut");
> +               }
> +       }
> +       return ret;
> +}

I would recommend to use the SNPRINTF_BUFFER_SIZE macro, so we keep
this consistent with all the other code.

regards
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
