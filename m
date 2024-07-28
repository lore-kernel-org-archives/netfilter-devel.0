Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76229EEC0;
	Sun, 28 Jul 2024 00:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722126389; cv=none; b=UlfhRh+aAWpn8Uf+9YgAXQ/SH2F9NccuKoqSkxLJaVLME+0IsVEEBiXx2sxlump/qZNHYOk7M57c8tmIcroM1OlD8UcJfhPeK8aMKj3c9cBAg69A5SRc7b52zQYaLunE9qZeGoXm0Po1ORJeUqkdKCiZcW3LBDnB1HX86ydWu80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722126389; c=relaxed/simple;
	bh=1Lw7jRXd2Z4jblu4O847A7DBHGOXTkU5W9yFUphZv6c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HrvXbjZ5iArpiCoWMQUibNc0ZtTtMYz51vC0ZBu8mDZ0yw7WdfHcIEDlUqD0cxgeaPa2nL2Ov0WOZlX2KezldzXiCis6rlMzVxAmKJ63av7TeEhBSG24t4TX/u7W/owSIgQGOb4tiT0kJk2bnV4jDVkNhwDmHFXj9c25wDnGyn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WWhxQ4QnGzyNqG;
	Sun, 28 Jul 2024 08:21:30 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 2D2CC1800D0;
	Sun, 28 Jul 2024 08:26:25 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 28 Jul 2024 08:26:23 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 7/9] selftests/landlock: Test listen on ULP socket without clone method
Date: Sun, 28 Jul 2024 08:26:00 +0800
Message-ID: <20240728002602.3198398-8-ivanov.mikhail1@huawei-partners.com>
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

Test checks that listen(2) doesn't wrongfully return -EACCES instead of
-EINVAL when trying to listen on a socket which is set to ULP that doesn't
have clone method in inet_csk(sk)->icsk_ulp_ops (espintcp).

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/config     |  1 +
 tools/testing/selftests/landlock/net_test.c | 38 +++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 0086efaa7b68..014401fe6114 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -12,3 +12,4 @@ CONFIG_SHMEM=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_XATTR=y
+CONFIG_INET_ESPINTCP=y
\ No newline at end of file
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 1a4c4d1cabc2..caf5f38996ed 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -12,6 +12,7 @@
 #include <fcntl.h>
 #include <linux/landlock.h>
 #include <linux/in.h>
+#include <linux/tcp.h>
 #include <sched.h>
 #include <stdint.h>
 #include <string.h>
@@ -1709,6 +1710,43 @@ TEST_F(ipv4_tcp, listen_on_connected)
 	EXPECT_EQ(0, close(bind_fd));
 }
 
+TEST_F(ipv4_tcp, espintcp_listen)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = ACCESS_ALL,
+	};
+	const struct landlock_net_port_attr tcp_denied_listen_p0 = {
+		.allowed_access = ACCESS_ALL & ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
+		.port = self->srv0.port,
+	};
+	int ruleset_fd;
+	int listen_fd;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Deny listen. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+				       &tcp_denied_listen_p0, 0));
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	listen_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, listen_fd);
+
+	/* Set espintcp ULP. */
+	EXPECT_EQ(0, setsockopt(listen_fd, IPPROTO_TCP, TCP_ULP, "espintcp",
+				sizeof("espintcp")));
+
+	EXPECT_EQ(0, bind_variant(listen_fd, &self->srv0));
+
+	/* Espintcp ULP doesn't have clone method, so listen is denied. */
+	EXPECT_EQ(-EINVAL, listen_variant(listen_fd, backlog));
+	EXPECT_EQ(0, close(listen_fd));
+}
+
 FIXTURE(port_specific)
 {
 	struct service_fixture srv0;
-- 
2.34.1

