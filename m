Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A97635;
	Wed,  4 Sep 2024 10:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446945; cv=none; b=sbgbBSabf9f1tGQLrk042VYFaEzgAotRebQ+84CAk/pxRGPws3fN++DoJCR9W8AnIMjjpI5JoKrl4atoxrBW/45dSa7bs1u/LsefSwHebKsliCRtRnqJs3NOcqOhMerydap8wL+vR7QQEpNrMjqYqef//USY9+o4ZgLP+eoaC3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446945; c=relaxed/simple;
	bh=T6GtqoJzV0efJ7P94ycJVbkR65k3kEAMIOFHO2iTWrU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iRRuDA06DKjKoF5ZqsT7AEgHkGBGHM4Lx3Im5DDi2XYIwjHSfEcAjq6wpjMwLwpw2SKhhVOhTO6ARNdmpwXbvUyAvt0kwm+psrOKRGiPYTM6Rm4nnUfdh0w25BAUxsQCfX/7ZZq4kO4eRADzykvDqfvITRdIh+8nA9YKbRnJ/Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzK3X6mzZz1j849;
	Wed,  4 Sep 2024 18:48:40 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 1BB541A016C;
	Wed,  4 Sep 2024 18:49:01 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:59 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 16/19] selftests/landlock: Test that accept(2) is not restricted
Date: Wed, 4 Sep 2024 18:48:21 +0800
Message-ID: <20240904104824.1844082-17-ivanov.mikhail1@huawei-partners.com>
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

Add test validating that socket creation with accept(2) is not restricted
by Landlock.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 .../testing/selftests/landlock/socket_test.c  | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 2ab27196fa3d..052dbe0d1227 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -939,4 +939,75 @@ TEST_F(socket_creation, sctp_peeloff)
 	ASSERT_EQ(0, close(server_fd));
 }
 
+TEST_F(socket_creation, accept)
+{
+	int status;
+	pid_t child;
+	struct sockaddr_in addr;
+	int server_fd, client_fd;
+	char buf;
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	struct landlock_socket_attr tcp_socket_create = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_INET,
+		.type = SOCK_STREAM,
+	};
+
+	server_fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
+	ASSERT_LE(0, server_fd);
+
+	addr.sin_family = AF_INET;
+	addr.sin_port = htons(loopback_port);
+	addr.sin_addr.s_addr = inet_addr(loopback_ipv4);
+
+	ASSERT_EQ(0, bind(server_fd, &addr, sizeof(addr)));
+	ASSERT_EQ(0, listen(server_fd, backlog));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		/* Closes listening socket for the child. */
+		ASSERT_EQ(0, close(server_fd));
+
+		client_fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
+		ASSERT_LE(0, client_fd);
+
+		ASSERT_EQ(0, connect(client_fd, &addr, sizeof(addr)));
+		EXPECT_EQ(1, write(client_fd, ".", 1));
+
+		ASSERT_EQ(0, close(client_fd));
+		_exit(_metadata->exit_code);
+		return;
+	}
+
+	if (self->sandboxed) {
+		int ruleset_fd = landlock_create_ruleset(
+			&ruleset_attr, sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+		if (self->allowed) {
+			ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
+						       LANDLOCK_RULE_SOCKET,
+						       &tcp_socket_create, 0));
+		}
+		enforce_ruleset(_metadata, ruleset_fd);
+		ASSERT_EQ(0, close(ruleset_fd));
+	}
+
+	client_fd = accept(server_fd, NULL, 0);
+
+	/* accept(2) should not be restricted by Landlock. */
+	EXPECT_LE(0, client_fd);
+
+	EXPECT_EQ(1, read(client_fd, &buf, 1));
+	EXPECT_EQ('.', buf);
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	ASSERT_EQ(0, close(server_fd));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

