Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1462810F1;
	Sun, 28 Jul 2024 00:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722126384; cv=none; b=EwjBeCK7hsu4xPlRfCvBl/tqL2OlOWA5mj5iGYqWyPczDXEpKQ0eT8ledHZDsLPeNuFBbALF4y93HSA52VMh/ReqP1dqcbwg8dbgqe68n+ETOIYEstbrA+fS6Q6NbRZ2h6Cx/lznJcXlbXjCIQhwFSlAbAvBX7oSjZ4pXTCJGPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722126384; c=relaxed/simple;
	bh=LN9sJF1ELuFamW2XwjLNaIq9pF5WelaQTpeGs6NP4RA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etf8OreEEGR9lVaIvoqzZreXm6R94+vrq1ssvsaKOLvfHiw0nfpGFJHXBBXhfEtNidfxbeMpFPbmiu8Mi7LLQOCV5HiUIIdZlWBXYa8oqXmm+rrS3Y3cGkgEAzdTre4DDvgB9MRZtgV2c9olxSWzUYtaZuY4CTANobMFRO3kG9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WWj1v63Zjzncnf;
	Sun, 28 Jul 2024 08:25:23 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 174B51800A4;
	Sun, 28 Jul 2024 08:26:18 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 28 Jul 2024 08:26:16 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 3/9] selftests/landlock: Support LANDLOCK_ACCESS_NET_LISTEN_TCP
Date: Sun, 28 Jul 2024 08:25:56 +0800
Message-ID: <20240728002602.3198398-4-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
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

* Add listen_variant() to simplify listen(2) return code checking.
* Rename test_bind_and_connect() to test_restricted_net_fixture().
* Extend current net rules with LANDLOCK_ACCESS_NET_LISTEN_TCP access.
* Rename test port_specific.bind_connect_1023 to
  port_specific.port_1023.
* Check little endian port restriction for listen in
  ipv4_tcp.port_endianness.
* Some local renames and comment changes.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/net_test.c | 198 +++++++++++---------
 1 file changed, 107 insertions(+), 91 deletions(-)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index f21cfbbc3638..8126f5c0160f 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -2,7 +2,7 @@
 /*
  * Landlock tests - Network
  *
- * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
+ * Copyright © 2022-2024 Huawei Tech. Co., Ltd.
  * Copyright © 2023 Microsoft Corporation
  */
 
@@ -22,6 +22,17 @@
 
 #include "common.h"
 
+/* clang-format off */
+
+#define ACCESS_LAST LANDLOCK_ACCESS_NET_LISTEN_TCP
+
+#define ACCESS_ALL ( \
+	LANDLOCK_ACCESS_NET_BIND_TCP | \
+	LANDLOCK_ACCESS_NET_CONNECT_TCP | \
+	LANDLOCK_ACCESS_NET_LISTEN_TCP)
+
+/* clang-format on */
+
 const short sock_port_start = (1 << 10);
 
 static const char loopback_ipv4[] = "127.0.0.1";
@@ -282,6 +293,16 @@ static int connect_variant(const int sock_fd,
 	return connect_variant_addrlen(sock_fd, srv, get_addrlen(srv, false));
 }
 
+static int listen_variant(const int sock_fd, const int backlog)
+{
+	int ret;
+
+	ret = listen(sock_fd, backlog);
+	if (ret < 0)
+		return -errno;
+	return ret;
+}
+
 FIXTURE(protocol)
 {
 	struct service_fixture srv0, srv1, srv2, unspec_any0, unspec_srv0;
@@ -438,9 +459,11 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_unix_datagram) {
 	},
 };
 
