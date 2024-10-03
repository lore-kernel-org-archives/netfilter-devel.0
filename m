Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391B210A1E;
	Thu,  3 Oct 2024 12:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727959329; cv=none; b=qOrDYhIueecWcrp1m95u/AdSlJXQSt/dWnAJAHMvV2MlJ+v+iEkd9dSPubM9zofwxJhiK1XYphWu7uZWBkuLHbOHeqOiG6zN+XZVQzXcXz7u18j+NTOlb9CpeXAisP/SV6su554Mz0AznFIffRoRWV/dFQfTOlZW402anK1mjHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727959329; c=relaxed/simple;
	bh=7vpf7dtlkmVcw67xiNILfntdKzVtAewtfIOaoErLmmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DmG1HJx5r96qBI9x+mSEOneOOxcY5VUIW1hnCYcC7iQ5oPSdpzW6odJWMR1l0lxStRcksAYKlhfMQPYnUsWQ2Yi1Kv1Qgw37cJ88BtWdS5IKxzYkQ9QKsTys8z5hjzFpDsY6pRPabX4TIytJES3h7PD6pB6799ISJ55JztkO6rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XKB9k4mSjz1SCBZ;
	Thu,  3 Oct 2024 20:40:58 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id EBD191A0188;
	Thu,  3 Oct 2024 20:41:56 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Oct 2024 20:41:53 +0800
Message-ID: <cd8064ca-a5cd-15fd-8409-5a6a8d393591@huawei-partners.com>
Date: Thu, 3 Oct 2024 15:41:48 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 16/19] selftests/landlock: Test that accept(2) is
 not restricted
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-17-ivanov.mikhail1@huawei-partners.com>
 <ZvbG_ym1PKmVY6Ts@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZvbG_ym1PKmVY6Ts@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/27/2024 5:53 PM, Günther Noack wrote:
> On Wed, Sep 04, 2024 at 06:48:21PM +0800, Mikhail Ivanov wrote:
>> Add test validating that socket creation with accept(2) is not restricted
>> by Landlock.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 71 +++++++++++++++++++
>>   1 file changed, 71 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index 2ab27196fa3d..052dbe0d1227 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -939,4 +939,75 @@ TEST_F(socket_creation, sctp_peeloff)
>>   	ASSERT_EQ(0, close(server_fd));
>>   }
>>   
>> +TEST_F(socket_creation, accept)
>> +{
>> +	int status;
>> +	pid_t child;
>> +	struct sockaddr_in addr;
>> +	int server_fd, client_fd;
>> +	char buf;
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +	};
>> +	struct landlock_socket_attr tcp_socket_create = {
>          ^^^^^^
> 
> Could be const as well, just like the ruleset_attr?
> 
> (I probably overlooked this as well in some of the other tests.)

Yeap, I'll fix this for each test.

> 
> 
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = AF_INET,
>> +		.type = SOCK_STREAM,
>> +	};
>> +
>> +	server_fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
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
> 
> Nit:
> I feel like the child code would benefit from a higher level comment,
> like "Connects to the server once and exits." or such.

Agreed, I'll add this

> 
>> +		/* Closes listening socket for the child. */
>> +		ASSERT_EQ(0, close(server_fd));
>> +
>> +		client_fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
>> +		ASSERT_LE(0, client_fd);
>> +
>> +		ASSERT_EQ(0, connect(client_fd, &addr, sizeof(addr)));
>> +		EXPECT_EQ(1, write(client_fd, ".", 1));
>> +
>> +		ASSERT_EQ(0, close(client_fd));
>> +		_exit(_metadata->exit_code);
>> +		return;
>> +	}
>> +
>> +	if (self->sandboxed) {
>> +		int ruleset_fd = landlock_create_ruleset(
>> +			&ruleset_attr, sizeof(ruleset_attr), 0);
>> +		ASSERT_LE(0, ruleset_fd);
>> +		if (self->allowed) {
>> +			ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
>> +						       LANDLOCK_RULE_SOCKET,
>> +						       &tcp_socket_create, 0));
>> +		}
>> +		enforce_ruleset(_metadata, ruleset_fd);
>> +		ASSERT_EQ(0, close(ruleset_fd));
>> +	}
>> +
>> +	client_fd = accept(server_fd, NULL, 0);
>> +
>> +	/* accept(2) should not be restricted by Landlock. */
>> +	EXPECT_LE(0, client_fd);
> 
> Should be an ASSERT, IMHO.
> If this fails, client_fd will be -1,
> and a lot of the stuff afterwards will fail as well.

Agreed, thank you!

> 
>> +
>> +	EXPECT_EQ(1, read(client_fd, &buf, 1));
>> +	EXPECT_EQ('.', buf);
> 
> I'm torn on whether the "." write and the check for it is very useful in this test.
> It muddies the test's purpose a bit, and makes it harder to recognize the main use case.
> Might make the test a bit simpler to drop it.

Agreed, this check is really not that important.

> 
>> +
>> +	ASSERT_EQ(child, waitpid(child, &status, 0));
>> +	ASSERT_EQ(1, WIFEXITED(status));
>> +	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>> +
>> +	ASSERT_EQ(0, close(server_fd));
> 
> You are missing to close client_fd.

will be fixed

> 
>> +}
>> +
>>   TEST_HARNESS_MAIN
>> -- 
>> 2.34.1
>>
