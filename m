From: James King <t.james.king@gmail.com>
Subject: Re: netfilter: xtables: Combine ipt_TTL and ip6t_HL source
Date: Tue, 20 Jan 2009 14:37:47 -0800
Message-ID: <38bcb3ec0901201437t6ba198c8w83ecea8e3e6d4cde@mail.gmail.com>
References: <alpine.LSU.2.00.0901201415470.16288@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:39678 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZATWhu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:37:50 -0500
Received: by ewy13 with SMTP id 13so1204793ewy.13
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2009 14:37:48 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0901201415470.16288@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 20, 2009 at 5:16 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
> parent b0b47dffd52c2eca62bc9a7d4fdf2cd4a2022e47 (v2.6.29-rc2-16-gb0b47df)
> commit 46094aad3697c8196da64c0d5bc64c8f14557fe1
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sun Jan 18 09:02:53 2009 +0100
>
> netfilter: xtables: Combine ipt_TTL and ip6t_HL source
>
> Suggested by: James King <t.james.king@gmail.com>
>
> Similarly to commit c9fd49680954714473d6cbd2546d6ff120f96840, merge
> TTL and HL. Since HL does not depend on any IPv6-specific function,
> no new module dependencies would arise.
>
> With slight adjustments to the Kconfig help text.
>
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---

> +static struct xt_target hl_tg_reg[] __read_mostly = {
> +       {
> +               .name       = "TTL",
> +               .revision   = 0,
> +               .family     = NFPROTO_IPV4,
> +               .target     = ttl_tg,
> +               .targetsize = sizeof(struct ipt_TTL_info),
> +               .table      = "mangle",
> +               .checkentry = ttl_tg_check,
> +               .me         = THIS_MODULE,
> +       },
> +       {
> +               .name       = "HL",
> +               .revision   = 0,
> +               .family     = NFPROTO_IPV6,
> +               .target     = hl_tg6,
> +               .targetsize = sizeof(struct ip6t_HL_info),
> +               .table      = "mangle",
> +               .checkentry = hl_tg6_check,
> +               .me         = THIS_MODULE,

Can we drop the mangle restriction at the same time?  Otherwise, looks
good to me.
