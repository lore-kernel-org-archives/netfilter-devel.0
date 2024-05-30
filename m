Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F09187557;
	Thu, 30 May 2024 15:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717082902; cv=none; b=Ln0dWr2qXZUU5NuJJqdbSER2U035pAY0QIRlRBUz0zq7aelYyVGe0AbcKYWp9aHkKTpBE5eTzPBllhLUuCKAQc9J1N6DkhjlnUhCwHwZWNB2Mhv4easi72lv2pSCADCCfPzGz2amtKvu+3SBhOCxY5qWE+G9BrPar8hWbm3RC3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717082902; c=relaxed/simple;
	bh=0rFOh5Wx0WXGSD0QbT8W0KPBA4iJlpiLDxiO6JVIE2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=E7UO6rM7NC073u0bMmkHJlqq+5xGqTer/HamaJ9JKGGPcE7pWPbh8jfZw8BUYDBXEVHaDTECA8n4eqLV9REbgt3rK/454hxEdBbsAZh9L1G172YFKyxkzstWcanZzmZBnP5v7KBYPkeL282sTEQtkIn6/f1yY7XUqS32QAuDhyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VqqmS2t8czxR38;
	Thu, 30 May 2024 23:24:24 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id CEA72180069;
	Thu, 30 May 2024 23:28:14 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 30 May 2024 23:28:10 +0800
Message-ID: <9f0ffe83-8ecf-59f8-83e5-6d4828f02308@huawei-partners.com>
Date: Thu, 30 May 2024 18:28:05 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 07/12] selftests/landlock: Add protocol.inval to
 socket tests
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240524093015.2402952-8-ivanov.mikhail1@huawei-partners.com>
 <ZlT6wGIRbQI4pjmK@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZlT6wGIRbQI4pjmK@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 dggpemm500020.china.huawei.com (7.185.36.49)



5/28/2024 12:27 AM, Günther Noack wrote:
> On Fri, May 24, 2024 at 05:30:10PM +0800, Mikhail Ivanov wrote:
>> Add test that validates behavior of landlock with fully
>> access restriction.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>
>> Changes since v1:
>> * Refactors commit message.
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 34 +++++++++++++++++++
>>   1 file changed, 34 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index 31af47de1937..751596c381fe 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -265,4 +265,38 @@ TEST_F(protocol, rule_with_unhandled_access)
>>   	EXPECT_EQ(0, close(ruleset_fd));
>>   }
>>   
>> +TEST_F(protocol, inval)
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE
>> +	};
>> +
>> +	struct landlock_socket_attr protocol = {
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = self->srv0.protocol.family,
>> +		.type = self->srv0.protocol.type,
>> +	};
>> +
>> +	struct landlock_socket_attr protocol_denied = {
>> +		.allowed_access = 0,
>> +		.family = self->srv0.protocol.family,
>> +		.type = self->srv0.protocol.type,
>> +	};
>> +
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
>> +	/* Adds with legitimate values. */
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +				       &protocol, 0));
>> +}
>> +
>>   TEST_HARNESS_MAIN
>> -- 
>> 2.34.1
>>
> 
> Code is based on TEST_F(mini, inval) from net_test.c.  I see that you removed
> the check for unhandled allowed_access, because there is already a separate
> TEST_F(mini, rule_with_unhandled_access) for that.
> 
> That is true for the "legitimate value" case as well, though...?  We already
> have a test for that too.  Should that also get removed?

I thought that "legitimate value" case is needed to check that adding
a zero-access rule doesn't affect landlock behavior when adding correct
rules. Do you think it's not worth it?

> 
> Should we then rename the "inval" test to "rule_with_zero_access", so that the
> naming is consistent with the "rule_with_unhandled_access" test?

Definitely, thanks!

> 
> —Günther
