From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] netfilter: xtables: remove table restrictions from some modules
Date: Fri, 21 Dec 2012 11:19:05 +0100
Message-ID: <CAHo-OowdeVrzc8GfMes0y-LLpq4Kxei=nuGdih7hkyAvk3ahWw@mail.gmail.com>
References: <1355839621-14206-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: pablo@netfilter.org, jhs@mojatatu.com,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:58868 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2LUKq1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:46:27 -0500
Received: by mail-vb0-f54.google.com with SMTP id l1so4941492vba.27
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Dec 2012 02:46:26 -0800 (PST)
In-Reply-To: <1355839621-14206-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm not sure about the current state.
But there used to be code that would cause a mangle tables tos change
to trigger a reroute.
I'm guessing this wouldn't work if tos was changed from another table.

On Tue, Dec 18, 2012 at 3:07 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> I cannot think of a reason to limit the use of these modules to the
> "mangle" table or their hooks. TOS/DSCP is not only used to influence
> a routing decision, for example.
>
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>
> Are there any pitfalls I am not aware of?
> Could conntrack be upset if TCPOPTSTRIP/CHECKSUM can execute
> at different places?
>
>
>  net/ipv4/netfilter/ipt_ECN.c   |    1 -
>  net/netfilter/xt_CHECKSUM.c    |    1 -
>  net/netfilter/xt_CLASSIFY.c    |    3 ---
>  net/netfilter/xt_DSCP.c        |    4 ----
>  net/netfilter/xt_HL.c          |    2 --
>  net/netfilter/xt_TCPOPTSTRIP.c |    2 --
>  6 files changed, 13 deletions(-)
>
> diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
> index 4bf3dc4..5508113 100644
> --- a/net/ipv4/netfilter/ipt_ECN.c
> +++ b/net/ipv4/netfilter/ipt_ECN.c
> @@ -119,7 +119,6 @@ static struct xt_target ecn_tg_reg __read_mostly = {
>         .family         = NFPROTO_IPV4,
>         .target         = ecn_tg,
>         .targetsize     = sizeof(struct ipt_ECN_info),
> -       .table          = "mangle",
>         .checkentry     = ecn_tg_check,
>         .me             = THIS_MODULE,
>  };
> diff --git a/net/netfilter/xt_CHECKSUM.c b/net/netfilter/xt_CHECKSUM.c
> index 0f642ef..153d5c3 100644
> --- a/net/netfilter/xt_CHECKSUM.c
> +++ b/net/netfilter/xt_CHECKSUM.c
> @@ -51,7 +51,6 @@ static struct xt_target checksum_tg_reg __read_mostly = {
>         .family         = NFPROTO_UNSPEC,
>         .target         = checksum_tg,
>         .targetsize     = sizeof(struct xt_CHECKSUM_info),
> -       .table          = "mangle",
>         .checkentry     = checksum_tg_check,
>         .me             = THIS_MODULE,
>  };
> diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
> index af9c4da..c988093 100644
> --- a/net/netfilter/xt_CLASSIFY.c
> +++ b/net/netfilter/xt_CLASSIFY.c
> @@ -42,8 +42,6 @@ static struct xt_target classify_tg_reg[] __read_mostly = {
>                 .name       = "CLASSIFY",
>                 .revision   = 0,
>                 .family     = NFPROTO_UNSPEC,
> -               .hooks      = (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
> -                             (1 << NF_INET_POST_ROUTING),
>                 .target     = classify_tg,
>                 .targetsize = sizeof(struct xt_classify_target_info),
>                 .me         = THIS_MODULE,
> @@ -52,7 +50,6 @@ static struct xt_target classify_tg_reg[] __read_mostly = {
>                 .name       = "CLASSIFY",
>                 .revision   = 0,
>                 .family     = NFPROTO_ARP,
> -               .hooks      = (1 << NF_ARP_OUT) | (1 << NF_ARP_FORWARD),
>                 .target     = classify_tg,
>                 .targetsize = sizeof(struct xt_classify_target_info),
>                 .me         = THIS_MODULE,
> diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
> index ae82716..0a9ff64 100644
> --- a/net/netfilter/xt_DSCP.c
> +++ b/net/netfilter/xt_DSCP.c
> @@ -118,7 +118,6 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
>                 .checkentry     = dscp_tg_check,
>                 .target         = dscp_tg,
>                 .targetsize     = sizeof(struct xt_DSCP_info),
> -               .table          = "mangle",
>                 .me             = THIS_MODULE,
>         },
>         {
> @@ -127,14 +126,12 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
>                 .checkentry     = dscp_tg_check,
>                 .target         = dscp_tg6,
>                 .targetsize     = sizeof(struct xt_DSCP_info),
> -               .table          = "mangle",
>                 .me             = THIS_MODULE,
>         },
>         {
>                 .name           = "TOS",
>                 .revision       = 1,
>                 .family         = NFPROTO_IPV4,
> -               .table          = "mangle",
>                 .target         = tos_tg,
>                 .targetsize     = sizeof(struct xt_tos_target_info),
>                 .me             = THIS_MODULE,
> @@ -143,7 +140,6 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
>                 .name           = "TOS",
>                 .revision       = 1,
>                 .family         = NFPROTO_IPV6,
> -               .table          = "mangle",
>                 .target         = tos_tg6,
>                 .targetsize     = sizeof(struct xt_tos_target_info),
>                 .me             = THIS_MODULE,
> diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
> index 1535e87..4da5db3 100644
> --- a/net/netfilter/xt_HL.c
> +++ b/net/netfilter/xt_HL.c
> @@ -137,7 +137,6 @@ static struct xt_target hl_tg_reg[] __read_mostly = {
>                 .family     = NFPROTO_IPV4,
>                 .target     = ttl_tg,
>                 .targetsize = sizeof(struct ipt_TTL_info),
> -               .table      = "mangle",
>                 .checkentry = ttl_tg_check,
>                 .me         = THIS_MODULE,
>         },
> @@ -147,7 +146,6 @@ static struct xt_target hl_tg_reg[] __read_mostly = {
>                 .family     = NFPROTO_IPV6,
>                 .target     = hl_tg6,
>                 .targetsize = sizeof(struct ip6t_HL_info),
> -               .table      = "mangle",
>                 .checkentry = hl_tg6_check,
>                 .me         = THIS_MODULE,
>         },
> diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
> index 25fd1c4..b42c02e 100644
> --- a/net/netfilter/xt_TCPOPTSTRIP.c
> +++ b/net/netfilter/xt_TCPOPTSTRIP.c
> @@ -103,7 +103,6 @@ static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
>         {
>                 .name       = "TCPOPTSTRIP",
>                 .family     = NFPROTO_IPV4,
> -               .table      = "mangle",
>                 .proto      = IPPROTO_TCP,
>                 .target     = tcpoptstrip_tg4,
>                 .targetsize = sizeof(struct xt_tcpoptstrip_target_info),
> @@ -113,7 +112,6 @@ static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
>         {
>                 .name       = "TCPOPTSTRIP",
>                 .family     = NFPROTO_IPV6,
> -               .table      = "mangle",
>                 .proto      = IPPROTO_TCP,
>                 .target     = tcpoptstrip_tg6,
>                 .targetsize = sizeof(struct xt_tcpoptstrip_target_info),
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
