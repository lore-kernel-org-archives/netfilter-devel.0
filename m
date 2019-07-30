Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFFFC76186
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 02:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F78C2064C
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 02:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbfG3CYJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 22:24:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728962AbfG3CYI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 22:24:08 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E4C4D73401A1CAA62BA7;
        Tue, 30 Jul 2019 10:24:03 +0800 (CST)
Received: from [127.0.0.1] (10.184.191.73) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Jul 2019
 10:23:57 +0800
Subject: Re: [PATCH net] ipvs: Improve robustness to the ipvs sysctl
To:     Julian Anastasov <ja@ssi.bg>, Florian Westphal <fw@strlen.de>
CC:     <wensong@linux-vs.org>, <horms@verge.net.au>,
        <pablo@netfilter.org>, <lvs-devel@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>, <wangxiaogang3@huawei.com>,
        <xuhanbing@huawei.com>
References: <1997375e-815d-137f-20c9-0829a8587ee9@huawei.com>
 <20190729004958.GA19226@strlen.de>
 <alpine.LFD.2.21.1907292305200.2909@ja.home.ssi.bg>
From:   hujunwei <hujunwei4@huawei.com>
Message-ID: <6be23b8c-7747-c763-5db3-cf78ee13ee99@huawei.com>
Date:   Tue, 30 Jul 2019 10:23:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.21.1907292305200.2909@ja.home.ssi.bg>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.191.73]
X-CFilter-Loop: Reflected
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello, Julian

On 2019/7/30 4:20, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Mon, 29 Jul 2019, Florian Westphal wrote:
> 
>>> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
>>> index 741d91aa4a8d..e78fd05f108b 100644
>>> --- a/net/netfilter/ipvs/ip_vs_ctl.c
>>> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
>>> @@ -1680,12 +1680,18 @@ proc_do_defense_mode(struct ctl_table *table, int write,
>>>  	int val = *valp;
>>>  	int rc;
>>>
>>> -	rc = proc_dointvec(table, write, buffer, lenp, ppos);
>>> +	struct ctl_table tmp = {
>>> +		.data = &val,
>>> +		.maxlen = sizeof(int),
>>> +		.mode = table->mode,
>>> +	};
>>> +
>>> +	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
>>
>> Wouldn't it be better do use proc_dointvec_minmax and set the
>> constraints via .extra1,2 in the sysctl knob definition?
> 
> 	We store the 'ipvs' back-ptr in extra2, so may be we
> can not use it in the table for proc_do_defense_mode, only for
> tmp. proc_do_sync_mode may use extra1/2 in table for the
> proc_dointvec_minmax call.
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
> .
> 

I agree with you, in these four function, only proc_do_sync_mode can
use extra1/2 in table for the proc_dointvec_minmax,
i will update it in patch v2. Thank you for reply.

Regards,
Junwei

