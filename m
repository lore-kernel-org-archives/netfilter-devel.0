Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C782D2E5;
	Fri, 13 Sep 2024 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726244135; cv=none; b=ThMww8o1keB2vUrkOmTJKUof2GFDYnIEPgkw9Q67N88GSzwhxR49ESlLUi77RtVso3ioIDL0pQtdeyYKct7bJx5v4kO+1ItX6LaDiq2oyG9uos0fGwE6lKrMLt3hPiygdithARoSvlumtXJgbb6SlPanodBLrL8aWj7X9yFQHWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726244135; c=relaxed/simple;
	bh=/hADo25VOWxE6cDzncVwMHVnQ5/7gnWCFGFlhaWnpOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Fxf8E/5FrhsdDRQM2vxB9xotJITOsdKLxR77QQjtPSJKe37ovVYAH0MyhMhINqlAYTgOtaWrW1rBuHMcl+PPJAYxZgYxd6UchBhoN44H4lfvecoz/GOZbPnZMGnbW40uR2eWZe+zWJih0PinubP5uC0ua25A93FXQkglCiSiJI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4X4zr40ryFzmVCX;
	Sat, 14 Sep 2024 00:13:24 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 23B49180106;
	Sat, 14 Sep 2024 00:15:29 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 14 Sep 2024 00:15:25 +0800
Message-ID: <2f07d52b-0273-b2d8-450b-db88a7f16042@huawei-partners.com>
Date: Fri, 13 Sep 2024 19:15:20 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 06/19] selftests/landlock: Test adding a rule for
 unhandled access
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-7-ivanov.mikhail1@huawei-partners.com>
 <ZuAP8iSv_sjmlYIp@google.com>
 <fd6ef478-4d0b-03f2-78f6-8bfd0fc3a846@huawei-partners.com>
 <ZuRUagjolNjXsS3r@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZuRUagjolNjXsS3r@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/13/2024 6:04 PM, Günther Noack wrote:
> On Wed, Sep 11, 2024 at 11:19:48AM +0300, Mikhail Ivanov wrote:
>> On 9/10/2024 12:22 PM, Günther Noack wrote:
>>> Hi!
>>>
>>> On Wed, Sep 04, 2024 at 06:48:11PM +0800, Mikhail Ivanov wrote:
>>>> Add test that validates behaviour of Landlock after rule with
>>>> unhandled access is added.
>>>>
>>>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>>>> ---
>>>> Changes since v2:
>>>> * Replaces EXPECT_EQ with ASSERT_EQ for close().
>>>> * Refactors commit title and message.
>>>>
>>>> Changes since v1:
>>>> * Refactors commit message.
>>>> ---
>>>>    .../testing/selftests/landlock/socket_test.c  | 33 +++++++++++++++++++
>>>>    1 file changed, 33 insertions(+)
>>>>
>>>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>>>> index 811bdaa95a7a..d2fedfca7193 100644
>>>> --- a/tools/testing/selftests/landlock/socket_test.c
>>>> +++ b/tools/testing/selftests/landlock/socket_test.c
>>>> @@ -351,4 +351,37 @@ TEST_F(protocol, rule_with_unknown_access)
>>>>    	ASSERT_EQ(0, close(ruleset_fd));
>>>>    }
>>>> +TEST_F(protocol, rule_with_unhandled_access)
>>>> +{
>>>> +	struct landlock_ruleset_attr ruleset_attr = {
>>>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>>>> +	};
>>>> +	struct landlock_socket_attr protocol = {
>>>> +		.family = self->prot.family,
>>>> +		.type = self->prot.type,
>>>> +	};
>>>> +	int ruleset_fd;
>>>> +	__u64 access;
>>>> +
>>>> +	ruleset_fd =
>>>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>>>> +	ASSERT_LE(0, ruleset_fd);
>>>> +
>>>> +	for (access = 1; access > 0; access <<= 1) {
>>>> +		int err;
>>>> +
>>>> +		protocol.allowed_access = access;
>>>> +		err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>>>> +					&protocol, 0);
>>>> +		if (access == ruleset_attr.handled_access_socket) {
>>>> +			EXPECT_EQ(0, err);
>>>> +		} else {
>>>> +			EXPECT_EQ(-1, err);
>>>> +			EXPECT_EQ(EINVAL, errno);
>>>> +		}
>>>> +	}
>>>> +
>>>> +	ASSERT_EQ(0, close(ruleset_fd));
>>>> +}
>>>> +
>>>
>>> I should probably have noticed this on the first review round; you are not
>>> actually exercising any scenario here where a rule with unhandled access is
>>> added.
>>>
>>> To clarify, the notion of an access right being "unhandled" means that the
>>> access right was not listed at ruleset creation time in the ruleset_attr's
>>> .handled_access_* field where it would have belonged.  If that is the case,
>>> adding a ruleset with that access right is going to be denied.
>>>
>>> As an example:
>>> If the ruleset only handles LANDLOCK_ACCESS_FS_WRITE_FILE and nothing else,
>>> then, if the test tries to insert a rule for LANDLOCK_ACCESS_SOCKET_CREATE,
>>> that call is supposed to fail -- because the "socket creation" access right is
>>> not handled.
>>
>> This test was added to exercise adding a rule with future possible
>> "unhandled" access rights of "socket" type, but since this patch
>> implements only one, this test is really meaningless. Thank you for
>> this note!
>>
>>>
>>> IMHO the test would become more reasonable if it was more clearly "handling"
>>> something entirely unrelated at ruleset creation time, e.g. one of the file
>>> system access rights.  (And we could do the same for the "net" and "fs" tests as
>>> well.)
>>>
>>> Your test is a copy of the same test for the "net" rights, which in turn is a
>>> copy of teh same test for the "fs" rights.  When the "fs" test was written, the
>>> "fs" access rights were the only ones that could be used at all to create a
>>> ruleset, but this is not true any more.
>>
>> Good idea! Can I implement such test in the current patchset?
> 
> Yes, I think it would be a good idea.
> 
> I would, in fact, recommend to turn the rule_with_unhandled_access test into that test.
> 
> The test traces its roots clearly to
> 
>    TEST_F(mini, rule_with_unhandled_access)  from net_test.c
> 
> and to
> 
>    TEST_F_FORK(layout1, rule_with_unhandled_access)  from fs_test.c
> 
> 
> and I think all three variants would better be advised to create a ruleset with
> 
> struct landlock_ruleset_attr ruleset_attr = {
> 	.handled_access_something_entirely_different = LANDLOCK_ACCESS_WHATEVER,
> }
> 
> and then check their corresponding fs, net and socket access rights using a
> landlock_add_rule() call for the access rights that belong to the respective
> module, so that it exercises the scenario where userspace attempts to use the
> access right in a rule, but the surrounding ruleset did not restrict the same
> access right (it was "unhandled").

Agreed, thanks for the recommendation!

> 
> In spirit, it would be nicest if we could create a ruleset where nothing at all
> is handled, but I believe in that case, the landlock_create_ruleset() call would
> already fail.
> 
> —Günther
> 
> P.S.: I am starting to grow a bit uncomfortable with the amount of duplicated
> test code that we start having across the different types of access rights.  If
> you see a way to keep this more in check, while still keeping the tests
> expressive and not over-frameworking them, let's try to move in that direction
> if we can. :)

Yeah, I really want to see patchset dedicated to tests refactoring. I'll
try to finish the description of corresponding issue [1] ASAP.

[1] https://github.com/landlock-lsm/linux/issues/34
