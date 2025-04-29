Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEEB1E0DBA;
	Tue, 29 Apr 2025 11:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745927973; cv=none; b=oBxWj1u5E0vzsXJMZigV5njHDn2+0misMaZB1sCu5He/HGeof7yOHeP6SJ/SKBCBHWx+1LXkLGWD4CeU/wdttjEDeHldCrDK6urU5zM5Tl7uag0PSLqEdZ4Isu3TGPKDXPDbiMm/Je3ohKoTsf6ykHqIngD//fBAmOuXfuXXmN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745927973; c=relaxed/simple;
	bh=rABI53vpjnl1yAdQD0xk0cPlD1agLIFnuQ/S5FhSZrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jTVAzMusPKRaAmfBtqiBzsU4jmr7K7I1X0AXT/xS5sAcC55jfL+6evOMrTVDstLFHMcQhTpqQ/lrO1eCHjeS55nQgt3FLlDTE4fAdUTE28zASU6H8n9/djqqGVa8X6SmTZYvS1lvvzzAKjmVugL7VpUCSKfM7Bq1kF+DD2Fuens=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZmzJk1LfWz6M4ht;
	Tue, 29 Apr 2025 19:55:02 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id A2E471400D9;
	Tue, 29 Apr 2025 19:59:20 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 29 Apr 2025 14:59:18 +0300
Message-ID: <5b82e994-e3a7-3c40-5ca0-46356084e688@huawei-partners.com>
Date: Tue, 29 Apr 2025 14:59:16 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 00/19] Support socket access-control
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
	=?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>, Paul Moore
	<paul@paul-moore.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20250422.iesaivaj8Aeb@digikod.net> <aAuU-LmjENslCF2P@google.com>
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <aAuU-LmjENslCF2P@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Hello, Günther, Mickaël!

Sorry for the huge delay, I was snowed under with internal project and
academic activity. I've almost finished the v4 patchset and will send it
in a few days.

On 4/25/2025 4:58 PM, Günther Noack wrote:
> Hello Mikhail!
> 
> I would also be interested in seeing this patch set land. :)
> Do you think you would be able to pick this up again?
> 
> 
> To refresh my memory, I also had a look at V3 again; One of the last big
> questions here was the userspace API in struct landlock_socket_attr.
> 
> To briefly recap that discussion, what we settled on at the end [1] was that we
> can use special wildcard values for some of the members of that struct, so that
> it looks like this:
> 
> struct landlock_socket_attr {
>    __u64 allowed_access;
>    int family;   /* same as domain in socket(2)    (required, never a wildcard) */
>    int type;     /* same as type in socket(2),     or the wildcard value (i64)-1 */
>    int protocol; /* same as protocol in socket(2), or the wildcard value (i64)-1 */
> };
> 
> (In other words, we have discarded the ideas of "handled_socket_layers" and
> using bitmasks to specify different values for the socket(2) arguments.)
> 
> So, when an attempt is made to call socket(family, type, protocol), Landlock has
> to check for the presence of the following keys in the RB-tree:
> 
>   1. (family, type, protocol)
>   2. (family, type, *)
>   3. (family, *,    *)
>   4. (family, *,    protocol)
> 
> but is an acceptable compromise to make ([1]).
> 
> Small remark: The four lookups sound bad, but I suspect that in many cases, only
> variant 1 (and maybe 2) will be used at all.  If you create four separate struct
> rb_root for these four cases, then if the more obscure variants are unused, the
> lookups for these will be almost for free.  (An empty rb_root contains only a
> single NULL-pointer.)

I expect socket rulesets to be quite small, so theoretically a single
lookup operation should really be almost free.

Anyway, optimization can be implemented by modifying structure
used to contain socket rules (rbtree currently). We can think of
something like "rules" array of AF_MAX * SOCK_MAX (~500) entries,
each entry holding information related to (family, type) pair.

rules[family][type] can be represented by the following stucture:

struct socket_rule {
	bool allowed; // = 0 by default
	struct socket_proto_rule *proto_rules;
};

struct socket_proto_rule {
	struct list_head list;
	int val; // eg. = IPPROTO_TCP
};

It will hold information about each of the following rules:
	1. (family, type, protocol)
	2. (family, type, *)
	3. (family, *,    *)
	4. (family, *,    protocol)

- If user wants to add type 2 rule, we'll just set
	rules[family][type].allowed = 1;

- If user wants to add type 3 rule, we'll perform previous
   operation for every socket type.

- If user wants to add type 1 rule, we'll add a new entry in
   socket_rule.proto_rules linked list.

