Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483491D55AC;
	Wed, 25 Sep 2024 12:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266691; cv=none; b=Zb4Kpv84lgPO3Dzo3OKI3O1UMxjOtMaILvGCRRDVquux/TkTvtbxBE2PORjczLWXf/Rk4iIETCQXNZzQtvLs1+emB//YgwSWJRo6VkDFCqoZm8gdF91PL6wT92kczOrUVJkIhITFjKlM3Xe8OuOpMFoV9xNbzwZ3zEoGcACSq2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266691; c=relaxed/simple;
	bh=KIWi6UV11qdsj/3jICtJLwq2sT3rLbBlGrQYqqzSqgA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=ut1kLsEDaszWT5z5KJpCmdHOZElDU3eE2/WwwyAgAv3C7UujAY6E8lgk207LxnpOUoH2uWGLW9QoU4X2TniD8jh+zYRSlkJwUGYywC40uM9584xIJmiJcy1j4DyjhAJNTE9yQdrKSouU8q2DUzg7z6XCylGgJTQmVWcAvtjDflU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XDG1F1bjPzyRsP;
	Wed, 25 Sep 2024 20:16:33 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 899CC140392;
	Wed, 25 Sep 2024 20:17:58 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 25 Sep 2024 20:17:54 +0800
Message-ID: <45ab87a3-beba-b5f6-ef25-8b19a4b1dcee@huawei-partners.com>
Date: Wed, 25 Sep 2024 15:17:50 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/19] selftests/landlock: Test socketpair(2)
 restriction
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-15-ivanov.mikhail1@huawei-partners.com>
 <ZurZ7nuRRl0Zf2iM@google.com>
 <220a19f6-f73c-54ef-1c4d-ce498942f106@huawei-partners.com>
