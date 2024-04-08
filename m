Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7347739FDD;
	Mon,  8 Apr 2024 09:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569728; cv=none; b=IXnPPq7zPIIZAdMLwFW9BPcf6XqlwIODtWrmx7A0Xa4Otkaau5ahN3CCdWPGhosnlmIKgCzrn9LhPZ/BLnRs9dv2SNNPhT3ZxxnRBGyOVC0oNmj+BF4j/Tzrh1XMe8jHVBrpXc7O0Gm+K8QFk6AEzk2fkhQufSnCDBuf7IcjlN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569728; c=relaxed/simple;
	bh=kX09jP7Qd17zNz9DPXQK9L+bUAc//Zw+me8sdEYNyMw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UF/JC0sFyGkykWaQz4eMoHzJaNsZ4ztAPduc2nMgfTec/ejM1WR0lIgl2ajQcK4q7fC8N0xMNX6vBJ7tPoZHm0oIfqSk5dMnoIWiRltoLJHn/NeElxm66ixtq0mrVqQuRhTqL8mdwOUoNv4+QyZnfI4e6wL211dJa/2UoufLNDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VCkjZ6ZHbzXjB3;
	Mon,  8 Apr 2024 17:45:38 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 18DF818007B;
	Mon,  8 Apr 2024 17:48:44 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:48:42 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [PATCH 0/2] Forbid illegitimate binding via listen(2)
Date: Mon, 8 Apr 2024 17:47:45 +0800
Message-ID: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
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

listen(2) can be called without explicit bind(2) call. For a TCP socket
it would result in assigning random port(in some range) to this socket
by the kernel. If Landlock sandbox supports LANDLOCK_ACCESS_NET_BIND_TCP,
this may lead to implicit access to a prohibited (by Landlock sandbox)
port. Malicious sandboxed process can accidentally impersonate a
legitimate server process (if listen(2) assigns it a server port number).

Patch adds hook on socket_listen() that prevents such scenario by checking
LANDLOCK_ACCESS_NET_BIND_TCP access for port 0.

Few tests were added to cover this case.

Code coverage(gcov):
* security/landlock:
lines......: 94.5% (745 of 788 lines)
functions..: 97.1% (100 of 103 functions)

Ivanov Mikhail (2):
  landlock: Add hook on socket_listen()
  selftests/landlock: Create 'listen_zero', 'deny_listen_zero' tests

 security/landlock/net.c                     | 104 +++++++++++++++++---
 tools/testing/selftests/landlock/net_test.c |  89 +++++++++++++++++
 2 files changed, 177 insertions(+), 16 deletions(-)

-- 
2.34.1

