Return-Path: <SRS0=keFs=CC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962DFC433E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Aug 2020 13:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E8862074D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Aug 2020 13:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgHXNLP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Aug 2020 09:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgHXNLN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Aug 2020 09:11:13 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237F6C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2020 06:11:12 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kACFc-0004Gx-Se; Mon, 24 Aug 2020 15:11:04 +0200
Date:   Mon, 24 Aug 2020 15:11:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink: Busy-loop in nfnetlink_rcv_msg()
Message-ID: <20200824131104.GC23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823115536.16631-1-pablo@netfilter.org>
 <20200823120434.GA16617@salvia>
 <20200822184621.GH15804@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sat, Aug 22, 2020 at 08:46:21PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
[...]
> > The value of sk_rcvbuf is 425984, BTW. sk_rmem_alloc is 426240. In user
> > space, I see a call to setsockopt(SO_RCVBUF) with value 4194304. No idea
> > if this is related and how.
> 
> Does that SO_RCVBUF succeed? How large is the recvbuf?
> We should try to investigate and see that nft works rather than just
> fix the loop and claim that fixes the bug (but just changes
> 'nft loops' to 'nft exits with an error').

Yes, that call succeeds. A following getsockopt() reveals a bufsize of
425984. Should we print a warning if the kernel accepts but restricts
the value? Not sure how well warnings work when emitted by libnftables,
though.

In mnl_nft_event_listener(), we check the return value of
mnl_set_rcvbuffer() and print an error message:

| nft_print(octx, "# Cannot set up netlink receive socket buffer size to %u bytes, falling back to %u bytes\n",
|                           NFTABLES_NLEVENT_BUFSIZ, bufsiz);

When called from mnl_batch_talk(), the return code is ignored.

On Sun, Aug 23, 2020 at 02:04:34PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Sat, Aug 22, 2020 at 01:06:15AM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > Starting firewalld with two active zones in an lxc container provokes a
> > situation in which nfnetlink_rcv_msg() loops indefinitely, because
> > nc->call_rcu() (nf_tables_getgen() in this case) returns -EAGAIN every
> > time.
> > 
> > I identified netlink_attachskb() as the originator for the above error
> > code. The conditional leading to it looks like this:
> > 
> > | if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
> > |      test_bit(NETLINK_S_CONGESTED, &nlk->state))) {
> > |         [...]
> > |         if (!*timeo) {
> > 
> > *timeo is zero, so this seems to be a non-blocking socket. Both
> > NETLINK_S_CONGESTED bit is set and sk->sk_rmem_alloc exceeds
> > sk->sk_rcvbuf.
> > 
> > From user space side, firewalld seems to simply call sendto() and the
> > call never returns.
> > 
> > How to solve that? I tried to find other code which does the same, but I
> > haven't found one that does any looping. Should nfnetlink_rcv_msg()
> > maybe just return -EAGAIN to the caller if it comes from call_rcu
> > backend?
> 
> It's a bug in the netlink frontend, which erroneously reports -EAGAIN
> to the nfnetlink when the socket buffer is full, see:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200823115536.16631-1-pablo@netfilter.org/

Obviously this avoids the lockup. As correctly assumed by Florian,
firewalld startup fails instead. (The daemon keeps running, but an error
message is printed indicating that initial ruleset setup failed.)

[...]
> > The value of sk_rcvbuf is 425984, BTW. sk_rmem_alloc is 426240. In user
> > space, I see a call to setsockopt(SO_RCVBUF) with value 4194304. No idea
> > if this is related and how.
> 
> Next problem is to track why socket buffer is getting full with
> GET_GENID.
> 
> firewalld heavily uses NLM_F_ECHO, there I can see how it can easily
> reach the default socket buffer size, but with GET_GENID I'm not sure
> yet, probably the problem is elsewhere but it manifests in GET_GENID
> because it's the first thing that is done when sending a batch (maybe
> there are unread messages in the socket buffer, you might check
> /proc/net/netlink to see if the socket buffer keeps growing as
> firewalld moves on).

Yes, it happens only for echo mode. With your fix in place, I also see
what firewalld is trying to do: The JSON input leading to the error is
huge (~72k characters). I suspect that GET_GENID just happens to be the
last straw. Or my debugging was faulty somehow and netlink_attachskb()
really got called via a different code-path.

> Is this easy to reproduce? Or does this happens after some time of
> firewalld execution?

The necessary lxd setup aside, it's pretty trivial: launch an instance
of images:centos/8/amd64, install firewalld therein, add two zone files
and start firewalld. It happens immediately, so two active zones already
make firewalld generate enough rules to exceed the buffer space.

On Sun, Aug 23, 2020 at 01:55:36PM +0200, Pablo Neira Ayuso wrote:
> Frontend callback reports EAGAIN to nfnetlink to retry a command, this
> is used to signal that module autoloading is required. Unfortunately,
> nlmsg_unicast() reports EAGAIN in case the receiver socket buffer gets
> full, so it enters a busy-loop.
> 
> This patch updates nfnetlink_unicast() to turn EAGAIN into ENOBUFS and
> to use nlmsg_unicast(). Remove the flags field in nfnetlink_unicast()
> since this is always MSG_DONTWAIT in the existing code which is exactly
> what nlmsg_unicast() passes to netlink_unicast() as parameter.
> 
> Fixes: 96518518cc41 ("netfilter: add nftables")
> Reported-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

This indeed "fixes" the problem. Or rather, exposes the actual problem
in echo-related code, namely the tendency to exhaust socket buffers.

So the problem we're facing is that while user space still waits for
sendmsg() to complete, receive buffer fills up. Is it possible to buffer
the data in kernel somewhere else so user space has a chance to call
recvmsg()?

Thanks, Phil
