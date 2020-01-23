Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48ECCC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 20:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19F0C21D7E
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 20:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="t9cLn/if"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAWUIQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 15:08:16 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:33346 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727215AbgAWUIQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 15:08:16 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579810095; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=u+8Z/XIxtWT4JtZBGkj3NyDJOQ2r5UpCc7DQzpF+k7s=;
 b=t9cLn/iffHhIyP/49Lyk6aT5pVd49o1yQEFtp5AeSx6DRqlL4n7F+oUaSfjb1jGTzJTA+iaf
 rikPl6kYDvG1wc93xLdJZPhw/Yntq9LIXYFGbqcCZGnHheE6/q45uS9eQdbARVOBsTBCbxFR
 aJ+UnJ3ikGkbGcaUwZRemMU/9SE=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e29fd2e.7f05fdc034c8-smtp-out-n01;
 Thu, 23 Jan 2020 20:08:14 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 97483C447A1; Thu, 23 Jan 2020 20:08:14 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stranche)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2C570C43383;
        Thu, 23 Jan 2020 20:08:14 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 23 Jan 2020 13:08:14 -0700
From:   stranche@codeaurora.org
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        lucien.xin@gmail.com, subashab@codeaurora.org
Subject: Re: [PATCH nf] Revert "netfilter: unlock xt_table earlier in
 __do_replace"
In-Reply-To: <20200123102921.GU795@breakpoint.cc>
References: <1579740455-17249-1-git-send-email-stranche@codeaurora.org>
 <20200123102921.GU795@breakpoint.cc>
Message-ID: <41d1a7e128c92ac4cbc85806e0a09692@codeaurora.org>
X-Sender: stranche@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-01-23 03:29, Florian Westphal wrote:
> 
> I don't see how this changes anything wrt. packet path.
> This disallows another instance of iptables(-restore) to come in
> before the counters have been copied/freed and the destructors have 
> run.
> 
> But as those have nothing to do with the jumpstack I don't see how this
> helps.

Based on on the stack of the iptables-restore task that freed the 
jumpstack being accessed in the ipt_do_table() routine, we end up in 
__do_replace()
       0xFFFFFF9239243AE0, ->kvfree
       0xFFFFFF923A1969EC, ->xt_free_table_info+0x50
       0xFFFFFF923A2100E0, ->__do_replace+0x200

Prior to the original patch, this xt_free_table_info was under lock, so 
it seems that having this call under lock guarantees that the new 
table->private entry that contains the jumpstack is seen across all 
CPUs.

> 
> But the packet path doesn't grab the table mutex.
> 

Good point. Perhaps the reason that moving this lock helps is because it 
prevents multiple writers from stepping on one another in such a way 
that the private entry is left in a bad state. Or this whole thing is a 
red herring and the problem is actually that xt_replace_table() is able 
to return prematurely and not all CPUs are finished with the old 
jumpstack by the time the old table info is freed.