- For type 4 rule, we'll perform previous operation for every socket
   type.

If we expect to have about 2-3 protocols per-family in worst case, than
lookup overhead should be negligible.

> 
> 
> I hope this is a reasonable summary of the discussion at [1] and helps to
> unblock the progress here?  Mikhail, are there any other open points which are
> blocking you on this patch set?

Yes, thank you!

A single thing I'm not quite sure about is that protocols of IP and UNIX
family can be defined in two ways. Socket API allows to have "default"
protocols for each protocol family which can be specified by setting
protocol = 0 in socket(2).

For example, we can define TCP socket as
	socket(AF_INET, SOCK_STREAM, IPPROTO_TCP) and
	socket(AF_INET, SOCK_STREAM, 0).
Theoretically, it can be a little bit uncomfortable to take care about
default values in ruleset definition, but I don't think there is a
pretty way to optimize it.

> 
> -Günther
> 
> 
> [1] https://lore.kernel.org/all/20250124.sei0Aur6aegu@digikod.net/
> 
> 
> On Tue, Apr 22, 2025 at 07:19:02PM +0200, Mickaël Salaün wrote:
>> Hi Mikhail.  Could you please send a new version taking into account the
>> reviews?
>>
>> This series should support audit by logging socket creation denials and
>> extending audit_log_lsm_data().  You can get inspiration from the format
>> used by audit_net_cb() but without the number to text translation, that
>> can be handled by auditd if needed.  New tests should check these new
>> audit logs.

Ok, thanks for pointing this out!

