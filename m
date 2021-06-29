Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E48C11F67
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 15:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ABBD61D01
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 15:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhF2PhQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 11:37:16 -0400
Received: from mail.thelounge.net ([91.118.73.15]:26805 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbhF2PhQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 11:37:16 -0400
X-Greylist: delayed 953 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jun 2021 11:37:16 EDT
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4GDp6545NszXT1;
        Tue, 29 Jun 2021 17:18:53 +0200 (CEST)
Subject: Re: Reload IPtables
To:     slow_speed@att.net, "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Cc:     netfilter-devel@vger.kernel.org
References: <08f069e3-914f-204a-dfd6-a56271ec1e55.ref@att.net>
 <08f069e3-914f-204a-dfd6-a56271ec1e55@att.net>
 <4ac5ff0d-4c6f-c963-f2c5-29154e0df24b@hajes.org>
 <6430a511-9cb0-183d-ed25-553b5835fa6a@att.net>
 <877683bf-6ea4-ca61-ba41-5347877d3216@thelounge.net>
 <d2156e5b-2be9-c0cf-7f5b-aaf8b81769f8@att.net>
 <f5314629-8a08-3b5f-cfad-53bf13483ec3@hajes.org>
 <adc28927-724f-2cdb-ca6a-ff39be8de3ba@thelounge.net>
 <96559e16-e3a6-cefd-6183-1b47f31b9345@hajes.org>
 <16b55f10-5171-590f-f9d2-209cfaa7555d@thelounge.net>
 <54e70d0a-0398-16e4-a79e-ec96a8203b22@tana.it>
 <f0daea91-4d12-1605-e6df-e7f95ba18cac@thelounge.net>
 <8395d083-022b-f6f7-b2d3-e2a83b48c48a@tana.it>
 <20210628104310.61bd287ff147a59b12e23533@plushkava.net>
 <20210628220241.64f9af54@playground>
 <c78c189b-efad-0d20-fa9e-989c828d7067@att.net>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <9dab1af3-3041-0fc0-e5d0-bd377ede37a3@thelounge.net>
Date:   Tue, 29 Jun 2021 17:18:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c78c189b-efad-0d20-fa9e-989c828d7067@att.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 29.06.21 um 16:52 schrieb slow_speed@att.net:
> 
> 
> On 6/28/21 10:02 PM, Neal P. Murphy wrote:
>> On Mon, 28 Jun 2021 10:43:10 +0100
>> Kerin Millar <kfm@plushkava.net> wrote:
>>
>>> Now you benefit from atomicity (the rules will either be committed at 
>>> once, in full, or not at all) and proper error handling (the exit 
>>> status value of iptables-restore is meaningful and acted upon). 
>>> Further, should you prefer to indent the body of the heredoc, you may 
>>> write <<-EOF, though only leading tab characters will be stripped out.
>>>
>>
>> [minor digression]
>>
>> Is iptables-restore truly atomic in *all* cases? Some years ago, I 
>> found through experimentation that some rules were 'lost' when 
>> restoring more than 25 000 rules. If I placed a COMMIT every 20 000 
>> rules or so, then all rules would be properly loaded. I think COMMITs 
>> break atomicity. I tested with 100k to 1M rules. I was comparing the 
>> efficiency of iptables-restore with another tool that read from STDIN; 
>> the other tool was about 5% more efficient.
>>
> 
> Please explain why you might have so many rules.  My server is pushing 
> it at a dozen

likely because people don't use "ipset" and "chains" instead repeat the 
same stuff again and again so that every single package has to travel 
over hundrets and thousands of rules :-)
