Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF80A30F52A;
	Tue, 18 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473631; cv=none; b=kXc+hGj6zAaIyn4VtronvsAgVO0ixGRsDH4hQSyAelc2u5p8bNRY2UHszeD8bFekk5uXzN9UelscwzsGw9XXGCD1TNm++KkKU1O11orwbRWKsc611wvVlCBmrIIzj6WLPZg976G2wQGdG8+rnpR2dNe3rniUdDqY9ErPeI0fQco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473631; c=relaxed/simple;
	bh=K5UvAeQaJDLQEt6TxazsrdmbD4UuqZX9vXnPKc2XZP8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CyoEKV721XAXn6ecqTLRyssHchnCtOIcJIlCOtBBl7Mo2FfBrKM0GDazVoMeZ4V5l+gNW26Jq5F8p6uOHvRDCuoT1uc+gfx4jHmLm6A/e/P42t33yxQ1WqwrvOokwPXhFFvd1ZTaD4jxIcAKTuSFqHRSBNHHEuKRhTpGmYcq9dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9j5jtszHnH5g;
	Tue, 18 Nov 2025 21:46:33 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id AED4D14033F;
	Tue, 18 Nov 2025 21:47:04 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:04 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 00/19] Support socket access-control
Date: Tue, 18 Nov 2025 21:46:20 +0800
Message-ID: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Hello! This is v4 RFC patch dedicated to socket protocols restriction.

It is based on the landlock's mic-next branch on top of Linux 6.16-rc2
kernel version.

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
corresponds to user space sockets creation. The key in this rule
corresponds to communication protocol signature from socket(2) syscall.

The right to create a socket is checked in the LSM hook which is called
in the __sock_create method. The following user space operations are
subject to this check: socket(2), socketpair(2), io_uring(7).

`LANDLOCK_ACCESS_SOCKET_CREATE` does not restrict socket creation
performed by accept(2), because created socket is used for messaging
between already existing endpoints.

Design discussion
===================
1. Should `SCTP_SOCKOPT_PEELOFF` and socketpair(2) be restricted?

SCTP socket can be connected to a multiple endpoints (one-to-many
relation). Calling setsockopt(2) on such socket with option
`SCTP_SOCKOPT_PEELOFF` detaches one of existing connections to a separate
UDP socket. This detach is currently restrictable.

Same applies for the socketpair(2) syscall. It was noted that denying
usage of socketpair(2) in sandboxed environment may be not meaninful [1].

Currently both operations use general socket interface to create sockets.
Therefore it's not possible to distinguish between socket(2) and those
operations inside security_socket_create LSM hook which is currently
used for protocols restriction. Providing such separation may require
changes in socket layer (eg. in __sock_create) interface which may not be
acceptable.

[1] https://lore.kernel.org/all/ZurZ7nuRRl0Zf2iM@google.com/

Code coverage
=============
Code coverage(gcov) report with the launch of all the landlock selftests:
* security/landlock:
lines......: 94.0% (1200 of 1276 lines)
functions..: 95.0% (134 of 141 functions)

* security/landlock/socket.c:
lines......: 100.0% (56 of 56 lines)
functions..: 100.0% (5 of 5 functions)

Currently landlock-test-tools fails on mini.kernel_socket test due to lack
of SMC protocol support.

General changes v3->v4
======================
* Implementation
  * Adds protocol field to landlock_socket_attr.
  * Adds protocol masks support via wildcards values in
    landlock_socket_attr.
  * Changes LSM hook used from socket_post_create to socket_create.
  * Changes protocol ranges acceptable by socket rules.
  * Adds audit support.
  * Changes ABI version to 8.
* Tests
  * Adds 5 new tests:
    * mini.rule_with_wildcard, protocol_wildcard.access,
      mini.ruleset_with_wildcards_overlap:
      verify rulesets containing rules with wildcard values.
    * tcp_protocol.alias_restriction: verify that Landlock doesn't
      perform protocol mappings.
    * audit.socket_create: tests audit denial logging.
  * Squashes tests corresponding to Landlock rule adding to a single commit.
* Documentation
  * Refactors Documentation/userspace-api/landlock.rst.
* Commits
  * Rebases on mic-next.
  * Refactors commits.

Previous versions
=================
v3: https://lore.kernel.org/all/20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com/
v2: https://lore.kernel.org/all/20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com/
v1: https://lore.kernel.org/all/20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com/

Mikhail Ivanov (19):
  landlock: Support socket access-control
  selftests/landlock: Test creating a ruleset with unknown access
  selftests/landlock: Test adding a socket rule
  selftests/landlock: Testing adding rule with wildcard value
  selftests/landlock: Test acceptable ranges of socket rule key
  landlock: Add hook on socket creation
  selftests/landlock: Test basic socket restriction
  selftests/landlock: Test network stack error code consistency
  selftests/landlock: Test overlapped rulesets with rules of protocol
    ranges
  selftests/landlock: Test that kernel space sockets are not restricted
  selftests/landlock: Test protocol mappings
  selftests/landlock: Test socketpair(2) restriction
  selftests/landlock: Test SCTP peeloff restriction
  selftests/landlock: Test that accept(2) is not restricted
  lsm: Support logging socket common data
  landlock: Log socket creation denials
  selftests/landlock: Test socket creation denial log for audit
  samples/landlock: Support socket protocol restrictions
  landlock: Document socket rule type support

 Documentation/userspace-api/landlock.rst      |   48 +-
 include/linux/lsm_audit.h                     |    8 +
 include/uapi/linux/landlock.h                 |   60 +-
 samples/landlock/sandboxer.c                  |  118 +-
 security/landlock/Makefile                    |    2 +-
 security/landlock/access.h                    |    3 +
 security/landlock/audit.c                     |   12 +
 security/landlock/audit.h                     |    1 +
 security/landlock/limits.h                    |    4 +
 security/landlock/ruleset.c                   |   37 +-
 security/landlock/ruleset.h                   |   46 +-
 security/landlock/setup.c                     |    2 +
 security/landlock/socket.c                    |  198 +++
 security/landlock/socket.h                    |   20 +
 security/landlock/syscalls.c                  |   61 +-
 security/lsm_audit.c                          |    4 +
 tools/testing/selftests/landlock/base_test.c  |    2 +-
 tools/testing/selftests/landlock/common.h     |   14 +
 tools/testing/selftests/landlock/config       |   47 +
 tools/testing/selftests/landlock/net_test.c   |   11 -
 .../selftests/landlock/protocols_define.h     |  169 +++
 .../testing/selftests/landlock/socket_test.c  | 1169 +++++++++++++++++
 22 files changed, 1990 insertions(+), 46 deletions(-)
 create mode 100644 security/landlock/socket.c
 create mode 100644 security/landlock/socket.h
 create mode 100644 tools/testing/selftests/landlock/protocols_define.h
 create mode 100644 tools/testing/selftests/landlock/socket_test.c


base-commit: 6dde339a3df80a57ac3d780d8cfc14d9262e2acd
-- 
2.34.1

