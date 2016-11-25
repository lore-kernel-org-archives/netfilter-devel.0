From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH net-next 1/1] netfilter: xt_multiport: Fix wrong unmatch
 result with multiple ports
Date: Fri, 25 Nov 2016 12:09:16 +0800
Message-ID: <CA+6hz4o4tR_PgY-2d6-SGSLSnGKjeUYQh+Lt4E+xUEGROjfXbg@mail.gmail.com>
References: <1480046337-9521-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Feng Gao <gfree.wind@gmail.com>, Gao Feng <fgao@ikuai8.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:34705 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbcKYEJS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 23:09:18 -0500
Received: by mail-ua0-f195.google.com with SMTP id b35so2959691uaa.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 20:09:18 -0800 (PST)
In-Reply-To: <1480046337-9521-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 25, 2016 at 11:58 AM,  <fgao@ikuai8.com> wrote:
> From: Gao Feng <fgao@ikuai8.com>
>
> I lost one test case in the commit for xt_multiport.
> For example, the rule is "-m multiport --dports 22,80,443".
> When first port is unmatched and the second is matched, the curent codes
> could not return the right result.
> It would return false directly when the first port is unmatched.
>
> Fixes: dd2602d00f80 ("netfilter: xt_multiport: Use switch case instead
> of multiple condition checks")
>
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/xt_multiport.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
> index ec06fb1..a99da44 100644
> --- a/net/netfilter/xt_multiport.c
> +++ b/net/netfilter/xt_multiport.c
> @@ -41,29 +41,39 @@
>                         /* range port matching */
>                         e = minfo->ports[++i];
>                         pr_debug("src or dst matches with %d-%d?\n", s, e);
> -
>                         switch (minfo->flags) {
>                         case XT_MULTIPORT_SOURCE:
> -                               return (src >= s && src <= e) ^ minfo->invert;
> +                               if (src >= s && src <= e)
> +                                       return true ^ minfo->invert;
> +                               break;
>                         case XT_MULTIPORT_DESTINATION:
> -                               return (dst >= s && dst <= e) ^ minfo->invert;
> +                               if (dst >= s && dst <= e)
> +                                       return true ^ minfo->invert;
> +                               break;
>                         case XT_MULTIPORT_EITHER:
> -                               return ((dst >= s && dst <= e) ||
> -                                       (src >= s && src <= e)) ^ minfo->invert;
> +                               if ((dst >= s && dst <= e) ||
> +                                   (src >= s && src <= e))
> +                                       return true ^ minfo->invert;
> +                               break;
>                         default:
>                                 break;
>                         }
>                 } else {
>                         /* exact port matching */
>                         pr_debug("src or dst matches with %d?\n", s);
> -
>                         switch (minfo->flags) {
>                         case XT_MULTIPORT_SOURCE:
> -                               return (src == s) ^ minfo->invert;
> +                               if (src == s)
> +                                       return true ^ minfo->invert;
> +                               break;
>                         case XT_MULTIPORT_DESTINATION:
> -                               return (dst == s) ^ minfo->invert;
> +                               if (dst == s)
> +                                       return true ^ minfo->invert;
> +                               break;
>                         case XT_MULTIPORT_EITHER:
> -                               return (src == s || dst == s) ^ minfo->invert;
> +                               if (src == s || dst == s)
> +                                       return true ^ minfo->invert;
> +                               break;
>                         default:
>                                 break;
>                         }
> --
> 1.9.1
>
>

Sorry, please ignore this commit.
I write wrong title. It should be for "nf-next", not "net-next".
And this patch removed two space lines.

Regards
Feng
