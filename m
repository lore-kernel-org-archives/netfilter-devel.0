Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [185.125.25.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F3F293B78;
	Tue, 22 Apr 2025 17:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745342357; cv=none; b=mDhTvRqWPi1RjSiy3tIDjTUwa7mQmSqb0WtYT8mo+rKYg4VD0wwFswU2itMf6JqpnYzH1eWVnT0RGgt3wBl+XbWQF55CG3AT+UU//aHP5ttBZlny2Bc1koMr35WXseuTW2GZk9YLsKUbv6ncj8xBepF5JROmbFjP6AMgzBTXg3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745342357; c=relaxed/simple;
	bh=t35hlQuDtvfHPTHDg0CvjqyOvwh0pkrGfRx7H9Y7c98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdIyz31LWJYCH29wX72xcK+F0atdkPEL2nVROFHwTgmSu5LzIcsa9Nx5lJKV4hOootNYnXvAPaGwtzpVV+XuOlqwia3zDNKlB+xKATJ7LHMcE/wZNPQYxcBgt5dp8vUzzIyTHv9kUh1h1i3bSlXn9F4RecG/G5pGJXYya2wbJcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=csqOyEo8; arc=none smtp.client-ip=185.125.25.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="csqOyEo8"
Received: from smtp-4-0000.mail.infomaniak.ch (unknown [IPv6:2001:1600:7:10:40ca:feff:fe05:0])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Zhpqr2rSDzYGH;
	Tue, 22 Apr 2025 19:19:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1745342344;
	bh=GsNBQQ/0jgUnK4M3pOOre1/bTfSk8iwc/ssxVA4CQTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=csqOyEo8MaRVFS4xclpqckzIVytITwa+bLw3V+sKYSDC+Wy1F+CfQY2zR2QHq/bkK
	 kNgmhXJ4GX143muDMoz1vO/Mp7gSo7bSLEB7YnIQprxxI+p7YVHs3TakuGmq54NNsC
	 nzadJMSBa7zYIA8TyhKdgMVDSAu4R5Go6jNtDyD0=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Zhpqq4Vf1z1rG;
	Tue, 22 Apr 2025 19:19:03 +0200 (CEST)
Date: Tue, 22 Apr 2025 19:19:02 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH v3 00/19] Support socket access-control
Message-ID: <20250422.iesaivaj8Aeb@digikod.net>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

Hi Mikhail.  Could you please send a new version taking into account the
reviews?

This series should support audit by logging socket creation denials and
extending audit_log_lsm_data().  You can get inspiration from the format
used by audit_net_cb() but without the number to text translation, that
can be handled by auditd if needed.  New tests should check these new
audit logs.


