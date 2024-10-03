Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225261CFBC;
	Thu,  3 Oct 2024 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727964029; cv=none; b=PlKR1tjE02v1Pecl7MlBVfxInjuX6pg46C820cd5Qdpq+/enCiRdLZEAEWp6FkNbSrnMQesqFmorDJ7Lgp9TDquz1dBnh+36gNlJ2E0nzeest7wKI9A2ggz+CHnlIuqtUGFNz6E8JviiGfiYt+obznDe/K+YbIFX/uCwSjG5f6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727964029; c=relaxed/simple;
	bh=oOP7GGAd3xEMVOUHY0dcQn1CfAtTStyBJ2/NTZIepos=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MpmWkZmx5Uw30dFVbgYVvWbxKBH5J1fIF5gejZKOj1D4/V0IER0iZ3/tM9vfUOmPqRqm0NgCMt70AyrZhq4dNXdYX9fE1+yRo+VxOrwsPs1ISQb2s9UjP9Sxqz5oBqiGmAvTXp0I8+5dHU8RtUD9r41fw4IAovki8iOr8WcxuBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XKCwC6HYmz1SC2M;
	Thu,  3 Oct 2024 21:59:23 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 385CA180042;
	Thu,  3 Oct 2024 22:00:22 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Oct 2024 22:00:18 +0800
Message-ID: <db38b163-ceb9-c74b-bcd5-402c646abea7@huawei-partners.com>
Date: Thu, 3 Oct 2024 17:00:14 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 19/19] landlock: Document socket rule type support
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-20-ivanov.mikhail1@huawei-partners.com>
 <ZvufroAFgLp_vZcF@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZvufroAFgLp_vZcF@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 10/1/2024 10:09 AM, Günther Noack wrote:
> Hello!
> 
> On Wed, Sep 04, 2024 at 06:48:24PM +0800, Mikhail Ivanov wrote:
>> Extend documentation with socket rule type description.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   Documentation/userspace-api/landlock.rst | 46 ++++++++++++++++++++----
>>   1 file changed, 40 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
>> index 37dafce8038b..4bf45064faa1 100644
>> --- a/Documentation/userspace-api/landlock.rst
>> +++ b/Documentation/userspace-api/landlock.rst
>> @@ -33,7 +33,7 @@ A Landlock rule describes an action on an object which the process intends to
>>   perform.  A set of rules is aggregated in a ruleset, which can then restrict
>>   the thread enforcing it, and its future children.
>>   
>> -The two existing types of rules are:
>> +The three existing types of rules are:
>>   
>>   Filesystem rules
>>       For these rules, the object is a file hierarchy,
>> @@ -44,14 +44,19 @@ Network rules (since ABI v4)
>>       For these rules, the object is a TCP port,
>>       and the related actions are defined with `network access rights`.
>>   
>> +Socket rules (since ABI v6)
>> +    For these rules, the object is a pair of an address family and a socket type,
>> +    and the related actions are defined with `socket access rights`.
>> +
>>   Defining and enforcing a security policy
>>   ----------------------------------------
>>   
>>   We first need to define the ruleset that will contain our rules.
>>   
>>   For this example, the ruleset will contain rules that only allow filesystem
>> -read actions and establish a specific TCP connection. Filesystem write
>> -actions and other TCP actions will be denied.
>> +read actions, create TCP sockets and establish a specific TCP connection.
>> +Filesystem write actions, creating non-TCP sockets and other TCP
>> +actions will be denied.
>>   
>>   The ruleset then needs to handle both these kinds of actions.  This is
>>   required for backward and forward compatibility (i.e. the kernel and user
>> @@ -81,6 +86,8 @@ to be explicit about the denied-by-default access rights.
>>           .handled_access_net =
>>               LANDLOCK_ACCESS_NET_BIND_TCP |
>>               LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +        .handled_access_socket =
>> +            LANDLOCK_ACCESS_SOCKET_CREATE,
>>       };
>>   
>>   Because we may not know on which kernel version an application will be
>> @@ -119,6 +126,11 @@ version, and only use the available subset of access rights:
>>       case 4:
>>           /* Removes LANDLOCK_ACCESS_FS_IOCTL_DEV for ABI < 5 */
>>           ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_IOCTL_DEV;
>> +        __attribute__((fallthrough));
>> +	case 5:
>> +		/* Removes socket support for ABI < 6 */
>> +		ruleset_attr.handled_access_socket &=
>> +			~LANDLOCK_ACCESS_SOCKET_CREATE;
> 
> When I patched this in, the indentation of this "case" was off, compared to the
> rest of the code example.  (The code example uses spaces for indentation, not
> tabs.)
Thanks for noticing this! Will be fixed.

