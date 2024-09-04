Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B1B1CF7CD;
	Wed,  4 Sep 2024 10:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446941; cv=none; b=X7THqabYGEfvJrLB1fumOmVSvyJVS8Do4d9hV3vuuUl6LHywNls7xUJa0HmGW+sd3cAbGGHO+M6jXOF0w4ug5be7g6r3VNwCLVyn2n5efYaYHML2O8R4nuXLNEEA3QEflaqMJ5plxLf/q0xJ+BEOrCgXwVbHDwBR/LnBmfpHy68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446941; c=relaxed/simple;
	bh=we4WZUGk5ZmrA1eAHN+Z5KDLZe5xE3AfMYBOX+apLjU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pfMqpgB3q32r7rgWOIxH6+Qc+BfMGHAMPz0WDZoVtqDW45foSp7CodYv7uIBFOvIUgoQcJYUaAHiKscuD1MQQUFlSfa6RzooikOeDk6p7gQPNcbBjtV0JY5cq9UXBI6RCEAcQMfLKHNOaaPtyR1VxjwiaPoaZLsvqCCY8Rfpx8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WzK1h6SvWzpTwX;
	Wed,  4 Sep 2024 18:47:04 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A6CD140137;
	Wed,  4 Sep 2024 18:48:57 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:55 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 14/19] selftests/landlock: Test socketpair(2) restriction
Date: Wed, 4 Sep 2024 18:48:19 +0800
Message-ID: <20240904104824.1844082-15-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
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

Add test that checks the restriction on socket creation using
socketpair(2).

Add `socket_creation` fixture to configure sandboxing in tests in
which different socket creation actions are tested.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 .../testing/selftests/landlock/socket_test.c  | 101 ++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 8fc507bf902a..67db0e1c1121 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -738,4 +738,105 @@ TEST_F(packet_protocol, alias_restriction)
 	EXPECT_EQ(0, test_socket_variant(&self->prot_tested));
 }
 
+static int test_socketpair(int family, int type, int protocol)
+{
+	int fds[2];
+	int err;
+
+	err = socketpair(family, type | SOCK_CLOEXEC, protocol, fds);
+	if (err)
+		return errno;
+	/*
+	 * Mixing error codes from close(2) and socketpair(2) should not lead to
+	 * any (access type) confusion for this test.
+	 */
+	if (close(fds[0]) != 0)
+		return errno;
+	if (close(fds[1]) != 0)
+		return errno;
+	return 0;
+}
+
+FIXTURE(socket_creation)
+{
+	bool sandboxed;
+	bool allowed;
+};
+
+FIXTURE_VARIANT(socket_creation)
+{
+	bool sandboxed;
+	bool allowed;
+};
+
+FIXTURE_SETUP(socket_creation)
+{
+	self->sandboxed = variant->sandboxed;
+	self->allowed = variant->allowed;
+
+	setup_loopback(_metadata);
+};
+
+FIXTURE_TEARDOWN(socket_creation)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(socket_creation, no_sandbox) {
+	/* clang-format on */
+	.sandboxed = false,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(socket_creation, sandbox_allow) {
+	/* clang-format on */
+	.sandboxed = true,
+	.allowed = true,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(socket_creation, sandbox_deny) {
+	/* clang-format on */
+	.sandboxed = true,
+	.allowed = false,
+};
+
+TEST_F(socket_creation, socketpair)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	struct landlock_socket_attr unix_socket_create = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_UNIX,
+		.type = SOCK_STREAM,
+	};
+	int ruleset_fd;
+
+	if (self->sandboxed) {
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		if (self->allowed) {
+			ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
+						       LANDLOCK_RULE_SOCKET,
+						       &unix_socket_create, 0));
+		}
+		enforce_ruleset(_metadata, ruleset_fd);
+		ASSERT_EQ(0, close(ruleset_fd));
+	}
+
+	if (!self->sandboxed || self->allowed) {
+		/*
+		 * Tries to create sockets when ruleset is not established
+		 * or protocol is allowed.
+		 */
+		EXPECT_EQ(0, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
+	} else {
+		/* Tries to create sockets when protocol is restricted. */
+		EXPECT_EQ(EACCES, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

