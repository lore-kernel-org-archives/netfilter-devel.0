Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C252C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 21:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B0B92075E
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 21:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfE0V0M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 17:26:12 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37342 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726772AbfE0V0M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 17:26:12 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hVN8D-0000UQ-OB; Mon, 27 May 2019 23:26:09 +0200
Date:   Mon, 27 May 2019 23:26:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 2/4] netfilter: synproxy: remove module
 dependency on IPv6 SYNPROXY
Message-ID: <20190527212609.sigjj636awmagfww@breakpoint.cc>
References: <20190524170106.2686-1-ffmancera@riseup.net>
 <20190524170106.2686-3-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524170106.2686-3-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> This is a prerequisite for the new infrastructure module NF_SYNPROXY. The new
> module is needed to avoid duplicated code for the SYNPROXY nftables support.
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  include/linux/netfilter_ipv6.h | 17 +++++++++++++++++
>  net/ipv6/netfilter.c           |  1 +
>  2 files changed, 18 insertions(+)
> 
> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> index 12113e502656..549a5df39cf9 100644
> --- a/include/linux/netfilter_ipv6.h
> +++ b/include/linux/netfilter_ipv6.h
> @@ -8,6 +8,7 @@
>  #define __LINUX_IP6_NETFILTER_H
>  
>  #include <uapi/linux/netfilter_ipv6.h>
> +#include <net/tcp.h>
>  
>  /* Extra routing may needed on local out, as the QUEUE target never returns
>   * control to the table.
> @@ -34,6 +35,8 @@ struct nf_ipv6_ops {
>  		       struct in6_addr *saddr);
>  	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
>  		     bool strict);
> +	u32 (*cookie_init_sequence)(const struct ipv6hdr *iph,
> +				    const struct tcphdr *th, u16 *mssp);

This is good, but not enough:

/tmp/foo/./lib/modules/5.2.0-rc1+/kernel/net/netfilter/nf_synproxy.ko needs "__cookie_v6_check": /tmp/foo/./lib/modules/5.2.0-rc1+/kernel/net/ipv6/ipv6.ko

IOW, you need to also add the same trick for __cookie_v6_check.

Otherwise, an ipv4 only rule involving synproxy will pull in ipv6.ko
module.

> +static inline u32 nf_ipv6_cookie_init_sequence(const struct ipv6hdr *iph,
> +					       const struct tcphdr *th,
> +					       u16 *mssp)
> +{
> +#if IS_MODULE(CONFIG_IPV6)
> +	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
> +
> +	if (v6_ops)
> +		return v6_ops->cookie_init_sequence(iph, th, mssp);

This triggers a compiler warning for me, because return value is
undefined in !v6ops case.

I think you can just return 0 here for the !v6ops case.