-static void test_bind_and_connect(struct __test_metadata *const _metadata,
-				  const struct service_fixture *const srv,
-				  const bool deny_bind, const bool deny_connect)
+static void test_restricted_net_fixture(struct __test_metadata *const _metadata,
+					const struct service_fixture *const srv,
+					const bool deny_bind,
+					const bool deny_connect,
+					const bool deny_listen)
 {
 	char buf = '\0';
 	int inval_fd, bind_fd, client_fd, status, ret;
@@ -512,8 +535,14 @@ static void test_bind_and_connect(struct __test_metadata *const _metadata,
 		EXPECT_EQ(0, ret);
 
 		/* Creates a listening socket. */
-		if (srv->protocol.type == SOCK_STREAM)
-			EXPECT_EQ(0, listen(bind_fd, backlog));
+		if (srv->protocol.type == SOCK_STREAM) {
+			ret = listen_variant(bind_fd, backlog);
+			if (deny_listen) {
+				EXPECT_EQ(-EACCES, ret);
+			} else {
+				EXPECT_EQ(0, ret);
+			}
+		}
 	}
 
 	child = fork();
@@ -530,7 +559,7 @@ static void test_bind_and_connect(struct __test_metadata *const _metadata,
 		ret = connect_variant(connect_fd, srv);
 		if (deny_connect) {
 			EXPECT_EQ(-EACCES, ret);
-		} else if (deny_bind) {
+		} else if (deny_bind || deny_listen) {
 			/* No listening server. */
 			EXPECT_EQ(-ECONNREFUSED, ret);
 		} else {
@@ -545,7 +574,7 @@ static void test_bind_and_connect(struct __test_metadata *const _metadata,
 
 	/* Accepts connection from the child. */
 	client_fd = bind_fd;
-	if (!deny_bind && !deny_connect) {
+	if (!deny_bind && !deny_connect && !deny_listen) {
 		if (srv->protocol.type == SOCK_STREAM) {
 			client_fd = accept(bind_fd, NULL, 0);
 			ASSERT_LE(0, client_fd);
@@ -571,16 +600,15 @@ TEST_F(protocol, bind)
 {
 	if (variant->sandbox == TCP_SANDBOX) {
 		const struct landlock_ruleset_attr ruleset_attr = {
-			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
-					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+			.handled_access_net = ACCESS_ALL,
 		};
-		const struct landlock_net_port_attr tcp_bind_connect_p0 = {
-			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
-					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
+			.allowed_access = ACCESS_ALL,
 			.port = self->srv0.port,
 		};
-		const struct landlock_net_port_attr tcp_connect_p1 = {
-			.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		const struct landlock_net_port_attr tcp_denied_bind_p1 = {
+			.allowed_access = ACCESS_ALL &
+					  ~LANDLOCK_ACCESS_NET_BIND_TCP,
 			.port = self->srv1.port,
 		};
 		int ruleset_fd;
@@ -589,48 +617,47 @@ TEST_F(protocol, bind)
 						     sizeof(ruleset_attr), 0);
 		ASSERT_LE(0, ruleset_fd);
 
-		/* Allows connect and bind for the first port.  */
+		/* Allows all actions for the first port. */
 		ASSERT_EQ(0,
 			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
-					    &tcp_bind_connect_p0, 0));
+					    &tcp_not_restricted_p0, 0));
 
-		/* Allows connect and denies bind for the second port. */
+		/* Allows all actions despite bind. */
 		ASSERT_EQ(0,
 			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
-					    &tcp_connect_p1, 0));
+					    &tcp_denied_bind_p1, 0));
 
 		enforce_ruleset(_metadata, ruleset_fd);
 		EXPECT_EQ(0, close(ruleset_fd));
 	}
+	bool restricted = is_restricted(&variant->prot, variant->sandbox);
 
 	/* Binds a socket to the first port. */
-	test_bind_and_connect(_metadata, &self->srv0, false, false);
+	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
+				    false);
 
 	/* Binds a socket to the second port. */
-	test_bind_and_connect(_metadata, &self->srv1,
-			      is_restricted(&variant->prot, variant->sandbox),
-			      false);
+	test_restricted_net_fixture(_metadata, &self->srv1, restricted, false,
+				    false);
 
 	/* Binds a socket to the third port. */
-	test_bind_and_connect(_metadata, &self->srv2,
-			      is_restricted(&variant->prot, variant->sandbox),
-			      is_restricted(&variant->prot, variant->sandbox));
+	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
+				    restricted, restricted);
 }
 
 TEST_F(protocol, connect)
 {
 	if (variant->sandbox == TCP_SANDBOX) {
 		const struct landlock_ruleset_attr ruleset_attr = {
-			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
-					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+			.handled_access_net = ACCESS_ALL,
 		};
-		const struct landlock_net_port_attr tcp_bind_connect_p0 = {
-			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
-					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
+			.allowed_access = ACCESS_ALL,
 			.port = self->srv0.port,
 		};
-		const struct landlock_net_port_attr tcp_bind_p1 = {
-			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		const struct landlock_net_port_attr tcp_denied_connect_p1 = {
+			.allowed_access = ACCESS_ALL &
+					  ~LANDLOCK_ACCESS_NET_CONNECT_TCP,
 			.port = self->srv1.port,
 		};
 		int ruleset_fd;
@@ -639,28 +666,27 @@ TEST_F(protocol, connect)
 						     sizeof(ruleset_attr), 0);
 		ASSERT_LE(0, ruleset_fd);
 
-		/* Allows connect and bind for the first port. */
+		/* Allows all actions for the first port. */
 		ASSERT_EQ(0,
 			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
-					    &tcp_bind_connect_p0, 0));
+					    &tcp_not_restricted_p0, 0));
 
