Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474BEC636D3
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Jan 2023 14:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjAaOS3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Jan 2023 09:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbjAaOST (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Jan 2023 09:18:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED414AA66;
        Tue, 31 Jan 2023 06:18:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pMrSh-00040e-4Q; Tue, 31 Jan 2023 15:18:15 +0100
Date:   Tue, 31 Jan 2023 15:18:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [RFC] bpf: add bpf_link support for BPF_NETFILTER programs
Message-ID: <20230131141815.GA6999@breakpoint.cc>
References: <20230130150432.24924-1-fw@strlen.de>
 <87zg9zx6ro.fsf@toke.dk>
 <20230130180115.GB12902@breakpoint.cc>
 <20230130214442.robf7ljttx5krjth@macbook-pro-6.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130214442.robf7ljttx5krjth@macbook-pro-6.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> Yes. bpf_link is the right model.
> I'd also allow more than one BPF_NETFILTER prog at the hook.
> When Daniel respins his tc bpf_link set there will be a way to do that
> for tc and hopefully soon for xdp.
> For netfilter hook we can use the same approach.

For nf it should already support several programs, the
builtin limit in the nf core is currently 1024 hooks per
family/hook location.

> > I could add a new nfnetlink subtype for nf-bpf if bpf_link is not
> > appropriate as an alternative.
> 
> Let's start with bpf_link and figure out netlink path when appropriate.

Good, that works for me.

> I'd steer clear from new abi-s.
> Don't look at uapi __sk_buff model. It's not a great example to follow.
> Just pass kernel nf_hook_state into bpf prog and let program deal
> with changes to it via CORE.

The current prototype for nf hooks is

fun(void *private, struct sk_buff *skb, struct nf_hook_state *s)

Originally I had intended to place sk_buff in nf_hook_state, but its
quite some code churn for everyone else.

So I'm leaning towards something like
	struct nf_bpf_ctx {
		struct nf_hook_state *state;
		struct sk_buff *skb;
	};

that gets passed as argument.

> The prog will get a defition of 'struct nf_hook_state' from vmlinux.h
> or via private 'struct nf_hook_state___flavor' with few fields defined
> that prog wants to use. CORE will deal with offset adjustments.
> That's a lot less kernel code. No need for asm style ctx rewrites.
> Just see how much kernel code we already burned on *convert_ctx_access().
> We cannot remove this tech debt due to uapi.
> When you pass struct nf_hook_state directly none of it is needed.

Ok, thanks for pointing that out.  I did not realize
convert_ctx_access() conversions were frowned upon.

I will pass a known/exposed struct then.

I thought __sk_buff was required for direct packet access, I will look
at this again.
