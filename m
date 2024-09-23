Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F240F199252;
	Mon, 23 Sep 2024 12:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727096282; cv=none; b=QV3vgNDnERl7pIJdnkjaG/GqQSpWEzsgKasKh//xdLsjB3+VocYDsp8TZEed6SMUSnSWC6BFn65+wqMz+BLwoWv54C+a9NcPJRX3zgOTVTkZcwdOJFxQTvx0brjNwAeJV8mRFlTVM79h2I5KCpAghdHbw704fWK/auVTxGBzeTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727096282; c=relaxed/simple;
	bh=Bj/tXWBgjrICyrnrUL2GanASL2oP9kNSbxzVqhM03/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=INgOJDp3kUjYTruPwcFSsvsU/BkZVM+cshbbdnLhO/GjimJw/EI1yGFT4Nrv/lbvPRMNL0/F0uEL4RLlZcBUUC0Me3Zt0L315Ovu1H1UVkQntlEeOUFPlYcsykO0xodu5ZhtU3s2gIDvWlX779Hs59yE138OsHZMSwnW6kAo4r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XC31X0Y63z20pDL;
	Mon, 23 Sep 2024 20:57:36 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 46BB7140202;
	Mon, 23 Sep 2024 20:57:55 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 23 Sep 2024 20:57:51 +0800
Message-ID: <220a19f6-f73c-54ef-1c4d-ce498942f106@huawei-partners.com>
Date: Mon, 23 Sep 2024 15:57:47 +0300
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
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-15-ivanov.mikhail1@huawei-partners.com>
 <ZurZ7nuRRl0Zf2iM@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZurZ7nuRRl0Zf2iM@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/18/2024 4:47 PM, Günther Noack wrote:
> On Wed, Sep 04, 2024 at 06:48:19PM +0800, Mikhail Ivanov wrote:
>> Add test that checks the restriction on socket creation using
>> socketpair(2).
>>
>> Add `socket_creation` fixture to configure sandboxing in tests in
>> which different socket creation actions are tested.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 101 ++++++++++++++++++
>>   1 file changed, 101 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index 8fc507bf902a..67db0e1c1121 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -738,4 +738,105 @@ TEST_F(packet_protocol, alias_restriction)
>>   	EXPECT_EQ(0, test_socket_variant(&self->prot_tested));
>>   }
>>   
>> +static int test_socketpair(int family, int type, int protocol)
>> +{
>> +	int fds[2];
>> +	int err;
>> +
>> +	err = socketpair(family, type | SOCK_CLOEXEC, protocol, fds);
>> +	if (err)
>> +		return errno;
>> +	/*
>> +	 * Mixing error codes from close(2) and socketpair(2) should not lead to
>> +	 * any (access type) confusion for this test.
>> +	 */
>> +	if (close(fds[0]) != 0)
>> +		return errno;
>> +	if (close(fds[1]) != 0)
>> +		return errno;
>> +	return 0;
>> +}
>> +
>> +FIXTURE(socket_creation)
>> +{
>> +	bool sandboxed;
>> +	bool allowed;
>> +};
>> +
>> +FIXTURE_VARIANT(socket_creation)
>> +{
>> +	bool sandboxed;
>> +	bool allowed;
>> +};
>> +
>> +FIXTURE_SETUP(socket_creation)
>> +{
>> +	self->sandboxed = variant->sandboxed;
>> +	self->allowed = variant->allowed;
>> +
>> +	setup_loopback(_metadata);
>> +};
>> +
>> +FIXTURE_TEARDOWN(socket_creation)
>> +{
>> +}
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(socket_creation, no_sandbox) {
>> +	/* clang-format on */
>> +	.sandboxed = false,
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(socket_creation, sandbox_allow) {
>> +	/* clang-format on */
>> +	.sandboxed = true,
>> +	.allowed = true,
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(socket_creation, sandbox_deny) {
>> +	/* clang-format on */
>> +	.sandboxed = true,
>> +	.allowed = false,
>> +};
>> +
>> +TEST_F(socket_creation, socketpair)
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +	};
>> +	struct landlock_socket_attr unix_socket_create = {
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = AF_UNIX,
>> +		.type = SOCK_STREAM,
>> +	};
>> +	int ruleset_fd;
>> +
>> +	if (self->sandboxed) {
>> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +						     sizeof(ruleset_attr), 0);
>> +		ASSERT_LE(0, ruleset_fd);
>> +
>> +		if (self->allowed) {
>> +			ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
>> +						       LANDLOCK_RULE_SOCKET,
>> +						       &unix_socket_create, 0));
>> +		}
>> +		enforce_ruleset(_metadata, ruleset_fd);
>> +		ASSERT_EQ(0, close(ruleset_fd));
>> +	}
>> +
>> +	if (!self->sandboxed || self->allowed) {
>> +		/*
>> +		 * Tries to create sockets when ruleset is not established
>> +		 * or protocol is allowed.
>> +		 */
>> +		EXPECT_EQ(0, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
>> +	} else {
>> +		/* Tries to create sockets when protocol is restricted. */
>> +		EXPECT_EQ(EACCES, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
>> +	}
> 
> I am torn on whether socketpair() should be denied at all --
> 
>    * on one hand, the created sockets are connected to each other
>      and the creating process can only talk to itself (or pass one of them on),
>      which seems legitimate and harmless.
> 
>    * on the other hand, it *does* create two sockets, and
>      if they are datagram sockets, it it probably currently possible
>      to disassociate them with connect(AF_UNSPEC). >
> What are your thoughts on that?

Good catch! According to the discussion that you've mentioned [1] (I
believe I found correct one), you've already discussed socketpair(2)
control with Mickaël and came to the conclusion that socketpair(2) and
unnamed pipes do not give access to new resources to the process,
therefore should not be restricted.

[1] 
https://lore.kernel.org/all/e7e24682-5da7-3b09-323e-a4f784f10158@digikod.net/

Therefore, this is more like connect(AF_UNSPEC)-related issue. On
security summit you've mentioned that it will be useful to implement
restriction of connection dissociation for sockets. This feature will
solve the problem of reusage of UNIX sockets that were created with
socketpair(2).

If we want such feature to be implemented, I suggest leaving current
implementation as it is (to prevent vulnerable creation of UNIX dgram
sockets) and enable socketpair(2) in the patchset dedicated to
connect(AF_UNSPEC) restriction. Also it will be useful to create a
dedicated issue on github. WDYT?

(Btw I think that disassociation control can be really useful. If
it were possible to restrict this action for each protocol, we would
have stricter control over the protocols used.)

> 
> Mickaël, I believe we have also discussed similar questions for pipe(2) in the
> past, and you had opinions on that?
> 
> 
> (On a much more technical note; consider replacing self->allowed with
> self->socketpair_error to directly indicate the expected error? It feels that
> this could be more straightforward?)

I've considered this approach and decided that this would
* negatively affect the readability of conditional for adding Landlock
   rule,
* make checking the test_socketpair() error code less explicit.

> 
> —Günther