>>
>>
>> On Wed, Sep 04, 2024 at 06:48:05PM +0800, Mikhail Ivanov wrote:
>>> Hello! This is v3 RFC patch dedicated to socket protocols restriction.
>>>
>>> It is based on the landlock's mic-next branch on top of v6.11-rc1 kernel
>>> version.
>>>
>>> Objective
>>> =========
>>> Extend Landlock with a mechanism to restrict any set of protocols in
>>> a sandboxed process.
>>>
>>> Closes: https://github.com/landlock-lsm/linux/issues/6
>>>
>>> Motivation
>>> ==========
>>> Landlock implements the `LANDLOCK_RULE_NET_PORT` rule type, which provides
>>> fine-grained control of actions for a specific protocol. Any action or
>>> protocol that is not supported by this rule can not be controlled. As a
>>> result, protocols for which fine-grained control is not supported can be
>>> used in a sandboxed system and lead to vulnerabilities or unexpected
>>> behavior.
>>>
>>> Controlling the protocols used will allow to use only those that are
>>> necessary for the system and/or which have fine-grained Landlock control
>>> through others types of rules (e.g. TCP bind/connect control with
>>> `LANDLOCK_RULE_NET_PORT`, UNIX bind control with
>>> `LANDLOCK_RULE_PATH_BENEATH`).
>>>
>>> Consider following examples:
>>> * Server may want to use only TCP sockets for which there is fine-grained
>>>    control of bind(2) and connect(2) actions [1].
>>> * System that does not need a network or that may want to disable network
>>>    for security reasons (e.g. [2]) can achieve this by restricting the use
>>>    of all possible protocols.
>>>
>>> [1] https://lore.kernel.org/all/ZJvy2SViorgc+cZI@google.com/
>>> [2] https://cr.yp.to/unix/disablenetwork.html
>>>
>>> Implementation
>>> ==============
>>> This patchset adds control over the protocols used by implementing a
>>> restriction of socket creation. This is possible thanks to the new type
>>> of rule - `LANDLOCK_RULE_SOCKET`, that allows to restrict actions on
>>> sockets, and a new access right - `LANDLOCK_ACCESS_SOCKET_CREATE`, that
>>> corresponds to creating user space sockets. The key in this rule is a pair
>>> of address family and socket type (Cf. socket(2)).
>>>
>>> The right to create a socket is checked in the LSM hook, which is called
>>> in the __sock_create method. The following user space operations are
>>> subject to this check: socket(2), socketpair(2), io_uring(7).
>>>
>>> In the case of connection-based socket types,
>>> `LANDLOCK_ACCESS_SOCKET_CREATE` does not restrict the actions that result
>>> in creation of sockets used for messaging between already existing
>>> endpoints (e.g. accept(2), setsockopt(2) with option
>>> `SCTP_SOCKOPT_PEELOFF`).
>>>
>>> Current limitations
>>> ===================
>>> `SCTP_SOCKOPT_PEELOFF` should not be restricted (see test
>>> socket_creation.sctp_peeloff).
>>>
>>> SCTP socket can be connected to a multiple endpoints (one-to-many
>>> relation). Calling setsockopt(2) on such socket with option
>>> `SCTP_SOCKOPT_PEELOFF` detaches one of existing connections to a separate
>>> UDP socket. This detach is currently restrictable.
>>>
>>> Code coverage
>>> =============
>>> Code coverage(gcov) report with the launch of all the landlock selftests:
>>> * security/landlock:
>>> lines......: 93.5% (794 of 849 lines)
>>> functions..: 95.5% (106 of 111 functions)
>>>
>>> * security/landlock/socket.c:
>>> lines......: 100.0% (33 of 33 lines)
>>> functions..: 100.0% (4 of 4 functions)
>>>
>>> General changes v2->v3
>>> ======================
>>> * Implementation
>>>    * Accepts (AF_INET, SOCK_PACKET) as an alias for (AF_PACKET, SOCK_PACKET).
>>>    * Adds check to not restrict kernel sockets.
>>>    * Fixes UB in pack_socket_key().
>>>    * Refactors documentation.
>>> * Tests
>>>    * Extends variants of `protocol` fixture with every protocol that can be
>>>      used to create user space sockets.
>>>    * Adds 5 new tests:
>>>      * 3 tests to check socketpair(2), accept(2) and sctp_peeloff
>>>        restriction.
>>>      * 1 test to check restriction of kernel sockets.
>>>      * 1 test to check AF_PACKET aliases.
>>> * Documentation
>>>    * Updates Documentation/userspace-api/landlock.rst.
>>> * Commits
>>>    * Rebases on mic-next.
>>>    * Refactors commits.
>>>
>>> Previous versions
>>> =================
>>> v2: https://lore.kernel.org/all/20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com/
>>> v1: https://lore.kernel.org/all/20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com/
>>>
>>> Mikhail Ivanov (19):
>>>    landlock: Support socket access-control
>>>    landlock: Add hook on socket creation
>>>    selftests/landlock: Test basic socket restriction
>>>    selftests/landlock: Test adding a rule with each supported access
>>>    selftests/landlock: Test adding a rule for each unknown access
>>>    selftests/landlock: Test adding a rule for unhandled access
>>>    selftests/landlock: Test adding a rule for empty access
>>>    selftests/landlock: Test overlapped restriction
>>>    selftests/landlock: Test creating a ruleset with unknown access
>>>    selftests/landlock: Test adding a rule with family and type outside
>>>      the range
>>>    selftests/landlock: Test unsupported protocol restriction
>>>    selftests/landlock: Test that kernel space sockets are not restricted
>>>    selftests/landlock: Test packet protocol alias
>>>    selftests/landlock: Test socketpair(2) restriction
>>>    selftests/landlock: Test SCTP peeloff restriction
>>>    selftests/landlock: Test that accept(2) is not restricted
>>>    samples/landlock: Replace atoi() with strtoull() in
>>>      populate_ruleset_net()
>>>    samples/landlock: Support socket protocol restrictions
>>>    landlock: Document socket rule type support
>>>
>>>   Documentation/userspace-api/landlock.rst      |   46 +-
>>>   include/uapi/linux/landlock.h                 |   61 +-
>>>   samples/landlock/sandboxer.c                  |  135 ++-
>>>   security/landlock/Makefile                    |    2 +-
>>>   security/landlock/limits.h                    |    4 +
>>>   security/landlock/ruleset.c                   |   33 +-
>>>   security/landlock/ruleset.h                   |   45 +-
>>>   security/landlock/setup.c                     |    2 +
>>>   security/landlock/socket.c                    |  137 +++
>>>   security/landlock/socket.h                    |   19 +
>>>   security/landlock/syscalls.c                  |   66 +-
>>>   tools/testing/selftests/landlock/base_test.c  |    2 +-
>>>   tools/testing/selftests/landlock/common.h     |   13 +
>>>   tools/testing/selftests/landlock/config       |   47 +
>>>   tools/testing/selftests/landlock/net_test.c   |   11 -
>>>   .../testing/selftests/landlock/socket_test.c  | 1013 +++++++++++++++++
>>>   16 files changed, 1593 insertions(+), 43 deletions(-)
>>>   create mode 100644 security/landlock/socket.c
>>>   create mode 100644 security/landlock/socket.h
>>>   create mode 100644 tools/testing/selftests/landlock/socket_test.c
>>>
>>>
>>> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
>>> -- 
>>> 2.34.1
>>>
>>>
