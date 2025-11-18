Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF64330DD1C;
	Tue, 18 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473632; cv=none; b=gVnO+ft3mpk705fR19vkVt4AMIwFtRnTGycjANy2t8+AtdbyxhvZ3xKmkt2+uVcq2yb/BZhKdHDqTG1Zn3vCHyGa9CplJrNrTtn4bQ+JAP0R5YhPsf2Qo7gEknEbLqYSr83cfaCk8QP7gFsrxOc2feKM8/gh07cCdZqosrnMZY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473632; c=relaxed/simple;
	bh=5Nt73loEtROSMEG6PpKMy/JeJuD2D0KwpsFgZpIgbrc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OTsXBtb7jyl1ZBhiKcxTUrAO8zpLmdI8wmBtuPs6PHsQJvs1o9IzlBOog9ik33p17YIMFyIYK6t3qQZvZ+/aBWI5wacgFFG9rUzbHjQLuUzbiVtuBrxG/YQ9gog2pZhf+nL/OGy+KF3NiKuoJlUtv3khvL/Nau8dqtrEUoHaUtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9W4NFwzJ467Y;
	Tue, 18 Nov 2025 21:46:23 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id E413E140277;
	Tue, 18 Nov 2025 21:47:05 +0800 (CST)
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
Subject: [RFC PATCH v4 09/19] selftests/landlock: Test overlapped rulesets with rules of protocol ranges
Date: Tue, 18 Nov 2025 21:46:29 +0800
Message-ID: <20251118134639.3314803-10-ivanov.mikhail1@huawei-partners.com>
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

Add test that validates Landlock behaviour with overlapped socket
restriction.

Add test that validates behaviour of using multiple layers that
define access for protocol ranges using wildcard values.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Adds test "ruleset_with_wildcards_overlap".

Changes since v2:
* Removes `tcp_layers` fixture and replaces it with `protocol` fixture
  for this test. protocol.ruleset_overlap tests every layers depth
  in a single run.
* Adds add_ruleset_layer() helper that enforces ruleset and allows access
  if such is given.
* Replaces EXPECT_EQ with ASSERT_EQ for close().
* Refactors commit message and title.

Changes since v1:
* Replaces test_socket_create() with test_socket().
* Formats code with clang-format.
* Refactors commit message.
* Minor fixes.
---
 .../testing/selftests/landlock/socket_test.c  | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index ebb39cbf9211..8b8913290a64 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -578,4 +578,96 @@ TEST_F(mini, unsupported_af_and_prot)
 	EXPECT_EQ(EACCES, test_socket(AF_UNIX, SOCK_STREAM, PF_UNIX + 1));
 }
 
+static void add_ruleset_layer(struct __test_metadata *const _metadata,
+			      const struct landlock_socket_attr *socket_attr)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	int ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	if (socket_attr) {
+		ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					       socket_attr, 0));
+	}
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+}
+
+TEST_F(mini, ruleset_overlap)
+{
+	const struct landlock_socket_attr create_socket_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = 0,
+	};
+
+	/* socket(2) is allowed if there are no restrictions. */
+	ASSERT_EQ(0, test_socket(AF_INET, SOCK_STREAM, 0));
+
+	/* Creates ruleset with socket(2) allowed. */
+	add_ruleset_layer(_metadata, &create_socket_attr);
+	EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, 0));
+
+	/* Adds ruleset layer with socket(2) restricted. */
+	add_ruleset_layer(_metadata, NULL);
+	EXPECT_EQ(EACCES, test_socket(AF_INET, SOCK_STREAM, 0));
+
+	/*
+	 * Adds ruleset layer with socket(2) allowed. socket(2) is restricted
+	 * by second layer of the ruleset.
+	 */
+	add_ruleset_layer(_metadata, &create_socket_attr);
+	EXPECT_EQ(EACCES, test_socket(AF_INET, SOCK_STREAM, 0));
+}
+
+TEST_F(mini, ruleset_with_wildcards_overlap)
+{
+	const struct landlock_socket_attr create_socket_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_INET,
+		.type = (-1),
+		.protocol = (-1),
+	};
+
+	/* socket(2) is allowed if there are no restrictions. */
+	ASSERT_EQ(0, test_socket(AF_INET, SOCK_STREAM, 0));
+	ASSERT_EQ(0, test_socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP));
+	ASSERT_EQ(0, test_socket(AF_INET, SOCK_DGRAM, 0));
+
+	/* Creates ruleset with AF_INET allowed. */
+	add_ruleset_layer(_metadata, &create_socket_attr);
+	EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, 0));
+	EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP));
+	EXPECT_EQ(0, test_socket(AF_INET, SOCK_DGRAM, 0));
+
+	const struct landlock_socket_attr create_socket_attr2 = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = (-1),
+	};
+	/* Creates layer with AF_INET + SOCK_STREAM allowed. */
+	add_ruleset_layer(_metadata, &create_socket_attr2);
+	EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, 0));
+	EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP));
+	EXPECT_EQ(EACCES, test_socket(AF_INET, SOCK_DGRAM, 0));
+
+	const struct landlock_socket_attr create_socket_attr3 = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = 0,
+	};
+	/* Creates layer with AF_INET + SOCK_STREAM + 0 allowed. */
+	add_ruleset_layer(_metadata, &create_socket_attr3);
+	EXPECT_EQ(0, test_socket(AF_INET, SOCK_STREAM, 0));
+	EXPECT_EQ(EACCES, test_socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP));
+	EXPECT_EQ(EACCES, test_socket(AF_INET, SOCK_DGRAM, 0));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

