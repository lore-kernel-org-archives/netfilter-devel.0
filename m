Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB801C63798
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Nov 2020 14:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A039B217A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Nov 2020 14:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732051AbgKWOte (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Nov 2020 09:49:34 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8388 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731823AbgKWOte (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 09:49:34 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cfqm91XYmz711Q;
        Mon, 23 Nov 2020 22:48:57 +0800 (CST)
Received: from [10.174.179.81] (10.174.179.81) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Mon, 23 Nov 2020 22:49:11 +0800
Subject: Re: [PATCH net v2] ipvs: fix possible memory leak in
 ip_vs_control_net_init
To:     Julian Anastasov <ja@ssi.bg>
CC:     Simon Horman <horms@verge.net.au>, <pablo@netfilter.org>,
        <christian@brauner.io>, <lvs-devel@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>
References: <20201120082610.60917-1-wanghai38@huawei.com>
 <21af4c92-8ca6-cce9-64bc-c4e88b6d1e8a@ssi.bg>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <66825441-bb06-3d18-0424-df355d596c5f@huawei.com>
Date:   Mon, 23 Nov 2020 22:49:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <21af4c92-8ca6-cce9-64bc-c4e88b6d1e8a@ssi.bg>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


ÔÚ 2020/11/22 19:20, Julian Anastasov Ð´µÀ:
> 	Hello,
>
> On Fri, 20 Nov 2020, Wang Hai wrote:
>
>> kmemleak report a memory leak as follows:
>>
>> BUG: memory leak
>> unreferenced object 0xffff8880759ea000 (size 256):
>> comm "syz-executor.3", pid 6484, jiffies 4297476946 (age 48.546s)
[...]
>>
>> Fixes: b17fc9963f83 ("IPVS: netns, ip_vs_stats and its procfs")
>> Fixes: 61b1ab4583e2 ("IPVS: netns, add basic init per netns.")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
[...]
>>   
>> -	proc_create_net("ip_vs", 0, ipvs->net->proc_net, &ip_vs_info_seq_ops,
>> -			sizeof(struct ip_vs_iter));
>> -	proc_create_net_single("ip_vs_stats", 0, ipvs->net->proc_net,
>> -			ip_vs_stats_show, NULL);
>> -	proc_create_net_single("ip_vs_stats_percpu", 0, ipvs->net->proc_net,
>> -			ip_vs_stats_percpu_show, NULL);
>> +#ifdef CONFIG_PROC_FS
>> +	if (!proc_create_net("ip_vs", 0, ipvs->net->proc_net, &ip_vs_info_seq_ops,
>> +			sizeof(struct ip_vs_iter)))
>> +		goto err_vs;
>> +	if (!proc_create_net_single("ip_vs_stats", 0, ipvs->net->proc_net,
>> +			ip_vs_stats_show, NULL))
>> +		goto err_stats;
>> +	if (!proc_create_net_single("ip_vs_stats_percpu", 0, ipvs->net->proc_net,
>> +			ip_vs_stats_percpu_show, NULL))
>> +		goto err_percpu;
> 	Make sure the parameters are properly aligned to function open
> parenthesis without exceeding 80 columns:
>
> linux# scripts/checkpatch.pl --strict /tmp/file.patch
Thanks, I'll perfect it.
> 	It was true only for first call due to some
> renames for the others two in commit 3617d9496cd9 :(
It does indeed rename in commit 3617d9496cd9.
But I don't understand what's wrong with my patch here.
>> +#endif
>>   
>>   	if (ip_vs_control_net_init_sysctl(ipvs))
>>   		goto err;
>> @@ -4180,6 +4185,14 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
>>   	return 0;
>>   
>>   err:
>> +#ifdef CONFIG_PROC_FS
>> +	remove_proc_entry("ip_vs_stats_percpu", ipvs->net->proc_net);
> 	It should look better with an empty line before
> the 3 new labels.
Thanks, I'll perfect it.
>> +err_percpu:
[...]
>>   	remove_proc_entry("ip_vs_stats", ipvs->net->proc_net);
>>   	remove_proc_entry("ip_vs", ipvs->net->proc_net);
>> +#endif
>>   	free_percpu(ipvs->tot_stats.cpustats);
>>   }
>>   
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>
> .
>