On Wed, Sep 04, 2024 at 06:48:05PM +0800, Mikhail Ivanov wrote:
> Hello! This is v3 RFC patch dedicated to socket protocols restriction.
> 
> It is based on the landlock's mic-next branch on top of v6.11-rc1 kernel
> version.
> 
> Objective
> =========
> Extend Landlock with a mechanism to restrict any set of protocols in
> a sandboxed process.
> 
> Closes: https://github.com/landlock-lsm/linux/issues/6
> 
> Motivation
> ==========
> Landlock implements the `LANDLOCK_RULE_NET_PORT` rule type, which provides
> fine-grained control of actions for a specific protocol. Any action or
> protocol that is not supported by this rule can not be controlled. As a
> result, protocols for which fine-grained control is not supported can be
> used in a sandboxed system and lead to vulnerabilities or unexpected
> behavior.
> 
> Controlling the protocols used will allow to use only those that are
> necessary for the system and/or which have fine-grained Landlock control
> through others types of rules (e.g. TCP bind/connect control with
> `LANDLOCK_RULE_NET_PORT`, UNIX bind control with
> `LANDLOCK_RULE_PATH_BENEATH`).
> 
> Consider following examples:
> * Server may want to use only TCP sockets for which there is fine-grained
>   control of bind(2) and connect(2) actions [1].
> * System that does not need a network or that may want to disable network
>   for security reasons (e.g. [2]) can achieve this by restricting the use
>   of all possible protocols.
> 
> [1] https://lore.kernel.org/all/ZJvy2SViorgc+cZI@google.com/
> [2] https://cr.yp.to/unix/disablenetwork.html
> 
> Implementation
> ==============
> This patchset adds control over the protocols used by implementing a
> restriction of socket creation. This is possible thanks to the new type
> of rule - `LANDLOCK_RULE_SOCKET`, that allows to restrict actions on
> sockets, and a new access right - `LANDLOCK_ACCESS_SOCKET_CREATE`, that
> corresponds to creating user space sockets. The key in this rule is a pair
> of address family and socket type (Cf. socket(2)).
> 
> The right to create a socket is checked in the LSM hook, which is called
> in the __sock_create method. The following user space operations are
> subject to this check: socket(2), socketpair(2), io_uring(7).
> 
> In the case of connection-based socket types,
> `LANDLOCK_ACCESS_SOCKET_CREATE` does not restrict the actions that result
> in creation of sockets used for messaging between already existing
> endpoints (e.g. accept(2), setsockopt(2) with option
> `SCTP_SOCKOPT_PEELOFF`).
> 
> Current limitations
> ===================
> `SCTP_SOCKOPT_PEELOFF` should not be restricted (see test
> socket_creation.sctp_peeloff).
> 
> SCTP socket can be connected to a multiple endpoints (one-to-many
> relation). Calling setsockopt(2) on such socket with option
> `SCTP_SOCKOPT_PEELOFF` detaches one of existing connections to a separate
> UDP socket. This detach is currently restrictable.
> 
> Code coverage
> =============
> Code coverage(gcov) report with the launch of all the landlock selftests:
> * security/landlock:
> lines......: 93.5% (794 of 849 lines)
> functions..: 95.5% (106 of 111 functions)
> 
> * security/landlock/socket.c:
> lines......: 100.0% (33 of 33 lines)
> functions..: 100.0% (4 of 4 functions)
> 
> General changes v2->v3
> ======================
> * Implementation
>   * Accepts (AF_INET, SOCK_PACKET) as an alias for (AF_PACKET, SOCK_PACKET).
>   * Adds check to not restrict kernel sockets.
>   * Fixes UB in pack_socket_key().
>   * Refactors documentation.
> * Tests
>   * Extends variants of `protocol` fixture with every protocol that can be
>     used to create user space sockets.
>   * Adds 5 new tests:
>     * 3 tests to check socketpair(2), accept(2) and sctp_peeloff
>       restriction.
>     * 1 test to check restriction of kernel sockets.
>     * 1 test to check AF_PACKET aliases.
> * Documentation
>   * Updates Documentation/userspace-api/landlock.rst.
> * Commits
>   * Rebases on mic-next.
>   * Refactors commits.
> 
> Previous versions
> =================
> v2: https://lore.kernel.org/all/20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com/
> v1: https://lore.kernel.org/all/20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com/
> 
> Mikhail Ivanov (19):
>   landlock: Support socket access-control
>   landlock: Add hook on socket creation
>   selftests/landlock: Test basic socket restriction
>   selftests/landlock: Test adding a rule with each supported access
>   selftests/landlock: Test adding a rule for each unknown access
>   selftests/landlock: Test adding a rule for unhandled access
>   selftests/landlock: Test adding a rule for empty access
>   selftests/landlock: Test overlapped restriction
>   selftests/landlock: Test creating a ruleset with unknown access
>   selftests/landlock: Test adding a rule with family and type outside
>     the range
>   selftests/landlock: Test unsupported protocol restriction
>   selftests/landlock: Test that kernel space sockets are not restricted
>   selftests/landlock: Test packet protocol alias
>   selftests/landlock: Test socketpair(2) restriction
>   selftests/landlock: Test SCTP peeloff restriction
>   selftests/landlock: Test that accept(2) is not restricted
>   samples/landlock: Replace atoi() with strtoull() in
>     populate_ruleset_net()
>   samples/landlock: Support socket protocol restrictions
>   landlock: Document socket rule type support
> 
>  Documentation/userspace-api/landlock.rst      |   46 +-
>  include/uapi/linux/landlock.h                 |   61 +-
>  samples/landlock/sandboxer.c                  |  135 ++-
>  security/landlock/Makefile                    |    2 +-
>  security/landlock/limits.h                    |    4 +
>  security/landlock/ruleset.c                   |   33 +-
>  security/landlock/ruleset.h                   |   45 +-
>  security/landlock/setup.c                     |    2 +
>  security/landlock/socket.c                    |  137 +++
>  security/landlock/socket.h                    |   19 +
>  security/landlock/syscalls.c                  |   66 +-
>  tools/testing/selftests/landlock/base_test.c  |    2 +-
>  tools/testing/selftests/landlock/common.h     |   13 +
>  tools/testing/selftests/landlock/config       |   47 +
>  tools/testing/selftests/landlock/net_test.c   |   11 -
>  .../testing/selftests/landlock/socket_test.c  | 1013 +++++++++++++++++
>  16 files changed, 1593 insertions(+), 43 deletions(-)
>  create mode 100644 security/landlock/socket.c
>  create mode 100644 security/landlock/socket.h
>  create mode 100644 tools/testing/selftests/landlock/socket_test.c
> 
> 
> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
> -- 
> 2.34.1
> 
> 
