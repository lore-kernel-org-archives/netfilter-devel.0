From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH 1/2 libnftnl] Fix leak in nftnl_*_unset()
Date: Fri, 10 Jun 2016 13:14:14 +0200
Message-ID: <CAOkSjBh1f-psUnErLLbEifZm9_Af62gPeDFS89srVvVp3s9q_Q@mail.gmail.com>
References: <1465554054-16283-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: =?UTF-8?Q?Carlos_Falgueras_Garc=C3=ADa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34148 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbcFJLOf convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 07:14:35 -0400
Received: by mail-wm0-f68.google.com with SMTP id n184so17138168wmn.1
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2016 04:14:35 -0700 (PDT)
In-Reply-To: <1465554054-16283-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10 June 2016 at 12:20, Carlos Falgueras Garc=C3=ADa <carlosfg@riseup=
=2Enet> wrote:
> Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
> ---
>  src/rule.c     | 1 +
>  src/set_elem.c | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/src/rule.c b/src/rule.c
> index 1e1a138..4c22436 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -112,6 +112,7 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint1=
6_t attr)
>         case NFTNL_RULE_POSITION:
>         case NFTNL_RULE_FAMILY:
>         case NFTNL_RULE_USERDATA:
> +               xfree(r->user.data);
>                 break;
>         }
>

I think you need to isolate this NFTNL_RULE_USERDATA case from the
others by avoiding the fall through.

Example: an user calling nftnl_rule_unset() with NFTNL_RULE_FAMILY
will free 'r->user.data'. That doesn't seem correct.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
