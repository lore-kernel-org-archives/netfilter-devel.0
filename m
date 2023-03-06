Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC272C6FA99
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Mar 2023 16:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCFQBM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Mar 2023 11:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjCFQAy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2023 11:00:54 -0500
Received: from smtp-190a.mail.infomaniak.ch (smtp-190a.mail.infomaniak.ch [185.125.25.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A671232E53
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2023 08:00:50 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PVjwZ5BNWzMq0bV;
        Mon,  6 Mar 2023 17:00:46 +0100 (CET)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4PVjwY6ttHzMtDdV;
        Mon,  6 Mar 2023 17:00:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1678118446;
        bh=W9bxayx1B7vEQkL2vJ0A4EzTLbTTWSnAAKU6B5OE5bg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IddPPHRGl7MDwiat8dL4ZmRxRLyXBRJA0Vj2QQU+7JZI7awA3IZwK+ZLkJBcvLksI
         WKVCnSRyAjyKOvOs1cQifWsoL9HYg+QBFKY2cb0zLx4Zc01xehgQXHI+fRqeJp7wHW
         IL8RVjooFQ7xGguaZFveggTh5rXckKzezHBUApgQ=
Message-ID: <0efdc745-2365-a8c2-43cb-ef3608586481@digikod.net>
Date:   Mon, 6 Mar 2023 17:00:45 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 10/12] selftests/landlock: Add 10 new test suites
 dedicated to network
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-11-konstantin.meskhidze@huawei.com>
 <fa306757-2040-415b-99a7-ba40c100638a@digikod.net>
 <b324a6bc-0b0f-c299-72b9-903eede187e8@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <b324a6bc-0b0f-c299-72b9-903eede187e8@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 06/03/2023 13:03, Konstantin Meskhidze (A) wrote:
> 
> 
> 2/21/2023 9:05 PM, Mickaël Salaün пишет:
>>
>> On 16/01/2023 09:58, Konstantin Meskhidze wrote:
>>> These test suites try to check edge cases for TCP sockets
>>> bind() and connect() actions.
>>>
>>> socket:
>>> * bind: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
>>> * connect: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
>>> * bind_afunspec: Tests with non-landlocked/landlocked restrictions
>>> for bind action with AF_UNSPEC socket family.
>>> * connect_afunspec: Tests with non-landlocked/landlocked restrictions
>>> for connect action with AF_UNSPEC socket family.
>>> * ruleset_overlap: Tests with overlapping rules for one port.
>>> * ruleset_expanding: Tests with expanding rulesets in which rules are
>>> gradually added one by one, restricting sockets' connections.
>>> * inval: Tests with invalid user space supplied data:
>>>       - out of range ruleset attribute;
>>>       - unhandled allowed access;
>>>       - zero port value;
>>>       - zero access value;
>>>       - legitimate access values;
>>> * bind_connect_inval_addrlen: Tests with invalid address length
>>> for ipv4/ipv6 sockets.
>>> * inval_port_format: Tests with wrong port format for ipv4/ipv6 sockets.
>>>
>>> layout1:
>>> * with_net: Tests with network bind() socket action within
>>> filesystem directory access test.
>>>
>>> Test coverage for security/landlock is 94.1% of 946 lines according
>>> to gcc/gcov-11.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v8:
>>> * Adds is_sandboxed const for FIXTURE_VARIANT(socket).
>>> * Refactors AF_UNSPEC tests.
>>> * Adds address length checking tests.
>>> * Convert ports in all tests to __be16.
>>> * Adds invalid port values tests.
>>> * Minor fixes.
>>>
>>> Changes since v7:
>>> * Squashes all selftest commits.
>>> * Adds fs test with network bind() socket action.
>>> * Minor fixes.
>>>
>>> ---
>>>    tools/testing/selftests/landlock/config     |    4 +
>>>    tools/testing/selftests/landlock/fs_test.c  |   65 ++
>>>    tools/testing/selftests/landlock/net_test.c | 1157 +++++++++++++++++++
>>>    3 files changed, 1226 insertions(+)
>>>    create mode 100644 tools/testing/selftests/landlock/net_test.c
>>>
>>> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
>>> index 0f0a65287bac..71f7e9a8a64c 100644
>>> --- a/tools/testing/selftests/landlock/config
>>> +++ b/tools/testing/selftests/landlock/config

[...]

>>> +static int bind_variant(const struct _fixture_variant_socket *const variant,
>>> +			const int sockfd,
>>> +			const struct _test_data_socket *const self,
>>> +			const size_t index, const bool zero_size)
>>> +
>>
>> Extra new line.
> 
>    Will be deleted. Thanks. >>
>>> +{
>>> +	if (variant->is_ipv4)
>>> +		return bind(sockfd, &self->addr4[index],
>>> +			    (zero_size ? 0 : sizeof(self->addr4[index])));
>>
>> Is the zero_size really useful? Do calling bind and connect with this
>> argument reaches the Landlock code (check_addrlen) or is it caught by
>> the network code beforehand?
> 
>     In __sys_bind() syscall security_socket_bind() function goes before
>     sock->ops->bind() method. Selinux and Smacks provide such checks in
>     bind()/connect() hooks, so I think Landlock should do the same.
>     What do you think?

Yes, we should keep these checks. However, we should have a 
bind_variant() without the zero_size argument because it is only set to 
true once (in bind_connect_inval_addrlen). You can explicitly call 
bind() with a zero size in bind_connect_inval_addrlen().

Same for connect_variant().


>>
>>
>>> +	else
>>> +		return bind(sockfd, &self->addr6[index],
>>> +			    (zero_size ? 0 : sizeof(self->addr6[index])));
>>> +}
>>> +
>>> +static int connect_variant(const struct _fixture_variant_socket *const variant,
>>> +			   const int sockfd,
>>> +			   const struct _test_data_socket *const self,
>>> +			   const size_t index, const bool zero_size)
>>> +{
>>> +	if (variant->is_ipv4)
>>> +		return connect(sockfd, &self->addr4[index],
>>> +			       (zero_size ? 0 : sizeof(self->addr4[index])));
>>> +	else
>>> +		return connect(sockfd, &self->addr6[index],
>>> +			       (zero_size ? 0 : sizeof(self->addr6[index])));
>>> +}
