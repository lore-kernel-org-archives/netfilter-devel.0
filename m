Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C36C63697
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 17:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82DA4206C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 17:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="hxjZXm5m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387937AbgKPRwC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:52:02 -0500
Received: from z5.mailgun.us ([104.130.96.5]:58889 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388135AbgKPRwB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 12:52:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605549121; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=QcDU5JHoRISa++HbwWWnrD6sr4uqRAqkiu5sj0buFvw=;
 b=hxjZXm5mgmCacPJETXKqrqAiqPhNeS86bACxBmXpKn47eiFBMt7OSTVYeKDjJl4UTMQ61MBp
 dBMFFF4IpY5dTL255Vs8ECCOvDTIETyG5z5zvFQrJIfarDyt7Tg7NXNxl3Cxtj/jihkyfkd7
 WFbDfXWcIjDNJLguFTq+e63XSl8=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5fb2bc41f34fcfd5e55a9365 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 16 Nov 2020 17:52:01
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D8B96C43463; Mon, 16 Nov 2020 17:52:00 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF13FC43464;
        Mon, 16 Nov 2020 17:51:59 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 16 Nov 2020 10:51:59 -0700
From:   subashab@codeaurora.org
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
In-Reply-To: <20201116170440.GA26150@breakpoint.cc>
References: <1605320516-17810-1-git-send-email-stranche@codeaurora.org>
 <20201114165330.GM23619@breakpoint.cc>
 <2ab4bcb63cbacba12ad927621fb56aab@codeaurora.org>
 <20201116141810.GB22792@breakpoint.cc>
 <8256f40ba9b73181f121baafe12cac61@codeaurora.org>
 <20201116170440.GA26150@breakpoint.cc>
Message-ID: <983d178e6f3aac81d491362ab60db61f@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

>> Unfortunately we are seeing it on ARM64 regression systems which runs 
>> a
>> variety of
>> usecases so the exact steps are not known.
> 
> Ok.  Would you be willing to run some of those with your suggested
> change to see if that resolves the crashes or is that so rare that this
> isn't practical?

I can try that out. Let me know if you have any other suggestions as 
well
and I can try that too.

I assume we cant add locks here as it would be in the packet processing 
path.
