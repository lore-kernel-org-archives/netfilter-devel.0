Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768501D220C;
	Wed,  4 Sep 2024 10:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446943; cv=none; b=M+xVfTyDLg+xKRiRNlN5RVzWLjSDBQppXct8e8rcKrlL4h8DOH4LlWT1+xYinDAbt0scqBe09HxIk0sLXif4gIWdykemw1Jnxb6Gx7qLdKvgrx3Dm9kSePOlc7Ins4wnR2fLSbjvODOntDLOYzd1G0nTSJ2XqA0ACzbp5+ij1kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446943; c=relaxed/simple;
	bh=ZQhcZ7oABbdgp64nuh8UmhP5SCvaqs8uKBtCbxWMHX0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=orXkfoKzg4sAH1xMO8d2FHeuVr9bgf2FVzcgH2HhnZFNCdXfRZ9JL3gJT3tRqz1sKKjq5aB/tnATAJjcqR7I347cSz2wdmU0bDgixW/FOmF3c9kyz+t6bbB7iUn8I0Nt3WR1cCpA7gVWDVYrQjm+6duIkC9Utll6zrlNmmBwoYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WzJyB1vspz20nLj;
	Wed,  4 Sep 2024 18:44:02 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 5375C1A0188;
	Wed,  4 Sep 2024 18:48:59 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:57 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 15/19] selftests/landlock: Test SCTP peeloff restriction
Date: Wed, 4 Sep 2024 18:48:20 +0800
Message-ID: <20240904104824.1844082-16-ivanov.mikhail1@huawei-partners.com>
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

It is possible to branch off an SCTP UDP association into a separate
user space UDP socket. Add test validating that such scenario is not
restricted by Landlock.

Move setup_loopback() helper from net_test to common.h to use it to
enable connection in this test.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/common.h     |  12 +++
 tools/testing/selftests/landlock/net_test.c   |  11 --
 .../testing/selftests/landlock/socket_test.c  | 102 +++++++++++++++++-
 3 files changed, 113 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 28df49fa22d5..07d959a8ac7b 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -16,6 +16,7 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <unistd.h>
+#include <sched.h>
 
 #include "../kselftest_harness.h"
 
@@ -227,3 +228,14 @@ enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
 		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
 	}
 }
+
+static void setup_loopback(struct __test_metadata *const _metadata)
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
index f21cfbbc3638..0b8386657c72 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -103,17 +103,6 @@ static int set_service(struct service_fixture *const srv,
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
 static bool is_restricted(const struct protocol_variant *const prot,
 			  const enum sandbox_type sandbox)
 {
diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 67db0e1c1121..2ab27196fa3d 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -11,8 +11,11 @@
 #include <linux/pfkeyv2.h>
 #include <linux/kcm.h>
 #include <linux/can.h>
-#include <linux/in.h>
+#include <sys/socket.h>
+#include <stdint.h>
+#include <linux/sctp.h>
 #include <sys/prctl.h>
+#include <arpa/inet.h>
 
 #include "common.h"
 
@@ -839,4 +842,101 @@ TEST_F(socket_creation, socketpair)
 	}
 }
 
+static const char loopback_ipv4[] = "127.0.0.1";
+static const int backlog = 10;
+static const int loopback_port = 1024;
+
+TEST_F(socket_creation, sctp_peeloff)
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
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+		};
+		struct landlock_socket_attr sctp_socket_create = {
+			.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+			.family = AF_INET,
+			.type = SOCK_SEQPACKET,
+		};
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
+		if (self->sandboxed) {
+			/* Denies creation of SCTP sockets. */
+			int ruleset_fd = landlock_create_ruleset(
+				&ruleset_attr, sizeof(ruleset_attr), 0);
+			ASSERT_LE(0, ruleset_fd);
+
+			if (self->allowed) {
+				ASSERT_EQ(0, landlock_add_rule(
+						     ruleset_fd,
+						     LANDLOCK_RULE_SOCKET,
+						     &sctp_socket_create, 0));
+			}
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
+		 * Creation of SCTP socket by branching off existing SCTP association
+		 * should not be restricted by Landlock.
+		 */
+		EXPECT_LE(0, ret);
+
+		/* Closes peeloff socket if such was created. */
+		if (!ret) {
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

