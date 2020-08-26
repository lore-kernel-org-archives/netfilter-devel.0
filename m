Return-Path: <SRS0=uS4O=CE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9977C433E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Aug 2020 18:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C93E208E4
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Aug 2020 18:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHZSyl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Aug 2020 14:54:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22338 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726783AbgHZSyi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Aug 2020 14:54:38 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-bnIagJGbMmCDIZmKQKWqSw-1; Wed, 26 Aug 2020 14:54:26 -0400
X-MC-Unique: bnIagJGbMmCDIZmKQKWqSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48FD68015AA;
        Wed, 26 Aug 2020 18:54:25 +0000 (UTC)
Received: from localhost (ovpn-116-163.rdu2.redhat.com [10.10.116.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8051475261;
        Wed, 26 Aug 2020 18:54:24 +0000 (UTC)
Date:   Wed, 26 Aug 2020 14:54:23 -0400
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink: Busy-loop in nfnetlink_rcv_msg()
Message-ID: <20200826185423.5cqsybffo66jcoy7@egarver>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20200823115536.16631-1-pablo@netfilter.org>
 <20200823120434.GA16617@salvia>
 <20200822184621.GH15804@breakpoint.cc>
 <20200824131104.GC23632@orbyte.nwl.cc>
 <20200826153219.GA2640@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826153219.GA2640@salvia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 26, 2020 at 05:32:19PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Mon, Aug 24, 2020 at 03:11:04PM +0200, Phil Sutter wrote:
> [...]
> > On Sun, Aug 23, 2020 at 02:04:34PM +0200, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Sat, Aug 22, 2020 at 01:06:15AM +0200, Phil Sutter wrote:
> > > > Hi,
> > > > 
> > > > Starting firewalld with two active zones in an lxc container provokes a
> > > > situation in which nfnetlink_rcv_msg() loops indefinitely, because
> > > > nc->call_rcu() (nf_tables_getgen() in this case) returns -EAGAIN every
> > > > time.
> > > > 
> > > > I identified netlink_attachskb() as the originator for the above error
> > > > code. The conditional leading to it looks like this:
> > > > 
> > > > | if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
> > > > |      test_bit(NETLINK_S_CONGESTED, &nlk->state))) {
> > > > |         [...]
> > > > |         if (!*timeo) {
> > > > 
> > > > *timeo is zero, so this seems to be a non-blocking socket. Both
> > > > NETLINK_S_CONGESTED bit is set and sk->sk_rmem_alloc exceeds
> > > > sk->sk_rcvbuf.
> > > > 
> > > > From user space side, firewalld seems to simply call sendto() and the
> > > > call never returns.
> > > > 
> > > > How to solve that? I tried to find other code which does the same, but I
> > > > haven't found one that does any looping. Should nfnetlink_rcv_msg()
> > > > maybe just return -EAGAIN to the caller if it comes from call_rcu
> > > > backend?
> > > 
> > > It's a bug in the netlink frontend, which erroneously reports -EAGAIN
> > > to the nfnetlink when the socket buffer is full, see:
> > > 
> > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200823115536.16631-1-pablo@netfilter.org/
> > 
> > Obviously this avoids the lockup. As correctly assumed by Florian,
> > firewalld startup fails instead. (The daemon keeps running, but an error
> > message is printed indicating that initial ruleset setup failed.)
> 
> Thanks for confirming, I'll apply this patch to nf.git.
> 
> > [...]
> > > > The value of sk_rcvbuf is 425984, BTW. sk_rmem_alloc is 426240. In user
> > > > space, I see a call to setsockopt(SO_RCVBUF) with value 4194304. No idea
> > > > if this is related and how.
> > > 
> > > Next problem is to track why socket buffer is getting full with
> > > GET_GENID.
> > > 
> > > firewalld heavily uses NLM_F_ECHO, there I can see how it can easily
> > > reach the default socket buffer size, but with GET_GENID I'm not sure
> > > yet, probably the problem is elsewhere but it manifests in GET_GENID
> > > because it's the first thing that is done when sending a batch (maybe
> > > there are unread messages in the socket buffer, you might check
> > > /proc/net/netlink to see if the socket buffer keeps growing as
> > > firewalld moves on).
> > 
> > Yes, it happens only for echo mode. With your fix in place, I also see
> > what firewalld is trying to do: The JSON input leading to the error is
> > huge (~72k characters). I suspect that GET_GENID just happens to be the
> > last straw. Or my debugging was faulty somehow and netlink_attachskb()
> > really got called via a different code-path.
> > 
> > > Is this easy to reproduce? Or does this happens after some time of
> > > firewalld execution?
> > 
> > The necessary lxd setup aside, it's pretty trivial: launch an instance
> > of images:centos/8/amd64, install firewalld therein, add two zone files
> > and start firewalld. It happens immediately, so two active zones already
> > make firewalld generate enough rules to exceed the buffer space.
> > 
> > On Sun, Aug 23, 2020 at 01:55:36PM +0200, Pablo Neira Ayuso wrote:
> > > Frontend callback reports EAGAIN to nfnetlink to retry a command, this
> > > is used to signal that module autoloading is required. Unfortunately,
> > > nlmsg_unicast() reports EAGAIN in case the receiver socket buffer gets
> > > full, so it enters a busy-loop.
> > > 
> > > This patch updates nfnetlink_unicast() to turn EAGAIN into ENOBUFS and
> > > to use nlmsg_unicast(). Remove the flags field in nfnetlink_unicast()
> > > since this is always MSG_DONTWAIT in the existing code which is exactly
> > > what nlmsg_unicast() passes to netlink_unicast() as parameter.
> > > 
> > > Fixes: 96518518cc41 ("netfilter: add nftables")
> > > Reported-by: Phil Sutter <phil@nwl.cc>
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > This indeed "fixes" the problem. Or rather, exposes the actual problem
> > in echo-related code, namely the tendency to exhaust socket buffers.
> > 
> > So the problem we're facing is that while user space still waits for
> > sendmsg() to complete, receive buffer fills up. Is it possible to buffer
> > the data in kernel somewhere else so user space has a chance to call
> > recvmsg()?
> 
> There several possibilities, just a few that can be explored:
> 
> * I made a quick patch to batch several netlink messages coming as
>   reply to the NLM_F_ECHO request into one single skbuff. If you look
>   at the _notify() functions in the kernel, this is currently taking
>   one single skbuff for one message which adds a bit of overhead (the
>   skbuff truesize is used for the socket buffer accounting). I'm
>   measuring here on x86_64 that each command takes 768 bytes. With a
>   quick patch I'm batching several reply netlink messages into one
>   single skbuff, now each commands takes ~120 bytes (well, size
>   depends on how many expressions you use actually). This means this
>   can handle ~3550 commands vs. the existing ~555 commands (assuming
>   very small sk_rmem_alloc 426240 as the one you're reporting).
> 
>   Even if this does not fix your problem (you refer to 72k chars, not
>   sure how many commands this is), this is probably good to have
>   anyway, this decreasing memory consumption by 85%. This will also
>   make event reporting (monitor mode) more reliable through netlink
>   (it's the same codepath).
> 
>   Note that userspace requires no changes to support batching mode:
>   libmnl's mnl_cb_run() keeps iterating over the buffer that was
>   received until all netlink messages are consumed.
> 
>   The quick patch is incomplete, I just want to prove the saving in
>   terms of memory. I'll give it another spin and submit this for
>   review.
> 
> * Probably recover the cookie idea: firewalld specifies a cookie
>   that identifies the rule from userspace, so there is no need for
>   NLM_F_ECHO. Eric mentioned he would like to delete rules by cookie,
>   this should be possible by looking up for the handle from the
>   cookie to delete rules. The cookie is stored in NFTA_RULE_USERDATA
>   so this is only meaningful to userspace. No kernel changes are
>   required (this is supported for a bit of time already).

Good that it doesn't require a new kernel.

>   Note: The cookie could be duplicated. Since the cookie is allocated
>   by userspace, it's up to userspace to ensure uniqueness. In case
>   cookies are duplicated, if you delete a rule by cookie then

I think this is advantageous. It means a user/program can group rules
with a given cookie value.

>   Rule deletion by cookie requires dumping the whole ruleset though
>   (slow). However, I think firewalld keeps a rule cache, so it uses
>   the rule handle to delete the rule instead (no need to dump the
>   cache then). Therefore, the cookie is only used to fetch the rule
>   handle.
> 
>   With the rule cookie in place, firewalld can send the batch, then
>   make a NLM_F_DUMP request after sending the batch to retrieve the
>   handle from the cookie instead of using NLM_F_ECHO. The batch send +
>   NLM_F_DUMP barely consumes 16KBytes per recvmsg() call. The send +
>   dump is not atomic though.

NLM_F_DUMP has the downside that a single rule update means fetching the
whole rule set.

firewalld has a large batch when it starts up. After the initial startup
rule updates are generally small. I don't think NLM_F_DUMP is good for
firewalld's use case. The simpler solution would be for firewalld to
step the initial large batch, i.e. break it up into smaller batches.

>   Because NLM_F_ECHO is only used to get back the rule handle, right?

Right.

