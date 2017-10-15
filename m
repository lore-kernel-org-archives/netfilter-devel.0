From: Aastha Gupta <aastha.gupta4104@gmail.com>
Subject: Re: [PATCH v3] iptables: iptables-compat translation for TCPMSS
Date: Sun, 15 Oct 2017 22:32:35 +0530
Message-ID: <CAHXiS5_GXmDNi32UaQEoP9u+ArcrL7PkcrQPQ39u38Qh1i6Hmg@mail.gmail.com>
References: <CAHXiS5-LAiGs7+5zs-VhOmW2WLCAsNsaQrWh+5=m8=JrcyWtRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: outreachy-kernel@googlegroups.com, netfilter-devel@vger.kernel.org,
        Aastha Gupta <aastha.gupta4104@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:38544 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbdJORCg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Oct 2017 13:02:36 -0400
Received: by mail-vk0-f67.google.com with SMTP id d12so3373315vkf.5
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Oct 2017 10:02:36 -0700 (PDT)
In-Reply-To: <CAHXiS5-LAiGs7+5zs-VhOmW2WLCAsNsaQrWh+5=m8=JrcyWtRw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 15, 2017 at 5:46 PM, Aastha Gupta
<aastha.gupta4104@gmail.com> wrote:
> Since path mtu support was added, we can now add
> iptables-compat translation for TCPMSS extension.
>
> Signed-off-by: Aastha Gupta <aastha.gupta4104@gmail.com>
> ---
> changes in v3:
>         - fixed alignment issues
>
>  extensions/libxt_TCPMSS.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
> index 4b71e44..0d9b200 100644
> --- a/extensions/libxt_TCPMSS.c
> +++ b/extensions/libxt_TCPMSS.c
> @@ -91,6 +91,19 @@ static void TCPMSS_save(const void *ip, const
> struct xt_entry_target *target)
>                 printf(" --set-mss %u", mssinfo->mss);
>  }
>
> +static int TCPMSS_xlate(struct xt_xlate *xl,
> +                       const struct xt_xlate_tg_params *params)
> +{
> +       const struct xt_tcpmss_info *mssinfo =
> +               (const struct xt_tcpmss_info *)params->target->data;
> +       if (mssinfo->mss == XT_TCPMSS_CLAMP_PMTU)
> +               xt_xlate_add(xl, "tcp option maxseg size set rt mtu");
> +       else
> +               xt_xlate_add(xl, "tcp option maxseg size set %d", mssinfo->mss);
> +
> +       return 1;
> +}
> +
>  static struct xtables_target tcpmss_tg_reg[] = {
>         {
>                 .family        = NFPROTO_IPV4,
> @@ -104,6 +117,7 @@ static struct xtables_target tcpmss_tg_reg[] = {
>                 .x6_parse      = TCPMSS_parse,
>                 .x6_fcheck     = TCPMSS_check,
>                 .x6_options    = TCPMSS4_opts,
> +              .xlate              = TCPMSS_xlate,
>         },
>         {
>                 .family        = NFPROTO_IPV6,
> --
> 2.7.4

Please ignore this patch as this patch really dosen't solve anything.
The v2 of this patch should be considered instead.

Aastha
