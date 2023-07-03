Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B51CFC001B1
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jul 2023 12:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjGCMjo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jul 2023 08:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjGCMjn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jul 2023 08:39:43 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C31E50;
        Mon,  3 Jul 2023 05:39:42 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Qvlnf1zfBz6J7H0;
        Mon,  3 Jul 2023 20:37:58 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 3 Jul 2023 13:39:34 +0100
Message-ID: <f2754095-c0e8-7cd1-88f5-329696cdbee8@huawei.com>
Date:   Mon, 3 Jul 2023 15:39:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11 08/12] landlock: Add network rules and TCP hooks
 support
Content-Language: ru
To:     =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>
CC:     <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-9-konstantin.meskhidze@huawei.com>
 <20230627.82cde73b1efe@gnoack.org>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20230627.82cde73b1efe@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



6/27/2023 10:48 PM, Günther Noack пишет:
> On Tue, May 16, 2023 at 12:13:35AM +0800, Konstantin Meskhidze wrote:
>> +static int add_rule_net_service(struct landlock_ruleset *ruleset,
>> +				const void __user *const rule_attr)
>> +{
>> +#if IS_ENABLED(CONFIG_INET)
>> +	struct landlock_net_service_attr net_service_attr;
>> +	int res;
>> +	access_mask_t mask;
>> +
>> +	/* Copies raw user space buffer, only one type for now. */
> 
> Nit, which I came across by accident: I believe the remark "only one
> type for now" referred to the fact that path_beneath_attr was the only
> rule type up until now - but that is not true any more.  Please adapt
> the wording also in add_rule_path_beneath, where the same comment
> exists.
> 
   Thanks. I will fix it.

> –Günther
> .
