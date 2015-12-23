From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_MARK: Add translation to nft
Date: Wed, 23 Dec 2015 21:08:39 +0530
Message-ID: <CAKHNQQEqnUejMapByGwqr+Lhh5Q+Hsd=As9qeTHrEihQWDCW2Q@mail.gmail.com>
References: <20151223153353.GA17748@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36577 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbbLWPjA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 10:39:00 -0500
Received: by mail-wm0-f47.google.com with SMTP id p187so150917030wmp.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 07:38:59 -0800 (PST)
In-Reply-To: <20151223153353.GA17748@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 9:03 PM, Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> Add translation for target MARK to nftables.
>
> Examples:
>
> $ sudo iptables-translate -t mangle -A PREROUTING -j MARK --set-mark 12
> nft add rule ip mangle PREROUTING counter mark set 0xc
>
> $ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 22 -j MARK --set-mark 2
> nft add rule ip mangle PREROUTING tcp dport 22 counter mark set 0x2
>
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libxt_MARK.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
> index 556dbde..c5de763 100644
> --- a/extensions/libxt_MARK.c
> +++ b/extensions/libxt_MARK.c
> @@ -242,7 +242,24 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
>  {
>         const struct xt_mark_tginfo2 *info = (const void *)target->data;
>
> -       printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
> +       printf(" --set mark 0x%x/0x%x", info->mark, info->mask);
> +}
> +
> +static void
> +print_mark_xlate(unsigned long mark, struct xt_buf *buf)
> +{
> +       xt_buf_add(buf, " 0x%lx", mark);
> +}
> +
> +static int mark_tg_xlate(const struct xt_entry_target *target,
> +                         struct xt_buf *buf, int numeric)
> +{
> +       const struct xt_mark_tginfo2 *info = (const void *)target->data;
> +
> +       xt_buf_add(buf, "mark set");
> +       print_mark_xlate(info->mark, buf);
> +
> +       return 1;
>  }
>
>  static struct xtables_target mark_tg_reg[] = {
> @@ -259,6 +276,7 @@ static struct xtables_target mark_tg_reg[] = {
>                 .x6_parse      = MARK_parse_v0,
>                 .x6_fcheck     = MARK_check,
>                 .x6_options    = MARK_opts,
> +               .xlate         = mark_tg_xlate,
>         },
>         {
>                 .family        = NFPROTO_IPV4,
> @@ -273,6 +291,7 @@ static struct xtables_target mark_tg_reg[] = {
>                 .x6_parse      = MARK_parse_v1,
>                 .x6_fcheck     = MARK_check,
>                 .x6_options    = MARK_opts,
> +               .xlate         = mark_tg_xlate,
>         },
>         {
>                 .version       = XTABLES_VERSION,
> @@ -287,6 +306,7 @@ static struct xtables_target mark_tg_reg[] = {
>                 .x6_parse      = mark_tg_parse,
>                 .x6_fcheck     = mark_tg_check,
>                 .x6_options    = mark_tg_opts,
> +               .xlate         = mark_tg_xlate,
>         },
>  };
>
> --
> 1.9.1
>

Hi,

I'm unsure if the options or-set, and-set are supported in nftables. I
cannot find much about them. Please let me know if there are
translations corresponding to these options as well, I'll send another
patch then.

Thank you
