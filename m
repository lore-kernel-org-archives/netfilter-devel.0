Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA10282E2;
	Fri, 24 May 2024 09:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543062; cv=none; b=nD5Z8pyPo653g726o5K8E2rJYHmZBfbirgy9TPa5NgsJkHo0ICgL4RRLObfON8zyBYTuV6X7SOsS1/saKEAN1ex0A1pA5ez2pOhLu/ptPoPhW3JWl9nKpiN+f+6tJNH/6MzRlpAr6kPX2CARmtqWYXnJjLMtolUyBZmt2RCvhGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543062; c=relaxed/simple;
	bh=iSUGjStUDnULq441NmNtrtnQRwQJUew+PKFp4V5Spyk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JYqvT3ILmKtDqBIO9wDXsp7hNDhT0pVie0LHgIaYufYqExLMjexiuvf2hkIzvT5PUOj9NHkaM3rIdurNFUThp0LD+jKRWLD8+xfujd1kgBAXPetmoy8YJyZ+X3Yzlg8vVjZjrVGV62QGnfycXVT1DjOgjodqZfpNAsXiqOsRJRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Vm09Y5DDmz1HCVN;
	Fri, 24 May 2024 17:29:21 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id DF78F14037C;
	Fri, 24 May 2024 17:30:55 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 24 May 2024 17:30:54 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 00/12] Socket type control for Landlock
Date: Fri, 24 May 2024 17:30:03 +0800
Message-ID: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml100004.china.huawei.com (7.188.51.133) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Hello! This is v2 RFC patch dedicated to socket protocols restriction.

It is based on the landlock's mic-next branch on top of v6.9 kernel
version.

Description
===========
Patchset implements new type of Landlock rule, that restricts socket
protocols used in the sandboxed process. This restriction does not affect
socket actions such as bind(2) or send(2), only those actions that result
in a socket with unwanted protocol (e.g. creating socket with socket(2)).

Such restriction would be useful to ensure that a sandboxed process uses
only necessary protocols. For example sandboxed TCP server may want to
permit only TCP sockets and deny any others. See [1] for more cases.

The rules store information about the socket family and type. Thus, any
protocol that can be defined by a family-type pair can be restricted by
Landlock.

struct landlock_socket_attr {
	__u64 allowed_access;
	int family; // same as domain in socket(2)
	int type; // see socket(2)
}

Patchset currently implements rule only for socket creation, but
other necessary rules will also be impemented. [2]

[1] https://lore.kernel.org/all/ZJvy2SViorgc+cZI@google.com/
[2] https://lore.kernel.org/all/b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net/

Code coverage
=============
Code coverage(gcov) report with the launch of all the landlock selftests:
* security/landlock:
lines......: 93.3% (795 of 852 lines)
functions..: 95.5% (106 of 111 functions)

* security/landlock/socket.c:
lines......: 100.0% (33 of 33 lines)
functions..: 100.0% (5 of 5 functions)

General changes
===============
 * Rebases on mic-next (landlock-6.10-rc1).
 * Refactors code and commits.
 * Renames `family` into `domain` in landlock_socket_attr.
 * Changes ABI version from 5 to 6.
 * Reverts landlock_key.data type from u64 to uinptr_t.
 * Adds mini.socket_overflow, mini.socket_invalid_type tests.

Previous versions
=================
v1: https://lore.kernel.org/all/20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com/

Mikhail Ivanov (12):
  landlock: Support socket access-control
  landlock: Add hook on socket creation
  selftests/landlock: Add protocol.create to socket tests
  selftests/landlock: Add protocol.socket_access_rights to socket tests
  selftests/landlock: Add protocol.rule_with_unknown_access to socket
    tests
  selftests/landlock: Add protocol.rule_with_unhandled_access to socket
    tests
  selftests/landlock: Add protocol.inval to socket tests
  selftests/landlock: Add tcp_layers.ruleset_overlap to socket tests
  selftests/landlock: Add mini.ruleset_with_unknown_access to socket
    tests
  selftests/landlock: Add mini.socket_overflow to socket tests
  selftests/landlock: Add mini.socket_invalid_type to socket tests
  samples/landlock: Support socket protocol restrictions

 include/uapi/linux/landlock.h                 |  53 +-
 samples/landlock/sandboxer.c                  | 141 ++++-
 security/landlock/Makefile                    |   2 +-
 security/landlock/limits.h                    |   5 +
 security/landlock/ruleset.c                   |  37 +-
 security/landlock/ruleset.h                   |  41 +-
 security/landlock/setup.c                     |   2 +
 security/landlock/socket.c                    | 130 ++++
 security/landlock/socket.h                    |  19 +
 security/landlock/syscalls.c                  |  66 +-
 tools/testing/selftests/landlock/base_test.c  |   2 +-
 tools/testing/selftests/landlock/common.h     |   1 +
 tools/testing/selftests/landlock/config       |   1 +
 .../testing/selftests/landlock/socket_test.c  | 581 ++++++++++++++++++
 14 files changed, 1056 insertions(+), 25 deletions(-)
 create mode 100644 security/landlock/socket.c
 create mode 100644 security/landlock/socket.h
 create mode 100644 tools/testing/selftests/landlock/socket_test.c

-- 
2.34.1

