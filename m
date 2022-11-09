Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E98C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Nov 2022 17:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiKIRjR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 12:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiKIRjP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 12:39:15 -0500
X-Greylist: delayed 1918 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Nov 2022 09:39:09 PST
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E980E13CF5
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2022 09:39:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1osoXb-0004MN-Gj; Wed, 09 Nov 2022 18:07:07 +0100
Date:   Wed, 9 Nov 2022 18:07:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     pablo@netfilter.org, fw@strlen.de, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ctmark: Fix data-races around ctmark
Message-ID: <20221109170707.GA18993@breakpoint.cc>
References: <22e34710c6e22acc1139b8f8d0a8bd78cf5b64e5.1668012222.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22e34710c6e22acc1139b8f8d0a8bd78cf5b64e5.1668012222.git.dxu@dxuuu.xyz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Daniel Xu <dxu@dxuuu.xyz> wrote:
> index f97bda06d2a9..669561fb73bd 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1781,7 +1781,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
>  			}
>  
>  #ifdef CONFIG_NF_CONNTRACK_MARK
> -			ct->mark = exp->master->mark;
> +			WRITE_ONCE(ct->mark, READ_ONCE(exp->master->mark));

*ct is owned by the current cpu at this point, so WRITE_ONCE is not
needed.

Rest looks fine.
