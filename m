Return-Path: <SRS0=SAea=2Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFD5C32767
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jan 2020 08:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F552217F4
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jan 2020 08:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgADI3L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Jan 2020 03:29:11 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:47470 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgADI3L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Jan 2020 03:29:11 -0500
Received: from [192.168.1.6] (unknown [116.237.151.217])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 987505C1623;
        Sat,  4 Jan 2020 16:29:06 +0800 (CST)
Subject: Re: [PATCH nf] netfilter: nft_flow_offload: fix unnecessary use
 counter decrease in destory
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1576832926-4268-1-git-send-email-wenxu@ucloud.cn>
 <c9e07a82-ea38-d0bc-3ffa-cb0b5bc7ff95@ucloud.cn>
 <20191230200245.wr3tknzvduzecvaw@salvia>
 <71d4dbd8-e7a7-82f1-d246-e61129de00b1@ucloud.cn>
 <20200103171239.stghnammtqmyrzm5@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c407cab7-474b-0743-cc70-3cf394b16baf@ucloud.cn>
Date:   Sat, 4 Jan 2020 16:28:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200103171239.stghnammtqmyrzm5@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0pPS0tLT0pOQ0tJWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OCo6USo*CDgxFj8dKTcrAxNN
        Hk0KFFZVSlVKTkxDSklNTk9NQ0hOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SExVSk5KVUlKTFlXWQgBWUFJSElONwY+
X-HM-Tid: 0a6f6fac17032087kuqy987505c1623
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2020/1/4 1:12, Pablo Neira Ayuso 写道:
> On Tue, Dec 31, 2019 at 08:45:27AM +0800, wenxu wrote:
>> 在 2019/12/31 4:02, Pablo Neira Ayuso 写道:
>>> On Mon, Dec 30, 2019 at 09:25:36PM +0800, wenxu wrote:
>>>> Hi pablo,
>>>>
>>>> How about this patch?
>>> This test still fails after a second run with this patch:
>>>
>>> ./run-tests.sh testcases/flowtable/0009deleteafterflush_0
>>> I: using nft binary ./../../src/nft
>>>
>>> W: [FAILED]     testcases/flowtable/0009deleteafterflush_0: got 1
>>> Error: Could not process rule: Device or resource busy
>>> delete flowtable x f
>> Hi pablo,
>>
>> I did the same test for testcase 0009deleteafterflush_0, It is okay even
>> there is no this patch in my tree.
> Thanks, I'm going to apply the patch that I'm attaching to this email.

Thanks,  It's ok for me.

