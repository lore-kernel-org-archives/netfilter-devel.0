Return-Path: <SRS0=JGmF=W2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B3DC3A59B
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 20:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39B8523429
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 20:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfH3Uzv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 16:55:51 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:58868 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727992AbfH3Uzv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 16:55:51 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i3nvp-0006RE-4L; Fri, 30 Aug 2019 22:55:41 +0200
Date:   Fri, 30 Aug 2019 22:55:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 2/2] net: br_netfiler_hooks: Drops IPv6 packets if
 IPv6 module is not loaded
Message-ID: <20190830205541.GR20113@breakpoint.cc>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
 <20190830181354.26279-3-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830181354.26279-3-leonardo@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Leonardo Bras <leonardo@linux.ibm.com> wrote:
> A kernel panic can happen if a host has disabled IPv6 on boot and have to
> process guest packets (coming from a bridge) using it's ip6tables.
> 
> IPv6 packets need to be dropped if the IPv6 module is not loaded.
> 
> Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
> ---
>  net/bridge/br_netfilter_hooks.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index d3f9592f4ff8..5e8693730df1 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -493,6 +493,8 @@ static unsigned int br_nf_pre_routing(void *priv,
>  	brnet = net_generic(state->net, brnf_net_id);
>  	if (IS_IPV6(skb) || is_vlan_ipv6(skb, state->net) ||
>  	    is_pppoe_ipv6(skb, state->net)) {
> +		if (!ipv6_mod_enabled())
> +			return NF_DROP;
>  		if (!brnet->call_ip6tables &&
>  		    !br_opt_get(br, BROPT_NF_CALL_IP6TABLES))
>  			return NF_ACCEPT;

No, thats too aggressive and turns the bridge into an ipv6 blackhole.

There are two solutions:
1. The above patch, but use NF_ACCEPT instead
2. keep the DROP, but move it below the call_ip6tables test,
   so that users can tweak call-ip6tables to accept packets.

Perhaps it would be good to also add a pr_warn_once() that
tells that ipv6 was disabled on command line and
call-ip6tables isn't supported in this configuration.

I would go with option two.
