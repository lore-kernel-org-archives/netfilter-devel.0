Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0B78612C;
	Fri, 24 May 2024 09:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543076; cv=none; b=LpqERxc9GF5hZZ20ODukFuCcXh7tA1zufhOEkFcirLSZjzhlNs5rAqBGeKByXKy5yCDB2kyqQQyuoO1n7Q4S9xneha8K99/eQAMAOH/CcfEf0WYILSdBuJwwKAEI6by7sAN9DJukZFyz/U2y0RAK3hbOsEbRHXJzUP9huLUqJvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543076; c=relaxed/simple;
	bh=amUffNvgWr3XWgM3cDBGJHlFqjphGTGJejo4HcUHUHY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i21Y2/Ndi4eeWLzGfBJEqj4vXZOn2mvEmLU8KCSgjh0atGzQaTehOYQQIqnfrpXhnfuVpGkeQHnTY10dwZvQ3Cym9GZp2HzGIJmcfAYn21oBarM3dcy6uvJTttuWnkNtJSICp7aR5tmADh65ddI0MjTQmj9hKs+/VOk8he9GPZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Vm07N4vzMzsRmP;
	Fri, 24 May 2024 17:27:28 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 42DA11402CE;
	Fri, 24 May 2024 17:31:12 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 24 May 2024 17:31:10 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 10/12] selftests/landlock: Add mini.socket_overflow to socket tests
Date: Fri, 24 May 2024 17:30:13 +0800
Message-ID: <20240524093015.2402952-11-ivanov.mikhail1@huawei-partners.com>
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

* Add test validating that adding a rule for sockets that do not match
  the ranges (0 <= domain < AF_MAX), (0 <= type < SOCK_MAX)
  is prohibited. This test also checks that Landlock supports maximum
  possible domain, type values.

* Add CONFIG_MCTP to selftests config to check the socket with maximum
  family (AF_MCTP).

* Add CAP_NET_RAW capability to landlock selftests, which is required
  to create PACKET sockets (maximum type value).

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/common.h     |  1 +
 tools/testing/selftests/landlock/config       |  1 +
 .../testing/selftests/landlock/socket_test.c  | 93 +++++++++++++++++++
 3 files changed, 95 insertions(+)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 7e2b431b9f90..28df49fa22d5 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -66,6 +66,7 @@ static void _init_caps(struct __test_metadata *const _metadata, bool drop_all)
 		CAP_NET_BIND_SERVICE,
 		CAP_SYS_ADMIN,
 		CAP_SYS_CHROOT,
+		CAP_NET_RAW,
 		/* clang-format on */
 	};
 	const unsigned int noroot = SECBIT_NOROOT | SECBIT_NOROOT_LOCKED;
diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 0086efaa7b68..2820c481aefe 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -12,3 +12,4 @@ CONFIG_SHMEM=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_XATTR=y
+CONFIG_MCTP=y
\ No newline at end of file
diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index c81f02ffef6c..80c904380075 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -9,6 +9,7 @@
 #define _GNU_SOURCE
 
 #include <errno.h>
+#include <linux/net.h>
 #include <linux/landlock.h>
 #include <sched.h>
 #include <string.h>
@@ -439,4 +440,96 @@ TEST_F(mini, ruleset_with_unknown_access)
 	}
 }
 
+TEST_F(mini, socket_overflow)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	/*
+	 * Assuming that AF_MCTP == AF_MAX - 1 uses MCTP as protocol
+	 * with maximum family value. Appropriate сheck for this is given below.
+	 */
+	const struct landlock_socket_attr create_socket_max_family = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_MCTP,
+		.type = SOCK_DGRAM,
+	};
+	/*
+	 * Assuming that SOCK_PACKET == SOCK_MAX - 1 uses PACKET socket as
+	 * socket with maximum type value. Since SOCK_MAX cannot be accessed
+	 * from selftests, this assumption is not verified.
+	 */
+	const struct landlock_socket_attr create_socket_max_type = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_PACKET,
+		.type = SOCK_PACKET,
+	};
+	struct landlock_socket_attr create_socket_overflow = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct protocol_variant protocol_max_family = {
+		.family = create_socket_max_family.family,
+		.type = create_socket_max_family.type,
+	};
+	const struct protocol_variant protocol_max_type = {
+		.family = create_socket_max_type.family,
+		.type = create_socket_max_type.type,
+	};
+	const struct protocol_variant ipv4_tcp = {
+		.family = AF_INET,
+		.type = SOCK_STREAM,
+	};
+	struct service_fixture srv_max_allowed_family, srv_max_allowed_type,
+		srv_denied;
+	int ruleset_fd;
+
+	/* Checks protocol_max_family correctness. */
+	ASSERT_EQ(AF_MCTP + 1, AF_MAX);
+
+	srv_max_allowed_family.protocol = protocol_max_family;
+	srv_max_allowed_type.protocol = protocol_max_type;
+	srv_denied.protocol = ipv4_tcp;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &create_socket_max_family, 0));
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &create_socket_max_type, 0));
+
+	/* Checks the overflow variants for family, type values. */
+#define CHECK_RULE_OVERFLOW(family_val, type_val)                             \
+	do {                                                                  \
+		create_socket_overflow.family = family_val;                   \
+		create_socket_overflow.type = type_val;                       \
+		EXPECT_EQ(-1,                                                 \
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET, \
+					    &create_socket_overflow, 0));     \
+		EXPECT_EQ(EINVAL, errno);                                     \
+	} while (0)
+
+	CHECK_RULE_OVERFLOW(AF_MAX, SOCK_STREAM);
+	CHECK_RULE_OVERFLOW(AF_INET, (SOCK_PACKET + 1));
+	CHECK_RULE_OVERFLOW(AF_MAX, (SOCK_PACKET + 1));
+	CHECK_RULE_OVERFLOW(-1, SOCK_STREAM);
+	CHECK_RULE_OVERFLOW(AF_INET, -1);
+	CHECK_RULE_OVERFLOW(-1, -1);
+	CHECK_RULE_OVERFLOW(INT16_MAX + 1, INT16_MAX + 1);
+
+#undef CHECK_RULE_OVERFLOW
+
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	EXPECT_EQ(0, test_socket(&srv_max_allowed_family));
+
+	/* PACKET sockets can be used only with CAP_NET_RAW. */
+	set_cap(_metadata, CAP_NET_RAW);
+	EXPECT_EQ(0, test_socket(&srv_max_allowed_type));
+	clear_cap(_metadata, CAP_NET_RAW);
+
+	EXPECT_EQ(EACCES, test_socket(&srv_denied));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

