Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5A2482E9;
	Mon,  8 Apr 2024 09:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569224; cv=none; b=HhW7ivmj6gnWKdt+sis8c/KQ5waQc99/MKINceZQWfLQbRRP8EzZJheyCYWAWC4i1w3DjhKdYeUpgq4diGrzDM6+xT4b204C0AqACdZNqSswZyJLJpmfZhECJBgma/0MImU/ss6pkQOz7HVvqoTYqswYs9K7OL3Fx5As9kYHwio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569224; c=relaxed/simple;
	bh=JrikPBy7AnB+J5XvO4rxiRuxdBWn74dh3dvl28232M4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DPeaHKpmXZJZY/epWyFCVjrVeGvI9TcQ/GBibsNdOuXj+3Cc+qD5UJnAIhMnN2YZbW0xWcpnFfkdyQeTKyTVG+f8kRcEG2EjeF1SxCcOcUIZb0coSSYaUq3nuszzwgJvBle7keg+YvX6MupmzcnVuIKzrlpKWJILPj3LkUG4i5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VCkXB4dzXz1h64n;
	Mon,  8 Apr 2024 17:37:30 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 8D62F18005F;
	Mon,  8 Apr 2024 17:40:20 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:40:18 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 08/10] selftests/landlock: Create 'ruleset_overlap' test
Date: Mon, 8 Apr 2024 17:39:25 +0800
Message-ID: <20240408093927.1759381-9-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Add tcp_layers fixture for tests that check multiple layer configuration
scenarios.
Add test that validates multiple layer behavior with overlapped
restrictions.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 .../testing/selftests/landlock/socket_test.c  | 107 ++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index dd105489d..07f73618d 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -316,4 +316,111 @@ TEST_F(protocol, inval)
 				       &protocol, 0));
 }
 
+FIXTURE(tcp_layers)
+{
+	struct service_fixture srv0;
+};
+
+FIXTURE_VARIANT(tcp_layers)
+{
+	const size_t num_layers;
+};
+
+FIXTURE_SETUP(tcp_layers)
+{
+	const struct protocol_variant prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+	};
+
+	disable_caps(_metadata);
+	self->srv0.protocol = prot;
+	setup_namespace(_metadata);
+};
+
+FIXTURE_TEARDOWN(tcp_layers)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, no_sandbox_with_ipv4) {
+	/* clang-format on */
+	.num_layers = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, one_sandbox_with_ipv4) {
+	/* clang-format on */
+	.num_layers = 1,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, two_sandboxes_with_ipv4) {
+	/* clang-format on */
+	.num_layers = 2,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tcp_layers, three_sandboxes_with_ipv4) {
+	/* clang-format on */
+	.num_layers = 3,
+};
+
+TEST_F(tcp_layers, ruleset_overlap)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_socket_attr tcp_create = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.domain = self->srv0.protocol.domain,
+		.type = self->srv0.protocol.type,
+	};
+
+	if (variant->num_layers >= 1) {
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Allows create. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					    &tcp_create, 0));
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	if (variant->num_layers >= 2) {
+		int ruleset_fd;
+
+		/* Creates another ruleset layer with denied create. */
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	if (variant->num_layers >= 3) {
+		int ruleset_fd;
+
+		/* Creates another ruleset layer. */
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Try to allow create second time. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					    &tcp_create, 0));
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	test_socket_create(_metadata, &self->srv0, variant->num_layers >= 2);
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

