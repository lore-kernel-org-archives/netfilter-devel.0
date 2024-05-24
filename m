Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228E5282E2;
	Fri, 24 May 2024 09:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543065; cv=none; b=vD6iuaIgCZ5InvURCxByyBbmtmoGaxf+RwwT/g8dv/Qv4WUDqWhWd2nZ6xvAG8nQiF3gDVyUsGuOnkERuvqiS2uWk9OETQ0mrjlL18Ao2aDV9noPWQkP92/8qUYZtKUDgp/oVn7pM7KK7vd6oiBXMscMBxsZEhsJZUZxsgCzrP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543065; c=relaxed/simple;
	bh=u5P7SwWlxlkLkPdOZ5/gegigyxPtGC2QBP2iTb9MYWo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L2Q6khIuNzCthygQYXlDweyvqTK6qGDv4la3EzMLynlaV8ABhuU6BEz5l6khquPdAgb+tXG5qyyikijFBRX6+QWPzCWPYBho2MJxkkJO+O6v7XM0ftOVEz2orLOcUrNM2nd/5W7EibrSS8q0XUz1YpVv3ikQAz9m8z5sDzzdUfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Vm07D2GqCz1S4tG;
	Fri, 24 May 2024 17:27:20 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id E94B518007E;
	Fri, 24 May 2024 17:31:00 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 24 May 2024 17:30:59 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 03/12] selftests/landlock: Add protocol.create to socket tests
Date: Fri, 24 May 2024 17:30:06 +0800
Message-ID: <20240524093015.2402952-4-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml100004.china.huawei.com (7.188.51.133) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Initiate socket_test.c selftests. Add protocol fixture for tests
with changeable family-type values. Only most common variants of
protocols (like ipv4-tcp,ipv6-udp, unix) were added.
Add simple socket access right checking test.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Replaces test_socket_create() and socket_variant() helpers
  with test_socket().
* Renames domain to family in protocol fixture.
* Remove AF_UNSPEC fixture entry and add unspec_srv0 fixture field to
  check AF_UNSPEC socket creation case.
* Formats code with clang-format.
* Refactors commit message.
---
 .../testing/selftests/landlock/socket_test.c  | 181 ++++++++++++++++++
 1 file changed, 181 insertions(+)
 create mode 100644 tools/testing/selftests/landlock/socket_test.c

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
new file mode 100644
index 000000000000..4c51f89ed578
--- /dev/null
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock tests - Socket
+ *
+ * Copyright © 2024 Huawei Tech. Co., Ltd.
+ * Copyright © 2024 Microsoft Corporation
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
+	int family;
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
+static int test_socket(const struct service_fixture *const srv)
+{
+	int fd;
+
+	fd = socket(srv->protocol.family, srv->protocol.type | SOCK_CLOEXEC, 0);
+	if (fd < 0)
+		return errno;
+	/*
+	 * Mixing error codes from close(2) and socket(2) should not lead to any
+	 * (access type) confusion for this test.
+	 */
+	if (close(fd) != 0)
+		return errno;
+	return 0;
+}
+
+FIXTURE(protocol)
+{
+	struct service_fixture srv0, unspec_srv0;
+};
+
+FIXTURE_VARIANT(protocol)
+{
+	const struct protocol_variant protocol;
+};
+
+FIXTURE_SETUP(protocol)
+{
+	const struct protocol_variant prot_unspec = {
+		.family = AF_UNSPEC,
+		.type = SOCK_STREAM,
+	};
+
+	disable_caps(_metadata);
+	self->srv0.protocol = variant->protocol;
+	self->unspec_srv0.protocol = prot_unspec;
+	setup_namespace(_metadata);
+};
+
+FIXTURE_TEARDOWN(protocol)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, unix_stream) {
+	/* clang-format on */
+	.protocol = {
+		.family = AF_UNIX,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, unix_dgram) {
+	/* clang-format on */
+	.protocol = {
+		.family = AF_UNIX,
+		.type = SOCK_DGRAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, ipv4_tcp) {
+	/* clang-format on */
+	.protocol = {
+		.family = AF_INET,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, ipv4_udp) {
+	/* clang-format on */
+	.protocol = {
+		.family = AF_INET,
+		.type = SOCK_DGRAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, ipv6_tcp) {
+	/* clang-format on */
+	.protocol = {
+		.family = AF_INET6,
+		.type = SOCK_STREAM,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, ipv6_udp) {
+	/* clang-format on */
+	.protocol = {
+		.family = AF_INET6,
+		.type = SOCK_DGRAM,
+	},
+};
+
+TEST_F(protocol, create)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_socket_attr create_socket_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = self->srv0.protocol.family,
+		.type = self->srv0.protocol.type,
+	};
+
+	int ruleset_fd;
+
+	/* Allowed create */
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &create_socket_attr, 0));
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	ASSERT_EQ(0, test_socket(&self->srv0));
+	ASSERT_EQ(EAFNOSUPPORT, test_socket(&self->unspec_srv0));
+
+	/* Denied create */
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	ASSERT_EQ(EACCES, test_socket(&self->srv0));
+	ASSERT_EQ(EAFNOSUPPORT, test_socket(&self->unspec_srv0));
+}
+
+TEST_HARNESS_MAIN
-- 
2.34.1

