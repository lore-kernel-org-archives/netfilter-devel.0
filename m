Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04321CD68E6
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 02:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441906AbjJJCrz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 22:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441879AbjJJCry (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 22:47:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C89B9E;
        Mon,  9 Oct 2023 19:47:53 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S4Kxc1kK7z6D8Zj;
        Tue, 10 Oct 2023 10:44:52 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 10 Oct 2023 03:47:50 +0100
Message-ID: <017a5263-13b9-1b07-4bb2-52754585f2ac@huawei.com>
Date:   Tue, 10 Oct 2023 05:47:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v12 09/12] selftests/landlock: Share enforce_ruleset()
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
 <20230920092641.832134-10-konstantin.meskhidze@huawei.com>
 <20231001.Aiv7Chaedei0@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20231001.Aiv7Chaedei0@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



10/2/2023 11:26 PM, Mickaël Salaün пишет:
> On Wed, Sep 20, 2023 at 05:26:37PM +0800, Konstantin Meskhidze wrote:
>> This commit moves enforce_ruleset() helper function to common.h so that
>> it can be used both by filesystem tests and network ones.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v11:
>> * None.
>> 
> 
>> diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
>> index 251594306d40..7c94d3933b68 100644
>> --- a/tools/testing/selftests/landlock/fs_test.c
>> +++ b/tools/testing/selftests/landlock/fs_test.c
>> @@ -677,17 +677,7 @@ static int create_ruleset(struct __test_metadata *const _metadata,
>>  	return ruleset_fd;
>>  }
>> 
>> -static void enforce_ruleset(struct __test_metadata *const _metadata,
>> -			    const int ruleset_fd)
>> -{
>> -	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
>> -	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
>> -	{
>> -		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
>> -	}
>> -}
>> -
>> -TEST_F_FORK(layout0, proc_nsfs)
>> +TEST_F_FORK(layout1, proc_nsfs)
> 
> Why this change?

  Looks like a bug coming from v11 version.
  You have added layout0 recently. in V11 version
  there was TEST_F_FORK(layout1, proc_nsfs), and I missed the changed
  , resolving conflict with layout1.
  Will be fixed. Thanks.
> 
>>  {
>>  	const struct rule rules[] = {
>>  		{
>> --
>> 2.25.1
>> 
> .