-		/* Allows bind and denies connect for the second port. */
+		/* Allows all actions despite connect. */
 		ASSERT_EQ(0,
 			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
-					    &tcp_bind_p1, 0));
+					    &tcp_denied_connect_p1, 0));
 
 		enforce_ruleset(_metadata, ruleset_fd);
 		EXPECT_EQ(0, close(ruleset_fd));
 	}
-
-	test_bind_and_connect(_metadata, &self->srv0, false, false);
-
-	test_bind_and_connect(_metadata, &self->srv1, false,
-			      is_restricted(&variant->prot, variant->sandbox));
-
-	test_bind_and_connect(_metadata, &self->srv2,
-			      is_restricted(&variant->prot, variant->sandbox),
-			      is_restricted(&variant->prot, variant->sandbox));
+	bool restricted = is_restricted(&variant->prot, variant->sandbox);
+
+	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
+				    false);
+	test_restricted_net_fixture(_metadata, &self->srv1, false, restricted,
+				    false);
+	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
+				    restricted, restricted);
 }
 
 TEST_F(protocol, bind_unspec)
@@ -761,7 +787,7 @@ TEST_F(protocol, connect_unspec)
 	ASSERT_LE(0, bind_fd);
 	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
 	if (self->srv0.protocol.type == SOCK_STREAM)
-		EXPECT_EQ(0, listen(bind_fd, backlog));
+		EXPECT_EQ(0, listen_variant(bind_fd, backlog));
 
 	child = fork();
 	ASSERT_LE(0, child);
@@ -1127,8 +1153,8 @@ TEST_F(tcp_layers, ruleset_overlap)
 	 * Forbids to connect to the socket because only one ruleset layer
 	 * allows connect.
 	 */
-	test_bind_and_connect(_metadata, &self->srv0, false,
-			      variant->num_layers >= 2);
+	test_restricted_net_fixture(_metadata, &self->srv0, false,
+				    variant->num_layers >= 2, false);
 }
 
 TEST_F(tcp_layers, ruleset_expand)
@@ -1208,11 +1234,12 @@ TEST_F(tcp_layers, ruleset_expand)
 		EXPECT_EQ(0, close(ruleset_fd));
 	}
 
-	test_bind_and_connect(_metadata, &self->srv0, false,
-			      variant->num_layers >= 3);
+	test_restricted_net_fixture(_metadata, &self->srv0, false,
+				    variant->num_layers >= 3, false);
 
-	test_bind_and_connect(_metadata, &self->srv1, variant->num_layers >= 1,
-			      variant->num_layers >= 2);
+	test_restricted_net_fixture(_metadata, &self->srv1,
+				    variant->num_layers >= 1,
+				    variant->num_layers >= 2, false);
 }
 
 /* clang-format off */
@@ -1230,16 +1257,6 @@ FIXTURE_TEARDOWN(mini)
 {
 }
 
-/* clang-format off */
-
-#define ACCESS_LAST LANDLOCK_ACCESS_NET_CONNECT_TCP
-
-#define ACCESS_ALL ( \
-	LANDLOCK_ACCESS_NET_BIND_TCP | \
-	LANDLOCK_ACCESS_NET_CONNECT_TCP)
-
-/* clang-format on */
-
 TEST_F(mini, network_access_rights)
 {
 	const struct landlock_ruleset_attr ruleset_attr = {
@@ -1454,8 +1471,9 @@ TEST_F(mini, tcp_port_overflow)
 
 	enforce_ruleset(_metadata, ruleset_fd);
 
-	test_bind_and_connect(_metadata, &srv_denied, true, true);
-	test_bind_and_connect(_metadata, &srv_max_allowed, false, false);
+	test_restricted_net_fixture(_metadata, &srv_denied, true, true, false);
+	test_restricted_net_fixture(_metadata, &srv_max_allowed, false, false,
+				    false);
 }
 
 FIXTURE(ipv4_tcp)
@@ -1485,22 +1503,21 @@ FIXTURE_TEARDOWN(ipv4_tcp)
 TEST_F(ipv4_tcp, port_endianness)
 {
 	const struct landlock_ruleset_attr ruleset_attr = {
-		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
-				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.handled_access_net = ACCESS_ALL,
 	};
 	const struct landlock_net_port_attr bind_host_endian_p0 = {
 		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
 		/* Host port format. */
 		.port = self->srv0.port,
 	};
-	const struct landlock_net_port_attr connect_big_endian_p0 = {
-		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	const struct landlock_net_port_attr connect_listen_big_endian_p0 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP |
+				  LANDLOCK_ACCESS_NET_LISTEN_TCP,
 		/* Big endian port format. */
 		.port = htons(self->srv0.port),
 	};
-	const struct landlock_net_port_attr bind_connect_host_endian_p1 = {
-		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
-				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	const struct landlock_net_port_attr not_restricted_host_endian_p1 = {
+		.allowed_access = ACCESS_ALL,
 		/* Host port format. */
 		.port = self->srv1.port,
 	};
@@ -1514,16 +1531,18 @@ TEST_F(ipv4_tcp, port_endianness)
 	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
 				       &bind_host_endian_p0, 0));
 	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
-				       &connect_big_endian_p0, 0));
+				       &connect_listen_big_endian_p0, 0));
 	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
