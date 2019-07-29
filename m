Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7262C7618B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 14:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 928DC2067D
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 14:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbfG2O7L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 10:59:11 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33374 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbfG2O7K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 10:59:10 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1619C9E47522CFEB2C32;
        Mon, 29 Jul 2019 22:59:08 +0800 (CST)
Received: from [127.0.0.1] (10.184.191.73) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 29 Jul 2019
 22:59:01 +0800
Subject: Re: [PATCH net] ipvs: Improve robustness to the ipvs sysctl
To:     Florian Westphal <fw@strlen.de>
CC:     <wensong@linux-vs.org>, <horms@verge.net.au>, <ja@ssi.bg>,
        <pablo@netfilter.org>, <lvs-devel@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>, <wangxiaogang3@huawei.com>,
        <xuhanbing@huawei.com>
References: <1997375e-815d-137f-20c9-0829a8587ee9@huawei.com>
 <20190729004958.GA19226@strlen.de>
From:   hujunwei <hujunwei4@huawei.com>
Message-ID: <5544dfbc-b291-05f5-ba7f-1cfc9bba013b@huawei.com>
Date:   Mon, 29 Jul 2019 22:58:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190729004958.GA19226@strlen.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.191.73]
X-CFilter-Loop: Reflected
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Julian, thank you for replay.

On 2019/7/29 8:49, Florian Westphal wrote:
> hujunwei <hujunwei4@huawei.com> wrote:
> 
> [ trimmed CC list ]
> 
>> The ipvs module parse the user buffer and save it to sysctl,
>> then check if the value is valid. invalid value occurs
>> over a period of time.
>> Here, I add a variable, struct ctl_table tmp, used to read
>> the value from the user buffer, and save only when it is valid.
> 
> Does this cause any problems?  If so, what are those?
> 
For example, when a negative number value occurs over a period of time,
the func such as ip_vs_sync_conn_v0() will get invalid number
by sysctl_sync_threshold(), casue judge abnormal in ip_vs_sync_conn_needed().

>> Fixes: f73181c8288f ("ipvs: add support for sync threads")
>> Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
>> ---
>>  net/netfilter/ipvs/ip_vs_ctl.c | 61 +++++++++++++++++++++++-----------
>>  1 file changed, 42 insertions(+), 19 deletions(-)
>>
>> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
>> index 741d91aa4a8d..e78fd05f108b 100644
>> --- a/net/netfilter/ipvs/ip_vs_ctl.c
>> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
>> @@ -1680,12 +1680,18 @@ proc_do_defense_mode(struct ctl_table *table, int write,
>>  	int val = *valp;
>>  	int rc;
>>
>> -	rc = proc_dointvec(table, write, buffer, lenp, ppos);
>> +	struct ctl_table tmp = {
>> +		.data = &val,
>> +		.maxlen = sizeof(int),
>> +		.mode = table->mode,
>> +	};
>> +
>> +	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
> 
> Wouldn't it be better do use proc_dointvec_minmax and set the
> constraints via .extra1,2 in the sysctl knob definition?
> 
You are right, proc_dointvec_minmax seems like a better choice, I will update the patch.

Regards,
Junwei

