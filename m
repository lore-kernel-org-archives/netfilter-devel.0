Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F118C0032E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 11:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377287AbjJTL7d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 07:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377296AbjJTL7d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 07:59:33 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE50D5D;
        Fri, 20 Oct 2023 04:59:31 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4SBjmH1x1Rz6K63D;
        Fri, 20 Oct 2023 19:58:55 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 20 Oct 2023 12:59:28 +0100
Message-ID: <c0cc04f0-2e4e-ed46-be95-f4ebc22ec648@huawei.com>
Date:   Fri, 20 Oct 2023 14:59:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v13 11/12] samples/landlock: Add network demo
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20231016015030.1684504-1-konstantin.meskhidze@huawei.com>
 <20231016015030.1684504-12-konstantin.meskhidze@huawei.com>
 <20231018.ShoMiep0ixei@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20231018.ShoMiep0ixei@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



10/18/2023 3:33 PM, Mickaël Salaün пишет:
> Please update the subject to "samples/landlock: Support TCP restrictions"

   Got it.
> 
> On Mon, Oct 16, 2023 at 09:50:29AM +0800, Konstantin Meskhidze wrote:
>> This commit adds network demo. It's possible to allow a sandboxer to
>> bind/connect to a list of particular ports restricting network
>> actions to the rest of ports.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> Link: https://lore.kernel.org/r/20230920092641.832134-12-konstantin.meskhidze@huawei.com
>> [mic: Define __SANE_USERSPACE_TYPES__ to select int-ll64.h and avoid
>> format warnings for PowerPC]
> 
> You can remove all this kind of "[mic: ]" comments, I add them when I
> merge a patch with additional changes.

   Ok. Thanks.
> 
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> ---
>> 
>> Changes since v12:
>> * Defines __SANE_USERSPACE_TYPES__ to avoid warnings for PowerPC.
> .
