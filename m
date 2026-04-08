Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [83.166.143.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7880F3AB280
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2026 10:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775644041; cv=none; b=laRk99woPrLzm/+POQZxqBGQKMQ3+M8YOFuiwlAVrlTyr2qBUSCjrjg0qEE4QjsBtjrhvEx/46JZM8m7dmXgxNaPB26I/BII+Gr+GlIYqBfLyQfxCxfcVxpODZbSwUUs5yW9DcH/KDeXZqFkxmC0SkkPPb/9I/3Ejsnamq82OHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775644041; c=relaxed/simple;
	bh=sc1JMkY3UgErp6Dsnyry9IezKMrK1lzsKMC8DHOacuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWvv2vwKRV2apAD0r+5AnsDNhMAMs17t/1RyVzoK6NIy1UIb8X73Wvxf7TqEHXmmUGF8bJp3nGosD5Z+KxMlZI8SAGVLbFcFHCvMtzl/vMXy0YNd5OITmss+qw68J8kI3jBqGaGwdnIGTnziCHI3KJ4Asq2OH+8aJMVwM5eyCtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=PS8+bs48; arc=none smtp.client-ip=83.166.143.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="PS8+bs48"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4frK4T0kZyzYT9;
	Wed,  8 Apr 2026 12:27:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1775644024;
	bh=oYloD+uUZHW/PQ9KIAsFWQ7AEeM0J797FcnQco3MYso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PS8+bs48VJVWEpX8sXC7eJnUxIUVLljQIAqSsEQFuTmexP+nKJyNWszMqKlZAT/un
	 ewxAHw5sgpcvvGFaeNb6W2k8UEk8GoYDErvm95nWmHEqqXfWKX8zxNzpZL7tBhlReI
	 lBNFHX55tadziY8/N0fDkP68knExg896n2vt5tIc=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4frK4S22KbzKhg;
	Wed,  8 Apr 2026 12:27:03 +0200 (CEST)
Date: Wed, 8 Apr 2026 12:26:58 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: gnoack@google.com, willemdebruijn.kernel@gmail.com, matthieu@buffet.re, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v4 00/19] Support socket access-control
Message-ID: <20260408.icooCaighie2@digikod.net>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

Hi Mikhail,

On Tue, Nov 18, 2025 at 09:46:20PM +0800, Mikhail Ivanov wrote:
> Hello! This is v4 RFC patch dedicated to socket protocols restriction.
> 
> It is based on the landlock's mic-next branch on top of Linux 6.16-rc2
> kernel version.
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
> corresponds to user space sockets creation. The key in this rule
> corresponds to communication protocol signature from socket(2) syscall.

FYI, I sent a new patch series that adds a handled_perm field to
rulesets:
https://lore.kernel.org/all/20260312100444.2609563-6-mic@digikod.net/
See also the rationale:
https://lore.kernel.org/all/20260312100444.2609563-12-mic@digikod.net/

I think that would work well with the socket creation permission.  WDYT?

Do you think you'll be able to continue this work or would you like me
or Günther to complete the remaining last bits (while of course keeping
you as the main author)?


