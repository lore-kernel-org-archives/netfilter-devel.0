Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6068639FDD;
	Mon,  8 Apr 2024 09:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569732; cv=none; b=mc658PcC/6cInkb4LG3XWRy+I0uj+WR6de11D/7XaUYL8b9oTjjR6dg563tEP2GMzxbQZABpHEiwZl8lVqq+O5hnowcefG6omJueRj6piJZIF+M69LsRqhaNfCJTr1WZgHGRgo10lBuyA9qpbirkjy+GBUm24KU9GtLFMDLa+Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569732; c=relaxed/simple;
	bh=QASNcFLq4kfgEx+JMHc/eYSmFPFGV7YTjoey+j/hzVQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ONoScqQwsXHplstiVJoVZb7Gz4i/QZLfUd5Y6py9amQsIVpeLhPySRmiv5y7J0Ht8dhzfTHgqP+jRDaSt9DZMfjvae0iybbOftPDwep6qhYAJM9doEI9c7ecE0u9BFkeJsj07ydkksvVBvqRr++GYtE2QJartTi0fUCx764Q0Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VCkjx6v8Gz1h64s;
	Mon,  8 Apr 2024 17:45:57 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id DC05018005F;
	Mon,  8 Apr 2024 17:48:47 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:48:45 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [PATCH 2/2] selftests/landlock: Create 'listen_zero', 'deny_listen_zero' tests
Date: Mon, 8 Apr 2024 17:47:47 +0800
Message-ID: <20240408094747.1761850-3-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
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

Suggested code test scenarios where listen(2) call without explicit
bind(2) is allowed and forbidden.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 tools/testing/selftests/landlock/net_test.c | 89 +++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 936cfc879f1d..6d6b5aef387f 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -1714,6 +1714,95 @@ TEST_F(port_specific, bind_connect_zero)
 	EXPECT_EQ(0, close(bind_fd));
 }
 
+TEST_F(port_specific, listen_zero)
+{
+	int listen_fd, connect_fd;
+	uint16_t port;
+
+	/* Adds a rule layer with bind actions. */
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
+		};
+		const struct landlock_net_port_attr tcp_bind_zero = {
+			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+			.port = 0,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Checks zero port value on bind action. */
+		EXPECT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_bind_zero, 0));
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	listen_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, listen_fd);
+
+	connect_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, listen_fd);
+	/*
+	 * Allow listen(2) to select a random port for the socket,
+	 * since bind(2) wasn't called.
+	 */
+	EXPECT_EQ(0, listen(listen_fd, backlog));
+
+	/* Sets binded (by listen(2)) port for both protocol families. */
+	port = get_binded_port(listen_fd, &variant->prot);
+	EXPECT_NE(0, port);
+	set_port(&self->srv0, port);
+
+	/* Connects on the binded port. */
+	EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
+
+	EXPECT_EQ(0, close(listen_fd));
+	EXPECT_EQ(0, close(connect_fd));
+}
+
+TEST_F(port_specific, deny_listen_zero)
+{
+	int listen_fd, ret;
+
+	/* Adds a rule layer with bind actions. */
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Forbid binding to any port. */
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	listen_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, listen_fd);
+	/* 
+	 * Check that listen(2) call is prohibited without first calling bind(2).
+	 */
+	ret = listen(listen_fd, backlog);
+	if (is_restricted(&variant->prot, variant->sandbox)) {
+		/* Denied by Landlock. */
+		EXPECT_NE(0, ret);
+		EXPECT_EQ(EACCES, errno);
+	} else {
+		EXPECT_EQ(0, ret);
+	}
+
+	EXPECT_EQ(0, close(listen_fd));
+}
+
 TEST_F(port_specific, bind_connect_1023)
 {
 	int bind_fd, connect_fd, ret;
-- 
2.34.1

