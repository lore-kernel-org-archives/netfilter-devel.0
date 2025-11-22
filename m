Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D6C757EA;
	Sat, 22 Nov 2025 10:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763806913; cv=none; b=WZSjvXLwAehz3t+lZDZ7dt8WiE/TnTWVv6C9CiU2LU6RxTww3zX7fJz7pqj5nah5H3Oj7n8ZMNXd334grleNsCeh9aW5NdNTS2rBsa+Ii2Q7feEOucRx4++x4WRto2zpRd2mPCaua1xG036ejUpPL/v5Ze9H6tXdAEXlBEiHf+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763806913; c=relaxed/simple;
	bh=JhN4KajdYuov25fl8zbG1gvurzfTLNZiinySDI5UypM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=r1unWflqTtj5ZnRMLaXE1r+qGHnDZGNL6dCn2aSFSaSrSevc81MmnMGBU+dx5Q2HhoGsNzp2MS/0Ykj2UH60YEPdzevhuoPho/mu6k5UBqKeNFMfcyLQshwMZ5pLRuC7kHY9OjVp6roSua+OuiKamoFlVFA8Vu0xabxKjig4GUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dD7Qr5QS1zHnHBB;
	Sat, 22 Nov 2025 18:21:08 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 3BDDA140257;
	Sat, 22 Nov 2025 18:21:47 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 13:21:45 +0300
Message-ID: <306a198f-89dd-77e4-d45d-a1139d13d654@huawei-partners.com>
Date: Sat, 22 Nov 2025 13:21:30 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 12/19] selftests/landlock: Test socketpair(2)
 restriction
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: <mic@digikod.net>, <gnoack@google.com>, <willemdebruijn.kernel@gmail.com>,
	<matthieu@buffet.re>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
 <20251118134639.3314803-13-ivanov.mikhail1@huawei-partners.com>
 <20251122.4795c4c3bb03@gnoack.org>
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20251122.4795c4c3bb03@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 11/22/2025 1:16 PM, Günther Noack wrote:
> On Tue, Nov 18, 2025 at 09:46:32PM +0800, Mikhail Ivanov wrote:
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index e22e10edb103..d1a004c2e0f5 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -866,4 +866,59 @@ TEST_F(tcp_protocol, alias_restriction)
>>   	}
>>   }
>>   
>> +static int test_socketpair(int family, int type, int protocol)
>> +{
>> +	int fds[2];
>> +	int err;
>> +
>> +	err = socketpair(family, type | SOCK_CLOEXEC, protocol, fds);
>> +	if (err)
>> +		return errno;
>> +	/*
>> +	 * Mixing error codes from close(2) and socketpair(2) should not lead to
>> +	 * any (access type) confusion for this test.
>> +	 */
>> +	if (close(fds[0]) != 0)
>> +		return errno;
>> +	if (close(fds[1]) != 0)
>> +		return errno;
> 
> Very minor nit: the function leaks an FD if it returns early after the
> first close() call failed.  (Highly unlikely to happen though.)

Yeah, but AFAIK fd[0] may be leaked anyway if close() fails. Anyway
this shouldn't be an issue for tests.

> 
>> +	return 0;
>> +}
>> +
>> +TEST_F(mini, socketpair)
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +	};
>> +	const struct landlock_socket_attr unix_socket_create = {
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = AF_UNIX,
>> +		.type = SOCK_STREAM,
>> +		.protocol = 0,
>> +	};
>> +	int ruleset_fd;
>> +
>> +	/* Tries to create socket when ruleset is not established. */
>> +	ASSERT_EQ(0, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +				       &unix_socket_create, 0));
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	ASSERT_EQ(0, close(ruleset_fd));
>> +
>> +	/* Tries to create socket when protocol is allowed */
>> +	EXPECT_EQ(0, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
>> +
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> 
> You may want to check that landlock_create_ruleset() succeeded here:
> 
> ASSERT_LE(0, ruleset_fd)

thanks, I'll fix it.

> 
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	ASSERT_EQ(0, close(ruleset_fd));
>> +
>> +	/* Tries to create socket when protocol is restricted. */
>> +	EXPECT_EQ(EACCES, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
>> +}
>> +
>>   TEST_HARNESS_MAIN
>> -- 
>> 2.34.1
>>
> 
> Otherwise, looks good.
> –Günther
