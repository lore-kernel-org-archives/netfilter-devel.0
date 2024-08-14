Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECD61CAA2;
	Wed, 14 Aug 2024 03:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723604533; cv=none; b=Qqdpf+dKClUqToE1DVWuFVNovmbRypk2/rZtJPVOjecDHREUZGD9Hvs0uVf80dfJT5BaemnhaiF0z/3W1u1UazCzuGBaFpE3k6MAw/wLsrD6pyA8W2HWFEFjfh3ttfnAciRAU2lMyVJMSd1L3rim0QHp1Puyp23sFufHO+Rj7Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723604533; c=relaxed/simple;
	bh=wtB0l5FobLp8sTKRHYLuJrJAFDakL8hq6JSqlFDJAMo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5QhUIxmfAY+ngWSlM+pGs2h85kPfrg+mGOsFliuT6ZE0iHDVl9ZT60YAPiKPnnIRTHQuevWeGpyt9a9zmEwQ/t155EzOKA/7dpKX3Mr9hpsdkHqGRbTO8x92QW4hAFL8wPia/lHxp29VXh5r237fSkiyYwVGqC8N880lPqxx74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4WkCfp3tVZz1xtxV;
	Wed, 14 Aug 2024 11:00:18 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id CB5C21A016C;
	Wed, 14 Aug 2024 11:02:09 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 11:02:08 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 5/9] selftests/landlock: Test listen on connected socket
Date: Wed, 14 Aug 2024 11:01:47 +0800
Message-ID: <20240814030151.2380280-6-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Test checks that listen(2) doesn't wrongfully return -EACCES instead
of -EINVAL when trying to listen for an incorrect socket state.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Uses 'protocol' fixture instead of 'ipv4_tcp'.
* Minor fixes.
---
 tools/testing/selftests/landlock/net_test.c | 74 +++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index b6fe9bde205f..551891b18b7a 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -926,6 +926,80 @@ TEST_F(protocol, connect_unspec)
 	EXPECT_EQ(0, close(bind_fd));
 }
 
+TEST_F(protocol, listen_on_connected)
+{
+	int bind_fd, status;
+	pid_t child;
+
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = ACCESS_ALL,
+		};
+		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
+			.allowed_access = ACCESS_ALL,
+			.port = self->srv0.port,
+		};
+		const struct landlock_net_port_attr tcp_denied_listen_p1 = {
+			.allowed_access = ACCESS_ALL &
+					  ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
+			.port = self->srv1.port,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Allows all actions for the first port. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_not_restricted_p0, 0));
+
+		/* Denies listening for the second port. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_denied_listen_p1, 0));
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	if (variant->prot.type != SOCK_STREAM)
+		SKIP(return, "listen(2) is supported only on stream sockets");
+
+	/* Initializes listening socket. */
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
 FIXTURE(ipv4)
 {
 	struct service_fixture srv0, srv1;
-- 
2.34.1

