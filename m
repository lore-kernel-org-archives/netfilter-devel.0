Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EBCC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 May 2022 15:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbiEYPYn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 May 2022 11:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiEYPYm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 May 2022 11:24:42 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368D2AFB12
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 08:24:39 -0700 (PDT)
Received: from relay5-d.mail.gandi.net (unknown [217.70.183.197])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 64BA8C7C0D
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 15:21:20 +0000 (UTC)
Received: (Authenticated sender: ben@demerara.io)
        by mail.gandi.net (Postfix) with ESMTPSA id 5D4EF1C0007;
        Wed, 25 May 2022 15:21:16 +0000 (UTC)
Message-ID: <597542de-e062-57cf-c1d8-e5547016fa85@demerara.io>
Date:   Wed, 25 May 2022 16:21:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:100.0) Gecko/20100101
 Thunderbird/100.0a1
Subject: Re: [iptables PATCH] build: Fix error during out of tree build
Content-Language: en-US
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
References: <d454c825-2d43-56d9-d001-e98308d2dd1b@demerara.io>
 <Yo4NOcCsPPCM5h+6@orbyte.nwl.cc>
From:   Ben Brown <ben@demerara.io>
In-Reply-To: <Yo4NOcCsPPCM5h+6@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 25/05/2022 12:04, Phil Sutter wrote:
> Your mailer broke the patch by breaking long lines. Please use
> git-send-email to submit patches, it's a lot less error-prone.

Erk, apologies. I was attempting to circumvent having to update my
sendemail configs, though clearly that wasn't the smart choice.

> When resubmitting, also please add:
> 
> Fixes: f58b0d7406451 ("libxtables: Implement notargets hash table")

Sure thing!

> Apart from that, looks good to me!

Cheers,
Ben
