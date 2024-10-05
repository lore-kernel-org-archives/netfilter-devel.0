Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA85158D81;
	Sat,  5 Oct 2024 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728149394; cv=none; b=NaBBr2IyCqetDm09E6B8M5I+KQj2aPTGhGzj3GuZWX4mlo6P5xQdkqUl2poqF0srOEfnsvEztShRboDql3TlgTTPHRbSF5Jx5XsXNt8999pySBf5QZZ+YeHupraN5mYbC3QHCSl/9U1ooOQSdN5tbgLtflSL7og2JApfCitLMh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728149394; c=relaxed/simple;
	bh=yKuWImx5CLK6/jQfJwcJD4qFxtkCxjuZ5fJ1Vg6VeiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qhZPb2b4ZyT9oW/LozkBWobKbj1cAG5UxYSbUqjMBZXrNBwRpZ7auSutY8t2TyhJnE1FeUlBjXIKfDxzHI5NlHTjtZtUQcP0FzSIkFRwklR1YdnDZs+AvFqtIvWt+eb5vBOnDiGhPS2Gti70zJUUHFLmCfowjwhPbCuJWHu62rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XLXS35t4Nz1T8Bb;
	Sun,  6 Oct 2024 01:28:03 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 4393D180113;
	Sun,  6 Oct 2024 01:29:42 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 6 Oct 2024 01:29:38 +0800
Message-ID: <70ae6422-4e8c-465f-9bbf-5ff4df52a057@huawei-partners.com>
Date: Sat, 5 Oct 2024 20:29:34 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 8/9] selftests/landlock: Test changing socket
 backlog with listen(2)
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-9-ivanov.mikhail1@huawei-partners.com>
 <20241005.c0501f9d61a8@gnoack.org>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241005.c0501f9d61a8@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 10/5/2024 7:57 PM, Günther Noack wrote:
> On Wed, Aug 14, 2024 at 11:01:50AM +0800, Mikhail Ivanov wrote:
>> listen(2) can be used to change length of the pending connections queue
>> of the listening socket. Such scenario shouldn't be restricted by Landlock
>> since socket doesn't change its state.
> 
> Yes, this behavior makes sense to me as well. 👍 __inet_listen_sk()
> only changes sk->sk_max_ack_backlog when listen() gets called a second
> time.
> 
>> * Implement test that validates this case.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 26 +++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> index 6831d8a2e9aa..dafc433a0068 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -1768,6 +1768,32 @@ TEST_F(ipv4_tcp, with_fs)
>>   	EXPECT_EQ(-EACCES, bind_variant(bind_fd, &self->srv1));
>>   }
>>   
>> +TEST_F(ipv4_tcp, double_listen)
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_net = LANDLOCK_ACCESS_NET_LISTEN_TCP,
>> +	};
>> +	int ruleset_fd;
>> +	int listen_fd;
>> +
>> +	listen_fd = socket_variant(&self->srv0);
>> +	ASSERT_LE(0, listen_fd);
>> +
>> +	EXPECT_EQ(0, bind_variant(listen_fd, &self->srv0));
>> +	EXPECT_EQ(0, listen_variant(listen_fd, backlog));
>> +
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	/* Denies listen. */
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	EXPECT_EQ(0, close(ruleset_fd));
>> +
>> +	/* Tries to change backlog value of listening socket. */
>> +	EXPECT_EQ(0, listen_variant(listen_fd, backlog + 1));
> 
> For test clarity: Without reading the commit message, I believe it
> might not be obvious to the reader *why* the second listen() is
> supposed to work.  This might be worth a comment.

Ofc, thanks!

> 
>> +}
>> +
>>   FIXTURE(port_specific)
>>   {
>>   	struct service_fixture srv0;
>> -- 
>> 2.34.1
>>
> 
> Reviewed-by: Günther Noack <gnoack3000@gmail.com>
