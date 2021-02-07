Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C02CC433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Feb 2021 16:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07BF064E3F
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Feb 2021 16:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhBGQfk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Feb 2021 11:35:40 -0500
Received: from mail.thelounge.net ([91.118.73.15]:19217 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhBGQfj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Feb 2021 11:35:39 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4DYZWN5b6RzXMD;
        Sun,  7 Feb 2021 17:34:51 +0100 (CET)
Subject: Re: [PATCH net 1/4] netfilter: xt_recent: Fix attempt to update
 deleted entry
From:   Reindl Harald <h.reindl@thelounge.net>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
References: <20210205001727.2125-1-pablo@netfilter.org>
 <20210205001727.2125-2-pablo@netfilter.org>
 <69957353-7fe0-9faa-4ddd-1ac44d5386a5@thelounge.net>
 <alpine.DEB.2.23.453.2102051448220.10405@blackhole.kfki.hu>
 <a51d867a-3ca9-fd36-528a-353aa6c42f42@thelounge.net>
Organization: the lounge interactive design
Message-ID: <3018f068-62b1-6dae-2dde-39d1a62fbcb2@thelounge.net>
Date:   Sun, 7 Feb 2021 17:34:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <a51d867a-3ca9-fd36-528a-353aa6c42f42@thelounge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 05.02.21 um 15:42 schrieb Reindl Harald:
> 
> 
> Am 05.02.21 um 14:54 schrieb Jozsef Kadlecsik:
>> Hi Harald,
>>
>> On Fri, 5 Feb 2021, Reindl Harald wrote:
>>
>>> "Reap only entries which won't be updated" sounds for me like the could
>>> be some optimization: i mean when you first update and then check what
>>> can be reaped the recently updated entry would not match to begin with
>>
>> When the entry is new and the given recent table is full we cannot update
>> (add) it, unless old entries are deleted (reaped) first. So it'd require
>> more additional checkings to be introduced to reverse the order of the 
>> two
>> operations.
> well, the most important thing is that the firewall-vm stops to 
> kernel-panic

why is that still not part of 5.10.14 given how old that issue is :-(

https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.10.14
