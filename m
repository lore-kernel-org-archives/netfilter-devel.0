Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E6A134AC;
	Wed, 21 Aug 2024 11:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724241176; cv=none; b=KIEO2uwXvVhRT64dyYNnU1qrjWHgFWuaz1fJVoEiP6wiNqvXh6erEjVsbV27lRk2Ore9fAxwx+jjUnLcTvkY0jl85xchf3aDUXAjw8pnjh66N9tn0Pi7cHl7A+Nw3d9XIJRWbVfO2VKUek32tyQpNtnnfvh2VvEcCUeNqfp0y7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724241176; c=relaxed/simple;
	bh=r4TmNIC6JJelSj6jfu58Oaz4qMKQPjqXVKp4zwQxDOo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=X6z8Jsa7SftwsSgZ5tOHKJssDaW4Jb5W3OKZVp/5OAFySOHnHeMcpUA1kz8/iEM0JJevHa42+gFjru4JuChfgIQIxE+E0XLneZdb6sLgYG9kceyjixKqwzJ/TL1gQwpXlgWNgWUasjnZ0JCswqSGFMWN8c3hk1a7FS9lQmBbMFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Wpl780ZkYz13Vj2;
	Wed, 21 Aug 2024 19:52:04 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C38518009B;
	Wed, 21 Aug 2024 19:52:43 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 19:52:39 +0800
Message-ID: <4aae6528-cfed-efc5-a7bc-d967a8d43153@huawei-partners.com>
Date: Wed, 21 Aug 2024 14:52:34 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 6/9] selftests/landlock: Test listening without
 explicit bind restriction
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-7-ivanov.mikhail1@huawei-partners.com>
 <ZsST6Nk3Bf8F5lmJ@google.com>
 <58b328fc-aa98-c4f1-eb11-2d59e50ec407@huawei-partners.com>
In-Reply-To: <58b328fc-aa98-c4f1-eb11-2d59e50ec407@huawei-partners.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/20/2024 4:46 PM, Mikhail Ivanov wrote:
> 8/20/2024 4:02 PM, Günther Noack wrote:
>> On Wed, Aug 14, 2024 at 11:01:48AM +0800, Mikhail Ivanov wrote:
>>> Test scenarios where listen(2) call without explicit bind(2) is allowed
>>> and forbidden.
>>>
>>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>>> ---
>>>   tools/testing/selftests/landlock/net_test.c | 83 +++++++++++++++++++++
>>>   1 file changed, 83 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/landlock/net_test.c 
>>> b/tools/testing/selftests/landlock/net_test.c
>>> index 551891b18b7a..92c042349596 100644
>>> --- a/tools/testing/selftests/landlock/net_test.c
>>> +++ b/tools/testing/selftests/landlock/net_test.c
>>> @@ -1851,6 +1851,89 @@ TEST_F(port_specific, bind_connect_zero)
>>>       EXPECT_EQ(0, close(bind_fd));
>>>   }
>>> +TEST_F(port_specific, listen_without_bind_allowed)
>>> +{
>>> +    if (variant->sandbox == TCP_SANDBOX) {
>>> +        const struct landlock_ruleset_attr ruleset_attr = {
>>> +            .handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>>> +                          LANDLOCK_ACCESS_NET_LISTEN_TCP
>>> +        };
>>> +        const struct landlock_net_port_attr tcp_listen_zero = {
>>> +            .allowed_access = LANDLOCK_ACCESS_NET_LISTEN_TCP,
>>> +            .port = 0,
>>> +        };
>>> +        int ruleset_fd;
>>> +
>>> +        ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>>> +                             sizeof(ruleset_attr), 0);
>>> +        ASSERT_LE(0, ruleset_fd);
>>> +
>>> +        /*
>>> +         * Allow listening without explicit bind
>>> +         * (cf. landlock_net_port_attr).
>>> +         */
>>> +        EXPECT_EQ(0,
>>> +              landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>> +                        &tcp_listen_zero, 0));
>>> +
>>> +        enforce_ruleset(_metadata, ruleset_fd);
>>> +        EXPECT_EQ(0, close(ruleset_fd));
>>> +    }
>>> +    int listen_fd, connect_fd;
>>> +    __u64 port;
>>> +
>>> +    listen_fd = socket_variant(&self->srv0);
>>> +    ASSERT_LE(0, listen_fd);
>>> +
>>> +    connect_fd = socket_variant(&self->srv0);
>>> +    ASSERT_LE(0, connect_fd);
>>> +    /*
>>> +     * Allow listen(2) to select a random port for the socket,
>>> +     * since bind(2) wasn't called.
>>> +     */
>>> +    EXPECT_EQ(0, listen_variant(listen_fd, backlog));
>>> +
>>> +    /* Connects on the binded port. */
>>> +    port = get_binded_port(listen_fd, &variant->prot);
>>
>> Please rename "binded" to "bound" when you come across it.
> 
> Can I do such refactoring in the 3/9 patch?

I mean, can I replace all "binded" occurrences in net_test in 3/9 patch?

> 
>>
>>
>>> +    EXPECT_NE(0, port);
>>> +    set_port(&self->srv0, port);
>>> +    EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
>>> +
>>> +    EXPECT_EQ(0, close(connect_fd));
>>> +    EXPECT_EQ(0, close(listen_fd));
>>> +}
>>> +
>>> +TEST_F(port_specific, listen_without_bind_denied)
>>> +{
>>> +    if (variant->sandbox == TCP_SANDBOX) {
>>> +        const struct landlock_ruleset_attr ruleset_attr = {
>>> +            .handled_access_net = LANDLOCK_ACCESS_NET_LISTEN_TCP
>>> +        };
>>> +        int ruleset_fd;
>>> +
>>> +        ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>>> +                             sizeof(ruleset_attr), 0);
>>> +        ASSERT_LE(0, ruleset_fd);
>>> +
>>> +        /* Deny listening. */
>>> +        enforce_ruleset(_metadata, ruleset_fd);
>>> +        EXPECT_EQ(0, close(ruleset_fd));
>>> +    }
>>> +    int listen_fd, ret;
>>> +
>>> +    listen_fd = socket_variant(&self->srv0);
>>> +    ASSERT_LE(0, listen_fd);
>>> +
>>> +    /* Checks that listening without explicit binding is prohibited. */
>>> +    ret = listen_variant(listen_fd, backlog);
>>> +    if (is_restricted(&variant->prot, variant->sandbox)) {
>>> +        /* Denied by Landlock. */
>>> +        EXPECT_EQ(-EACCES, ret);
>>> +    } else {
>>> +        EXPECT_EQ(0, ret);
>>> +    }
>>> +}
>>> +
>>>   TEST_F(port_specific, port_1023)
>>>   {
>>>       int bind_fd, connect_fd, ret;
>>> -- 
>>> 2.34.1
>>>
