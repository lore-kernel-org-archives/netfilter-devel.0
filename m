Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3861C0015E
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jul 2023 10:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjGCKor (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jul 2023 06:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjGCKor (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jul 2023 06:44:47 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EC1C1;
        Mon,  3 Jul 2023 03:44:46 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QvjCd3JSNz67CvH;
        Mon,  3 Jul 2023 18:41:49 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 3 Jul 2023 11:44:43 +0100
Message-ID: <7aa49767-0ee9-8d66-7c88-7006fb9c3312@huawei.com>
Date:   Mon, 3 Jul 2023 13:44:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11 08/12] landlock: Add network rules and TCP hooks
 support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-9-konstantin.meskhidze@huawei.com>
 <167413e7-c69a-3030-cd72-4c198158622e@digikod.net>
 <62715f92-96ec-ca8b-afc7-a1ae85f4141d@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <62715f92-96ec-ca8b-afc7-a1ae85f4141d@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



6/29/2023 5:04 PM, Mickaël Salaün пишет:
> 
> On 27/06/2023 18:14, Mickaël Salaün wrote:
>> 
>> On 15/05/2023 18:13, Konstantin Meskhidze wrote:
>>> This commit adds network rules support in the ruleset management
>>> helpers and the landlock_create_ruleset syscall.
>>> Refactor user space API to support network actions. Add new network
>>> access flags, network rule and network attributes. Increment Landlock
>>> ABI version. Expand access_masks_t to u32 to be sure network access
>>> rights can be stored. Implement socket_bind() and socket_connect()
>>> LSM hooks, which enables to restrict TCP socket binding and connection
>>> to specific ports.
> 
> It is important to explain the decision rationales. Please explain new
> types, something like this:
> 
> The new landlock_net_port_attr structure has two fields. The
> allowed_access field contains the LANDLOCK_ACCESS_NET_* rights. The port
> field contains the port value according to the the allowed protocol.
> This field can take up to a 64-bit value [1] but the maximum value
> depends on the related protocol (e.g. 16-bit for TCP).
> 
   Ok. Thanks.
> [1]
> https://lore.kernel.org/r/278ab07f-7583-a4e0-3d37-1bacd091531d@digikod.net
> .


