Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E2FC77B7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Apr 2023 06:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjDSGRa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Apr 2023 02:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjDSGR2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2023 02:17:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714204200
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2023 23:17:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pp187-0000u3-Bu; Wed, 19 Apr 2023 08:17:23 +0200
Date:   Wed, 19 Apr 2023 08:17:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        stgraber@stgraber.org
Subject: Re: [PATCH nf] netfilter: conntrack: restore IPS_CONFIRMED out of
 nf_conntrack_hash_check_insert()
Message-ID: <20230419061723.GF21058@breakpoint.cc>
References: <20230418214024.14653-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230418214024.14653-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> e6d57e9ff0ae ("netfilter: conntrack: fix rmmod double-free race")
> consolidates IPS_CONFIRMED bit set in nf_conntrack_hash_check_insert().
> However, this breaks ctnetlink:
> 
>  # conntrack -I -p tcp --timeout 123 --src 1.2.3.4 --dst 5.6.7.8 --state ESTABLISHED --sport 1 --dport 4 -u SEEN_REPLY
>  conntrack v1.4.6 (conntrack-tools): Operation failed: Device or resource busy
> 
> This is a partial revert of the aforementioned commit.
> 
> Fixes: e6d57e9ff0ae ("netfilter: conntrack: fix rmmod double-free race")
> Reported-by: Stéphane Graber <stgraber@stgraber.org>
> Tested-by: Stéphane Graber <stgraber@stgraber.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_conntrack_bpf.c     | 1 +
>  net/netfilter/nf_conntrack_core.c    | 1 -
>  net/netfilter/nf_conntrack_netlink.c | 3 +++
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index bfc3aaa2c872..d3ee18854698 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2316,6 +2316,9 @@ ctnetlink_create_conntrack(struct net *net,
>  	nfct_seqadj_ext_add(ct);
>  	nfct_synproxy_ext_add(ct);
>  
> +	/* we must add conntrack extensions before confirmation. */
> +	ct->status |= IPS_CONFIRMED;
> +

I'd guess that these 2 lines are the only part that is needed, but up
to you.
