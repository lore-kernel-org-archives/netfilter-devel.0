Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03341A35;
	Sun, 28 Jul 2024 00:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722126383; cv=none; b=NwTV1bNbZq0xnprlVzWoV4WkF6/cwKYt/eOENKpgZFrewbw5YE+1cH5KOcn7ZlrKD9eEI5vtw6JPapYzv5E6ecKpdhYFT0gI7pJ6f2u4dBKrHbZ03wrnpGVFu+icL8KgjrDvIN0hbetrRYcrdkiBDvYtuXDOWSKndARGAFMkZvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722126383; c=relaxed/simple;
	bh=ro4bdkgBTJxXixVQhErz0ISyv4OySIyBHEcBU6aJXSE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A+n3lbeLsrBWbEK31SsV17UptHPRlTSzC4fnuK1ZMJjuAf149JKAo+TaySLyLdhIhEhQ1g6zQS/PmpWYo7BeaiIO+eqGrV4d8jirHnQULzxSJhcRwiG8LP4kc5tILMlDmJ/OAGG+oM5QqZjeqp+LpOehyqIHQdhuZsIY9YZMu8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WWj2j6DvNz1L9BQ;
	Sun, 28 Jul 2024 08:26:05 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id A80131800D0;
	Sun, 28 Jul 2024 08:26:12 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 28 Jul 2024 08:26:11 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 0/9] Support TCP listen access-control
Date: Sun, 28 Jul 2024 08:25:53 +0800
Message-ID: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
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

Hello! This is v1 RFC patch dedicated to restriction of listening sockets.

It is based on the landlock's mic-next branch on top of v6.10 kernel
version.

Description
===========
LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
ports to forbid a malicious sandboxed process to impersonate a legitimate
server process. However, bind(2) might be used by (TCP) clients to set the
source port to a (legitimate) value. Controlling the ports that can be
used for listening would allow (TCP) clients to explicitly bind to ports
that are forbidden for listening.

Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
access right that restricts listening on undesired ports with listen(2).

It's worth noticing that this access right doesn't affect changing 
backlog value using listen(2) on already listening socket. For this case
test ipv4_tcp.double_listen is provided.

Closes: https://github.com/landlock-lsm/linux/issues/15

Code coverage
=============
Code coverage(gcov) report with the launch of all the landlock selftests:
* security/landlock:
lines......: 93.4% (759 of 813 lines)
functions..: 95.3% (101 of 106 functions)

* security/landlock/net.c:
lines......: 100% (77 of 77 lines)
functions..: 100% (9 of 9 functions)

Mikhail Ivanov (9):
  landlock: Refactor current_check_access_socket() access right check
  landlock: Support TCP listen access-control
  selftests/landlock: Support LANDLOCK_ACCESS_NET_LISTEN_TCP
  selftests/landlock: Test listening restriction
  selftests/landlock: Test listen on connected socket
  selftests/landlock: Test listening without explicit bind restriction
  selftests/landlock: Test listen on ULP socket without clone method
  selftests/landlock: Test changing socket backlog with listen(2)
  samples/landlock: Support LANDLOCK_ACCESS_NET_LISTEN

 include/uapi/linux/landlock.h                |  23 +-
 samples/landlock/sandboxer.c                 |  31 +-
 security/landlock/limits.h                   |   2 +-
 security/landlock/net.c                      | 131 +++++-
 security/landlock/syscalls.c                 |   2 +-
 tools/testing/selftests/landlock/base_test.c |   2 +-
 tools/testing/selftests/landlock/config      |   1 +
 tools/testing/selftests/landlock/net_test.c  | 448 +++++++++++++++----
 8 files changed, 519 insertions(+), 121 deletions(-)

-- 
2.34.1

