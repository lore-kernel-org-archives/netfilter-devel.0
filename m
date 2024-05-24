Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4128612C;
	Fri, 24 May 2024 09:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543072; cv=none; b=JbMwDmyaAvh2/fJcuvX1wX1Za1sgYbHuSCSp0agihg0S2Gekst4ewRqPUl8mEil0sdk5EFuVTjnGCBiJUWtCAx7n+WonT/9M14PVt8fvbyDKgv2E7HNejetugOizebKCD48WdQDGtphmQuqJBz1hvsB6AZ9VmRVij8uzKqgRELc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543072; c=relaxed/simple;
	bh=84g9o5v72dYyI4CMgJLcxvV2pF5YMVFNegl/wbvvSUQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l81zIl+t6hDgi90ApVtDEvOFq/tcyE1RzFqi0ThMjIa+sGEKmcXwnV4g1DiNZoSLolt5jbgA1bjmJaQs5FziHprb8O5ga+NSMRDhEE/+ox83SARHjbemsRrTR+tx7ytueSiXQKp0VcnBeX2f+8fMW1nkWL7yf+vJ9mcmiLmSRqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Vm0845DJPzPlm4;
	Fri, 24 May 2024 17:28:04 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id E80F9140132;
	Fri, 24 May 2024 17:31:08 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 24 May 2024 17:31:07 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 08/12] selftests/landlock: Add tcp_layers.ruleset_overlap to socket tests
Date: Fri, 24 May 2024 17:30:11 +0800
Message-ID: <20240524093015.2402952-9-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml100004.china.huawei.com (7.188.51.133) To
 dggpemm500020.china.huawei.com (7.185.36.49)

* Add tcp_layers fixture for tests that check multiple layer
  configuration scenarios.

* Add test that validates multiple layer behavior with overlapped
  restrictions.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Replaces test_socket_create() with test_socket().
* Formats code with clang-format.
* Refactors commit message.
* Minor fixes.
---
 .../testing/selftests/landlock/socket_test.c  | 109 ++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 751596c381fe..52edc1a8ac21 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -299,4 +299,113 @@ TEST_F(protocol, inval)
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
+		.family = AF_INET,
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
+		.family = self->srv0.protocol.family,
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
+		ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					       &tcp_create, 0));
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
+		ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					       &tcp_create, 0));
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+
+	if (variant->num_layers < 2) {
+		ASSERT_EQ(0, test_socket(&self->srv0));
+	} else {
+		ASSERT_EQ(EACCES, test_socket(&self->srv0));
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

