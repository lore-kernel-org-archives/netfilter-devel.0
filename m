Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662E518C91C;
	Tue, 20 Aug 2024 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724161353; cv=none; b=TL21SNr4Q6Nsj3hpq75Y22tSEbhJJC7jCJOqIdeYgsSUXOdnNlpF/toVhHPAyHPBb7oh+jUHDyyd9Ua2vHCt4z0gQXaM1X892IDKUr4mEDT/a4TEbDW/v+EarlKX7kx6VItAsfDphb1s9mPn4fwRhSgQYEgcC2ekk6eYkZ2maps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724161353; c=relaxed/simple;
	bh=5kSZeaHScVa2+RQkGNUbFnACDfjLIwo5tfRBvYLVY78=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=h7ZTQclggMqfjv/kW/2WyOCl7RjBN8vHPpahRCSCC6oSdSeK6UhIHiR9ax4u/nx8M5Mzw3hqvmWTwu8s+F9ys1Hx2bYXaQHju6FOjWzrko6oUWYgSASWHnGowhQO8a9Up6C11+o0/TnvsVWEbx2zyN26FuHz9gDzdyFP9NUUhgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Wp9cB1Bq1z13j65;
	Tue, 20 Aug 2024 21:41:46 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id EFE68140138;
	Tue, 20 Aug 2024 21:42:23 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 21:42:20 +0800
Message-ID: <79d21a08-ec8c-14e7-7040-38dd9c7d441f@huawei-partners.com>
Date: Tue, 20 Aug 2024 16:42:16 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 5/9] selftests/landlock: Test listen on connected
 socket
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-6-ivanov.mikhail1@huawei-partners.com>
 <ZsSTouBzDOHFKC1L@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZsSTouBzDOHFKC1L@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/20/2024 4:01 PM, Günther Noack wrote:
> On Wed, Aug 14, 2024 at 11:01:47AM +0800, Mikhail Ivanov wrote:
>> Test checks that listen(2) doesn't wrongfully return -EACCES instead
>> of -EINVAL when trying to listen for an incorrect socket state.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>
>> Changes since v1:
>> * Uses 'protocol' fixture instead of 'ipv4_tcp'.
>> * Minor fixes.
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 74 +++++++++++++++++++++
>>   1 file changed, 74 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> index b6fe9bde205f..551891b18b7a 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -926,6 +926,80 @@ TEST_F(protocol, connect_unspec)
>>   	EXPECT_EQ(0, close(bind_fd));
>>   }
>>   
>> +TEST_F(protocol, listen_on_connected)
>> +{
>> +	int bind_fd, status;
>> +	pid_t child;
>> +
>> +	if (variant->sandbox == TCP_SANDBOX) {
>> +		const struct landlock_ruleset_attr ruleset_attr = {
>> +			.handled_access_net = ACCESS_ALL,
>> +		};
>> +		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
>> +			.allowed_access = ACCESS_ALL,
>> +			.port = self->srv0.port,
>> +		};
>> +		const struct landlock_net_port_attr tcp_denied_listen_p1 = {
>> +			.allowed_access = ACCESS_ALL &
>> +					  ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
>> +			.port = self->srv1.port,
>> +		};
>> +		int ruleset_fd;
>> +
>> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +						     sizeof(ruleset_attr), 0);
>> +		ASSERT_LE(0, ruleset_fd);
>> +
>> +		/* Allows all actions for the first port. */
>> +		ASSERT_EQ(0,
>> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> +					    &tcp_not_restricted_p0, 0));
>> +
>> +		/* Denies listening for the second port. */
>> +		ASSERT_EQ(0,
>> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> +					    &tcp_denied_listen_p1, 0));
>> +
>> +		enforce_ruleset(_metadata, ruleset_fd);
>> +		EXPECT_EQ(0, close(ruleset_fd));
>> +	}
> 
> Same remarks as in the previous commit apply here as well:
> 
>    - The if condition does the same thing, can maybe be deduplicated.
>    - Can merge ruleset_fd declaration and assignment into one line.
>      (This happens in a few more tests in later commits as well,
>      please double check these as well.)

Thanks for mentioning! You can check my reply in the previous commit
discussion.

> 
>> +
>> +	if (variant->prot.type != SOCK_STREAM)
>> +		SKIP(return, "listen(2) is supported only on stream sockets");
>> +
>> +	/* Initializes listening socket. */
>> +	bind_fd = socket_variant(&self->srv0);
>> +	ASSERT_LE(0, bind_fd);
>> +	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
>> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
> 
> I believe if bind() or listen() fail here, it does not make sense to continue
> the test execution, so ASSERT_EQ would be more appropriate than EXPECT_EQ.

Will be fixed, thanks.

> 
> 
>> +
>> +	child = fork();
>> +	ASSERT_LE(0, child);
>> +	if (child == 0) {
>> +		int connect_fd;
>> +
>> +		/* Closes listening socket for the child. */
>> +		EXPECT_EQ(0, close(bind_fd));
> 
> You don't need to do this from a child process, you can just connect() from the
> same process to the listening port.  (Since you are not calling accept(), the
> server won't pick up the phone on the other end, but that is still enough to
> connect successfully.)  It would simplify the story of correctly propagating
> test exit statuses as well.

Thanks, I'll fix this.

> 
>> +
>> +		connect_fd = socket_variant(&self->srv1);
>> +		ASSERT_LE(0, connect_fd);
>> +		EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
>> +
>> +		/* Tries to listen on connected socket. */
>> +		EXPECT_EQ(-EINVAL, listen_variant(connect_fd, backlog));
> 
> Since this assertion is the actual point of the test,
> maybe we could emphasize it a bit more with a comment here?
> 
> e.g:
> 
> /*
>   * Checks that we always return EINVAL
>   * and never accidentally return EACCES, if listen(2) fails.
>   */

You're right.. current description doesn't give an understanding of why
this test is needed at all. I'll change it.

> 
>> +
>> +		EXPECT_EQ(0, close(connect_fd));
>> +		_exit(_metadata->exit_code);
>> +		return;
>> +	}
>> +
>> +	EXPECT_EQ(child, waitpid(child, &status, 0));
>> +	EXPECT_EQ(1, WIFEXITED(status));
>> +	EXPECT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>> +
>> +	EXPECT_EQ(0, close(bind_fd));
>> +}
>> +
>>   FIXTURE(ipv4)
>>   {
>>   	struct service_fixture srv0, srv1;
>> -- 
>> 2.34.1
>>
