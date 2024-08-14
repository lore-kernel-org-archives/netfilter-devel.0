Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2401CAA2;
	Wed, 14 Aug 2024 03:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723604537; cv=none; b=mOCLiJ7FnTgYQAODe8vkdB3RlNG8iym8Y1RiaFELnpbVM74KPwvuWcniUOwRGHbkyTRSRrj/7BkpLVNj0fqKb85ho2GUIq8+9biW6zCxjKAka+6sjSRD0DUBuGaiiOr4chZdf4DRfYPVgyzj++9jrz946rOo/yeooKiLzYFE4Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723604537; c=relaxed/simple;
	bh=Uq4vzzgadJB20TaRLv6mrGvs5NXdbdW6AOn2E7X585s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l0wa9+Sj0tWzIppBNaAunUH5XbYSOBFfvbBUZe+jZpV7fr+7ReBIs0X9hMqyeCId2oGWjOfPJH9BooL4gDVnzgBk5f41umDBN+tdopmjvXAtFUDARJkNAmiu+PsblYbb7UQ37QEoaQuBF1PPiWypwpHCUi1DLtHF3e5IFL06VRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WkCgT0P8YzndvW;
	Wed, 14 Aug 2024 11:00:53 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 502EB1800A0;
	Wed, 14 Aug 2024 11:02:13 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 11:02:11 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 7/9] selftests/landlock: Test listen on ULP socket without clone method
Date: Wed, 14 Aug 2024 11:01:49 +0800
Message-ID: <20240814030151.2380280-8-ivanov.mikhail1@huawei-partners.com>
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

Test checks that listen(2) doesn't wrongfully return -EACCES instead of
-EINVAL when trying to listen on a socket which is set to ULP that doesn't
have clone method in inet_csk(sk)->icsk_ulp_ops (espintcp).

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Uses 'protocol' fixture instead of 'ipv4_tcp'.
* Adds missing CONFIG_INET_ESP dependency in config.
---
 tools/testing/selftests/landlock/config     |  4 ++
 tools/testing/selftests/landlock/net_test.c | 50 +++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 29af19c4e9f9..72de73d1ee4c 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -1,7 +1,11 @@
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_INET=y
+CONFIG_INET_ESPINTCP=y
+CONFIG_INET_ESP=y
 CONFIG_IPV6=y
+CONFIG_INET6_ESPINTCP=y
+CONFIG_INET6_ESP=y
 CONFIG_KEYS=y
 CONFIG_NET=y
 CONFIG_NET_NS=y
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 92c042349596..6831d8a2e9aa 100644
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
@@ -1000,6 +1001,55 @@ TEST_F(protocol, listen_on_connected)
 	EXPECT_EQ(0, close(bind_fd));
 }
 
+TEST_F(protocol, espintcp_listen)
+{
+	int listen_fd;
+	int domain, type;
+
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = ACCESS_ALL,
+		};
+		const struct landlock_net_port_attr tcp_denied_listen_p0 = {
+			.allowed_access = ACCESS_ALL &
+					  ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
+			.port = self->srv0.port,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Deny listen. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_denied_listen_p0, 0));
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	domain = variant->prot.domain;
+	type = variant->prot.type;
+
+	if (!((domain == AF_INET || domain == AF_INET6) && type == SOCK_STREAM))
+		SKIP(return, "espintcp is available only for TCP socket");
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
 FIXTURE(ipv4)
 {
 	struct service_fixture srv0, srv1;
-- 
2.34.1

