Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B476C64EC4
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Mar 2023 09:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCCJdO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Mar 2023 04:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCCJdN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2023 04:33:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E413410C7
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2023 01:33:12 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pY1mo-0008SF-Sl; Fri, 03 Mar 2023 10:33:10 +0100
Date:   Fri, 3 Mar 2023 10:33:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Major =?iso-8859-15?Q?D=E1vid?= <major.david@balasys.hu>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: CPU soft lockup in a spin lock using tproxy and nfqueue
Message-ID: <20230303093310.GC20617@breakpoint.cc>
References: <401bd6ed-314a-a196-1cdc-e13c720cc8f2@balasys.hu>
 <20230302142946.GB309@breakpoint.cc>
 <f8d03b81-8980-b54e-a2a3-57f8e54044be@balasys.hu>
 <20230303000926.GC9239@breakpoint.cc>
 <374ce7bf-e953-ab61-15ac-d99efce9152d@balasys.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <374ce7bf-e953-ab61-15ac-d99efce9152d@balasys.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Major Dávid <major.david@balasys.hu> wrote:
> On 3/3/23 01:09, Florian Westphal wrote:
> > 
> > Which one?  As far as I can see TCP stack would end up adding a
> > duplicate quadruple to the hash if we only drop the reference and
> > keep the listen sk around.
> 
> I just thought that tcp_timewait_state_process is called by TCP stack to
> handle TW state, which actually call inet_twsk_deschedule_put parallel to tproxy and
> that would be the root cause of the deadlock.

No, it won't be called.

We can do two things:
1. Assign the tw sk to skb->sk, then its handled by
   tcp_timewait_state_process() in tcp stack.

Problem is that after the tw sk was handled, tcp stack won't find
a listener socket if the tproxy service is running on a different port.

2. Assign the listener socket to skb->sk (this is whats done now).

> So I guess now, basically we would leak away the tw socket if we do not call put in tproxy?

We could just drop the reference, but then, as far as i can see, we end
up with two identical connection entries in the ehash table.
