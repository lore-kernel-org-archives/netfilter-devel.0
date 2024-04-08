Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979ED481A6;
	Mon,  8 Apr 2024 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569209; cv=none; b=MBq6ceC+ebFhpMMDkRs+VAV1t1Q6KJftgN9+numQe9a253D1DqvjxY4Z+c8nxEyPRcEInPIa8E6nWc+8Kl8eWFU/H4499bX7EELwnpC3wyuWRvNj/90l5gfosuyOg3VKxMpjL26LbuU25AwZ4v93xx80CocbqOv/31gOogZeuus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569209; c=relaxed/simple;
	bh=YBUbh6HtUyMMTAq9uOto0mpD3Zh0eaTzvy58NwTSo6c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aiV/DWQ8XIiXjq13qF/Fz8OVo19PWzyHrSXNFMgikipuchNMitAz1NOv1yLkpR4X/Yqb5Y5cnXegJ0wbq8CHqmStA3IclVQ8C4tVT7RIpM617/s7G3xmGkiXBTHWqb3YGZzQgNCs+547H/VbVbzj0E/eas79JKz9eS/1LBEla44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VCkWs5l4Pz29lMy;
	Mon,  8 Apr 2024 17:37:13 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id E0AD718005F;
	Mon,  8 Apr 2024 17:40:03 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:40:01 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 00/10] Socket type control for Landlock
Date: Mon, 8 Apr 2024 17:39:17 +0800
Message-ID: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Patchset implements new type of Landlock rule, that restricts actions for
sockets of any protocol. Such restriction would be useful to ensure
that a sandboxed process uses only necessary protocols.
See [2] for more cases.

The rules store information about the socket family(aka domain) and type.

struct landlock_socket_attr {
	__u64 allowed_access;
	int domain; // see socket(2)
	int type; // see socket(2)
}

Patchset currently implements rule only for socket_create() method, but
other necessary rules will also be impemented. [1]

Code coverage(gcov) report with the launch of all the landlock selftests:
* security/landlock:
lines......: 94.7% (784 of 828 lines)
functions..: 97.2% (105 of 108 functions)

* security/landlock/socket.c:
lines......: 100.0% (33 of 33 lines)
functions..: 100.0% (5 of 5 functions)

[1] https://lore.kernel.org/all/b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net/
[2] https://lore.kernel.org/all/ZJvy2SViorgc+cZI@google.com/

Ivanov Mikhail (10):
  landlock: Support socket access-control
  landlock: Add hook on socket_create()
  selftests/landlock: Create 'create' test
  selftests/landlock: Create 'socket_access_rights' test
  selftests/landlock: Create 'rule_with_unknown_access' test
  selftests/landlock: Create 'rule_with_unhandled_access' test
  selftests/landlock: Create 'inval' test
  selftests/landlock: Create 'ruleset_overlap' test
  selftests/landlock: Create 'ruleset_with_unknown_access' test
  samples/landlock: Support socket protocol restrictions

 include/uapi/linux/landlock.h                 |  49 ++
 samples/landlock/sandboxer.c                  | 149 +++++-
 security/landlock/Makefile                    |   2 +-
 security/landlock/limits.h                    |   5 +
 security/landlock/net.c                       |   2 +-
 security/landlock/ruleset.c                   |  35 +-
 security/landlock/ruleset.h                   |  44 +-
 security/landlock/setup.c                     |   2 +
 security/landlock/socket.c                    | 115 +++++
 security/landlock/socket.h                    |  19 +
 security/landlock/syscalls.c                  |  55 ++-
 tools/testing/selftests/landlock/base_test.c  |   2 +-
 .../testing/selftests/landlock/socket_test.c  | 457 ++++++++++++++++++
 13 files changed, 910 insertions(+), 26 deletions(-)
 create mode 100644 security/landlock/socket.c
 create mode 100644 security/landlock/socket.h
 create mode 100644 tools/testing/selftests/landlock/socket_test.c

-- 
2.34.1