> 
> The right to create a socket is checked in the LSM hook which is called
> in the __sock_create method. The following user space operations are
> subject to this check: socket(2), socketpair(2), io_uring(7).
> 
> `LANDLOCK_ACCESS_SOCKET_CREATE` does not restrict socket creation
> performed by accept(2), because created socket is used for messaging
> between already existing endpoints.
> 
> Design discussion
> ===================
> 1. Should `SCTP_SOCKOPT_PEELOFF` and socketpair(2) be restricted?
> 
> SCTP socket can be connected to a multiple endpoints (one-to-many
> relation). Calling setsockopt(2) on such socket with option
> `SCTP_SOCKOPT_PEELOFF` detaches one of existing connections to a separate
> UDP socket. This detach is currently restrictable.
> 
> Same applies for the socketpair(2) syscall. It was noted that denying
> usage of socketpair(2) in sandboxed environment may be not meaninful [1].
> 
> Currently both operations use general socket interface to create sockets.
> Therefore it's not possible to distinguish between socket(2) and those
> operations inside security_socket_create LSM hook which is currently
> used for protocols restriction. Providing such separation may require
> changes in socket layer (eg. in __sock_create) interface which may not be
> acceptable.
> 
> [1] https://lore.kernel.org/all/ZurZ7nuRRl0Zf2iM@google.com/
> 
> Code coverage
> =============
> Code coverage(gcov) report with the launch of all the landlock selftests:
> * security/landlock:
> lines......: 94.0% (1200 of 1276 lines)
> functions..: 95.0% (134 of 141 functions)
> 
> * security/landlock/socket.c:
> lines......: 100.0% (56 of 56 lines)
> functions..: 100.0% (5 of 5 functions)
> 
> Currently landlock-test-tools fails on mini.kernel_socket test due to lack
> of SMC protocol support.
> 
> General changes v3->v4
> ======================
> * Implementation
>   * Adds protocol field to landlock_socket_attr.
>   * Adds protocol masks support via wildcards values in
>     landlock_socket_attr.
>   * Changes LSM hook used from socket_post_create to socket_create.
>   * Changes protocol ranges acceptable by socket rules.
>   * Adds audit support.
>   * Changes ABI version to 8.
> * Tests
>   * Adds 5 new tests:
>     * mini.rule_with_wildcard, protocol_wildcard.access,
>       mini.ruleset_with_wildcards_overlap:
>       verify rulesets containing rules with wildcard values.
>     * tcp_protocol.alias_restriction: verify that Landlock doesn't
>       perform protocol mappings.
>     * audit.socket_create: tests audit denial logging.
>   * Squashes tests corresponding to Landlock rule adding to a single commit.
> * Documentation
>   * Refactors Documentation/userspace-api/landlock.rst.
> * Commits
>   * Rebases on mic-next.
>   * Refactors commits.
> 
> Previous versions
> =================
> v3: https://lore.kernel.org/all/20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com/
> v2: https://lore.kernel.org/all/20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com/
> v1: https://lore.kernel.org/all/20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com/
> 
> Mikhail Ivanov (19):
>   landlock: Support socket access-control
>   selftests/landlock: Test creating a ruleset with unknown access
>   selftests/landlock: Test adding a socket rule
>   selftests/landlock: Testing adding rule with wildcard value
>   selftests/landlock: Test acceptable ranges of socket rule key
>   landlock: Add hook on socket creation
>   selftests/landlock: Test basic socket restriction
>   selftests/landlock: Test network stack error code consistency
>   selftests/landlock: Test overlapped rulesets with rules of protocol
>     ranges
>   selftests/landlock: Test that kernel space sockets are not restricted
>   selftests/landlock: Test protocol mappings
>   selftests/landlock: Test socketpair(2) restriction
>   selftests/landlock: Test SCTP peeloff restriction
>   selftests/landlock: Test that accept(2) is not restricted
>   lsm: Support logging socket common data
>   landlock: Log socket creation denials
>   selftests/landlock: Test socket creation denial log for audit
>   samples/landlock: Support socket protocol restrictions
>   landlock: Document socket rule type support
> 
>  Documentation/userspace-api/landlock.rst      |   48 +-
>  include/linux/lsm_audit.h                     |    8 +
>  include/uapi/linux/landlock.h                 |   60 +-
>  samples/landlock/sandboxer.c                  |  118 +-
>  security/landlock/Makefile                    |    2 +-
>  security/landlock/access.h                    |    3 +
>  security/landlock/audit.c                     |   12 +
>  security/landlock/audit.h                     |    1 +
>  security/landlock/limits.h                    |    4 +
>  security/landlock/ruleset.c                   |   37 +-
>  security/landlock/ruleset.h                   |   46 +-
>  security/landlock/setup.c                     |    2 +
>  security/landlock/socket.c                    |  198 +++
>  security/landlock/socket.h                    |   20 +
>  security/landlock/syscalls.c                  |   61 +-
>  security/lsm_audit.c                          |    4 +
>  tools/testing/selftests/landlock/base_test.c  |    2 +-
>  tools/testing/selftests/landlock/common.h     |   14 +
>  tools/testing/selftests/landlock/config       |   47 +
>  tools/testing/selftests/landlock/net_test.c   |   11 -
>  .../selftests/landlock/protocols_define.h     |  169 +++
>  .../testing/selftests/landlock/socket_test.c  | 1169 +++++++++++++++++
>  22 files changed, 1990 insertions(+), 46 deletions(-)
>  create mode 100644 security/landlock/socket.c
>  create mode 100644 security/landlock/socket.h
>  create mode 100644 tools/testing/selftests/landlock/protocols_define.h
>  create mode 100644 tools/testing/selftests/landlock/socket_test.c
> 
> 
> base-commit: 6dde339a3df80a57ac3d780d8cfc14d9262e2acd
> -- 
> 2.34.1
> 
> 
