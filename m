Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B411303A35;
	Tue, 18 Nov 2025 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473636; cv=none; b=OZJ+zh7dCxvLvEk6UezV//2nuBniDW6EKcRRCaULLzdeJdKt8HdaYKPvEO8duG8Y5+yYiUW7zE7s7UvxWsl2RgG/dK2yJLft8mSysVHbXJz2r1/PioZEIoMvJo+CzjbC4z9E861xPnJFmigO57ZNcdciAs5Rhhc6Gy966uA4Cyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473636; c=relaxed/simple;
	bh=OmWgf5pTiYf+LWIz9kaF4Ay7sRI2ktYbTbtuTlgJTR8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M9WaZdBidSIzNt8oqTva5zeWRR1UknKMku+UYZIOINupBTIE7APbsoF29c9yw1YwL7MND5a9wqNv0Vp0OqjrTdG6fKrTx54kn0W0kpfc0xNgu6NqBca+hYmA8/SeCXQTH6IvC4QFVzgI13wMcerwaFn+8nlg60Bt8AIdc7Cm52E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9l1cwnzHnH7J;
	Tue, 18 Nov 2025 21:46:35 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 22289140277;
	Tue, 18 Nov 2025 21:47:06 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:05 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 11/19] selftests/landlock: Test protocol mappings
Date: Tue, 18 Nov 2025 21:46:31 +0800
Message-ID: <20251118134639.3314803-12-ivanov.mikhail1@huawei-partners.com>
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

It is possible to create sockets of the same protocol with different
protocol number (cf. socket(2)) values. For example, TCP sockets can
be created using one of the following commands:
	1. fd = socket(AF_INET, SOCK_STREAM, 0);
	2. fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
Whereas IPPROTO_TCP = 6. Protocol number 0 correspond to the default
protocol of the given protocol family and can be mapped to another
value. Mapping is handled on the protocol family level.

Socket rules should not perform such mappings to not increase complexity
of rules definition and their maintenance.

(AF_INET, SOCK_PACKET) is an alias for (AF_PACKET, SOCK_PACKET)
(cf. __sock_create) handled due to compatibility reasons. Compared to TCP
network stack performs mapping before calling LSM hook related to socket
creation. Therefore Landlock should not restrict one pair if the other
was allowed.

Add `packet_protocol` and `tcp_protocol` fixtures and tests to validate
these scenarios.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Adds verification of TCP mapping.
* Changes commit message.
---
 .../testing/selftests/landlock/socket_test.c  | 157 ++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index ce9a6e283be6..e22e10edb103 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -709,4 +709,161 @@ TEST_F(mini, kernel_socket)
 	EXPECT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
 }
 
+/* clang-format off */
+FIXTURE(packet_protocol) {};
+/* clang-format on */
+
+FIXTURE_VARIANT(packet_protocol)
+{
+	int family, type, protocol;
+};
+
+/* clang-format off */
+FIXTURE_SETUP(packet_protocol) {};
+/* clang-format on */
+
+FIXTURE_TEARDOWN(packet_protocol)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(packet_protocol, pf_inet) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = SOCK_PACKET,
+	.protocol = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(packet_protocol, pf_packet) {
+	/* clang-format on */
+	.family = AF_PACKET,
+	.type = SOCK_PACKET,
+	.protocol = 0,
+};
+
+/*
+ * (AF_INET, SOCK_PACKET) is an alias for the (AF_PACKET, SOCK_PACKET)
+ * handled in socket layer (cf. __sock_create) due to compatibility reasons.
+ *
+ * Checks that Landlock does not restrict one pair if the other was allowed.
+ */
+TEST_F(packet_protocol, alias_restriction)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const int family = variant->family;
+	const int type = variant->type;
+	const int protocol = variant->protocol;
+	const struct landlock_socket_attr packet_socket_create = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = family,
+		.type = type,
+		.protocol = protocol,
+	};
+	int ruleset_fd;
+
+	/*
+	 * Checks that packet socket is created successfully without
+	 * landlock restrictions.
+	 *
+	 * Packet sockets require CAP_NET_RAW capability.
+	 */
+	set_cap(_metadata, CAP_NET_RAW);
+	ASSERT_EQ(0, test_socket(AF_INET, SOCK_PACKET, 0));
+	ASSERT_EQ(0, test_socket(AF_PACKET, SOCK_PACKET, 0));
+	clear_cap(_metadata, CAP_NET_RAW);
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &packet_socket_create, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	set_cap(_metadata, CAP_NET_RAW);
+	EXPECT_EQ(0, test_socket(AF_INET, SOCK_PACKET, 0));
+	EXPECT_EQ(0, test_socket(AF_PACKET, SOCK_PACKET, 0));
+	clear_cap(_metadata, CAP_NET_RAW);
+}
+
+/* clang-format off */
+FIXTURE(tcp_protocol) {};
+/* clang-format on */
+
+FIXTURE_VARIANT(tcp_protocol)
+{
+	int family, type, protocol;
+};
+
+/* clang-format off */
+FIXTURE_SETUP(tcp_protocol) {};
+/* clang-format on */
+
+FIXTURE_TEARDOWN(tcp_protocol)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_protocol, variant1) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = SOCK_STREAM,
+	.protocol = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_protocol, variant2) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = SOCK_STREAM,
+	.protocol = IPPROTO_TCP, /* = 6 */
+};
+
+/*
+ * Landlock doesn't perform protocol mappings handled by network stack on
+ * protocol family level. Test verifies that if only one definition is
+ * allowed another becomes restricted.
+ */
+TEST_F(tcp_protocol, alias_restriction)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const int family = variant->family;
+	const int type = variant->type;
+	const int protocol = variant->protocol;
+	const struct landlock_socket_attr tcp_socket_create = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = family,
+		.type = type,
+		.protocol = protocol,
+	};
+	int ruleset_fd;
+
+	ASSERT_EQ(0, test_socket(AF_INET, SOCK_STREAM, 0));
+	ASSERT_EQ(0, test_socket(AF_INET, SOCK_STREAM, IPPROTO_TCP));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &tcp_socket_create, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	if (protocol == 0) {
+		EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, 0));
+		EXPECT_EQ(EACCES,
+			  test_socket(AF_PACKET, SOCK_STREAM, IPPROTO_TCP));
+	} else if (protocol == IPPROTO_TCP) {
+		EXPECT_EQ(EACCES, test_socket(AF_INET, SOCK_STREAM, 0));
+		EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, IPPROTO_TCP));
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

