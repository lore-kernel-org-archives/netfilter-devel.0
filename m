Return-Path: <SRS0=C2Rd=CA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D961C433E1
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 18:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 334DB20714
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 18:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgHVSq2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Aug 2020 14:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgHVSq1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Aug 2020 14:46:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D0CC061573
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Aug 2020 11:46:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k9YWz-0000SY-6Z; Sat, 22 Aug 2020 20:46:21 +0200
Date:   Sat, 22 Aug 2020 20:46:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: nfnetlink: Busy-loop in nfnetlink_rcv_msg()
Message-ID: <20200822184621.GH15804@breakpoint.cc>
References: <20200821230615.GW23632@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821230615.GW23632@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Starting firewalld with two active zones in an lxc container provokes a
> situation in which nfnetlink_rcv_msg() loops indefinitely, because
> nc->call_rcu() (nf_tables_getgen() in this case) returns -EAGAIN every
> time.
> 
> I identified netlink_attachskb() as the originator for the above error
> code. The conditional leading to it looks like this:
> 
> | if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
> |      test_bit(NETLINK_S_CONGESTED, &nlk->state))) {
> |         [...]
> |         if (!*timeo) {
> 
> *timeo is zero, so this seems to be a non-blocking socket. Both
> NETLINK_S_CONGESTED bit is set and sk->sk_rmem_alloc exceeds
> sk->sk_rcvbuf.
> 
> From user space side, firewalld seems to simply call sendto() and the
> call never returns.
> 
> How to solve that? I tried to find other code which does the same, but I
> haven't found one that does any looping. Should nfnetlink_rcv_msg()
> maybe just return -EAGAIN to the caller if it comes from call_rcu
> backend?

Yes, I think thats the most straightforward solution.

We can of course also intercept -EAGAIN in nf_tables_api.c and translate
it to -ENOBUFS like in nft_get_set_elem().

But I think a generic solution it better.  The call_rcu backends should
not result in changes to nf_tables internal state so they do not load
modules and therefore don't need a restart.

> This happening only in an lxc container may be due to some setsockopt()
> calls not being allowed. In particular, setsockopt(SO_RCVBUFFORCE)
> returns EPERM.

Right.

> The value of sk_rcvbuf is 425984, BTW. sk_rmem_alloc is 426240. In user
> space, I see a call to setsockopt(SO_RCVBUF) with value 4194304. No idea
> if this is related and how.

Does that SO_RCVBUF succeed? How large is the recvbuf?
We should try to investigate and see that nft works rather than just
fix the loop and claim that fixes the bug (but just changes
'nft loops' to 'nft exits with an error').
