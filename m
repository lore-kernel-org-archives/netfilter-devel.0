Return-Path: <SRS0=/8pw=SU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A9CC282DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 02:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23CB5217FA
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 02:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387886AbfDRCRu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 22:17:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6640 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729189AbfDRCRu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 22:17:50 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6AEFC95D5B0A47E8B65E;
        Thu, 18 Apr 2019 10:17:47 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.20) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.408.0; Thu, 18 Apr 2019
 10:17:40 +0800
Subject: Re: [PATCH] ipvs:set sock send/receive buffer correctly
To:     Eric Dumazet <eric.dumazet@gmail.com>, <wensong@linux-vs.org>,
        <horms@verge.net.au>, <ja@ssi.bg>, <pablo@netfilter.org>,
        <kadlec@blackhole.kfki.hu>, <fw@strlen.de>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <lvs-devel@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <linux-kernel@vger.kernel.org>
CC:     Mingfangsen <mingfangsen@huawei.com>, <liujie165@huawei.com>
References: <501e5522-1d69-7c67-a1bc-fd8502d3b5d1@huawei.com>
 <60c11e72-99eb-fcde-e130-a35ecdc1d2d1@gmail.com>
 <bbfcccf4-626b-1029-62a6-a82b79edacbb@huawei.com>
 <a8ed41f3-1576-cbf6-907a-f501b3df189e@gmail.com>
From:   linmiaohe <linmiaohe@huawei.com>
Message-ID: <99e42cf0-bb45-cc88-a6f6-aff1098745dd@huawei.com>
Date:   Thu, 18 Apr 2019 10:17:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <a8ed41f3-1576-cbf6-907a-f501b3df189e@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.20]
X-CFilter-Loop: Reflected
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 2019/4/18 10:02, Eric Dumazet wrote:
> 
> 
> On 04/17/2019 06:45 PM, linmiaohe wrote:
>>
> 
>> In fact, I just implemented this function with reference to
>> sock_setsockopt(). When val * 2 overflow, we will set the
>> buffer as SOCK_MIN_SNDBUF, just as sock_setsockopt() do.
>>
> 
> I do not think so.
> 
> Please check latest linux kernel, not some old version.
> 
> commit 4057765f2dee79cb92f9067909477303360be8d3    sock: consistent handling of extreme SO_SNDBUF/SO_RCVBUF values
> 
> .
> 

Thank you for your patience, you are right. My version is not the newest.
I will update my patch according to the newest version. Thanks again.

