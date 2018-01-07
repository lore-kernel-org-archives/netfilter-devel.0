From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [RFC PATCH] netfilter: nf_nat_snmp_basic: snmp_version() can be static
Date: Mon, 8 Jan 2018 00:17:24 +0900
Message-ID: <CAMArcTVnjhU46xJ0jJWrbStGuiU-Cy2BTe31-L0nqKOWPmgt6Q@mail.gmail.com>
References: <20171225150046.4227-1-ap420073@gmail.com> <20171226032557.GA27398@lkp-wsm-ep2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kbuild-all@01.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:32962 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752898AbeAGPR0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jan 2018 10:17:26 -0500
Received: by mail-qt0-f194.google.com with SMTP id e2so10988364qti.0
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jan 2018 07:17:25 -0800 (PST)
In-Reply-To: <20171226032557.GA27398@lkp-wsm-ep2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-12-26 12:25 GMT+09:00 kbuild test robot <lkp@intel.com>:
>
> Fixes: 499b2f89cea8 ("netfilter: nf_nat_snmp_basic: use asn1 decoder library")
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  nf_nat_snmp_basic_main.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
> index b6e2770..b16d3ad 100644
> --- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
> +++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
> @@ -101,8 +101,8 @@ static void fast_csum(struct snmp_ctx *ctx, unsigned char offset)
>                                              ~csum_unfold(*ctx->check)));
>  }
>
> -int snmp_version(void *context, size_t hdrlen, unsigned char tag,
> -                const void *data, size_t datalen)
> +static int snmp_version(void *context, size_t hdrlen, unsigned char tag,
> +                       const void *data, size_t datalen)
>  {
>         if (*(unsigned char *)data > 1)
>                 return -ENOTSUPP;

After this RFC, I found wrong code in my V4 patch
that is snmp_version() is not used.
I sent V5 patch that fixed this.

Thank you!
