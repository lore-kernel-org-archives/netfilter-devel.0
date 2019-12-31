Return-Path: <SRS0=FFQ3=2V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEACC2D0C8
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Dec 2019 05:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42FE2206DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Dec 2019 05:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbfLaFMu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Dec 2019 00:12:50 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:10923 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfLaFMu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Dec 2019 00:12:50 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 69C074118D;
        Tue, 31 Dec 2019 13:12:45 +0800 (CST)
Subject: Re: [PATCH nf] netfilter: nft_flow_offload: fix unnecessary use
 counter decrease in destory
From:   wenxu <wenxu@ucloud.cn>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1576832926-4268-1-git-send-email-wenxu@ucloud.cn>
 <c9e07a82-ea38-d0bc-3ffa-cb0b5bc7ff95@ucloud.cn>
 <20191230200245.wr3tknzvduzecvaw@salvia>
 <71d4dbd8-e7a7-82f1-d246-e61129de00b1@ucloud.cn>
Message-ID: <859038ff-dd2d-d2f7-224c-d9d2ca6849ea@ucloud.cn>
Date:   Tue, 31 Dec 2019 13:12:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <71d4dbd8-e7a7-82f1-d246-e61129de00b1@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkhOS0tLSktCTUxJTk5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBg6Sxw5ATg0NDk0Tj4MDxYp
        OiIaCgNVSlVKTkxMTE1CSk1OTU1OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0hKTDcG
X-HM-Tid: 0a6f5a5ee2b62086kuqy69c074118d
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,


I found this testcase already contain the rules.


I can reproduce it with your nf branch. 

# uname -r
5.5.0-rc2+


# cat testcases/flowtable/0009deleteafterflush_0:

#!/bin/bash

set -e

$NFT add table x
$NFT add chain x y
$NFT add flowtable x f { hook ingress priority 0\; devices = { lo }\;}
$NFT add rule x y flow add @f
$NFT flush chain x y
sleep 1
$NFT delete flowtable x f


It is not easy to reproduce it without the sleep 1 between flush chain and delete the flowtable.

The flowtable delete maybe early than rule destroy because the operation is the flush chain

but not delete rule directly .


Without my patch:

# ./run-tests.sh testcases/flowtable/0009deleteafterflush_0
I: using nft binary ./../../src/nft

W: [FAILED]    testcases/flowtable/0009deleteafterflush_0: got 1
Error: Could not process rule: Device or resource busy
delete flowtable x f
^^^^^^^^^^^^^^^^^^^^^

I: results: [OK] 0 [FAILED] 1 [TOTAL] 1


Add with my fixes patch: I run this 50 times all result is OK

# ./run-tests.sh testcases/flowtable/0009deleteafterflush_0
I: using nft binary ./../../src/nft

I: [OK]        testcases/flowtable/0009deleteafterflush_0

I: results: [OK] 1 [FAILED] 0 [TOTAL] 1


So which branch did you test with this patch?


BR

wenxu

On 12/31/2019 8:45 AM, wenxu wrote:
>
> 在 2019/12/31 4:02, Pablo Neira Ayuso 写道:
>> On Mon, Dec 30, 2019 at 09:25:36PM +0800, wenxu wrote:
>>> Hi pablo,
>>>
>>> How about this patch?
>> This test still fails after a second run with this patch:
>>
>> ./run-tests.sh testcases/flowtable/0009deleteafterflush_0
>> I: using nft binary ./../../src/nft
>>
>> W: [FAILED]     testcases/flowtable/0009deleteafterflush_0: got 1
>> Error: Could not process rule: Device or resource busy
>> delete flowtable x f
>
> Hi pablo,
>
>
> I did the same test for testcase 0009deleteafterflush_0, It is okay even there is no this patch in my tree.
>
> ++ which nft
> + NFT=/usr/sbin/nft
> + /usr/sbin/nft add table x
> + /usr/sbin/nft add chain x y
> + /usr/sbin/nft add flowtable x f '{' hook ingress priority '0;' devices = '{' lo '};}'
> + /usr/sbin/nft add rule x y flow add @f
> + /usr/sbin/nft flush chain x y
>
> + /usr/sbin/nft delete flowtable x f
>
>
> This patch fix the problem that there are nft_flow_offload rules,  when flush the rules or chain which will lead the use counter double decrease and overflow.
>
> nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @f
> nft add rule firewall ftb-all ct zone 1 ip protocol udp flow offload @f
>
> This testcase does not have any nft_flow_offload rules. So this testcase don't cover the problem I want to fixes.
>
>
> Ps:
>
>  I test the nf-next tree, this testcase have the problem, I think it should be another new problem. I will check it.
>
>
