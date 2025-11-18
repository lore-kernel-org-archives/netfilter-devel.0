Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A25358D04;
	Tue, 18 Nov 2025 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473637; cv=none; b=KzUudAnb/FEENgNN4AERgaH4hXR3JFFhEIgZgHQ5hDVkENSRUcUNnyIZqHpZXbxTMjPlv9iqG1uR2z1dmT9VWpsCKI5uE34DYer3ED+QYUQknwTFReLr+WZ3zVCDSORm8OioFitF5nVy7yMF10zIV18wpAHa6g0JL9Yyf5UkLMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473637; c=relaxed/simple;
	bh=mpWMjTIPa3DOoR0/ai8dXrcSaJlo6G3+gZDYVvqILYc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WHL5i/cYx4eKsUO5u8AEKmE81vvZnJRWGqYudjrxeRthbbgEN2gKNqGuHRdndQeOVAIuVCv/mbDu54zjaZsfUkyAZMhahbOUhXzYgTMGRIIHKzCBr0sxw5WQABTP0xHV2vfr60FGFcRZ812ARiRSLFpYLovBBrnqoEx0QxC6/kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9l34ztzHnH4s;
	Tue, 18 Nov 2025 21:46:35 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 54CC51400DC;
	Tue, 18 Nov 2025 21:47:06 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:06 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 13/19] selftests/landlock: Test SCTP peeloff restriction
Date: Tue, 18 Nov 2025 21:46:33 +0800
Message-ID: <20251118134639.3314803-14-ivanov.mikhail1@huawei-partners.com>
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

It is possible to branch off an SCTP UDP association into a separate
user space UDP socket. Add test validating that such scenario is
restricted by Landlock.

Move setup_loopback() helper from net_test to common.h to use it to
enable connection in this test.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Restricts branching off SCTP association.
* Changes commit message.
* Chages fixture from socket_create to mini.
---
 tools/testing/selftests/landlock/common.h     |  13 ++
 tools/testing/selftests/landlock/net_test.c   |  11 --
 .../testing/selftests/landlock/socket_test.c  | 128 ++++++++++++++++++
 3 files changed, 141 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index e9378a229a4c..ff1b7fc94a5b 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -16,6 +16,7 @@
 #include <sys/un.h>
 #include <sys/wait.h>
 #include <unistd.h>
+#include <sched.h>
 
 #include "../kselftest_harness.h"
 #include "wrappers.h"
@@ -255,3 +256,15 @@ static void __maybe_unused set_unix_address(struct service_fixture *const srv,
 	srv->unix_addr_len = SUN_LEN(&srv->unix_addr);
 	srv->unix_addr.sun_path[0] = '\0';
 }
+
+static void __maybe_unused
+setup_loopback(struct __test_metadata *const _metadata)
+{
+	set_cap(_metadata, CAP_SYS_ADMIN);
+	ASSERT_EQ(0, unshare(CLONE_NEWNET));
+	clear_cap(_metadata, CAP_SYS_ADMIN);
+
+	set_ambient_cap(_metadata, CAP_NET_ADMIN);
+	ASSERT_EQ(0, system("ip link set dev lo up"));
+	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
+}
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 2a45208551e6..a71ea275cf10 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -75,17 +75,6 @@ static int set_service(struct service_fixture *const srv,
 	return 1;
 }
 
-static void setup_loopback(struct __test_metadata *const _metadata)
-{
-	set_cap(_metadata, CAP_SYS_ADMIN);
-	ASSERT_EQ(0, unshare(CLONE_NEWNET));
-	clear_cap(_metadata, CAP_SYS_ADMIN);
-
-	set_ambient_cap(_metadata, CAP_NET_ADMIN);
-	ASSERT_EQ(0, system("ip link set dev lo up"));
-	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
-}
-
 static bool prot_is_tcp(const struct protocol_variant *const prot)
 {
 	return (prot->domain == AF_INET || prot->domain == AF_INET6) &&
diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index d1a004c2e0f5..e9f56a86f456 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -12,6 +12,10 @@
 #include <linux/pfkeyv2.h>
 #include <linux/kcm.h>
 #include <linux/can.h>
+#include <sys/socket.h>
+#include <stdint.h>
+#include <linux/sctp.h>
+#include <arpa/inet.h>
 
 #include "common.h"
 
@@ -921,4 +925,128 @@ TEST_F(mini, socketpair)
 	EXPECT_EQ(EACCES, test_socketpair(AF_UNIX, SOCK_STREAM, 0));
 }
 
