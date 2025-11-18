Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2DE2F6197;
	Tue, 18 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473632; cv=none; b=f8efp2Akk1qiiVI3XaUv4DaSMkbc0vz5CKXVFa/XNZSv8oZUHkpuaagjqhB4QjEkbu3mA67tQc3EFzkI5oLAAzEx6k3vvu8T92GGlRRRmj1WGblfVbL+ZyxofAY4hqOG8mIVzYVftdBiu51VMrAXlXQPI3qVvr/745JioSLoTuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473632; c=relaxed/simple;
	bh=Bfv2N7IJjt65NfbcWNYWNe3b/i+a8fU6NsVSYWm10Ns=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r5pFlPREAzns+NS7hb6qoQqF1P6EwXlV2ogCf/Gh6H0S6YeFNdQUde1L45cbbIP1BVCacoIOX2/T+VAJKwkXR3TfI81oKjAVTUmu0+Q6GfA81B1mGm5MYXWVNGIG89Ttx7GdbauCeEVU7UzakYfulyKeZjKdT0gsCQKuhbkB7YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9V6QJFzJ46XL;
	Tue, 18 Nov 2025 21:46:22 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 36AE014033F;
	Tue, 18 Nov 2025 21:47:05 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:04 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 05/19] selftests/landlock: Test acceptable ranges of socket rule key
Date: Tue, 18 Nov 2025 21:46:25 +0800
Message-ID: <20251118134639.3314803-6-ivanov.mikhail1@huawei-partners.com>
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

Create fixture "protocol_inside_range" and "protocol_outside_range"
examining acceptable limits of family, type and protocol values
supported by Landlock ruleset.

Add test validating Landlock behaviour of adding rule with values
corresponding to the limits of the acceptable range and with values
beyond the acceptable ranges.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 .../testing/selftests/landlock/socket_test.c  | 189 ++++++++++++++++++
 1 file changed, 189 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index abcef11aaf39..16477614dfed 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -190,4 +190,193 @@ TEST_F(mini, rule_with_wildcard)
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 
+/* clang-format off */
+FIXTURE(prot_inside_range) {};
+/* clang-format on */
+
+FIXTURE_VARIANT(prot_inside_range)
+{
+	int family, type, protocol;
+};
+
+FIXTURE_SETUP(prot_inside_range)
+{
+	disable_caps(_metadata);
+};
+
+FIXTURE_TEARDOWN(prot_inside_range)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_inside_range, family_upper) {
+	/* clang-format on */
+	.family = UINT8_MAX - 1,
+	.type = SOCK_STREAM,
+	.protocol = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_inside_range, type_upper) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = UINT8_MAX - 1,
+	.protocol = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_inside_range, protocol_upper) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = SOCK_STREAM,
+	.protocol = UINT16_MAX - 1,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_inside_range, family_lower) {
+	/* clang-format on */
+	.family = 0,
+	.type = SOCK_STREAM,
+	.protocol = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_inside_range, type_lower) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = 0,
+	.protocol = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_inside_range, protocol_lower) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = SOCK_STREAM,
+	.protocol = 0,
+};
+
+/*
+ * Verifies acceptable range of family, type and protocol values. Specific
+ * case of adding rule with masked fields checked in "rule_with_wildcard"
+ * test.
+ *
+ * Acceptable ranges are [0, UINT8_MAX) for family and type,
+ * [0, UINT16_MAX) for protocol field.
+ */
+TEST_F(prot_inside_range, add_rule)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_socket_attr create_socket_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = variant->family,
+		.type = variant->type,
+		.protocol = variant->protocol,
+	};
+	int ruleset_fd;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &create_socket_attr, 0));
+	ASSERT_EQ(0, close(ruleset_fd));
+}
+
+/* clang-format off */
+FIXTURE(prot_outside_range) {};
+/* clang-format on */
+
+FIXTURE_VARIANT(prot_outside_range)
+{
+	int family, type, protocol;
+};
+
+FIXTURE_SETUP(prot_outside_range)
+{
+	disable_caps(_metadata);
+};
+
+FIXTURE_TEARDOWN(prot_outside_range)
+{
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_outside_range, family_upper) {
+	/* clang-format on */
+	.family = UINT8_MAX,
+	.type = SOCK_STREAM,
+	.protocol = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_outside_range, type_upper) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = UINT8_MAX,
+	.protocol = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_outside_range, protocol_upper) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = SOCK_STREAM,
+	.protocol = UINT16_MAX,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_outside_range, family_lower) {
+	/* clang-format on */
+	.family = -1,
+	.type = SOCK_STREAM,
+	.protocol = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_outside_range, type_lower) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = -2,
+	.protocol = 0,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(prot_outside_range, protocol_lower) {
+	/* clang-format on */
+	.family = AF_INET,
+	.type = SOCK_STREAM,
+	.protocol = -2,
+};
+
+/*
+ * Acceptable ranges are [0, UINT8_MAX) for family and type,
+ * [0, UINT16_MAX) for protocol field. Also type and protocol
+ * can be set with specific -1 wildcard value.
+ */
+TEST_F(prot_outside_range, add_rule)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_socket_attr create_socket_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = variant->family,
+		.type = variant->type,
+		.protocol = variant->protocol,
+	};
+	int ruleset_fd;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					&create_socket_attr, 0));
+	ASSERT_EQ(0, close(ruleset_fd));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

