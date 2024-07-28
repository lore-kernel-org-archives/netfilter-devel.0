Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B937C1388;
	Sun, 28 Jul 2024 00:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722126386; cv=none; b=UsGY5Dc8yQGU4j0zqjXWFUV0VoWkBFvGwReo0iUe8oyiDg35fJAC/2xf9SpJ80osy7PYS0yVtUdjcaqUBHWX5dRjlGrULOTK/lSGnfAt4PElaRYhFrki7xUUX5sGbtiNB3djQoUh5B9fvfCcvtZ7xblgARIK6gyMmZL89RZltSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722126386; c=relaxed/simple;
	bh=gyfT3CWwUD9Frt4iGtfnezH1VGZQ1U3LrKCn+H6YLZo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SvlsJHCzsKWXhur1fcqI9t7VWyNaN97LPUnv6+BDo3vnZnNvu3X7fS2wjV7hAKlmGRPjtI0YUOxiqM/Mw+1teXrOjKfaWbfgXyowgUMmh2IYAnr3nPTr2XtyZeWU8MUBxAl8N/Z029MkXnEw0KW3eCKXnsvK4gAUah54L1ZYL2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WWj2t3F34zxVYc;
	Sun, 28 Jul 2024 08:26:14 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 87E8D1800D0;
	Sun, 28 Jul 2024 08:26:21 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 28 Jul 2024 08:26:19 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 5/9] selftests/landlock: Test listen on connected socket
Date: Sun, 28 Jul 2024 08:25:58 +0800
Message-ID: <20240728002602.3198398-6-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
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

Test checks that listen(2) doesn't wrongfully return -EACCES instead
of -EINVAL when trying to listen for an incorrect socket state.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/net_test.c | 65 +++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index b6fe9bde205f..a8385f1373f6 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -1644,6 +1644,71 @@ TEST_F(ipv4_tcp, with_fs)
 	EXPECT_EQ(-EACCES, bind_variant(bind_fd, &self->srv1));
 }
 
+TEST_F(ipv4_tcp, listen_on_connected)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = ACCESS_ALL,
+	};
+	const struct landlock_net_port_attr tcp_not_restricted_p0 = {
+		.allowed_access = ACCESS_ALL,
+		.port = self->srv0.port,
+	};
+	const struct landlock_net_port_attr tcp_denied_listen_p1 = {
+		.allowed_access = ACCESS_ALL & ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
+		.port = self->srv1.port,
+	};
+	int ruleset_fd;
+	int bind_fd, status;
+	pid_t child;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Allows all actions for the first port. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+				       &tcp_not_restricted_p0, 0));
+
+	/* Deny listen for the second port. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+				       &tcp_denied_listen_p1, 0));
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	/* Init listening socket. */
+	bind_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, bind_fd);
+	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
+	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		int connect_fd;
+
+		/* Closes listening socket for the child. */
+		EXPECT_EQ(0, close(bind_fd));
+
+		connect_fd = socket_variant(&self->srv1);
+		ASSERT_LE(0, connect_fd);
+		EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
+
+		/* Tries to listen on connected socket. */
+		EXPECT_EQ(-EINVAL, listen_variant(connect_fd, backlog));
+
+		EXPECT_EQ(0, close(connect_fd));
+		_exit(_metadata->exit_code);
+		return;
+	}
+
+	EXPECT_EQ(child, waitpid(child, &status, 0));
+	EXPECT_EQ(1, WIFEXITED(status));
+	EXPECT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	EXPECT_EQ(0, close(bind_fd));
+}
+
 FIXTURE(port_specific)
 {
 	struct service_fixture srv0;
-- 
2.34.1

