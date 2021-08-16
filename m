Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59CFC4320A
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 09:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB8E06113A
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 09:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhHPJGz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 05:06:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54592 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbhHPJGp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 05:06:45 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id B29DC6004F;
        Mon, 16 Aug 2021 11:05:13 +0200 (CEST)
Date:   Mon, 16 Aug 2021 11:05:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     alexandre.ferrieux@orange.com
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink_queue -- why linear lookup ?
Message-ID: <20210816090555.GA2364@salvia>
References: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
 <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
 <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
 <20210815130716.GA21655@salvia>
 <4942_1629034317_6119174D_4942_150_1_d69d3f05-89f7-63b5-4759-ef1987aca476@orange.com>
 <20210815141204.GA22946@salvia>
 <5337_1629053191_61196107_5337_107_1_13003d18-0f95-f798-db9d-7182114b90c6@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5337_1629053191_61196107_5337_107_1_13003d18-0f95-f798-db9d-7182114b90c6@orange.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 15, 2021 at 08:47:04PM +0200, alexandre.ferrieux@orange.com wrote:
> 
> 
> On 8/15/21 4:12 PM, Pablo Neira Ayuso wrote:
> > On Sun, Aug 15, 2021 at 03:32:30PM +0200, alexandre.ferrieux@orange.com wrote:
> >>
> > > [...] I was just worried that people would >> object to adding even the slightest overhead (hash_add/hash_del) to the
> > > existing code path, that satisfies 99% of uses (LIFO). What do you think ?
> > 
> > It should be possible to maintain both the list and the hashtable,
> > AFAICS, the batch callback still needs the queue_list.
> 
> Yes, but to maintain the hashtable, we need to bother the "normal" code path
> with hash_add/del. Not much, but still, some overhead...

Probably you can collect some numbers to make sure this is not a
theoretical issue.

> > > > > PS: what is the intended dominant use case for batch verdicts ?
> > > > > Issuing a batch containing several packets helps to amortize the
> > > > cost of the syscall.
> > > 
> > > Yes, but that could also be achieved by passing an array of ids.
> > 
> > You mean, one single sendmsg() with several netlink messages, that
> > would also work to achieve a similar batching effect.
> 
> Yes, a full spectrum of batching methods are possible. If we're to minimize
> the number of bytes crossing the kernel/user boundary though, an array of
> ids looks like the way to go (4 bytes per packet, assuming uint32 ids).

Are you proposing a new batching mechanism?

> > > The extra constraint of using a (contiguous) range means that there
> > > is no outlier.  This seems to imply that ranges are no help when
> > > flows are multiplexed. Or maybe, the assumption was that bursts tend
> > > to be homogeneous ?
> > 
> > What is your usecase?
> 
> For O(1) lookup:
> 
> My primary motivation is for transparent proxies and userland qdiscs. In
> both cases, specific packets must be held for some time and reinjected at a
> later time which is not computed by a simple, fixed delay, but rather
> triggered by some external event.
> 
> My secondary motivation is that the netfilter queue is a beautifully
> asynchronous mechanism, and absolutely nothing in its definition limits it
> to the dumb FIFO-of-instantaneous-drop-decisions that seems to dominate
> sample code.

I see. Thanks for telling me.

> For the deprecation of id-range-based batching:
> 
> It seems that as soon as two different packet streams are muxed in the
> queue, one deserving verdict A and the other verdict B, contiguous id ranges
> of a given verdict may be very small. But I realize I'm 20 years late to
> complain :)

As I said, you can place several netlink messages in one single
sendmsg() call, then they do not need to be contiguous.

> That being said, the Doxygen of the userland nfqueue API mentions being
> DEPRECATED... So what is the recommended replacement ?

What API are you refering to specifically?
