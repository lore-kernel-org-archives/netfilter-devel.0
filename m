Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A3413213B;
	Thu, 30 May 2024 12:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717073463; cv=none; b=TVS4XaPCARGuJ4cuImJNdN0E7AgX+Hj6qOwJrHBLDPu/hfVFHAzUfZ7YdjxOJNrNJ9gaSJ8y4FclJzBNNqbgi9ZME+zvtDbl5ivfRsHYGnx9cBR3+7TSlNwxfmw3Xtcn1EIimc1TJmEBEMmvU2JkIYmV23ZxGGNvEaAx7vYZdPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717073463; c=relaxed/simple;
	bh=lKpaqNPJMf21IrGoIwYmzqq9mOimSqs4XI3W+F264Is=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fsJQoF6CYBuPUEjPsq5yTEMEytK/vOvpJ/YwWuBxzQ0Ti04Bw12k7xpNMPVQST8nzxWHin6TejJk1X8pprKqdL+s6Csd6JZYliuvddVs3UuoIFEDkMy2mLFTctWk3w8By3LbDNSXwP4l0oo5FF8lB+TNGy7TUFnJppivglTYw/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VqmGy2SzJzxR1N;
	Thu, 30 May 2024 20:47:06 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id A339118007A;
	Thu, 30 May 2024 20:50:56 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 30 May 2024 20:50:52 +0800
Message-ID: <10f3b3e0-d928-6bba-218c-f1b88778f83c@huawei-partners.com>
Date: Thu, 30 May 2024 15:50:47 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 03/12] selftests/landlock: Add protocol.create to
 socket tests
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240524093015.2402952-4-ivanov.mikhail1@huawei-partners.com>
 <ZlSmAhLV00iry6we@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZlSmAhLV00iry6we@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 dggpemm500020.china.huawei.com (7.185.36.49)



5/27/2024 6:27 PM, Günther Noack wrote:
> On Fri, May 24, 2024 at 05:30:06PM +0800, Mikhail Ivanov wrote:
>> Initiate socket_test.c selftests. Add protocol fixture for tests
>> with changeable family-type values. Only most common variants of
>> protocols (like ipv4-tcp,ipv6-udp, unix) were added.
>> Add simple socket access right checking test.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>
>> Changes since v1:
>> * Replaces test_socket_create() and socket_variant() helpers
>>    with test_socket().
>> * Renames domain to family in protocol fixture.
>> * Remove AF_UNSPEC fixture entry and add unspec_srv0 fixture field to
>>    check AF_UNSPEC socket creation case.
>> * Formats code with clang-format.
>> * Refactors commit message.
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 181 ++++++++++++++++++
>>   1 file changed, 181 insertions(+)
>>   create mode 100644 tools/testing/selftests/landlock/socket_test.c
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> new file mode 100644
>> index 000000000000..4c51f89ed578
>> --- /dev/null
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -0,0 +1,181 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Landlock tests - Socket
>> + *
>> + * Copyright © 2024 Huawei Tech. Co., Ltd.
>> + * Copyright © 2024 Microsoft Corporation
> 
> It looked to me like these patches came from Huawei?
> Was this left by accident?

Yeah, second line should be removed. Thanks!

> 
> 
>> + */
>> +
>> +#define _GNU_SOURCE
>> +
>> +#include <errno.h>
>> +#include <linux/landlock.h>
>> +#include <sched.h>
>> +#include <string.h>
>> +#include <sys/prctl.h>
>> +#include <sys/socket.h>
>> +
>> +#include "common.h"
>> +
>> +/* clang-format off */
>> +
>> +#define ACCESS_LAST LANDLOCK_ACCESS_SOCKET_CREATE
>> +
>> +#define ACCESS_ALL ( \
>> +	LANDLOCK_ACCESS_SOCKET_CREATE)
>> +
>> +/* clang-format on */
> 
> It does not look like clang-format would really mess up this format in a bad
> way.  Maybe we can remove the "clang-format off" section here and just write the
> "#define"s on one line?

You're right, I'll fix it

> 
> ACCESS_ALL is unused in this commit.
> Should it be introduced in a subsequent commit instead?

Indeed, thanks

> 
> 
>> +static int test_socket(const struct service_fixture *const srv)
>> +{
>> +	int fd;
>> +
>> +	fd = socket(srv->protocol.family, srv->protocol.type | SOCK_CLOEXEC, 0);
>> +	if (fd < 0)
>> +		return errno;
>> +	/*
>> +	 * Mixing error codes from close(2) and socket(2) should not lead to any
>> +	 * (access type) confusion for this test.
>> +	 */
>> +	if (close(fd) != 0)
>> +		return errno;
>> +	return 0;
>> +}
> 
> I personally find that it helps me remember if these test helpers have the same
> signature as the syscall that they are exercising.  (But I don't feel very
> strongly about it.  Just a suggestion.)

You're right, in this case test_socket() would be more clear.
I'll fix it.

> 
> 
>> [...]
>>
>> +TEST_F(protocol, create)
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +	};
>> +	const struct landlock_socket_attr create_socket_attr = {
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = self->srv0.protocol.family,
>> +		.type = self->srv0.protocol.type,
>> +	};
>> +
>> +	int ruleset_fd;
>> +
>> +	/* Allowed create */
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +				       &create_socket_attr, 0));
>> +
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	EXPECT_EQ(0, close(ruleset_fd));
>> +
>> +	ASSERT_EQ(0, test_socket(&self->srv0));
>> +	ASSERT_EQ(EAFNOSUPPORT, test_socket(&self->unspec_srv0));
>> +
>> +	/* Denied create */
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	EXPECT_EQ(0, close(ruleset_fd));
>> +
>> +	ASSERT_EQ(EACCES, test_socket(&self->srv0));
>> +	ASSERT_EQ(EAFNOSUPPORT, test_socket(&self->unspec_srv0));
> 
> Should we exhaustively try out the other combinations (other than selv->srv0)
> here?  I assume socket() should always fail for these?

Do you mean testing all supported protocols? AFAICS this will require
adding ~80 FIXTURE_VARIANTs, but it won't be an issue if you think that
it can be useful.

> 
> (If you are alredy doing this in another commit that I have not looked at yet,
> please ignore this comment.)
> 
> —Günther