-				       &bind_connect_host_endian_p1, 0));
+				       &not_restricted_host_endian_p1, 0));
 	enforce_ruleset(_metadata, ruleset_fd);
 
 	/* No restriction for big endinan CPU. */
-	test_bind_and_connect(_metadata, &self->srv0, false, little_endian);
+	test_restricted_net_fixture(_metadata, &self->srv0, false,
+				    little_endian, little_endian);
 
 	/* No restriction for any CPU. */
-	test_bind_and_connect(_metadata, &self->srv1, false, false);
+	test_restricted_net_fixture(_metadata, &self->srv1, false, false,
+				    false);
 }
 
 TEST_F(ipv4_tcp, with_fs)
@@ -1691,7 +1710,7 @@ TEST_F(port_specific, bind_connect_zero)
 	ret = bind_variant(bind_fd, &self->srv0);
 	EXPECT_EQ(0, ret);
 
-	EXPECT_EQ(0, listen(bind_fd, backlog));
+	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
 
 	/* Connects on port 0. */
 	ret = connect_variant(connect_fd, &self->srv0);
@@ -1714,26 +1733,23 @@ TEST_F(port_specific, bind_connect_zero)
 	EXPECT_EQ(0, close(bind_fd));
 }
 
-TEST_F(port_specific, bind_connect_1023)
+TEST_F(port_specific, port_1023)
 {
 	int bind_fd, connect_fd, ret;
 
-	/* Adds a rule layer with bind and connect actions. */
+	/* Adds a rule layer with all actions. */
 	if (variant->sandbox == TCP_SANDBOX) {
 		const struct landlock_ruleset_attr ruleset_attr = {
-			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
-					      LANDLOCK_ACCESS_NET_CONNECT_TCP
+			.handled_access_net = ACCESS_ALL
 		};
 		/* A rule with port value less than 1024. */
-		const struct landlock_net_port_attr tcp_bind_connect_low_range = {
-			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
-					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		const struct landlock_net_port_attr tcp_low_range_port = {
+			.allowed_access = ACCESS_ALL,
 			.port = 1023,
 		};
 		/* A rule with 1024 port. */
-		const struct landlock_net_port_attr tcp_bind_connect = {
-			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
-					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		const struct landlock_net_port_attr tcp_port_1024 = {
+			.allowed_access = ACCESS_ALL,
 			.port = 1024,
 		};
 		int ruleset_fd;
@@ -1744,10 +1760,10 @@ TEST_F(port_specific, bind_connect_1023)
 
 		ASSERT_EQ(0,
 			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
-					    &tcp_bind_connect_low_range, 0));
+					    &tcp_low_range_port, 0));
 		ASSERT_EQ(0,
 			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
-					    &tcp_bind_connect, 0));
+					    &tcp_port_1024, 0));
 
 		enforce_ruleset(_metadata, ruleset_fd);
 		EXPECT_EQ(0, close(ruleset_fd));
@@ -1771,7 +1787,7 @@ TEST_F(port_specific, bind_connect_1023)
 	ret = bind_variant(bind_fd, &self->srv0);
 	clear_cap(_metadata, CAP_NET_BIND_SERVICE);
 	EXPECT_EQ(0, ret);
-	EXPECT_EQ(0, listen(bind_fd, backlog));
+	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
 
 	/* Connects on the binded port 1023. */
 	ret = connect_variant(connect_fd, &self->srv0);
@@ -1791,7 +1807,7 @@ TEST_F(port_specific, bind_connect_1023)
 	/* Binds on port 1024. */
 	ret = bind_variant(bind_fd, &self->srv0);
 	EXPECT_EQ(0, ret);
-	EXPECT_EQ(0, listen(bind_fd, backlog));
+	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
 
 	/* Connects on the binded port 1024. */
 	ret = connect_variant(connect_fd, &self->srv0);
-- 
2.34.1