> 
>>       }
>>   
>>   This enables to create an inclusive ruleset that will contain our rules.
>> @@ -170,6 +182,20 @@ for the ruleset creation, by filtering access rights according to the Landlock
>>   ABI version.  In this example, this is not required because all of the requested
>>   ``allowed_access`` rights are already available in ABI 1.
>>   
>> +For socket access-control, we can add a rule to allow TCP sockets creation. UNIX,
>> +UDP IP and other protocols will be denied by the ruleset.
>> +
>> +.. code-block:: c
>> +
>> +    struct landlock_net_port_attr tcp_socket = {
>> +        .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +        .family = AF_INET,
>> +        .type = SOCK_STREAM,
>> +    };
>> +
>> +    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +                            &tcp_socket, 0);
>> +
> 
> IMHO, the length of the "Defining and enforcing a security policy" section is
> slowly getting out of hand.  This was easier to follow when it was only file
> system rules. -- I wonder whether we should split this up in subsections for the
> individual steps to give this a more logical outline, e.g.
> 
> * Creating a ruleset
> * Adding rules to the ruleset
>    * Adding a file system rule
>    * Adding a network rule
>    * Adding a socket rule
> * Enforcing the ruleset

I agree, it's important to keep usage usage description as simple as it
possible. Should I include related commit in current patchset?

> 
>>   For network access-control, we can add a set of rules that allow to use a port
>>   number for a specific action: HTTPS connections.
>>   
>> @@ -186,7 +212,8 @@ number for a specific action: HTTPS connections.
>>   The next step is to restrict the current thread from gaining more privileges
>>   (e.g. through a SUID binary).  We now have a ruleset with the first rule
>>   allowing read access to ``/usr`` while denying all other handled accesses for
>> -the filesystem, and a second rule allowing HTTPS connections.
>> +the filesystem, a second rule allowing TCP sockets and a third rule allowing
>> +HTTPS connections.
>>   
>>   .. code-block:: c
>>   
>> @@ -404,7 +431,7 @@ Access rights
>>   -------------
>>   
>>   .. kernel-doc:: include/uapi/linux/landlock.h
>> -    :identifiers: fs_access net_access
>> +    :identifiers: fs_access net_access socket_access
>>   
>>   Creating a new ruleset
>>   ----------------------
>> @@ -423,7 +450,7 @@ Extending a ruleset
>>   
>>   .. kernel-doc:: include/uapi/linux/landlock.h
>>       :identifiers: landlock_rule_type landlock_path_beneath_attr
>> -                  landlock_net_port_attr
>> +                  landlock_net_port_attr landlock_socket_attr
>>   
>>   Enforcing a ruleset
>>   -------------------
>> @@ -541,6 +568,13 @@ earlier ABI.
>>   Starting with the Landlock ABI version 5, it is possible to restrict the use of
>>   :manpage:`ioctl(2)` using the new ``LANDLOCK_ACCESS_FS_IOCTL_DEV`` right.
>>   
>> +Socket support (ABI < 6)
>> +-------------------------
>> +
>> +Starting with the Landlock ABI version 6, it is now possible to restrict
>> +creation of user space sockets to only a set of allowed protocols thanks
>> +to the new ``LANDLOCK_ACCESS_SOCKET_CREATE`` access right.
>> +
>>   .. _kernel_support:
>>   
>>   Kernel support
>> -- 
>> 2.34.1
>>
> 
> There is a section further below called "Network support" that talks about the
> need for CONFIG_INET in order to add a network rule.  Do similar restrictions
> apply to the socket rules as well?  Maybe this should be added to the section.

No, socket rules should be supported with default config. The only
restriction which we came to is that socket type and address family
values should fit related ranges [1].

[1] 
https://lore.kernel.org/all/deeada6f-2538-027a-4922-8697fc59c43f@huawei-partners.com/

> 
> Please don't forget -- Tahera Fahimi's "scoped" patches have landed in
> linux-next by now, so we will need to rebase and bump the ABI version one higher
> than before.

yeah, thank you!

> 
> Thanks,
> —Günther
