Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359B9C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 11:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1356F63213
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 11:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhHPLU3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 07:20:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55038 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhHPLU3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 07:20:29 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0D70560076;
        Mon, 16 Aug 2021 13:19:09 +0200 (CEST)
Date:   Mon, 16 Aug 2021 13:19:52 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     alexandre.ferrieux@orange.com
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink_queue -- why linear lookup ?
Message-ID: <20210816111952.GA13488@salvia>
References: <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
 <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
 <20210815130716.GA21655@salvia>
 <4942_1629034317_6119174D_4942_150_1_d69d3f05-89f7-63b5-4759-ef1987aca476@orange.com>
 <20210815141204.GA22946@salvia>
 <5337_1629053191_61196107_5337_107_1_13003d18-0f95-f798-db9d-7182114b90c6@orange.com>
 <20210816090555.GA2364@salvia>
 <19560_1629111179_611A438B_19560_274_1_0633ee7a-2660-91b4-f1d7-adc727864376@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19560_1629111179_611A438B_19560_274_1_0633ee7a-2660-91b4-f1d7-adc727864376@orange.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 16, 2021 at 12:53:33PM +0200, alexandre.ferrieux@orange.com wrote:
> 
> 
> On 8/16/21 11:05 AM, Pablo Neira Ayuso wrote:
> > On Sun, Aug 15, 2021 at 08:47:04PM +0200, alexandre.ferrieux@orange.com wrote:
> > > 
> > > 
> > > [...] to maintain the hashtable, we need to bother the "normal" code path
> > > with hash_add/del. Not much, but still, some overhead...
> > 
> > Probably you can collect some numbers to make sure this is not a
> > theoretical issue.
> 
> 'k, will do :)
> 
> > > Yes, a full spectrum of batching methods are possible. If we're to minimize
> > > the number of bytes crossing the kernel/user boundary though, an array of
> > > ids looks like the way to go (4 bytes per packet, assuming uint32 ids).
> > 
> > Are you proposing a new batching mechanism?
> 
> Well, the problem is backwards compatibility. Indeed I'd propose more
> flexible batching via an array of ids instead of a maxid. But the main added
> value of this flexibility is to enable reused-small-integers ids, like file
> descriptors. As long as the maxid API remains in place, this is impossible.

OK, I'll compare this to the sendmsg() call including several netlink
messages once you send your patch.

> > > That being said, the Doxygen of the userland nfqueue API mentions being
> > > DEPRECATED... So what is the recommended replacement ?
> > 
> > What API are you refering to specifically?
> 
> I'm referring to the nfq API documented here:
> 
> https://www.netfilter.org/projects/libnetfilter_queue/doxygen/html/group__Queue.html
> 
> It starts with "Queue handling [DEPRECATED]"...

libmnl is preferred these days, specifically for advanced stuff.

I've been getting reports from users about this old API: It is simple
enough and people don't have to deal with netlink details to get
packets from the kernel for simple stuff.

Probably we should turn this deprecation into using libmnl and the
helpers that libnetfilter_queue provides is recommended. Or translate
this old API to use libmnl behind the curtain.