+/* clang-format off */
+FIXTURE(connection_restriction) {};
+/* clang-format on */
+
+FIXTURE_VARIANT(connection_restriction)
+{
+	bool sandboxed;
+};
+
+FIXTURE_SETUP(connection_restriction)
+{
+	disable_caps(_metadata);
+	setup_loopback(_metadata);
+};
+
+FIXTURE_TEARDOWN(connection_restriction)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(connection_restriction, allowed) {
+	/* clang-format on */
+	.sandboxed = false,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(connection_restriction, sandboxed) {
+	/* clang-format on */
+	.sandboxed = true,
+};
+
+static const char loopback_ipv4[] = "127.0.0.1";
+static const int backlog = 10;
+static const int loopback_port = 1024;
+
+TEST_F(connection_restriction, sctp_peeloff)
+{
+	int status, ret;
+	pid_t child;
+	struct sockaddr_in addr;
+	int server_fd;
+
+	server_fd =
+		socket(AF_INET, SOCK_SEQPACKET | SOCK_CLOEXEC, IPPROTO_SCTP);
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
+		int client_fd;
+		sctp_peeloff_flags_arg_t peeloff;
+		socklen_t peeloff_size = sizeof(peeloff);
+
+		/* Closes listening socket for the child. */
+		ASSERT_EQ(0, close(server_fd));
+
+		client_fd = socket(AF_INET, SOCK_SEQPACKET | SOCK_CLOEXEC,
+				   IPPROTO_SCTP);
+		ASSERT_LE(0, client_fd);
+
+		/*
+		 * Establishes connection between sockets and
+		 * gets SCTP association id.
+		 */
+		ret = setsockopt(client_fd, IPPROTO_SCTP, SCTP_SOCKOPT_CONNECTX,
+				 &addr, sizeof(addr));
+		ASSERT_LE(0, ret);
+
+		if (variant->sandboxed) {
+			const struct landlock_ruleset_attr ruleset_attr = {
+				.handled_access_socket =
+					LANDLOCK_ACCESS_SOCKET_CREATE,
+			};
+			/* Denies creation of SCTP sockets. */
+			int ruleset_fd = landlock_create_ruleset(
+				&ruleset_attr, sizeof(ruleset_attr), 0);
+			ASSERT_LE(0, ruleset_fd);
+
+			enforce_ruleset(_metadata, ruleset_fd);
+			ASSERT_EQ(0, close(ruleset_fd));
+		}
+		/*
+		 * Branches off current SCTP association into a separate socket
+		 * and returns it to user space.
+		 */
+		peeloff.p_arg.associd = ret;
+		ret = getsockopt(client_fd, IPPROTO_SCTP, SCTP_SOCKOPT_PEELOFF,
+				 &peeloff, &peeloff_size);
+
+		/*
+		 * Branching off existing SCTP association leads to creation of user space
+		 * SCTP UDP socket and should be restricted by Landlock.
+		 */
+		if (variant->sandboxed) {
+			EXPECT_EQ(-1, ret);
+			EXPECT_EQ(EACCES, errno);
+		} else {
+			ASSERT_LE(0, ret);
+		}
+
+		/* getsockopt(2) returns 0 on success. */
+		if (ret == 0) {
+			/* Closes peeloff socket if such was created. */
+			ASSERT_EQ(0, close(peeloff.p_arg.sd));
+		}
+		ASSERT_EQ(0, close(client_fd));
+		_exit(_metadata->exit_code);
+		return;
+	}
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

