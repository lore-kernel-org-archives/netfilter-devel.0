Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20A218B478;
	Wed, 18 Sep 2024 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726667744; cv=none; b=tX9r+eBh0Eqfz1H+bh1yUVzEHHHlqOi1zGz1oR8DZCPTTS9YlE5+s9HGkGThCIWHDBrix/ZA7imSGdgRmdzKNtPzb+4U/79QhjDf942IyKtTqb+cVXmGEcWOak/W4JzMkBxoDq4mXx6yYOl097zukn8gTLs0jLm4AqYVP7LtWME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726667744; c=relaxed/simple;
	bh=4g5LbF2jsryqv6b1VJibeqyspCm9tp416dwH7lyZE1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=q7pdIskSh/mR7hwo14WXYOqdwoFeftMKyGFmHMGX7wU+5EmPE7/zS+dR0xaJHifGBnM83HCaG66kHumXS5SsLt+TEgaQlZ3vKwvmgXiSmvLUemJCwxV4w2vr2oB53a+CuDmMuLA69ebIDlam10FiuQiLA4TWk+G32DkvbGVoiFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4X805x5c2Mz1T7dH;
	Wed, 18 Sep 2024 21:35:49 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id B507A1800A7;
	Wed, 18 Sep 2024 21:37:05 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 18 Sep 2024 21:37:01 +0800
Message-ID: <810a169f-4d79-8a59-d58a-bba496b5f68a@huawei-partners.com>
Date: Wed, 18 Sep 2024 16:36:57 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 11/19] selftests/landlock: Test unsupported
 protocol restriction
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-12-ivanov.mikhail1@huawei-partners.com>
 <ZurNgJKzG-oWL3Tq@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZurNgJKzG-oWL3Tq@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/18/2024 3:54 PM, Günther Noack wrote:
> On Wed, Sep 04, 2024 at 06:48:16PM +0800, Mikhail Ivanov wrote:
>> Add test validating that Landlock doesn't wrongfully
>> return EACCES for unsupported address family and protocol.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>> Changes since v1:
>> * Adds socket(2) error code check when ruleset is not established.
>> * Tests unsupported family for error code consistency.
>> * Renames test to `unsupported_af_and_prot`.
>> * Refactors commit title and message.
>> * Minor fixes.
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 47 +++++++++++++++++++
>>   1 file changed, 47 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index 047603abc5a7..ff5ace711697 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -581,4 +581,51 @@ TEST_F(prot_outside_range, add_rule)
>>   	ASSERT_EQ(0, close(ruleset_fd));
>>   }
>>   
>> +TEST(unsupported_af_and_prot)
> 
> Nit: If I am reading this test correctly, the point is to make sure that for
> unsuported (EAFNOSUPPORT and ESOCKTNOSUPPORT) combinations of "family" and
> "type", socket(2) returns the same error code, independent of whether that
> combination is restricted with Landlock or not.  Maybe we could make it more
> clear from the test name or a brief docstring that this is about error code
> compatibility when calling socket() under from within a Landlock domain?

Agreed, thanks for the nit! I think that docstring would be more
appropriate here (similar to the kernel_socket test).

> 
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +	};
>> +	struct landlock_socket_attr socket_af_unsupported = {
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = AF_UNSPEC,
>> +		.type = SOCK_STREAM,
>> +	};
>> +	struct landlock_socket_attr socket_prot_unsupported = {
>                                             ^^^^
> Here and in the test name: Should this say "type" instead of "prot"?
> It seems that the part that is unsupported here is the socket(2) "type"
> argument, not the "protocol" argument?

You're right, this naming is more more suitable for the EPROTONOSUPPORT.
I'll extend this test by adding a separate check for this error code.

> 
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = AF_UNIX,
>> +		.type = SOCK_PACKET,
>> +	};
>> +	int ruleset_fd;
>> +
>> +	/* Tries to create a socket when ruleset is not established. */
>> +	ASSERT_EQ(EAFNOSUPPORT, test_socket(AF_UNSPEC, SOCK_STREAM, 0));
>> +	ASSERT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
>> +
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +				       &socket_af_unsupported, 0));
>> +	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +				       &socket_prot_unsupported, 0));
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	ASSERT_EQ(0, close(ruleset_fd));
>> +
>> +	/* Tries to create a socket when protocols are allowed. */
>> +	EXPECT_EQ(EAFNOSUPPORT, test_socket(AF_UNSPEC, SOCK_STREAM, 0));
>> +	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
>> +
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	ASSERT_EQ(0, close(ruleset_fd));
>> +
>> +	/* Tries to create a socket when protocols are restricted. */
>> +	EXPECT_EQ(EAFNOSUPPORT, test_socket(AF_UNSPEC, SOCK_STREAM, 0));
>> +	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
>> +}
>> +
>>   TEST_HARNESS_MAIN
>> -- 
>> 2.34.1
>>
