Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A194C634;
	Mon,  8 Apr 2024 09:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569215; cv=none; b=Pefzc0YDAOMoWlPLZ6/04TaFu5uKtlWaebgwbPEigYkAjtcRP/0TphIauT6+6qV8hKgYmX5SzenP+LdKB0gyNVZmD+sMoQ1DpmOcXyDRODoKAn1+DQHT06lMnt0Cgl4IoUkTJ4uQWuJF315wwWNWG8iOetKhAh+vtjJRjSm5/Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569215; c=relaxed/simple;
	bh=n2+4BF++X1ceQbrRCeBct5e2pXVkZ36iXd8vV/rip7s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iD5psf48Q/sNiWnUuRFfClY+NUtTif/aT53uUPAJwMLaRc8qJ2SvCdD6XeCBJhst7hiRwqDAe9N36s9iVCPzPB6ej/13ylMfKmMW2Jp9bIGscqqXzj5xBQUFsc8J+Q5X0vTBE7GOobh6wl0K4okFj4b7C7WfhEqosFKhALikxLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VCkX933h8ztRvC;
	Mon,  8 Apr 2024 17:37:29 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 35F8418001C;
	Mon,  8 Apr 2024 17:40:10 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:40:08 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 03/10] selftests/landlock: Create 'create' test
Date: Mon, 8 Apr 2024 17:39:20 +0800
Message-ID: <20240408093927.1759381-4-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Initiate socket_test.c selftests. Add protocol fixture for tests
with changeable domain/type values. Only most common variants of
protocols (like ipv4-tcp,ipv6-udp, unix) were added.
Add simple socket access right checking test.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 .../testing/selftests/landlock/socket_test.c  | 197 ++++++++++++++++++
 1 file changed, 197 insertions(+)
 create mode 100644 tools/testing/selftests/landlock/socket_test.c

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
new file mode 100644
index 000000000..525f4f7df
--- /dev/null
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -0,0 +1,197 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock tests - Socket
+ *
+ * Copyright © 2024 Huawei Tech. Co., Ltd.
+ */
+
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <linux/landlock.h>
+#include <sched.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <sys/socket.h>
+
+#include "common.h"
+
+/* clang-format off */
+
+#define ACCESS_LAST LANDLOCK_ACCESS_SOCKET_CREATE
+
+#define ACCESS_ALL ( \
+	LANDLOCK_ACCESS_SOCKET_CREATE)
+
+/* clang-format on */
+
+struct protocol_variant {
+	int domain;
+	int type;
+};
+
+struct service_fixture {
+	struct protocol_variant protocol;
+};
+
+static void setup_namespace(struct __test_metadata *const _metadata)
+{
+	set_cap(_metadata, CAP_SYS_ADMIN);
+	ASSERT_EQ(0, unshare(CLONE_NEWNET));
+	clear_cap(_metadata, CAP_SYS_ADMIN);
+}
+
+static int socket_variant(const struct service_fixture *const srv)
+{
+	int ret;
+
+	ret = socket(srv->protocol.domain, srv->protocol.type | SOCK_CLOEXEC,
+			 0);
+	if (ret < 0)
+		return -errno;
+	return ret;
+}
+
+FIXTURE(protocol)
+{
+	struct service_fixture srv0;
+};
+
+FIXTURE_VARIANT(protocol)
+{
+	const struct protocol_variant protocol;
+};
+
+FIXTURE_SETUP(protocol)
+{
+	disable_caps(_metadata);
+	self->srv0.protocol = variant->protocol;
+	setup_namespace(_metadata);
+};
+
+FIXTURE_TEARDOWN(protocol)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, unspec) {
+	/* clang-format on */
+	.protocol = {
+		.domain = AF_UNSPEC,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, unix_stream) {
+	/* clang-format on */
+	.protocol = {
+		.domain = AF_UNIX,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, unix_dgram) {
+	/* clang-format on */
+	.protocol = {
+		.domain = AF_UNIX,
+		.type = SOCK_DGRAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, ipv4_tcp) {
+	/* clang-format on */
+	.protocol = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, ipv4_udp) {
+	/* clang-format on */
+	.protocol = {
+		.domain = AF_INET,
+		.type = SOCK_DGRAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, ipv6_tcp) {
+	/* clang-format on */
+	.protocol = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, ipv6_udp) {
+	/* clang-format on */
+	.protocol = {
+		.domain = AF_INET6,
+		.type = SOCK_DGRAM,
+	},
+};
+
+static void test_socket_create(struct __test_metadata *const _metadata,
+				  const struct service_fixture *const srv,
+				  const bool deny_create)
+{
+	int fd;
+
+	fd = socket_variant(srv);
+	if (srv->protocol.domain == AF_UNSPEC) {
+		EXPECT_EQ(fd, -EAFNOSUPPORT);
+	} else if (deny_create) {
+		EXPECT_EQ(fd, -EACCES);
+	} else {
+		EXPECT_LE(0, fd)
+		{
+			TH_LOG("Failed to create socket: %s", strerror(errno));
+		}
+		EXPECT_EQ(0, close(fd));
+	}
+}
+
+TEST_F(protocol, create)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_socket_attr create_socket_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.domain = self->srv0.protocol.domain,
+		.type = self->srv0.protocol.type,
+	};
+
+	int ruleset_fd;
+
+	/* Allowed create */
+	ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+							sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0,
+			landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					&create_socket_attr, 0));
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	test_socket_create(_metadata, &self->srv0, false);
+
+	/* Denied create */
+	ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+							sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	test_socket_create(_metadata, &self->srv0, true);
+}
+
+TEST_HARNESS_MAIN
-- 
2.34.1

