Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FF8C001DD
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jul 2023 08:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjGCIhU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jul 2023 04:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjGCIhT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jul 2023 04:37:19 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B193D1;
        Mon,  3 Jul 2023 01:37:18 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QvfN74vpmz6D8cQ;
        Mon,  3 Jul 2023 16:33:59 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 3 Jul 2023 09:37:14 +0100
Message-ID: <338bba9d-6afa-7c6b-2843-b116abb36859@huawei.com>
Date:   Mon, 3 Jul 2023 11:37:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11 10/12] selftests/landlock: Add 11 new test suites
 dedicated to network
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230701.acb4d98c59a0@gnoack.org>
 <4a733dbd-f6e2-dc69-6c8d-47c362644462@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <4a733dbd-f6e2-dc69-6c8d-47c362644462@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



7/2/2023 11:45 AM, Mickaël Salaün пишет:
> 
> On 01/07/2023 21:07, Günther Noack wrote:
>> Hi!
>> 
>> On Tue, May 16, 2023 at 12:13:37AM +0800, Konstantin Meskhidze wrote:
>>> +TEST_F(inet, bind)
>> 
>> If you are using TEST_F() and you are enforcing a Landlock ruleset
>> within that test, doesn't that mean that the same Landlock ruleset is
>> now also enabled on other tests that get run after that test?
>> 
>> Most of the other Landlock selftests use TEST_F_FORK() for that
>> reason, so that the Landlock enforcement stays local to the specific
>> test, and does not accidentally influence the observed behaviour in
>> other tests.
> 
> Initially Konstantin wrote tests with TEST_F_FORK() but I asked him to
> only use TEST_F() because TEST_F_FORK() is only useful when a
> FIXTURE_TEARDOWN() needs access rights that were dropped with a
> TEST_F(), e.g. to unmount mount points set up with a FIXTURE_SETUP()
> while Landlock restricted a test process.
> 
> Indeed, TEST_F() already fork() to make sure there is no side effect
> with tests.
> 

  Hi, Günther
  Yep. Mickaёl asked me to replace TEST_F_FORK() with TEST_F(). Please 
check this thread
 
https://lore.kernel.org/netdev/33c1f049-12e4-f06d-54c9-b54eec779e6f@digikod.net/
T
>> 
>> The same question applies to other test functions in this file as
>> well.
>> 
>> –Günther
> .
