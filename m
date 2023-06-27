Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14AE1EB64D9
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jun 2023 11:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjF0LEN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jun 2023 07:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjF0LEN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2023 07:04:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EF91BE8;
        Tue, 27 Jun 2023 04:04:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qE6UK-0003PI-Kq; Tue, 27 Jun 2023 13:04:00 +0200
Date:   Tue, 27 Jun 2023 13:04:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     edumazet@google.com, dsahern@kernel.org, kuba@kernel.org,
        fw@strlen.de, pabeni@redhat.com, pablo@netfilter.org,
        davem@davemloft.net, kadlec@netfilter.org, daniel@iogearbox.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 3/7] netfilter: defrag: Add glue hooks for
 enabling/disabling defrag
Message-ID: <20230627110400.GG3207@breakpoint.cc>
References: <cover.1687819413.git.dxu@dxuuu.xyz>
 <66d1eaeb17721b1274eb4c1991a3725e47c912c5.1687819413.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66d1eaeb17721b1274eb4c1991a3725e47c912c5.1687819413.git.dxu@dxuuu.xyz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Daniel Xu <dxu@dxuuu.xyz> wrote:
> diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
> index e61ea428ea18..436e629b0969 100644
> --- a/net/ipv4/netfilter/nf_defrag_ipv4.c
> +++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
> @@ -7,6 +7,7 @@
>  #include <linux/ip.h>
>  #include <linux/netfilter.h>
>  #include <linux/module.h>
> +#include <linux/rcupdate.h>
>  #include <linux/skbuff.h>
>  #include <net/netns/generic.h>
>  #include <net/route.h>
> @@ -113,17 +114,24 @@ static void __net_exit defrag4_net_exit(struct net *net)
>  	}
>  }
>  
> +static struct nf_defrag_v4_hook defrag_hook = {
> +	.enable = nf_defrag_ipv4_enable,
> +	.disable = nf_defrag_ipv4_disable,
> +};

Nit: static const, same for v6.

>  static struct pernet_operations defrag4_net_ops = {
>  	.exit = defrag4_net_exit,
>  };
>  
>  static int __init nf_defrag_init(void)
>  {
> +	rcu_assign_pointer(nf_defrag_v4_hook, &defrag_hook);
>  	return register_pernet_subsys(&defrag4_net_ops);

register_pernet failure results in nf_defrag_v4_hook pointing to
garbage.
