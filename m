Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0F1824AF;
	Thu,  3 Oct 2024 12:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727957747; cv=none; b=clu0QcllxB7F9XUayy9aw7tVAFWmexqQHiaP8FX+odKuMPqvd4thxXHHyn1twONiXhPFF3XMt9k3wOyFwH0fFj9Sn9Qu9nkirn0v09r8UVeM6818bkE2qmzTVfidW2BbHAIgjvBrZZvfnSCSKF+iSjGDX5QkH3nkhpy/Yzr/tVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727957747; c=relaxed/simple;
	bh=eAWxCpuJbqrIU+nlFL+n0ajIMO5A3y476oaILQNkAIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GpWk2UktTWjq0zAzPW7rvgkB2DvxQ9DvU5FXOHcOp8urkbrOIY2WSTsG03oja71SiYGPZhHUds4WDqA6iD31B9VJVFJ5wE9TN6YhfgGfP38pVeFFw5Ex7/pns5seOJTyQqXUOz5oxaoiPVVmidhMWrbAJ2K/Wt2iJu05CtAv6bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XK9bJ246Yz2QTxt;
	Thu,  3 Oct 2024 20:14:36 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id C1018140361;
	Thu,  3 Oct 2024 20:15:33 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Oct 2024 20:15:29 +0800
Message-ID: <2f2c5e5c-a9aa-233e-e8f9-720c8a6ff1a2@huawei-partners.com>
Date: Thu, 3 Oct 2024 15:15:25 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 15/19] selftests/landlock: Test SCTP peeloff
 restriction
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-16-ivanov.mikhail1@huawei-partners.com>
 <ZvbCwtkXDakYDVD_@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZvbCwtkXDakYDVD_@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/27/2024 5:35 PM, Günther Noack wrote:
