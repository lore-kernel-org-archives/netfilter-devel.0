Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CDAC77B72
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 16:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjDTQGz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 12:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbjDTQGy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 12:06:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85C24EFB;
        Thu, 20 Apr 2023 09:06:33 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Q2Mpy6MSjz67RPp;
        Fri, 21 Apr 2023 00:01:46 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 17:06:31 +0100
Message-ID: <d14db00f-68c4-d183-1936-3d82c236c5e3@huawei.com>
Date:   Thu, 20 Apr 2023 19:06:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v10 10/13] selftests/landlock: Share enforce_ruleset()
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-11-konstantin.meskhidze@huawei.com>
 <a95dabd6-4c69-d915-a8a8-162c68c6e143@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <a95dabd6-4c69-d915-a8a8-162c68c6e143@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



4/16/2023 7:12 PM, Mickaël Salaün пишет:
> 
> On 23/03/2023 09:52, Konstantin Meskhidze wrote:
>> This commit moves enforce_ruleset() helper function to common.h so that
>> to be used both by filesystem tests and network ones.
> 
> "so that it can be used"

   Got it.
> 
> 
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v9:
>> * None.
>> 
>> Changes since v8:
>> * Adds __maybe_unused attribute for enforce_ruleset() helper.
>> 
>> Changes since v7:
>> * Refactors commit message.
>> 
>> Changes since v6:
>> * None.
>> 
>> Changes since v5:
>> * Splits commit.
>> * Moves enforce_ruleset helper into common.h
>> * Formats code with clang-format-14.
>> 
>> ---
>>   tools/testing/selftests/landlock/common.h  | 10 ++++++++++
>>   tools/testing/selftests/landlock/fs_test.c | 10 ----------
>>   2 files changed, 10 insertions(+), 10 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
>> index d7987ae8d7fc..0fd6c4cf5e6f 100644
>> --- a/tools/testing/selftests/landlock/common.h
>> +++ b/tools/testing/selftests/landlock/common.h
>> @@ -256,3 +256,13 @@ static int __maybe_unused send_fd(int usock, int fd_tx)
>>   		return -errno;
>>   	return 0;
>>   }
>> +
>> +static void __maybe_unused
>> +enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
>> +{
>> +	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
>> +	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
>> +	{
>> +		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
>> +	}
>> +}
>> diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
>> index b6c4be3faf7a..b762b5419a89 100644
>> --- a/tools/testing/selftests/landlock/fs_test.c
>> +++ b/tools/testing/selftests/landlock/fs_test.c
>> @@ -598,16 +598,6 @@ static int create_ruleset(struct __test_metadata *const _metadata,
>>   	return ruleset_fd;
>>   }
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
>>   TEST_F_FORK(layout1, proc_nsfs)
>>   {
>>   	const struct rule rules[] = {
>> --
>> 2.25.1
>> 
> .
