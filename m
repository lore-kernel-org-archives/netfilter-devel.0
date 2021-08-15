Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511FBC4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 14:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26C32610FD
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 14:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhHOOMm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 10:12:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53380 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhHOOMk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 10:12:40 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2FB576005D;
        Sun, 15 Aug 2021 16:11:23 +0200 (CEST)
Date:   Sun, 15 Aug 2021 16:12:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     alexandre.ferrieux@orange.com
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink_queue -- why linear lookup ?
Message-ID: <20210815141204.GA22946@salvia>
References: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
 <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
 <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
 <20210815130716.GA21655@salvia>
 <4942_1629034317_6119174D_4942_150_1_d69d3f05-89f7-63b5-4759-ef1987aca476@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4942_1629034317_6119174D_4942_150_1_d69d3f05-89f7-63b5-4759-ef1987aca476@orange.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 15, 2021 at 03:32:30PM +0200, alexandre.ferrieux@orange.com wrote:
> On 8/15/21 3:07 PM, Pablo Neira Ayuso wrote:
> > On Sun, Aug 15, 2021 at 02:17:08PM +0200, alexandre.ferrieux@orange.com wrote:
> > [...]
> > > So, the only way forward would be a separate hashtable on ids.
> > 
> > Using the rhashtable implementation is fine for this, it's mostly
> > boilerplate code that is needed to use it and there are plenty of
> > examples in the kernel tree if you need a reference.
> 
> Thanks, that's indeed pretty simple. I was just worried that people would
> object to adding even the slightest overhead (hash_add/hash_del) to the
> existing code path, that satisfies 99% of uses (LIFO). What do you think ?

It should be possible to maintain both the list and the hashtable,
AFAICS, the batch callback still needs the queue_list.

> > > PS: what is the intended dominant use case for batch verdicts ?
> > 
> > Issuing a batch containing several packets helps to amortize the
> > cost of the syscall.
> 
> Yes, but that could also be achieved by passing an array of ids.

You mean, one single sendmsg() with several netlink messages, that
would also work to achieve a similar batching effect.

> The extra constraint of using a (contiguous) range means that there
> is no outlier.  This seems to imply that ranges are no help when
> flows are multiplexed. Or maybe, the assumption was that bursts tend
> to be homogeneous ?

What is your usecase?
