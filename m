Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF8B1EBFE4;
	Wed,  4 Sep 2024 12:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725453966; cv=none; b=fEoOU3h1vHUJekkJ16/PbUfwqyOt+XPTz1yi8TUCf+SqbSWCaTXnjr3mvwzWPuQN0wBBDwr0u/JiL7GEWrfntcIjinAoC/psbZmeqhQ1ayRdFUCrEyaDRbXBJLg5vdJ/nJ0zmd/E/ktz8zHgmo8MkgZQgeGf2TK9tKe17lIXjCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725453966; c=relaxed/simple;
	bh=cWolgnJVYu/jZYJy8UBqMypLIpR4FmQEeBseScVKGw0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=jLZqn3nqOfaRHyiW03XVboqt5lmZ0sB7YfPYuMWq5hbZjq84srwtY2+UlfygITpkv8+795ssuxAdaY5MK1IVeFcfAoNELxmVELXfBY7XWYgJT7J4d6umGKxB+qJEWFpOa1WT6URmQDkX4oneHrNlR5pb4GSxBp7FUxinzf1tP+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzMfS2nghz1j83j;
	Wed,  4 Sep 2024 20:45:36 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id A05921A016C;
	Wed,  4 Sep 2024 20:45:56 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 20:45:53 +0800
Message-ID: <002a2153-a1fd-a8c7-549f-50cd215aeb81@huawei-partners.com>
Date: Wed, 4 Sep 2024 15:45:49 +0300
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
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-13-ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240904104824.1844082-13-ivanov.mikhail1@huawei-partners.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 kwepemj200016.china.huawei.com (7.202.194.28)

9/4/2024 1:48 PM, Mikhail Ivanov wrote:
> Add test validating that Landlock provides restriction of user space
> sockets only.
> 
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>   .../testing/selftests/landlock/socket_test.c  | 39 ++++++++++++++++++-
>   1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
> index ff5ace711697..23698b8c2f4d 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -7,7 +7,7 @@
>   
>   #define _GNU_SOURCE
>   
> -#include <linux/landlock.h>
> +#include "landlock.h"

typo, will be fixed

>   #include <linux/pfkeyv2.h>
>   #include <linux/kcm.h>
>   #include <linux/can.h>
> @@ -628,4 +628,41 @@ TEST(unsupported_af_and_prot)
>   	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
>   }
>   
> +TEST(kernel_socket)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
> +	};
> +	struct landlock_socket_attr smc_socket_create = {
> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
> +		.family = AF_SMC,
> +		.type = SOCK_STREAM,
> +	};
> +	int ruleset_fd;
> +
> +	/*
> +	 * Checks that SMC socket is created sucessfuly without
> +	 * landlock restrictions.
> +	 */
> +	ASSERT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
> +
> +	ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +				       &smc_socket_create, 0));
> +	enforce_ruleset(_metadata, ruleset_fd);
> +	ASSERT_EQ(0, close(ruleset_fd));
> +
> +	/*
> +	 * During the creation of an SMC socket, an internal service TCP socket
> +	 * is also created (Cf. smc_create_clcsk).
> +	 *
> +	 * Checks that Landlock does not restrict creation of the kernel space
> +	 * socket.
> +	 */
> +	EXPECT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
> +}
> +
>   TEST_HARNESS_MAIN
