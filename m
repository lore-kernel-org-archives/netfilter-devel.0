Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D01566A;
	Thu, 19 Sep 2024 10:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726743250; cv=none; b=jBPvi8JmDlqyzzxJI7dpFte54fK+2F5M8rPbquutJ7a5csNijW4hPWozmmaQ0k2TAw0T5DZCk3he7u0c8BaYjBpMaLAqsczI5jPgtTZgb4tXJsGJmcVy0DNnIYd05wCY8dyGAOPRDAbmcR0mjSLExR21Vi71zKIeoM2pJ7AxijM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726743250; c=relaxed/simple;
	bh=BsGDiCA1AlGAx1BMc5uiXmAshSyBwXv5Xg827sUD5S4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EXE7ufvZqhfJvr8+PgkSCyGGK86yLVDwpsD0RL6IrrjmafILBsJDCl9lgnXwCkAniCw6BaYDve4V9OfFIt3HvxK6mU9xg0d7IgcPilJj+vU+eqcPfkB0EXgb0e8Te885C19Vu76k41vmZma8fq1E02QqyeAAEWnsWpCv+Sj2SRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4X8XSX1JpPz20p7N;
	Thu, 19 Sep 2024 18:53:48 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id E179314010C;
	Thu, 19 Sep 2024 18:54:02 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 19 Sep 2024 18:53:58 +0800
Message-ID: <614b4c36-e0a1-1fc2-cec3-017a7d2bcebb@huawei-partners.com>
Date: Thu, 19 Sep 2024 13:53:54 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 12/19] selftests/landlock: Test that kernel space
 sockets are not restricted
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-13-ivanov.mikhail1@huawei-partners.com>
 <ZurPAMch78Mmylt5@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZurPAMch78Mmylt5@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/18/2024 4:00 PM, Günther Noack wrote:
> This is a good way to test this, IMHO. Good find.
> The comment at the bottom is really valuable. :)
> 
> Out of curiosity: I suspect that a selftest with NFS or another network-backed
> filesystem might be too complicated?  Have you tried that manually, by any
> chance?

I haven't, just ran through a code a little bit. I think that testing
NFS is possible, but it depends on which scenario we want to test.
Simple creation of a server may require only to mount NFS with the
appropriate parameters. Anyway, I don't see any reason for implementing
such test if restriction of kernel sockets is already tested with SMC
socket creation.

> 
> 
> On Wed, Sep 04, 2024 at 06:48:17PM +0800, Mikhail Ivanov wrote:
>> Add test validating that Landlock provides restriction of user space
>> sockets only.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 39 ++++++++++++++++++-
>>   1 file changed, 38 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index ff5ace711697..23698b8c2f4d 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -7,7 +7,7 @@
>>   
>>   #define _GNU_SOURCE
>>   
>> -#include <linux/landlock.h>
>> +#include "landlock.h"
>>   #include <linux/pfkeyv2.h>
>>   #include <linux/kcm.h>
>>   #include <linux/can.h>
>> @@ -628,4 +628,41 @@ TEST(unsupported_af_and_prot)
>>   	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
>>   }
>>   
>> +TEST(kernel_socket)
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +	};
>> +	struct landlock_socket_attr smc_socket_create = {
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = AF_SMC,
>> +		.type = SOCK_STREAM,
>> +	};
>> +	int ruleset_fd;
>> +
>> +	/*
>> +	 * Checks that SMC socket is created sucessfuly without
> 
> Typo nit: "successfully"
>               ^^     ^^

Thanks, will be fixed.

> 
>> +	 * landlock restrictions.
>> +	 */
>> +	ASSERT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
>> +
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +				       &smc_socket_create, 0));
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	ASSERT_EQ(0, close(ruleset_fd));
>> +
>> +	/*
>> +	 * During the creation of an SMC socket, an internal service TCP socket
>> +	 * is also created (Cf. smc_create_clcsk).
>> +	 *
>> +	 * Checks that Landlock does not restrict creation of the kernel space
>> +	 * socket.
>> +	 */
>> +	EXPECT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
>> +}
>> +
>>   TEST_HARNESS_MAIN
>> -- 
>> 2.34.1
>>
> 
> Reviewed-by: Günther Noack <gnoack@google.com>
