Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9420E19E971;
	Thu,  3 Oct 2024 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727966428; cv=none; b=oCcCcnAh/jauqCaPs0QxFq+3vqIAL9YAdeUtSorI62tFQrZFQKVfi4KOdvoL7zMDXvMwNuDHnMhrtQUd4Fcc0lg4aT9J6moE4KJRWcHjWJWN4NuIzcUUFvYM8a1bMdHOkBaE9uhKiAPp1fpyepq+IOPIjMl6s2vaqoNkmw3jT/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727966428; c=relaxed/simple;
	bh=IYK4s5n5Ksrvo/LH1b9vIh8zeM+5rSVKAGAEzWC+7os=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QF/AdBE6QW+KGUeNwFvZuWOpi5kMxzW7Y5hkmY0ySObS4kV1R48QO+ZbIdPvSEH9JnT3SjcbhwYLteJdZM8smy/5550GzZqQaU7/NxoFocngJJBKjzVyQHON7RpE94kfeFkt3XiQqz+UwOWtYL09fRW14vraXi/GPozZl0oTyC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XKDp33QZnzyScv;
	Thu,  3 Oct 2024 22:39:07 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 6D5351400CA;
	Thu,  3 Oct 2024 22:40:17 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Oct 2024 22:40:15 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 2/2] selftests/landlock: Test non-TCP INET connection-based protocols
Date: Thu, 3 Oct 2024 22:39:32 +0800
Message-ID: <20241003143932.2431249-3-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
References: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml100004.china.huawei.com (7.188.51.133) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Extend protocol fixture with test suits for MPTCP, SCTP and SMC protocols.
Add all options required by this protocols in config.

Extend protocol_variant structure with protocol field (Cf. socket(2)).

Refactor is_restricted() helper and add few helpers to check struct
protocol_variant on specific protocols.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/common.h   |   1 +
 tools/testing/selftests/landlock/config     |   5 +
 tools/testing/selftests/landlock/net_test.c | 212 ++++++++++++++++++--
 3 files changed, 198 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 61056fa074bb..40a2def50b83 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -234,6 +234,7 @@ enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
 struct protocol_variant {
 	int domain;
 	int type;
+	int protocol;
 };
 
 struct service_fixture {
diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 29af19c4e9f9..73b01d7d0881 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -1,8 +1,12 @@
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_INET=y
+CONFIG_INFINIBAND=y
+CONFIG_IP_SCTP=y
 CONFIG_IPV6=y
 CONFIG_KEYS=y
+CONFIG_MPTCP=y
+CONFIG_MPTCP_IPV6=y
 CONFIG_NET=y
 CONFIG_NET_NS=y
 CONFIG_OVERLAY_FS=y
@@ -10,6 +14,7 @@ CONFIG_PROC_FS=y
 CONFIG_SECURITY=y
 CONFIG_SECURITY_LANDLOCK=y
 CONFIG_SHMEM=y
+CONFIG_SMC=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_XATTR=y
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 4e0aeb53b225..dbe77d436281 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -36,6 +36,17 @@ enum sandbox_type {
 	TCP_SANDBOX,
 };
 
+/* Checks if IPPROTO_SMC is present for compatibility reasons. */
+#if !defined(__alpha__) && defined(IPPROTO_SMC)
+#define SMC_SUPPORTED 1
+#else
+#define SMC_SUPPORTED 0
+#endif
+
+#ifndef IPPROTO_SMC
+#define IPPROTO_SMC 256
+#endif
+
 static int set_service(struct service_fixture *const srv,
 		       const struct protocol_variant prot,
 		       const unsigned short index)
@@ -85,19 +96,37 @@ static void setup_loopback(struct __test_metadata *const _metadata)
 	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
 }
 
+static bool prot_is_inet_stream(const struct protocol_variant *const prot)
+{
+	return (prot->domain == AF_INET || prot->domain == AF_INET6) &&
+	       prot->type == SOCK_STREAM;
+}
+
+static bool prot_is_tcp(const struct protocol_variant *const prot)
+{
+	return prot_is_inet_stream(prot) &&
+	       (prot->protocol == IPPROTO_TCP || prot->protocol == IPPROTO_IP);
+}
+
+static bool prot_is_sctp(const struct protocol_variant *const prot)
+{
+	return prot_is_inet_stream(prot) && prot->protocol == IPPROTO_SCTP;
+}
+
+static bool prot_is_smc(const struct protocol_variant *const prot)
+{
+	return prot_is_inet_stream(prot) && prot->protocol == IPPROTO_SMC;
+}
+
+static bool prot_is_unix_stream(const struct protocol_variant *const prot)
+{
+	return prot->domain == AF_UNIX && prot->type == SOCK_STREAM;
+}
+
 static bool is_restricted(const struct protocol_variant *const prot,
 			  const enum sandbox_type sandbox)
 {
-	switch (prot->domain) {
-	case AF_INET:
-	case AF_INET6:
-		switch (prot->type) {
-		case SOCK_STREAM:
-			return sandbox == TCP_SANDBOX;
-		}
-		break;
-	}
-	return false;
+	return prot_is_tcp(prot) && sandbox == TCP_SANDBOX;
 }
 
 static int socket_variant(const struct service_fixture *const srv)
