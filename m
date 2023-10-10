Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39EACD68E3
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 02:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjJJCRS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 22:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbjJJCRR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 22:17:17 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D274693;
        Mon,  9 Oct 2023 19:17:15 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S4KGG3zBMz6D8Wl;
        Tue, 10 Oct 2023 10:14:14 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 10 Oct 2023 03:17:12 +0100
Message-ID: <2d59343e-63c5-239c-bbfa-c0686bdd4ab1@huawei.com>
Date:   Tue, 10 Oct 2023 05:17:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v12 02/12] landlock: Allow filesystem layout changes for
 domains without such rule type
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
 <20230920092641.832134-3-konstantin.meskhidze@huawei.com>
 <20231001.lahkohr4pu4P@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20231001.lahkohr4pu4P@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



10/2/2023 11:26 PM, Mickaël Salaün пишет:
> Please change the subject to "landlock: Allow FS topology changes for
> domains without such rule type" to be consistent with the documentation.
> 
   Got it. Thanks.
> 
> On Wed, Sep 20, 2023 at 05:26:30PM +0800, Konstantin Meskhidze wrote:
>> From: Mickaël Salaün <mic@digikod.net>
>> 
>> Allow mount point and root directory changes when there is no filesystem
>> rule tied to the current Landlock domain.  This doesn't change anything
>> for now because a domain must have at least a (filesystem) rule, but
>> this will change when other rule types will come.  For instance, a
>> domain only restricting the network should have no impact on filesystem
>> restrictions.
>> 
>> Add a new get_current_fs_domain() helper to quickly check filesystem
>> rule existence for all filesystem LSM hooks.
>> 
>> Remove unnecessary inlining.
>> 
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> .
