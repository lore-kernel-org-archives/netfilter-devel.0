Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B62E5026E;
	Mon,  8 Apr 2024 09:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569227; cv=none; b=U2odmeXtLy5xMEkUs9fNBdigX20tlzip+SDKWZd/hCl9DQ+MCXlmSnN0Nav/e8bCFUEpwwivWqbQySwUOO3DLwQEtW8UJd+eo2TTqCNXlmSp7nTo9q28ZUZLdf8gUHgh6U4NaYZRnkf15M4C8bwLI4Y8aIRSk/6+5vyACi2x0Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569227; c=relaxed/simple;
	bh=mKZkpuliNtqp3tlVBfZvyfHJ/YMtjtq+d2jWOezvQBQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSWQpiycgvnvIaIecn6YK8yN7V1jPUn4eOIqh5j4sHLSH06y4xSnbEqXmOHm9i7HbaPbEoc8DmUSbB+Ba2F49yhCXR8zSMy0F0NJNIVFzilsYRGw7+5YP9r/8ERx1GdGZBhc3Lt+ALhKZWGUvuawNJJPQ8llH4l/2EzVbj4i3b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VCkX83KxRz1h64b;
	Mon,  8 Apr 2024 17:37:28 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 6168D1A0172;
	Mon,  8 Apr 2024 17:40:18 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:40:16 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 07/10] selftests/landlock: Create 'inval' test
Date: Mon, 8 Apr 2024 17:39:24 +0800
Message-ID: <20240408093927.1759381-8-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
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

Add test that validates behavior of landlock with fully
access restriction.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 .../testing/selftests/landlock/socket_test.c  | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index c1c2b5d30..dd105489d 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -282,4 +282,38 @@ TEST_F(protocol, rule_with_unhandled_access)
 	EXPECT_EQ(0, close(ruleset_fd));
 }
 
+TEST_F(protocol, inval)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE
+	};
+
+	struct landlock_socket_attr protocol = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.domain = self->srv0.protocol.domain,
+		.type = self->srv0.protocol.type,
+	};
+
+	struct landlock_socket_attr protocol_denied = {
+		.allowed_access = 0,
+		.domain = self->srv0.protocol.domain,
+		.type = self->srv0.protocol.type,
+	};
+
+	int ruleset_fd;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Checks zero access value. */
+	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					&protocol_denied, 0));
+	EXPECT_EQ(ENOMSG, errno);
+
+	/* Adds with legitimate values. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &protocol, 0));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

