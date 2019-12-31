Return-Path: <SRS0=FFQ3=2V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E176C2D0C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Dec 2019 00:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7EB4206CB
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Dec 2019 00:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbfLaAqC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 19:46:02 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:48016 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbfLaAqC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 19:46:02 -0500
Received: from [192.168.1.4] (unknown [116.226.205.178])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 4D578415FF;
        Tue, 31 Dec 2019 08:45:58 +0800 (CST)
Subject: Re: [PATCH nf] netfilter: nft_flow_offload: fix unnecessary use
 counter decrease in destory
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1576832926-4268-1-git-send-email-wenxu@ucloud.cn>
 <c9e07a82-ea38-d0bc-3ffa-cb0b5bc7ff95@ucloud.cn>
 <20191230200245.wr3tknzvduzecvaw@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <71d4dbd8-e7a7-82f1-d246-e61129de00b1@ucloud.cn>
Date:   Tue, 31 Dec 2019 08:45:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191230200245.wr3tknzvduzecvaw@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTExCS0tLSk1IS0xDSEpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ngw6Ljo*KDg5SzkuIhMxPj0s
        HSIwFDVVSlVKTkxMTE5ISk5DQklIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SU1VSUtOVUpMQ1lXWQgBWUFJTExONwY+
X-HM-Tid: 0a6f596aa3832086kuqy4d578415ff
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/12/31 4:02, Pablo Neira Ayuso 写道:
> On Mon, Dec 30, 2019 at 09:25:36PM +0800, wenxu wrote:
>> Hi pablo,
>>
>> How about this patch?
> This test still fails after a second run with this patch:
>
> ./run-tests.sh testcases/flowtable/0009deleteafterflush_0
> I: using nft binary ./../../src/nft
>
> W: [FAILED]     testcases/flowtable/0009deleteafterflush_0: got 1
> Error: Could not process rule: Device or resource busy
> delete flowtable x f

Hi pablo,


I did the same test for testcase 0009deleteafterflush_0, It is okay even 
there is no this patch in my tree.

++ which nft
+ NFT=/usr/sbin/nft
+ /usr/sbin/nft add table x
+ /usr/sbin/nft add chain x y
+ /usr/sbin/nft add flowtable x f '{' hook ingress priority '0;' devices 
= '{' lo '};}'
+ /usr/sbin/nft add rule x y flow add @f
+ /usr/sbin/nft flush chain x y

+ /usr/sbin/nft delete flowtable x f


This patch fix the problem that there are nft_flow_offload rules,  when 
flush the rules or chain which will lead the use counter double decrease 
and overflow.

nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @f
nft add rule firewall ftb-all ct zone 1 ip protocol udp flow offload @f

This testcase does not have any nft_flow_offload rules. So this testcase 
don't cover the problem I want to fixes.


Ps:

  I test the nf-next tree, this testcase have the problem, I think it 
should be another new problem. I will check it.

