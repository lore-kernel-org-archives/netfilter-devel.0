Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67977C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 May 2022 15:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240185AbiESPB3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 May 2022 11:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbiESPBL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 May 2022 11:01:11 -0400
X-Greylist: delayed 1826 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 08:00:19 PDT
Received: from smtp-bc0c.mail.infomaniak.ch (smtp-bc0c.mail.infomaniak.ch [45.157.188.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F89DFF4F
        for <netfilter-devel@vger.kernel.org>; Thu, 19 May 2022 08:00:19 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L3tM56JqgzMqhbv;
        Thu, 19 May 2022 17:00:17 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4L3tM520f0zlj4cC;
        Thu, 19 May 2022 17:00:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652972417;
        bh=RrRKi8oUmt1YB3I+ph8gviDGRzqyCTf/OJOkMK4rIDo=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=QJZpPYja4fQyEaMcXUol3MtpZ+U7yE3IfeK1RsWyuyjVe/jdemwnwmGxFlMD/pzC+
         YrdJ2x2mR02yKfVICVShSoC//hK2Se6y7TjVy0IKxAjtpTIRBMx2Ps2JoexZzpVr3T
         IaseJaiJeDlVwUIUdchpqXy81KcxO6Cz+uV/wDVM=
Message-ID: <acda6f05-efeb-4f44-9189-589917a45b95@digikod.net>
Date:   Thu, 19 May 2022 17:00:16 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-12-konstantin.meskhidze@huawei.com>
 <e2c67180-3ec5-f710-710a-0c2644bfa54e@digikod.net>
 <1297f02f-5c2c-bebd-da58-eed9b8ee97cc@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 11/15] seltests/landlock: connect() with AF_UNSPEC
 tests
In-Reply-To: <1297f02f-5c2c-bebd-da58-eed9b8ee97cc@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 19/05/2022 14:31, Konstantin Meskhidze wrote:
> 
> 
> 5/17/2022 11:55 AM, Mickaël Salaün пишет:
>> I guess these tests would also work with IPv6. You can then use the 
>> "alternative" tests I explained.
>>
>    Do you mean adding new helpers such as bind_variant() and 
> connect_variant()??
>> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>>> Adds two selftests for connect() action with
>>> AF_UNSPEC family flag.
>>> The one is with no landlock restrictions
>>> allows to disconnect already conneted socket
>>> with connect(..., AF_UNSPEC, ...):
>>>      - connect_afunspec_no_restictions;
>>> The second one refuses landlocked process
>>> to disconnect already connected socket:
>>>      - connect_afunspec_with_restictions;
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v3:
>>> * Add connect_afunspec_no_restictions test.
>>> * Add connect_afunspec_with_restictions test.
>>>
>>> Changes since v4:
>>> * Refactoring code with self->port, self->addr4 variables.
>>> * Adds bind() hook check for with AF_UNSPEC family.
>>>
>>> ---
>>>   tools/testing/selftests/landlock/net_test.c | 121 ++++++++++++++++++++
>>>   1 file changed, 121 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/landlock/net_test.c 
>>> b/tools/testing/selftests/landlock/net_test.c
>>> index cf914d311eb3..bf8e49466d1d 100644
>>> --- a/tools/testing/selftests/landlock/net_test.c
>>> +++ b/tools/testing/selftests/landlock/net_test.c
>>> @@ -449,6 +449,7 @@ TEST_F_FORK(socket_test, 
>>> connect_with_restrictions_ip6) {
>>>       int new_fd;
>>>       int sockfd_1, sockfd_2;
>>>       pid_t child_1, child_2;
>>> +
>>>       int status;
>>>
>>>       struct landlock_ruleset_attr ruleset_attr = {
>>> @@ -467,10 +468,12 @@ TEST_F_FORK(socket_test, 
>>> connect_with_restrictions_ip6) {
>>>
>>>       const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>>>               sizeof(ruleset_attr), 0);
>>> +
>>
>> Please no…
>>
>   Sorry for that. I will apply clang-format-14.

clang-format will not complain about these new lines.


>>
>>>       ASSERT_LE(0, ruleset_fd);
>>>
>>>       /* Allows connect and bind operations to the port[0] socket */
>>>       ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>>> LANDLOCK_RULE_NET_SERVICE,
>>> +
>>
>> ditto
> 
>    Ditto. Will be fixed with clang-format.