@@ -105,7 +134,7 @@ static int socket_variant(const struct service_fixture *const srv)
 	int ret;
 
 	ret = socket(srv->protocol.domain, srv->protocol.type | SOCK_CLOEXEC,
-		     0);
+		     srv->protocol.protocol);
 	if (ret < 0)
 		return -errno;
 	return ret;
@@ -124,7 +153,7 @@ static socklen_t get_addrlen(const struct service_fixture *const srv,
 		return sizeof(srv->ipv4_addr);
 
 	case AF_INET6:
-		if (minimal)
+		if (minimal && !prot_is_sctp(&srv->protocol))
 			return SIN6_LEN_RFC2133;
 		return sizeof(srv->ipv6_addr);
 
@@ -271,6 +300,11 @@ FIXTURE_SETUP(protocol)
 		.type = SOCK_STREAM,
 	};
 
+#if !SMC_SUPPORTED
+	if (prot_is_smc(&variant->prot))
+		SKIP(return, "SMC protocol is not supported.");
+#endif
+
 	disable_caps(_metadata);
 
 	ASSERT_EQ(0, set_service(&self->srv0, variant->prot, 0));
@@ -299,6 +333,39 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_mptcp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_sctp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SCTP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_smc) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SMC,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp) {
 	/* clang-format on */
@@ -309,6 +376,39 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_mptcp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_sctp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SCTP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_smc) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SMC,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_udp) {
 	/* clang-format on */
@@ -359,6 +459,39 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_mptcp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_sctp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SCTP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_smc) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SMC,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp) {
 	/* clang-format on */
@@ -369,6 +502,39 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_mptcp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_sctp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SCTP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_smc) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SMC,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_udp) {
 	/* clang-format on */
@@ -663,7 +829,7 @@ TEST_F(protocol, bind_unspec)
 
 	/* Allowed bind on AF_UNSPEC/INADDR_ANY. */
 	ret = bind_variant(bind_fd, &self->unspec_any0);
-	if (variant->prot.domain == AF_INET) {
+	if (variant->prot.domain == AF_INET && !prot_is_sctp(&variant->prot)) {
 		EXPECT_EQ(0, ret)
 		{
 			TH_LOG("Failed to bind to unspec/any socket: %s",
@@ -689,7 +855,7 @@ TEST_F(protocol, bind_unspec)
 
 	/* Denied bind on AF_UNSPEC/INADDR_ANY. */
 	ret = bind_variant(bind_fd, &self->unspec_any0);
-	if (variant->prot.domain == AF_INET) {
+	if (variant->prot.domain == AF_INET && !prot_is_sctp(&variant->prot)) {
 		if (is_restricted(&variant->prot, variant->sandbox)) {
 			EXPECT_EQ(-EACCES, ret);
 		} else {
@@ -727,6 +893,10 @@ TEST_F(protocol, connect_unspec)
 	int bind_fd, client_fd, status;
 	pid_t child;
 
+	if (prot_is_smc(&variant->prot))
+		SKIP(return, "SMC does not properly handles disconnect "
+			     "in the case of fallback to TCP");
+
 	/* Specific connection tests. */
 	bind_fd = socket_variant(&self->srv0);
 	ASSERT_LE(0, bind_fd);
@@ -769,17 +939,18 @@ TEST_F(protocol, connect_unspec)
 
 		/* Disconnects already connected socket, or set peer. */
 		ret = connect_variant(connect_fd, &self->unspec_any0);
-		if (self->srv0.protocol.domain == AF_UNIX &&
-		    self->srv0.protocol.type == SOCK_STREAM) {
+		if (prot_is_unix_stream(&variant->prot)) {
 			EXPECT_EQ(-EINVAL, ret);
+		} else if (prot_is_sctp(&variant->prot)) {
+			EXPECT_EQ(-EOPNOTSUPP, ret);
 		} else {
 			EXPECT_EQ(0, ret);
 		}
 
 		/* Tries to reconnect, or set peer. */
 		ret = connect_variant(connect_fd, &self->srv0);
-		if (self->srv0.protocol.domain == AF_UNIX &&
-		    self->srv0.protocol.type == SOCK_STREAM) {
+		if (prot_is_unix_stream(&variant->prot) ||
+		    prot_is_sctp(&variant->prot)) {
 			EXPECT_EQ(-EISCONN, ret);
 		} else {
 			EXPECT_EQ(0, ret);
@@ -796,9 +967,10 @@ TEST_F(protocol, connect_unspec)
 		}
 
 		ret = connect_variant(connect_fd, &self->unspec_any0);
-		if (self->srv0.protocol.domain == AF_UNIX &&
-		    self->srv0.protocol.type == SOCK_STREAM) {
+		if (prot_is_unix_stream(&variant->prot)) {
 			EXPECT_EQ(-EINVAL, ret);
+		} else if (prot_is_sctp(&variant->prot)) {
+			EXPECT_EQ(-EOPNOTSUPP, ret);
 		} else {
 			/* Always allowed to disconnect. */
 			EXPECT_EQ(0, ret);
-- 
2.34.1

