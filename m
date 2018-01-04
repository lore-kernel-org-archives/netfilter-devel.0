From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [PATCH iptables] extensions: hashlimit: always print timeout on
 translations
Date: Thu, 4 Jan 2018 21:49:25 +1100
Message-ID: <20180104104925.GA7698@dimstar.local.net>
References: <20180104095547.5284-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40505 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753065AbeADMMc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jan 2018 07:12:32 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id DBC2C1044C3F
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2018 21:49:26 +1100 (AEDT)
Content-Disposition: inline
In-Reply-To: <20180104095547.5284-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 04, 2018 at 10:55:47AM +0100, Pablo Neira Ayuso wrote:
> Meters need an explicit timeout that we cannot skip, otherwise entries
> remain in the set forever.
>
> This fixes the following translation:
>
> $ iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
> --hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode
> srcip,dstport --hashlimit-name http2 --hashlimit-htable-expire 1000 -j
> DROP
>
> that was skipping the timeout option:
>
> nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport .
> ip saddr limit rate over 200 kbytes/second burst 1 mbytes}
> counter drop
>
> Reported-by: Duncan Roe <duncan_roe@optusnet.com.au>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  extensions/libxt_hashlimit.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
> index 3fa5719127db..f85f2d3a179a 100644
> --- a/extensions/libxt_hashlimit.c
> +++ b/extensions/libxt_hashlimit.c
> @@ -1341,8 +1341,7 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
>  	xt_xlate_add(xl, "flow table %s {", name);
>  	ret = hashlimit_mode_xlate(xl, cfg->mode, family,
>  				   cfg->srcmask, cfg->dstmask);
> -	if (cfg->expire != 1000)
> -		xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
> +	xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
>  	xt_xlate_add(xl, " limit rate");
>
>  	if (cfg->mode & XT_HASHLIMIT_INVERT)
> --
> 2.11.0
>
Hey Pablo,

After applying this latest patch:

> $ iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit --hashlimit-above 200/sec --hashlimit-mode srcip,dstport --hashlimit-name http1 -j DROP
> nft add rule ip filter INPUT tcp dport 80 flow table http1 { tcp dport . ip saddr timeout 1s limit rate over 200/second } counter drop

The spurious "timeout 1s" has re-appeared.

Sorry but ignoring default values is just a Bad Idea (tm).

You can either force a recognisable nonsense default (like 0, in the patch
below), or use flags in cfg (would need an extra __u8 in struct hashlimit_cfg3
to hold them).

This is the patch I submitted the other night (my time), but diffed against
commit 27de281d8aca84e3c841b3ae72a17616b1382ac4 (git diff -w). This is a simpler
diff than against HEAD:

> --- a/extensions/libxt_hashlimit.c
> +++ b/extensions/libxt_hashlimit.c
> @@ -759,15 +759,15 @@ static void hashlimit_mt_check(struct xt_fcheck_call *cb)
>  {
>         const struct hashlimit_mt_udata *udata = cb->udata;
>         struct xt_hashlimit_mtinfo3 *info = cb->data;
> +       uint32_t burst = 0;
>
>         if (!(cb->xflags & (F_UPTO | F_ABOVE)))
>                 xtables_error(PARAMETER_PROBLEM,
>                                 "You have to specify --hashlimit");
>         if (!(cb->xflags & F_HTABLE_EXPIRE))
> -               info->cfg.expire = udata->mult * 1000; /* from s to msec */
> +               info->cfg.expire = 0;
>
>         if (info->cfg.mode & XT_HASHLIMIT_BYTES) {
> -               uint32_t burst = 0;
>                 if (cb->xflags & F_BURST) {
>                         if (info->cfg.burst < cost_to_bytes(info->cfg.avg))
>                                 xtables_error(PARAMETER_PROBLEM,
> @@ -780,9 +780,9 @@ static void hashlimit_mt_check(struct xt_fcheck_call *cb)
>                         if (!(cb->xflags & F_HTABLE_EXPIRE))
>                                 info->cfg.expire = XT_HASHLIMIT_BYTE_EXPIRE_BURST * 1000;
>                 }
> -               info->cfg.burst = burst;
>         } else if (info->cfg.burst > XT_HASHLIMIT_BURST_MAX)
>                 burst_error();
> +       info->cfg.burst = burst;
>
>         if (cb->xflags & F_RATEMATCH) {
>                 if (!(info->cfg.mode & XT_HASHLIMIT_BYTES))
> @@ -1220,8 +1220,9 @@ static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
>                     _rates[i].mult / avg < _rates[i].mult % avg)
>                         break;
>
> -       xt_xlate_add(xl, " %llu/%s burst %lu packets",
> -                    _rates[i-1].mult / avg, _rates[i-1].name, burst);
> +       xt_xlate_add(xl, " %llu/%s", _rates[i-1].mult / avg, _rates[i-1].name);
> +       if (burst)
> +               xt_xlate_add(xl, " burst %lu packets", burst);
>  }
>
>  static void print_bytes_rate_xlate(struct xt_xlate *xl,
> @@ -1341,7 +1342,9 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
>         xt_xlate_add(xl, "flow table %s {", name);
>         ret = hashlimit_mode_xlate(xl, cfg->mode, family,
>                                    cfg->srcmask, cfg->dstmask);
> -       xt_xlate_add(xl, " timeout %us limit rate", cfg->expire / 1000);
> +       if (cfg->expire)
> +               xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
> +       xt_xlate_add(xl, " limit rate");
>
>         if (cfg->mode & XT_HASHLIMIT_INVERT)
>                 xt_xlate_add(xl, " over");

If you would rather leave default values as before, I can re-work it to use
flags instead.

Cheers ... Duncan.
