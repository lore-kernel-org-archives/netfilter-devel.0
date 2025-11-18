Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF41D301499;
	Tue, 18 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473633; cv=none; b=UDf+XYelmSO9hCA6FZzzTrW0agRCiO8XWvUl2WiAyb9SkcBXFc3qNbX0aEORy1JsJYjdkq9x4giwy3IyBNiGExCJYn/ULa8URuRITL7DA0B43WQntDY6bVevWQILSz+lUNCOjlwuQIzxw6Dwuzmj/ivYesuvcJJobqhJ8zCeSgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473633; c=relaxed/simple;
	bh=zwhSh3+/Y8p5EETp+zap2zVf7uU1n5BjR23kvgF9SP8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UU4PahIv0Ke3oxIZNoA9n6KhwgHTnWZ94uO/b7wmyFUwZr6YSXdMIo2OhFdDWL420ymGFRptAejbG4rXs7GOyEu1J6Q++Mbwwu+R3v3iibzEyL8zKDpH7pasaRyqZz8HXNUV65kyXDhRJBvMMx4Gi63l7yYaVCIe6JF+KuehHm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9W6bLZzJ46d5;
	Tue, 18 Nov 2025 21:46:23 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 3C1FA140277;
	Tue, 18 Nov 2025 21:47:06 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:05 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 12/19] selftests/landlock: Test socketpair(2) restriction
Date: Tue, 18 Nov 2025 21:46:32 +0800
Message-ID: <20251118134639.3314803-13-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Add test that checks the restriction on socket creation using
socketpair(2).

Add `socket_creation` fixture to configure sandboxing in tests in
which different socket creation actions are tested.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Removes socket_creation fixture.
---
 .../testing/selftests/landlock/socket_test.c  | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index e22e10edb103..d1a004c2e0f5 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -866,4 +866,59 @@ TEST_F(tcp_protocol, alias_restriction)
 	}
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
+TEST_F(mini, socketpair)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_socket_attr unix_socket_create = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_UNIX,
+		.type = SOCK_STREAM,
+		.protocol = 0,
+	};
+	int ruleset_fd;
+
+	/* Tries to create socket when ruleset is not established. */
+	ASSERT_EQ(0, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &unix_socket_create, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tries to create socket when protocol is allowed */
+	EXPECT_EQ(0, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tries to create socket when protocol is restricted. */
+	EXPECT_EQ(EACCES, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

