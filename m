Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980B7C678D4
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Mar 2023 09:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCCJlk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Mar 2023 04:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCCJlk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2023 04:41:40 -0500
Received: from mail.balasys.hu (mail.balasys.hu [185.199.30.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25D61B2E1
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2023 01:41:38 -0800 (PST)
Received: from [10.90.100.85] (unknown [10.90.100.85])
        by mail.balasys.hu (Postfix) with ESMTPSA id 40AEE2B4A31;
        Fri,  3 Mar 2023 10:41:37 +0100 (CET)
Message-ID: <31f0312c-7410-dbcd-4c35-5adbc036714c@balasys.hu>
Date:   Fri, 3 Mar 2023 10:41:37 +0100
MIME-Version: 1.0
Subject: Re: CPU soft lockup in a spin lock using tproxy and nfqueue
Content-Language: hu-HU
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <401bd6ed-314a-a196-1cdc-e13c720cc8f2@balasys.hu>
 <20230302142946.GB309@breakpoint.cc>
 <f8d03b81-8980-b54e-a2a3-57f8e54044be@balasys.hu>
 <20230303000926.GC9239@breakpoint.cc>
 <374ce7bf-e953-ab61-15ac-d99efce9152d@balasys.hu>
 <20230303093310.GC20617@breakpoint.cc>
From:   =?UTF-8?Q?Major_D=c3=a1vid?= <major.david@balasys.hu>
In-Reply-To: <20230303093310.GC20617@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 3/3/23 10:33, Florian Westphal wrote:
>>
>> I just thought that tcp_timewait_state_process is called by TCP stack to
>> handle TW state, which actually call inet_twsk_deschedule_put parallel to tproxy and
>> that would be the root cause of the deadlock.
> 
> No, it won't be called.
> 
> We can do two things:
> 1. Assign the tw sk to skb->sk, then its handled by
>     tcp_timewait_state_process() in tcp stack.
> 
> Problem is that after the tw sk was handled, tcp stack won't find
> a listener socket if the tproxy service is running on a different port.
> 
> 2. Assign the listener socket to skb->sk (this is whats done now).
> 
>> So I guess now, basically we would leak away the tw socket if we do not call put in tproxy?
> 
> We could just drop the reference, but then, as far as i can see, we end
> up with two identical connection entries in the ehash table.

Okay, I agree with this, and thanks again the quick fix here.

When we could expect this in the mainline or 5.15 LTS?

Should I do someting further with the bugzilla ticket 1662?


