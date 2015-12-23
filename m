From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] include: xtables: Add enum for better nft translation code
Date: Wed, 23 Dec 2015 20:53:57 +0530
Message-ID: <CAKHNQQGc-4T_9n=dJ9s5q422-MJic_tnSsvpaJxLD7SDAnwgKw@mail.gmail.com>
References: <20151223142132.GA15698@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36150 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbbLWPYS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 10:24:18 -0500
Received: by mail-wm0-f53.google.com with SMTP id p187so150413208wmp.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 07:24:17 -0800 (PST)
In-Reply-To: <20151223142132.GA15698@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 7:51 PM, Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> Add enum xt_op for ease to write cleaner and better code for
> nft translation.
>
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  include/xtables.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/include/xtables.h b/include/xtables.h
> index 7d97baa..0355057 100644
> --- a/include/xtables.h
> +++ b/include/xtables.h
> @@ -414,6 +414,18 @@ struct xtables_globals
>         int (*compat_rev)(const char *name, uint8_t rev, int opt);
>  };
>
> +/*
> + * enum op-
> + *
> + * For writing clean nftables translations code
> + */
> +
> +enum xt_op {
> +       XT_OP_EQ,
> +       XT_OP_NEQ,
> +       XT_OP_MAX,
> +};
> +
>  #define XT_GETOPT_TABLEEND {.name = NULL, .has_arg = false}
>
>  #ifdef __cplusplus
> --
> 1.9.1
>


Please apply this one before all others.
Thanks
