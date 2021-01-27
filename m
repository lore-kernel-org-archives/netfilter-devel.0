Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48689C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 23:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F14B364DD0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 23:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhA0X2r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:28:47 -0500
Received: from mail.thelounge.net ([91.118.73.15]:29441 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbhA0X0n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jan 2021 18:26:43 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4DR08m1VWyzY8v;
        Thu, 28 Jan 2021 00:25:55 +0100 (CET)
Subject: Re: https://bugzilla.kernel.org/show_bug.cgi?id=207773
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <9ab32341-ca2f-22e2-0cb0-7ab55198ab80@thelounge.net>
 <alpine.DEB.2.23.453.2101271435390.11052@blackhole.kfki.hu>
 <alpine.DEB.2.23.453.2101280006200.11052@blackhole.kfki.hu>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <8172eaaf-1911-14a2-9b20-fcad8602a1ec@thelounge.net>
Date:   Thu, 28 Jan 2021 00:25:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.23.453.2101280006200.11052@blackhole.kfki.hu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 28.01.21 um 00:13 schrieb Jozsef Kadlecsik:
> Hi,
> 
> On Wed, 27 Jan 2021, Jozsef Kadlecsik wrote:
> 
>> On Wed, 27 Jan 2021, Reindl Harald wrote:
>>
>>> for the sake of god may someone look at this?
>>> https://bugzilla.kernel.org/show_bug.cgi?id=207773
>>
>> Could you send your iptables rules and at least the set definitions
>> without the set contents? I need to reproduce the issue.
> 
> Checking your rules, you have got a recent match in which you use both the
> --reap and --update flags. 

which makes sense

> However, as far as I see the code leaves the
> possibility open that the recent entry to be updated is reaped, which
> then leads to the crash.

thanks for checking

> The following patch should fix the issue - however, I could not test it

hopefully this makes it into a near future kernel update, i rely on 
distribution packages and Fedora is pretty quick



