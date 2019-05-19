Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9B1C04AB4
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 21:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33F8720675
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 21:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfESVMJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 17:12:09 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54034 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbfESVMJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 17:12:09 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hST6F-0004ph-2u; Sun, 19 May 2019 23:12:07 +0200
Date:   Sun, 19 May 2019 23:12:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 2/4] netfilter: synproxy: remove module
 dependency on IPv6 SYNPROXY
Message-ID: <20190519211207.mi3mbgtjcsbijsve@breakpoint.cc>
References: <20190519205259.2821-1-ffmancera@riseup.net>
 <20190519205259.2821-3-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519205259.2821-3-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> This is a prerequisite for the new infrastructure module NF_SYNPROXY. The new
> module is needed to avoid duplicated code for the SYNPROXY nftables support.
> 
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  include/linux/netfilter_ipv6.h | 3 +++
>  net/ipv6/netfilter.c           | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> index 12113e502656..f440aaade612 100644
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
> @@ -35,6 +36,8 @@ struct nf_ipv6_ops {
>  	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
>  		     bool strict);
>  #endif
> +	u32 (*cookie_init_sequence)(const struct ipv6hdr *iph,
> +				    const struct tcphdr *th, u16 *mssp);

Could you place this above, in the #endif block?

You will need to create a helper as well:
static inline u32 nf_ipv6_cookie_init_sequence(const struct ipv6hdr *iph,
					       const struct tcphdr *th,
					       u16 *mssp)
{
#if IS_MODULE(CONFIG_IPV6)
	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();

	if (v6_ops)
		return v6_ops->cookie_init_sequence(iph, th, mssp);
#else
	return __cookie_v6_init_sequence(iph, th, mssp);
#endif
}

This way, when ipv6 is built-in, then we don't have the indirection
if netfilter uses the nf_ipv6_cookie_init_sequence() helper.

Also, can you check that if using CONFIG_IPV6=m then
"modinfo nf_synproxy" won't list ipv6 as a a module depencency?

If it does, there is another symbol that pulls in ipv6 (depmod will
say which one).

Thanks!
