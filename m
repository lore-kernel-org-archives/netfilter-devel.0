Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D357DC4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Aug 2021 21:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B098660EE2
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Aug 2021 21:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhHNVBe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Aug 2021 17:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhHNVBe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Aug 2021 17:01:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DF0C061764
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Aug 2021 14:01:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mF0m7-0005AA-UR; Sat, 14 Aug 2021 23:01:03 +0200
Date:   Sat, 14 Aug 2021 23:01:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     alexandre.ferrieux@orange.com
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink_queue -- why linear lookup ?
Message-ID: <20210814210103.GG607@breakpoint.cc>
References: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

alexandre.ferrieux@orange.com <alexandre.ferrieux@orange.com> wrote:
>   find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
>   {
>     ...
>     list_for_each_entry(i, &queue->queue_list, list) {
>       if (i->id == id) {
>         entry = i;
>         break;
>       }
>     }
>     ...
>   }
> 
> As a result, in a situation of "highly asynchronous" verdicts, i.e. when we
> want some packets to linger in the queue for some time before reinjection,
> the mere existence of a large number of such "old packets" may incur a
> nonnegligible cost to the system.
> 
> So I'm wondering: why is the list implemented as a simple linked list
> instead of an array directly indexed by the id (like file descriptors) ?

Because when this was implemented "highly asynchronous" was not on the
radar.  All users of this (that I know of) do in-order verdicts.
