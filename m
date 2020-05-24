Return-Path: <SRS0=wFQz=7G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3219C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 20:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7AB3207D8
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 20:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388065AbgEXUgk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 May 2020 16:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387641AbgEXUgk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 May 2020 16:36:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ED3C061A0E
        for <netfilter-devel@vger.kernel.org>; Sun, 24 May 2020 13:36:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jcxMM-0007VP-Nq; Sun, 24 May 2020 22:36:38 +0200
Date:   Sun, 24 May 2020 22:36:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, mkubecek@suse.cz,
        jacobraz@chromium.org, fw@strlen.de
Subject: Re: [PATCH nf 1/2] netfilter: conntrack: make conntrack userspace
 helpers work again
Message-ID: <20200524203638.GB2915@breakpoint.cc>
References: <20200524195410.28502-1-pablo@netfilter.org>
 <20200524195410.28502-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524195410.28502-2-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Florian Westphal says:
> 
> "Problem is that after the helper hook was merged back into the confirm
> one, the queueing itself occurs from the confirm hook, i.e. we queue
> from the last netfilter callback in the hook-list.
> 
> Therefore, on return, the packet bypasses the confirm action and the
> connection is never committed to the main conntrack table.
> 
> Therefore, on return, the packet bypasses the confirm action and the
> connection is never committed to the main conntrack table.
> 
> To fix this there are several ways:
> 1. revert the 'Fixes' commit and have a extra helper hook again.
>    Works, but has the drawback of adding another indirect call for
>    everyone.
> 
> 2. Special case this: split the hooks only when userspace helper
>    gets added, so queueing occurs at a lower priority again,
>    and normal nqueue reinject would eventually call the last hook.
> 
> 3. Extend the existing nf_queue ct update hook to allow a forced
>    confirmation (plus run the seqadj code).
> 
> This goes for 3)."
> 
> Fixes: 827318feb69cb ("netfilter: conntrack: remove helper hook again")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> + * processing after the helper invocation in nf_confirm().
> + */
> +static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
> +			       enum ip_conntrack_info ctinfo)
> +{
> +	const struct nf_conntrack_helper *helper;
> +	const struct nf_conn_help *help;
> +	unsigned int protoff;
> +
> +	help = nfct_help(ct);
> +	if (!help)
> +		return 0;
> +
> +	helper = rcu_dereference(help->helper);
> +	if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
> +		return 0;

Relying on this check means that in case of

... -j CT (assign userspace helper)
... -j NFQUEUE

> +	/* We've seen it coming out the other side: confirm it */
> +	return nf_conntrack_confirm(skb) == NF_DROP ? - 1 : 0;
> +}

> +static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
> +{
[..]
> +	err = nf_confirm_cthelper(skb, ct, ctinfo);
> +	if (err < 0)
> +		return err;
> +
> +	if (nf_ct_is_confirmed(ct))
> +		return 0;

This means that in case of userspace helper, we return here
any bypass the __nf_conntrack_update logic.

I don't think thats a problem either given the userspace
helper presence, so

Acked-by: Florian Westphal <fw@strlen.de>
