Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C37C433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 07:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D681610A5
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 07:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbhDZIA0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 04:00:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:45488 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232333AbhDZH6a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 03:58:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619423868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LrGxwRBCiuATYQupN+S+DW+ODJjtpcwNGGCCBas9vDU=;
        b=VnmNJEJsXPn6iTpDp85Rx87YoqDeCrWVJ8r1eLRCllXQVfrERBwtbwx3nKsDmQySoODoer
        zdQsDqqsU9kRhBKxMMhoWvq2Su8r5wUxjZjSqFN4G7Q0zZk7dRW3Ua9lF2+iMlMW3Tey4y
        ZN/cHfQOzXDRFfIM5S6MdtE1ms7Zb4U=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9A445AFB1;
        Mon, 26 Apr 2021 07:57:48 +0000 (UTC)
Date:   Mon, 26 Apr 2021 09:57:47 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: RSTs being marked as invalid because of wrong td_maxack value
Message-ID: <20210426075747.isyjkpoim5e7bgnb@Fryzen495>
References: <20210423155443.fmlbssgi6pq7nfp4@Fryzen495>
 <20210423162628.GB18119@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210423162628.GB18119@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 23.04.2021 18:26, Florian Westphal wrote:
> What is generating this sequence of events?  Is #3 just delayed?

Yes.

> Is this after we let a SYN through while conntrack is still in
> established state?

Yes.

> That would imply #1 was ignored too, else this should have destroyed
> the entry.
> 
> Yes, be_liberal is good for this, but nevertheless I'd like to have it
> behave correctly out-of-the-box.
> 
> Consider sending a new patch to add a be-liberal check for this.

Ok perfect, will send a patch later then.

> Problem is that if #1 is ignored, then at #3 we can't easily know if
> the syn was bogus (ack is for established connection, still alive)
> or if there was re-use (ack is delayed).
> Do these problematic connections support tcp timestamps?
> If so, we might want to track those so we can check if the segment
> is older than what we last saw.
> 
> Only problem is that this increases conn size by 16 bytes, but that
> would be acceptable if that solves the problem.

Yes, they do support timestamps, but I'm not sure if that will solve
the problem, as the problematic out of order frame #5 has more recent
timestamps.

1: 703 → 2049 [ACK] Seq=1132947682 Ack=1202969688 Win=2661 Len = 0
TSval=3506781692 TSecr=1717385629

2: 2049 → 703 [RST, ACK] Seq=1202969688 Ack=1132949130 Win=69120 Len=0
TSval=1717385630 TSecr=3506781692

3: 2049 → 703 [ACK] Seq=1202969688 Ack=1132947682 Win=70400 Len=0
TSval=1717385630 TSecr=3506781692

4: 703 → 2049 [SYN] Seq=1433611541 Win=29200 Len=0 MSS=1460 SACK_PERM=1
TSval=3506781693 TSecr=0

5: [PSH, ACK] Seq=1132949130 Ack=1202969688 Win=1362432 Len=604
TSval=3506781693 TSecr=1717385629

6: 2049 → 703 [RST, ACK] Seq=0 Ack=1433611542 Win=0 Len=0


Regards,

-- 
Ali Abdallah | SUSE Linux L3 Engineer
GPG fingerprint: 51A0 F4A0 C8CF C98F 842E  A9A8 B945 56F8 1C85 D0D5