> On Wed, Sep 04, 2024 at 06:48:20PM +0800, Mikhail Ivanov wrote:
>> It is possible to branch off an SCTP UDP association into a separate
>> user space UDP socket. Add test validating that such scenario is not
>> restricted by Landlock.
>>
>> Move setup_loopback() helper from net_test to common.h to use it to
>> enable connection in this test.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   tools/testing/selftests/landlock/common.h     |  12 +++
>>   tools/testing/selftests/landlock/net_test.c   |  11 --
>>   .../testing/selftests/landlock/socket_test.c  | 102 +++++++++++++++++-
>>   3 files changed, 113 insertions(+), 12 deletions(-)
>>
>> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
>> index 28df49fa22d5..07d959a8ac7b 100644
>> --- a/tools/testing/selftests/landlock/common.h
>> +++ b/tools/testing/selftests/landlock/common.h
>> @@ -16,6 +16,7 @@
>>   #include <sys/types.h>
>>   #include <sys/wait.h>
>>   #include <unistd.h>
>> +#include <sched.h>
>>   
>>   #include "../kselftest_harness.h"
>>   
>> @@ -227,3 +228,14 @@ enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
>>   		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
>>   	}
>>   }
>> +
>> +static void setup_loopback(struct __test_metadata *const _metadata)
>> +{
>> +	set_cap(_metadata, CAP_SYS_ADMIN);
>> +	ASSERT_EQ(0, unshare(CLONE_NEWNET));
>> +	clear_cap(_metadata, CAP_SYS_ADMIN);
>> +
>> +	set_ambient_cap(_metadata, CAP_NET_ADMIN);
>> +	ASSERT_EQ(0, system("ip link set dev lo up"));
>> +	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
>> +}
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> index f21cfbbc3638..0b8386657c72 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -103,17 +103,6 @@ static int set_service(struct service_fixture *const srv,
>>   	return 1;
>>   }
>>   
>> -static void setup_loopback(struct __test_metadata *const _metadata)
>> -{
>> -	set_cap(_metadata, CAP_SYS_ADMIN);
>> -	ASSERT_EQ(0, unshare(CLONE_NEWNET));
>> -	clear_cap(_metadata, CAP_SYS_ADMIN);
>> -
>> -	set_ambient_cap(_metadata, CAP_NET_ADMIN);
>> -	ASSERT_EQ(0, system("ip link set dev lo up"));
>> -	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
>> -}
>> -
>>   static bool is_restricted(const struct protocol_variant *const prot,
>>   			  const enum sandbox_type sandbox)
>>   {
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index 67db0e1c1121..2ab27196fa3d 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -11,8 +11,11 @@
>>   #include <linux/pfkeyv2.h>
>>   #include <linux/kcm.h>
>>   #include <linux/can.h>
>> -#include <linux/in.h>
>> +#include <sys/socket.h>
>> +#include <stdint.h>
>> +#include <linux/sctp.h>
>>   #include <sys/prctl.h>
>> +#include <arpa/inet.h>
>>   
>>   #include "common.h"
>>   
>> @@ -839,4 +842,101 @@ TEST_F(socket_creation, socketpair)
>>   	}
>>   }
>>   
>> +static const char loopback_ipv4[] = "127.0.0.1";
>> +static const int backlog = 10;
>> +static const int loopback_port = 1024;
>> +
>> +TEST_F(socket_creation, sctp_peeloff)
>> +{
>> +	int status, ret;
>> +	pid_t child;
>> +	struct sockaddr_in addr;
>> +	int server_fd;
>> +
>> +	server_fd =
>> +		socket(AF_INET, SOCK_SEQPACKET | SOCK_CLOEXEC, IPPROTO_SCTP);
>> +	ASSERT_LE(0, server_fd);
>> +
>> +	addr.sin_family = AF_INET;
>> +	addr.sin_port = htons(loopback_port);
>> +	addr.sin_addr.s_addr = inet_addr(loopback_ipv4);
>> +
>> +	ASSERT_EQ(0, bind(server_fd, &addr, sizeof(addr)));
>> +	ASSERT_EQ(0, listen(server_fd, backlog));
>> +
>> +	child = fork();
>> +	ASSERT_LE(0, child);
>> +	if (child == 0) {
>> +		int client_fd;
>> +		sctp_peeloff_flags_arg_t peeloff;
>> +		socklen_t peeloff_size = sizeof(peeloff);
>> +		const struct landlock_ruleset_attr ruleset_attr = {
>> +			.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		};
>> +		struct landlock_socket_attr sctp_socket_create = {
>> +			.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +			.family = AF_INET,
>> +			.type = SOCK_SEQPACKET,
>> +		};
>> +
>> +		/* Closes listening socket for the child. */
>> +		ASSERT_EQ(0, close(server_fd));
>> +
>> +		client_fd = socket(AF_INET, SOCK_SEQPACKET | SOCK_CLOEXEC,
>> +				   IPPROTO_SCTP);
>> +		ASSERT_LE(0, client_fd);
>> +
>> +		/*
>> +		 * Establishes connection between sockets and
>> +		 * gets SCTP association id.
>> +		 */
>> +		ret = setsockopt(client_fd, IPPROTO_SCTP, SCTP_SOCKOPT_CONNECTX,
>> +				 &addr, sizeof(addr));
>> +		ASSERT_LE(0, ret);
>> +
>> +		if (self->sandboxed) {
>> +			/* Denies creation of SCTP sockets. */
>> +			int ruleset_fd = landlock_create_ruleset(
>> +				&ruleset_attr, sizeof(ruleset_attr), 0);
>> +			ASSERT_LE(0, ruleset_fd);
>> +
>> +			if (self->allowed) {
>> +				ASSERT_EQ(0, landlock_add_rule(
>> +						     ruleset_fd,
>> +						     LANDLOCK_RULE_SOCKET,
>> +						     &sctp_socket_create, 0));
>> +			}
>> +			enforce_ruleset(_metadata, ruleset_fd);
>> +			ASSERT_EQ(0, close(ruleset_fd));
>> +		}
>> +		/*
>> +		 * Branches off current SCTP association into a separate socket
>> +		 * and returns it to user space.
>> +		 */
>> +		peeloff.p_arg.associd = ret;
>> +		ret = getsockopt(client_fd, IPPROTO_SCTP, SCTP_SOCKOPT_PEELOFF,
>> +				 &peeloff, &peeloff_size);
>> +
>> +		/*
>> +		 * Creation of SCTP socket by branching off existing SCTP association
>> +		 * should not be restricted by Landlock.
>> +		 */
>> +		EXPECT_LE(0, ret);
>> +
>> +		/* Closes peeloff socket if such was created. */
>> +		if (!ret) {
>> +			ASSERT_EQ(0, close(peeloff.p_arg.sd));
>> +		}
> 
> Nit: Should this check for (ret >= 0) instead?

Ofc, thank you

> 
> I imagine that getsockopt returns -1 on error, normally,
> and that would make it past the EXPECT_LE (even if it logs a failure).
> 
> 
>> +		ASSERT_EQ(0, close(client_fd));
>> +		_exit(_metadata->exit_code);
>> +		return;
>> +	}
>> +
>> +	ASSERT_EQ(child, waitpid(child, &status, 0));
>> +	ASSERT_EQ(1, WIFEXITED(status));
>> +	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>> +
>> +	ASSERT_EQ(0, close(server_fd));
>> +}
>> +
>>   TEST_HARNESS_MAIN
>> -- 
>> 2.34.1
>>
> 
> Reviewed-by: Günther Noack <gnoack@google.com>