In-Reply-To: <220a19f6-f73c-54ef-1c4d-ce498942f106@huawei-partners.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/23/2024 3:57 PM, Mikhail Ivanov wrote:
> On 9/18/2024 4:47 PM, Günther Noack wrote:
>> On Wed, Sep 04, 2024 at 06:48:19PM +0800, Mikhail Ivanov wrote:
>>> Add test that checks the restriction on socket creation using
>>> socketpair(2).
>>>
>>> Add `socket_creation` fixture to configure sandboxing in tests in
>>> which different socket creation actions are tested.
>>>
>>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>>> ---
>>>   .../testing/selftests/landlock/socket_test.c  | 101 ++++++++++++++++++
>>>   1 file changed, 101 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/landlock/socket_test.c 
>>> b/tools/testing/selftests/landlock/socket_test.c
>>> index 8fc507bf902a..67db0e1c1121 100644
>>> --- a/tools/testing/selftests/landlock/socket_test.c
>>> +++ b/tools/testing/selftests/landlock/socket_test.c
>>> @@ -738,4 +738,105 @@ TEST_F(packet_protocol, alias_restriction)
>>>       EXPECT_EQ(0, test_socket_variant(&self->prot_tested));
>>>   }
>>> +static int test_socketpair(int family, int type, int protocol)
>>> +{
>>> +    int fds[2];
>>> +    int err;
>>> +
>>> +    err = socketpair(family, type | SOCK_CLOEXEC, protocol, fds);
>>> +    if (err)
>>> +        return errno;
>>> +    /*
>>> +     * Mixing error codes from close(2) and socketpair(2) should not 
>>> lead to
>>> +     * any (access type) confusion for this test.
>>> +     */
>>> +    if (close(fds[0]) != 0)
>>> +        return errno;
>>> +    if (close(fds[1]) != 0)
>>> +        return errno;
>>> +    return 0;
>>> +}
>>> +
>>> +FIXTURE(socket_creation)
>>> +{
>>> +    bool sandboxed;
>>> +    bool allowed;
>>> +};
>>> +
>>> +FIXTURE_VARIANT(socket_creation)
>>> +{
>>> +    bool sandboxed;
>>> +    bool allowed;
>>> +};
>>> +
>>> +FIXTURE_SETUP(socket_creation)
>>> +{
>>> +    self->sandboxed = variant->sandboxed;
>>> +    self->allowed = variant->allowed;
>>> +
>>> +    setup_loopback(_metadata);
>>> +};
>>> +
>>> +FIXTURE_TEARDOWN(socket_creation)
>>> +{
>>> +}
>>> +
>>> +/* clang-format off */
>>> +FIXTURE_VARIANT_ADD(socket_creation, no_sandbox) {
>>> +    /* clang-format on */
>>> +    .sandboxed = false,
>>> +};
>>> +
>>> +/* clang-format off */
>>> +FIXTURE_VARIANT_ADD(socket_creation, sandbox_allow) {
>>> +    /* clang-format on */
>>> +    .sandboxed = true,
>>> +    .allowed = true,
>>> +};
>>> +
>>> +/* clang-format off */
>>> +FIXTURE_VARIANT_ADD(socket_creation, sandbox_deny) {
>>> +    /* clang-format on */
>>> +    .sandboxed = true,
>>> +    .allowed = false,
>>> +};
>>> +
>>> +TEST_F(socket_creation, socketpair)
>>> +{
>>> +    const struct landlock_ruleset_attr ruleset_attr = {
>>> +        .handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>>> +    };
>>> +    struct landlock_socket_attr unix_socket_create = {
>>> +        .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>>> +        .family = AF_UNIX,
>>> +        .type = SOCK_STREAM,
>>> +    };
>>> +    int ruleset_fd;
>>> +
>>> +    if (self->sandboxed) {
>>> +        ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>>> +                             sizeof(ruleset_attr), 0);
>>> +        ASSERT_LE(0, ruleset_fd);
>>> +
>>> +        if (self->allowed) {
>>> +            ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
>>> +                               LANDLOCK_RULE_SOCKET,
>>> +                               &unix_socket_create, 0));
>>> +        }
>>> +        enforce_ruleset(_metadata, ruleset_fd);
>>> +        ASSERT_EQ(0, close(ruleset_fd));
>>> +    }
>>> +
>>> +    if (!self->sandboxed || self->allowed) {
>>> +        /*
>>> +         * Tries to create sockets when ruleset is not established
>>> +         * or protocol is allowed.
>>> +         */
>>> +        EXPECT_EQ(0, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
>>> +    } else {
>>> +        /* Tries to create sockets when protocol is restricted. */
>>> +        EXPECT_EQ(EACCES, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
>>> +    }
>>
>> I am torn on whether socketpair() should be denied at all --
>>
>>    * on one hand, the created sockets are connected to each other
>>      and the creating process can only talk to itself (or pass one of 
>> them on),
>>      which seems legitimate and harmless.
>>
>>    * on the other hand, it *does* create two sockets, and
>>      if they are datagram sockets, it it probably currently possible
>>      to disassociate them with connect(AF_UNSPEC). >
>> What are your thoughts on that?
> 
> Good catch! According to the discussion that you've mentioned [1] (I
> believe I found correct one), you've already discussed socketpair(2)
> control with Mickaël and came to the conclusion that socketpair(2) and
> unnamed pipes do not give access to new resources to the process,
> therefore should not be restricted.
> 
> [1] 
> https://lore.kernel.org/all/e7e24682-5da7-3b09-323e-a4f784f10158@digikod.net/
> 
> Therefore, this is more like connect(AF_UNSPEC)-related issue. On
> security summit you've mentioned that it will be useful to implement
> restriction of connection dissociation for sockets. This feature will
> solve the problem of reusage of UNIX sockets that were created with
> socketpair(2).

Btw, I can suggest one more scenario, where restriction of
disassociation can be useful.

SMC sockets (AF_SMC+SOCK_STREAM) can fall back to TCP during the
connection (cf. smc_connect_decline_fallback). Then user can call
connect(AF_UNSPEC) to eventually get a TCP socket in the initial
(TCP_CLOSE) state which can be used to establish another connection.

This can be considered as an issue for the current patchset, because
there is a way to "create" a TCP socket while TCP is restricted by
Landlock (if ruleset allows SMC).

Besides it, there is another issue with SMC restriction that I'm going
to fix in the next RFC: recently has been applied patchset that
allows to create SMC sockets via AF_INET [1]. Such creation should be
denied if Landlock restricts SMC.

[1] 
https://lore.kernel.org/all/1718301630-63692-1-git-send-email-alibuda@linux.alibaba.com/

> 
> If we want such feature to be implemented, I suggest leaving current
> implementation as it is (to prevent vulnerable creation of UNIX dgram
> sockets) and enable socketpair(2) in the patchset dedicated to
> connect(AF_UNSPEC) restriction. Also it will be useful to create a
> dedicated issue on github. WDYT?
> 
> (Btw I think that disassociation control can be really useful. If
> it were possible to restrict this action for each protocol, we would
> have stricter control over the protocols used.)
> 
>>
>> Mickaël, I believe we have also discussed similar questions for 
>> pipe(2) in the
>> past, and you had opinions on that?
>>
>>
>> (On a much more technical note; consider replacing self->allowed with
>> self->socketpair_error to directly indicate the expected error? It 
>> feels that
>> this could be more straightforward?)
> 
> I've considered this approach and decided that this would
> * negatively affect the readability of conditional for adding Landlock
>    rule,
> * make checking the test_socketpair() error code less explicit.
> 
>>
>> —Günther
