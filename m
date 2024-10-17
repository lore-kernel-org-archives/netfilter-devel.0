Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136AB1D3566;
	Thu, 17 Oct 2024 11:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729163163; cv=none; b=c2Atdkv9HWZ+URmwPQaoTaKBU+hiRLu1UsvEAOwxTlagihbQTEVrLb00sA9u0INp9AxTGSqgoIWXvfZ/zqi32HE3kwEQwKkjN5RcePRpsooknxYy8oTcYc971o0QGVlZOStucG+9Rm4ep/SxdWOg92+xWok6PhXcSIrDs7o9sy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729163163; c=relaxed/simple;
	bh=Y26YuhEeOV5g2D/6jd/R/t6rMuzkgD6XOXI9VxnJb7s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sxX97Oo8W7PwaaXoWciG/pqyxAX7XVjzmB0M2iCAXboDlwgn/IG0lRazGtlzEp+D9WbPY2F14BchYzB/pjkncL1SqGXnbfKqK+Amm1jinmfRpc/5pJBAUOSnq2wODjTuBXQzhQ3/SGJmN8rQG7IjBltMxRR+tUrCRO9WJ4ScpGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XTlMQ6WL9z2DdSM;
	Thu, 17 Oct 2024 19:04:02 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 698F61A0188;
	Thu, 17 Oct 2024 19:05:18 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 17 Oct 2024 19:05:16 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 0/8] Fix non-TCP restriction and inconsistency of TCP errors
Date: Thu, 17 Oct 2024 19:04:46 +0800
Message-ID: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Hello!
This patchset provides two general fixes for TCP Landlock hooks:

First one fixes incorrect restriction of non-TCP bind/connect actions.
There is two commits related to testing MPTCP and SCTP protocols which were
incorrectly restricted. SCTP implementation has invalid check for minimal
address length in bind(2) call [1], therefore commit with SCTP testing can be
applied later after necessary SCTP fixes.

[1] https://lore.kernel.org/all/20241004.Hohpheipieh2@digikod.net/
Closes: https://github.com/landlock-lsm/linux/issues/40

Second one fixes inconsistency of errors in bind and connect hooks for
TCP sockets. It provides per-operation helpers, which consist of a set
of checks from the TCP network stack. Due to TCP connect(2) implementation
it's not possible to obtain full consistency, but the unhandled cases are
rather special scenarios that should almost should not normally appear.
Two new tests were implemented to validate errors consistency.

Diffs of second and third commits were unreadable, so I've decided to
rewrite net.c file to simplify reviewing process.

Code coverage
=============
Code coverage(gcov) report with the launch of net_test selftest:
 * security/landlock/net.c:
lines......: 98.8% (79 of 80 lines)
functions..: 100% (8 of 8 functions)

One uncovered line is documented in check_tcp_connect_consistency_and_get_port().

General changes
===============
 * Rebases on current linux-mic/next (based on Linux v6.12-rc3)
 * Fixes inconsistency of TCP actions errors and implements two related
   tests.
 * Removes SMC test suits.
 * Adds separate commit for SCTP test suits.
 * Adds test suits of protocol fixture for sockets created with
   protocol=IPPROTO_TCP (C.f. socket(2)).

Previous versions
=================
v1: https://lore.kernel.org/all/20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com/

Mikhail Ivanov (8):
  landlock: Fix non-TCP sockets restriction
  landlock: Make network stack layer checks explicit for each TCP action
  landlock: Fix inconsistency of errors for TCP actions
  selftests/landlock: Test TCP accesses with protocol=IPPROTO_TCP
  selftests/landlock: Test that MPTCP actions are not restricted
  selftests/landlock: Test consistency of errors for TCP actions
  landlock: Add note about errors consistency in documentation
  selftests/landlock: Test that SCTP actions are not restricted

 Documentation/userspace-api/landlock.rst    |   3 +-
 security/landlock/net.c                     | 501 +++++++++++-------
 tools/testing/selftests/landlock/common.h   |   1 +
 tools/testing/selftests/landlock/config     |   4 +
 tools/testing/selftests/landlock/net_test.c | 532 ++++++++++++++++++--
 5 files changed, 825 insertions(+), 216 deletions(-)
 rewrite security/landlock/net.c (36%)


base-commit: fe76bd133024aaef12d12a7d58fa3e8d138d3bf3
-- 
2.34.1

