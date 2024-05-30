Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD16E169AC6;
	Thu, 30 May 2024 14:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079734; cv=none; b=dtxh86bbeJ6nbPdPhY1Eozts4LvcpPrfKnwu3hxMmdBUg+F3KDXORGpF41ISWAUbk6Z1yuzHySXGThYWCAuZwR/Tly8FntXzuHCw0L9+703xO8886IgWRGXMOkImOtiY2P2swBMGKptCN7eDqKeR6boR4dQwTJYhMA9lXvYumQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079734; c=relaxed/simple;
	bh=nw72xWnPpdyLXDd6BSSXfeSuAij6WeLgNpBcNRwcIao=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cxpv7taI9362vLoLEi0dMUtq7xGKcEZFlMtb0Oc8HcoTKhQrlYmtfThQyOzhkXuEMpCL0PJLMwAjY8dHNQV6utu+z6pqffJdKYQyMKZ0UzeQfw5wgUgNofZ2cZdrs6BgUc9du/pVuZBr3kyPrYyrG4Lf3DBe28m8fezBU7kTOZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VqpZq18vWzmWxF;
	Thu, 30 May 2024 22:30:59 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 813F018007F;
	Thu, 30 May 2024 22:35:23 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 30 May 2024 22:35:19 +0800
Message-ID: <f4b5e2b9-e960-fd08-fdf4-328bb475e2ef@huawei-partners.com>
Date: Thu, 30 May 2024 17:35:14 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/12] selftests/landlock: Add
 protocol.socket_access_rights to socket tests
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240524093015.2402952-5-ivanov.mikhail1@huawei-partners.com>
 <ZlTyj_0g-E4oM22G@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZlTyj_0g-E4oM22G@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 dggpemm500020.china.huawei.com (7.185.36.49)



5/27/2024 11:52 PM, Günther Noack wrote:
> Hello!
> 
> I see that this test is adapted from the network_access_rights test in
> net_test.c, and some of the subsequent are similarly copied from there.  It
> makes it hard to criticize the code, because being a little bit consistent is
> probably a good thing.  Have you found any opportunities to extract
> commonalities into common.h?

I think that all common tests should be extracted to common.h or maybe
some new header. *_test.c could maintain a fixture for these tests for
some rule-specific logic. Such refactoring should be in separate patch
though.

> 	
> On Fri, May 24, 2024 at 05:30:07PM +0800, Mikhail Ivanov wrote:
>> Add test that checks possibility of adding rule with every possible
>> access right.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>
>> Changes since v1:
>> * Formats code with clang-format.
>> * Refactors commit message.
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 28 +++++++++++++++++++
>>   1 file changed, 28 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index 4c51f89ed578..eb5d62263460 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -178,4 +178,32 @@ TEST_F(protocol, create)
>>   	ASSERT_EQ(EAFNOSUPPORT, test_socket(&self->unspec_srv0));
>>   }
>>   
>> +TEST_F(protocol, socket_access_rights)
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = ACCESS_ALL,
>> +	};
>> +	struct landlock_socket_attr protocol = {
>> +		.family = self->srv0.protocol.family,
>> +		.type = self->srv0.protocol.type,
>> +	};
>> +	int ruleset_fd;
>> +	__u64 access;
>> +
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	for (access = 1; access <= ACCESS_LAST; access <<= 1) {
>> +		protocol.allowed_access = access;
>> +		EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +					       &protocol, 0))
>> +		{
>> +			TH_LOG("Failed to add rule with access 0x%llx: %s",
>> +			       access, strerror(errno));
>> +		}
>> +	}
>> +	EXPECT_EQ(0, close(ruleset_fd));
> 
> Reviewed-by: Günther Noack <gnoack@google.com>
> 
> P.S. We are inconsistent with our use of EXPECT/ASSERT for test teardown.  The
> fs_test.c uses ASSERT_EQ in these places whereas net_test.c and your new tests
> use EXPECT_EQ.
> 
> It admittedly does not make much of a difference for close(), so should be OK.
> Some other selftests are even ignoring the result for close().  If we want to
> make it consistent in the Landlock tests again, we can also do it in an
> independent sweep.
> 
> I filed a small cleanup task as a reminder:
> https://github.com/landlock-lsm/linux/issues/31
> 
> —Günther
