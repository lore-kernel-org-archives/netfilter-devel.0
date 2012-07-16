From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] extensions: add HMARK target
Date: Mon, 16 Jul 2012 14:22:33 +0200
Message-ID: <20120716122233.GA15107@1984>
References: <tqndgm6.1b88e2552b09f599e7127d46418a73b3@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35006 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab2GPMWh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:22:37 -0400
Content-Disposition: inline
In-Reply-To: <tqndgm6.1b88e2552b09f599e7127d46418a73b3@obelix.schillstrom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 15, 2012 at 12:53:46AM +0200, Hans Schillstrom wrote:
[...]
> >I'll be OK to make --hmark-offset mandatory, BTW.
>
> Well,  if people use it to other things than PBR it will be bad to have it mandatory
> so I think we leave it as it is.

Sorry, I missed this mail and pushed this into master. Already made it
mandatory. Send me a patch if you want to relax this.  I'll apply it.

> I don't like is that MODE_L3 is gone
> L3 can be substituted by using --hamrk-tuple src, dst. so that might be OK
> but there is no flag set. (causing a lot of extra cpu cycles)

This saves cycles for some specific case, but at the cost of adding
some branch misprediction in other case (ie. more cycles in other
cases). If we aim to genericity, we have to remove it.

BTW, I'd like to see some follow-up patch to support ICMP. We can just
generate the hash mark it using the src,dst,proto parts. That should
be easy.

> All masks have gone from set to  zero, (due to hmark-tuple ?)
> If it's more clear or not , I don't know  but the man page needs to be updated
>  --hmark-tuple ct alone doesn't do much.

You're right, I fixed this in a follow-up patch now in master.

> iptables \-t mangle \-A PREROUTING \-m state \-\-state NEW
> - \-j HMARK \-\-hmark-tuple ct \-\-hmark-offset 10000 \-\-hmark\-mod 10
> change to
> + \-j HMARK \-\-hmark-tuple ct,src,dst \-\-hmark-offset 10000 \-\-hmark\-mod 10
> \-\-hmark\-rnd 0xfeedcafe
> 
> Some faults found during my first sanity check.
> (I have not run any real tests so far, just some manual command  tests
> Due to the new behaviour and syntax the test suite needs some update)

I've applied this patch below. Please, add description next time.

> diff --git a/extensions/libxt_HMARK.c b/extensions/libxt_HMARK.c
> index ee2629d..053bc10 100644
> --- a/extensions/libxt_HMARK.c
> +++ b/extensions/libxt_HMARK.c
> @@ -280,15 +280,15 @@ static void HMARK_check(struct xt_fcheck_call *cb)
>  
>  static void HMARK_print(const struct xt_hmark_info *info)
>  {
> -       if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPORT))
> +       if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPORT_MASK))
>                 printf("sport-mask 0x%x ", htons(info->port_mask.p16.src));
> -       if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT))
> +       if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT_MASK))
>                 printf("dport-mask 0x%x ", htons(info->port_mask.p16.dst));
>         if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI))
>                 printf("spi-mask 0x%x ", htonl(info->port_mask.v32));
> -       if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPORT_MASK))
> +       if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPORT))
>                 printf("sport-set 0x%x ", htons(info->port_set.p16.src));
> -       if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT_MASK))
> +       if (info->flags & XT_HMARK_FLAG(XT_HMARK_DPORT))
>                 printf("dport-set 0x%x ", htons(info->port_set.p16.dst));
>         if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI_MASK))
>                 printf("spi-set 0x%x ", htonl(info->port_set.v32));
> @@ -333,11 +333,11 @@ static void HMARK_ip4_print(const void *ip,
>         if (info->flags & XT_HMARK_FLAG(XT_HMARK_CT))
>                 printf("ct, ");
>         if (info->flags & XT_HMARK_FLAG(XT_HMARK_SADDR_MASK))
> -               printf("src-prefix %s ",
> -                      xtables_ipmask_to_numeric(&info->src_mask.in) + 1);
> +               printf("src-prefix %d ",
> +                      xtables_ipmask_to_cidr(&info->src_mask.in));
>         if (info->flags & XT_HMARK_FLAG(XT_HMARK_DADDR_MASK))
> -               printf("dst-prefix %s ",
> -                      xtables_ipmask_to_numeric(&info->dst_mask.in) + 1);
> +               printf("dst-prefix %d ",
> +                      xtables_ipmask_to_cidr(&info->dst_mask.in));
>         HMARK_print(info);
>  }
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
