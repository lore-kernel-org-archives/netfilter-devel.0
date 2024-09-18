Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E1A17E019;
	Wed, 18 Sep 2024 13:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726664659; cv=none; b=M89exNpeSJSNy/0RJ+jVcTlEVKD3RrKKXRbiiabkjPt6P7vdZf67Sg0oAMkT65JqVGBeSJF0CR0w1W7mhjLQuOZ6+ETIJTa4NwEZO5/Ld7EKiS10telGRkcSJHqJZXKwdb5La0JmDqPR+WnXIcl8JkDGCvw42XrErADIRdGpKjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726664659; c=relaxed/simple;
	bh=Gti3B3tBG4fTGujWYxe9usSHv+WGjyz56jQdC/C2v0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=m0E5JNhLEZ8QHMDQBvMQd3FIxUSPs/ySa2W9GnKecMAuzUsA626EIRODIGPwPB3UWKf0kZmWe1DVuMWm/aO6CEgliDptJJi3QqucA9dIWd44ExkrH0EEArrpE6zeqNGC+B2yupCPb6D95QQe059+q9eZAFJiFRE3kXdDhbX8HqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4X7zP4422Yz20nwl;
	Wed, 18 Sep 2024 21:03:52 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 4D3D41401F0;
	Wed, 18 Sep 2024 21:04:06 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 18 Sep 2024 21:04:02 +0800
Message-ID: <8f2ad9d5-3e1e-babd-0399-2111a4a2f5e0@huawei-partners.com>
Date: Wed, 18 Sep 2024 16:03:58 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 07/19] selftests/landlock: Test adding a rule for
 empty access
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-8-ivanov.mikhail1@huawei-partners.com>
 <ZurKsk0LHrIxCoV9@google.com>
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZurKsk0LHrIxCoV9@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/18/2024 3:42 PM, Günther Noack wrote:
> On Wed, Sep 04, 2024 at 06:48:12PM +0800, Mikhail Ivanov wrote:
>> Add test that validates behaviour of Landlock after rule with
>> empty access is added.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>> Changes since v2:
>> * Renames protocol.inval into protocol.rule_with_empty_access.
>> * Replaces ASSERT_EQ with EXPECT_EQ for landlock_add_rule().
>> * Closes ruleset_fd.
>> * Refactors commit message and title.
>> * Minor fixes.
>>
>> Changes since v1:
>> * Refactors commit message.
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 33 +++++++++++++++++++
>>   1 file changed, 33 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index d2fedfca7193..d323f649a183 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -384,4 +384,37 @@ TEST_F(protocol, rule_with_unhandled_access)
>>   	ASSERT_EQ(0, close(ruleset_fd));
>>   }
>>   
>> +TEST_F(protocol, rule_with_empty_access)
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE
>> +	};
>> +	struct landlock_socket_attr protocol_allowed = {
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = self->prot.family,
>> +		.type = self->prot.type,
>> +	};
>> +	struct landlock_socket_attr protocol_denied = {
>> +		.allowed_access = 0,
>> +		.family = self->prot.family,
>> +		.type = self->prot.type,
>> +	};
>> +	int ruleset_fd;
>> +
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	/* Checks zero access value. */
>> +	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +					&protocol_denied, 0));
>> +	EXPECT_EQ(ENOMSG, errno);
>> +
>> +	/* Adds with legitimate value. */
>> +	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +				       &protocol_allowed, 0));
> 
> In my mind, the check with the legitimate rule is probably already done in other
> places and does not strictly need to be duplicated here.
> 
> But up to you, it's fine either way. :)

This test is a duplicate of mini.inval from net_test.c. I thought this
line can be useful to check that adding rule with zero access does not
affect Landlock behavior of adding a line with legitimate value. But
this is a really weak reason and I'd like to remove this line for
simplicity. Thank you!

> 
> Reviewed-by: Günther Noack <gnoack@google.com>
> 
>> +
>> +	ASSERT_EQ(0, close(ruleset_fd));
>> +}
>> +
>>   TEST_HARNESS_MAIN
>> -- 
>> 2.34.1
>>
