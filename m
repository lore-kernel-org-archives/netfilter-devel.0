Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40452C433B4
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Apr 2021 16:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE873611CC
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Apr 2021 16:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhDWQ1J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Apr 2021 12:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhDWQ1I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Apr 2021 12:27:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BC0C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Apr 2021 09:26:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lZydQ-0003to-5p; Fri, 23 Apr 2021 18:26:28 +0200
Date:   Fri, 23 Apr 2021 18:26:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ali Abdallah <ali.abdallah@suse.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: RSTs being marked as invalid because of wrong td_maxack value
Message-ID: <20210423162628.GB18119@breakpoint.cc>
References: <20210423155443.fmlbssgi6pq7nfp4@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210423155443.fmlbssgi6pq7nfp4@Fryzen495>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ali Abdallah <ali.abdallah@suse.com> wrote:
> 1: 2049 → 703 [RST, ACK] Seq=1202969688 Ack=1132949130
> 2: [TCP Port numbers reused] 703 → 2049 [SYN] Seq=1433611541
> 3: [TCP Out-Of-Order] 703 → 2049 [PSH, ACK] Seq=1132949130 Ack=1202969688
> 4: 2049 → 703 [RST, ACK] Seq=0 Ack=1433611542

What is generating this sequence of events?  Is #3 just delayed?

> The RST in 4 is dropped, printing out the td_maxack value, it turns out
> to be:
> 
> nf_ct_tcp: invalid RST seq:0 td_maxack:1202969688 SRC=10.78.206.110
> DST=10.78.202.146 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=43722 DF PROTO=TCP
> SPT=2049 DPT=703 SEQ=0 ACK=1433611542 WINDOW=0 RES=0x00 ACK RST URGP=0
> 
> So basically the SYN in 2 resets the IP_CT_TCP_FLAG_MAXACK_SET, while
> the out of order frame 3 resets it back, and we end up having again
> td_maxack=1202969688, that is compared against Seq=0 and the RST is dropped.

Is this after we let a SYN through while conntrack is still in
established state?

That would imply #1 was ignored too, else this should have destroyed
the entry.

> While we are still testing a proper fix, we would like to have the RST
> check introduced in [1] tunable. I can send a patch to add a proc bit
> for that, but I'm wondering whether or not to re-use the tcp_be_liberal
> option. Please let me know which option would work best for you.

Yes, be_liberal is good for this, but nevertheless I'd like to have it
behave correctly out-of-the-box.

Consider sending a new patch to add a be-liberal check for this.

Problem is that if #1 is ignored, then at #3 we can't easily know if
the syn was bogus (ack is for established connection, still alive)
or if there was re-use (ack is delayed).

Do these problematic connections support tcp timestamps?
If so, we might want to track those so we can check if the segment
is older than what we last saw.

Only problem is that this increases conn size by 16 bytes, but that
would be acceptable if that solves the problem.
