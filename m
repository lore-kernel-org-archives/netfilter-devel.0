Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9EC1667DE;
	Fri,  7 Jun 2024 13:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717768718; cv=none; b=VlFXwF7BYdrCouG01q5+lqO3x89oZRzqh7YRVWcFHrgJev0fm0KgEI5vnqu+fOoq6fMYnZFo3l2ZarFv3gvpgm5LY/W1IEaFSV9c+EpaPFWkTBQeZA0a7aGDgxJdX4OFeF63RjiPM6JNYKqTwsqpaBJTVQ1MLEqGv3+zu8AAYbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717768718; c=relaxed/simple;
	bh=4G3FDvumPPb0WEUrF2heN84BCxUEYbAoobu+s6ougQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jsP30XqQVIuI99wB2FkF3da9TRLh69y7Tr598EeMxM9Yhsm9M9pVR/bpcMUu5nCw0fHSk9Kkt7vrYDQDjXjjVGemzyOxzvuf3PAaBuUfLmtMEMODyrIJGir89fre68hQtdC/cuVDqXurIeQrKKr048No+q/66n/nbhB/OnyzwZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VwjNL4Rr8zmYYQ;
	Fri,  7 Jun 2024 21:53:54 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 1337C18007B;
	Fri,  7 Jun 2024 21:58:31 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 21:58:26 +0800
Message-ID: <a2514345-f6e0-c081-d285-1ce0f8885291@huawei-partners.com>
Date: Fri, 7 Jun 2024 16:58:21 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/12] Socket type control for Landlock
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>, <mic@digikod.net>,
	<willemdebruijn.kernel@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240604.c18387da7a0e@gnoack.org>
 <ebd680cc-25d6-ee14-4856-310f5e5e28e4@huawei-partners.com>
 <ZmG6f1XCrdWE-O7y@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZmG6f1XCrdWE-O7y@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 dggpemm500020.china.huawei.com (7.185.36.49)

6/6/2024 4:32 PM, Günther Noack wrote:
> Hello Mikhail!
> 
> On Thu, Jun 06, 2024 at 02:44:23PM +0300, Mikhail Ivanov wrote:
>> 6/4/2024 11:22 PM, Günther Noack wrote:
>>> On Fri, May 24, 2024 at 05:30:03PM +0800, Mikhail Ivanov wrote:
>>>> Hello! This is v2 RFC patch dedicated to socket protocols restriction.
>>>>
>>>> It is based on the landlock's mic-next branch on top of v6.9 kernel
>>>> version.
>>>
>>> Hello Mikhail!
>>>
>>> I patched in your patchset and tried to use the feature with a small
>>> demo tool, but I ran into what I think is a bug -- do you happen to
>>> know what this might be?
>>>
>>> I used 6.10-rc1 as a base and patched your patches on top.
>>>
>>> The code is a small tool called "nonet", which does the following:
>>>
>>>     - Disable socket creation with a Landlock ruleset with the following
>>>       attributes:
>>>       struct landlock_ruleset_attr attr = {
>>>         .handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>>>       };
>>>
>>>     - open("/dev/null", O_WRONLY)
>>>
>>> Expected result:
>>>
>>>     - open() should work
>>>
>>> Observed result:
>>>
>>>     - open() fails with EACCES.
>>>
>>> I traced this with perf, and found that the open() gets rejected from
>>> Landlock's hook_file_open, whereas hook_socket_create does not get
>>> invoked.  This is surprising to me -- Enabling a policy for socket
>>> creation should not influence the outcome of opening files!
>>>
>>> Tracing commands:
>>>
>>>     sudo perf probe hook_socket_create '$params'
>>>     sudo perf probe 'hook_file_open%return $retval'
>>>     sudo perf record -e 'probe:*' -g -- ./nonet
>>>     sudo perf report
>>> You can find the tool in my landlock-examples repo in the nonet_bug branch:
>>> https://github.com/gnoack/landlock-examples/blob/nonet_bug/nonet.c
>>>
>>> Landlock is enabled like this:
>>> https://github.com/gnoack/landlock-examples/blob/nonet_bug/sandbox_socket.c
>>>
>>> Do you have a hunch what might be going on?
>>
>> Hello Günther!
>> Big thanks for this research!
>>
>> I figured out that I define LANDLOCK_SHIFT_ACCESS_SOCKET macro in
>> really strange way (see landlock/limits.h):
>>
>>    #define LANDLOCK_SHIFT_ACCESS_SOCKET	LANDLOCK_NUM_ACCESS_SOCKET
>>
>> With this definition, socket access mask overlaps the fs access
>> mask in ruleset->access_masks[layer_level]. That's why
>> landlock_get_fs_access_mask() returns non-zero mask in hook_file_open().
>>
>> So, the macro must be defined in this way:
>>
>>    #define LANDLOCK_SHIFT_ACCESS_SOCKET	(LANDLOCK_NUM_ACCESS_NET +
>>                                           LANDLOCK_NUM_ACCESS_FS)
>>
>> With this fix, open() doesn't fail in your example.
>>
>> I'm really sorry that I somehow made such a stupid typo. I will try my
>> best to make sure this doesn't happen again.
> 
> Thanks for figuring it out so quickly.  With that change, I'm getting some
> compilation errors (some bit shifts are becoming too wide for the underlying
> types), but I'm sure you can address that easily for the next version of the
> patch set.
> 
> IMHO this shows that our reliance on bit manipulation is probably getting in the
> way of code clarity. :-/ I hope we can simplify these internal structures at
> some point.  Once we have a better way to check for performance changes [1], we
> can try to change this and measure whether these comprehensibility/performance
> tradeoff is really worth it.
> 
> [1] https://github.com/landlock-lsm/linux/issues/24

Sounds great, probably this idea should be added to this issue [1].

[1] https://github.com/landlock-lsm/linux/issues/34

> 
> The other takeaway in my mind is, we should probably have some tests for that,
> to check that the enablement of one kind of policy does not affect the
> operations that belong to other kinds of policies.  Like this, for instance (I
> was about to send this test to help debugging):
> 
> TEST_F(mini, restricting_socket_does_not_affect_fs_actions)
> {
> 	const struct landlock_ruleset_attr ruleset_attr = {
> 		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
> 	};
> 	int ruleset_fd, fd;
> 
> 	ruleset_fd = landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> 	ASSERT_LE(0, ruleset_fd);
> 
> 	enforce_ruleset(_metadata, ruleset_fd);
> 	ASSERT_EQ(0, close(ruleset_fd));
> 
> 	/*
> 	 * Accessing /dev/null for writing should be permitted,
> 	 * because we did not add any file system restrictions.
> 	 */
> 	fd = open("/dev/null", O_WRONLY);
> 	EXPECT_LE(0, fd);
> 
> 	ASSERT_EQ(0, close(fd));
> }
> 
> Since these kinds of tests are a bit at the intersection between the
> fs/net/socket tests, maybe they could go into a separate test file?  The next
> time we add a new kind of Landlock restriction, it would come more naturally to
> add the matching test there and spot such issues earlier.  Would you volunteer
> to add such a test as part of your patch set? :)

Good idea! This test should probably be a part of the patch I mentioned
here [1]. WDYT?

(Btw, [1] should also be a part of the issue mentioned above).

[1] 
https://lore.kernel.org/all/f4b5e2b9-e960-fd08-fdf4-328bb475e2ef@huawei-partners.com/

> 
> Thanks,
> Günther
