Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9096635;
	Wed,  4 Sep 2024 10:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446920; cv=none; b=alr5gaDybUdN3IVVuLor4IerXwjCHIIEMf4XWMhQbC4ugJpIaAkdffsotwmSE1seLg2mdI3AIZ9Jr9/44EeQFbdylOEGOc7WsYveyzUXXjzkE4BKyRe8Ht5Q9on1KrQznpm0WDNih0J61uCAke8tCrdSeNMDpVnOQv1zVmQNwVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446920; c=relaxed/simple;
	bh=bD1gjTJwkoIJ1+f8/mQjm9aUSh7Yn0IwmnrR4QIWjho=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B0LS5opXtKBT50MaB9Hj9ue79+sEqMkBeL5IRD97RQ9Y4IgNmxePsF3EaZurC0RXUhQgKz7JeOi5A+k3ZIY3PQM+dUYOloYnSrcRiAPOaepeH3O9OVdoQSLYIRY6mYf7EVFn8ZTNZe6HBpKrCISQXBJ4QT9TBqJnCK2VW/IwzXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WzK2J474Jz1BN4W;
	Wed,  4 Sep 2024 18:47:36 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id EF4411400CA;
	Wed,  4 Sep 2024 18:48:33 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:32 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 00/19] Support socket access-control
Date: Wed, 4 Sep 2024 18:48:05 +0800
Message-ID: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Hello! This is v3 RFC patch dedicated to socket protocols restriction.

It is based on the landlock's mic-next branch on top of v6.11-rc1 kernel
version.

Objective
=========
Extend Landlock with a mechanism to restrict any set of protocols in
a sandboxed process.

Closes: https://github.com/landlock-lsm/linux/issues/6

Motivation
==========
Landlock implements the `LANDLOCK_RULE_NET_PORT` rule type, which provides
fine-grained control of actions for a specific protocol. Any action or
protocol that is not supported by this rule can not be controlled. As a
result, protocols for which fine-grained control is not supported can be
used in a sandboxed system and lead to vulnerabilities or unexpected
behavior.

Controlling the protocols used will allow to use only those that are
necessary for the system and/or which have fine-grained Landlock control
through others types of rules (e.g. TCP bind/connect control with
`LANDLOCK_RULE_NET_PORT`, UNIX bind control with
`LANDLOCK_RULE_PATH_BENEATH`).

Consider following examples:
* Server may want to use only TCP sockets for which there is fine-grained
  control of bind(2) and connect(2) actions [1].
* System that does not need a network or that may want to disable network
  for security reasons (e.g. [2]) can achieve this by restricting the use
  of all possible protocols.

[1] https://lore.kernel.org/all/ZJvy2SViorgc+cZI@google.com/
[2] https://cr.yp.to/unix/disablenetwork.html

Implementation
==============
This patchset adds control over the protocols used by implementing a
restriction of socket creation. This is possible thanks to the new type
of rule - `LANDLOCK_RULE_SOCKET`, that allows to restrict actions on
sockets, and a new access right - `LANDLOCK_ACCESS_SOCKET_CREATE`, that
corresponds to creating user space sockets. The key in this rule is a pair
of address family and socket type (Cf. socket(2)).

The right to create a socket is checked in the LSM hook, which is called
in the __sock_create method. The following user space operations are
subject to this check: socket(2), socketpair(2), io_uring(7).

In the case of connection-based socket types,
`LANDLOCK_ACCESS_SOCKET_CREATE` does not restrict the actions that result
in creation of sockets used for messaging between already existing
endpoints (e.g. accept(2), setsockopt(2) with option
`SCTP_SOCKOPT_PEELOFF`).

Current limitations
===================
`SCTP_SOCKOPT_PEELOFF` should not be restricted (see test
socket_creation.sctp_peeloff).

SCTP socket can be connected to a multiple endpoints (one-to-many
relation). Calling setsockopt(2) on such socket with option
`SCTP_SOCKOPT_PEELOFF` detaches one of existing connections to a separate
UDP socket. This detach is currently restrictable.

Code coverage
=============
Code coverage(gcov) report with the launch of all the landlock selftests:
* security/landlock:
lines......: 93.5% (794 of 849 lines)
functions..: 95.5% (106 of 111 functions)

* security/landlock/socket.c:
lines......: 100.0% (33 of 33 lines)
functions..: 100.0% (4 of 4 functions)

General changes v2->v3
======================
* Implementation
  * Accepts (AF_INET, SOCK_PACKET) as an alias for (AF_PACKET, SOCK_PACKET).
  * Adds check to not restrict kernel sockets.
  * Fixes UB in pack_socket_key().
  * Refactors documentation.
* Tests
  * Extends variants of `protocol` fixture with every protocol that can be
    used to create user space sockets.
  * Adds 5 new tests:
    * 3 tests to check socketpair(2), accept(2) and sctp_peeloff
      restriction.
    * 1 test to check restriction of kernel sockets.
    * 1 test to check AF_PACKET aliases.
* Documentation
  * Updates Documentation/userspace-api/landlock.rst.
* Commits
  * Rebases on mic-next.
  * Refactors commits.

Previous versions
=================
v2: https://lore.kernel.org/all/20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com/
v1: https://lore.kernel.org/all/20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com/

Mikhail Ivanov (19):
  landlock: Support socket access-control
  landlock: Add hook on socket creation
  selftests/landlock: Test basic socket restriction
  selftests/landlock: Test adding a rule with each supported access
  selftests/landlock: Test adding a rule for each unknown access
  selftests/landlock: Test adding a rule for unhandled access
  selftests/landlock: Test adding a rule for empty access
  selftests/landlock: Test overlapped restriction
  selftests/landlock: Test creating a ruleset with unknown access
  selftests/landlock: Test adding a rule with family and type outside
    the range
  selftests/landlock: Test unsupported protocol restriction
  selftests/landlock: Test that kernel space sockets are not restricted
  selftests/landlock: Test packet protocol alias
  selftests/landlock: Test socketpair(2) restriction
  selftests/landlock: Test SCTP peeloff restriction
  selftests/landlock: Test that accept(2) is not restricted
  samples/landlock: Replace atoi() with strtoull() in
    populate_ruleset_net()
  samples/landlock: Support socket protocol restrictions
  landlock: Document socket rule type support

 Documentation/userspace-api/landlock.rst      |   46 +-
 include/uapi/linux/landlock.h                 |   61 +-
 samples/landlock/sandboxer.c                  |  135 ++-
 security/landlock/Makefile                    |    2 +-
 security/landlock/limits.h                    |    4 +
 security/landlock/ruleset.c                   |   33 +-
 security/landlock/ruleset.h                   |   45 +-
 security/landlock/setup.c                     |    2 +
 security/landlock/socket.c                    |  137 +++
 security/landlock/socket.h                    |   19 +
 security/landlock/syscalls.c                  |   66 +-
 tools/testing/selftests/landlock/base_test.c  |    2 +-
 tools/testing/selftests/landlock/common.h     |   13 +
 tools/testing/selftests/landlock/config       |   47 +
 tools/testing/selftests/landlock/net_test.c   |   11 -
 .../testing/selftests/landlock/socket_test.c  | 1013 +++++++++++++++++
 16 files changed, 1593 insertions(+), 43 deletions(-)
 create mode 100644 security/landlock/socket.c
 create mode 100644 security/landlock/socket.h
 create mode 100644 tools/testing/selftests/landlock/socket_test.c


base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
-- 
2.34.1

