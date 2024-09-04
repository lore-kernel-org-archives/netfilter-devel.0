Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EFE1D04B7;
	Wed,  4 Sep 2024 10:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446932; cv=none; b=gzGO2TYaPpiJ0rLkmIPaz68rQ/WFZywwdzycQcmyON2rCCsnPQxkCo0UIrIS3rFQ1nUxy4CLR5PzKDYASbkHsa9UBZe1EhdUkCcAwD2g2fP8bS2VXMCg2xafm+4R6I5Ua2tgtph1EwibZj5Dl+1N9xrFGNKST3900yjeU2f9b4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446932; c=relaxed/simple;
	bh=1TZhJzlO00aCdwJpkKrXG/0VbvdylOHLISqm2YEswCs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AP/duVWT07PYYiGv201e08fHhBbUljFwMt91g10Rl1v830y23sxAJ8CWq5ekHrHUtnBCYbRVT61mXbax7IZ1ZthnB4mTk4kh6sfNnZq2wm7j/rJd9jVU9Cj8f3iApl9jzn6MbX73qRmaVZxQtn30gOMJT0obYCEy6iTS+svN8Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WzK1D1l7LzgYvP;
	Wed,  4 Sep 2024 18:46:40 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 73A47180AE6;
	Wed,  4 Sep 2024 18:48:47 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:45 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 08/19] selftests/landlock: Test overlapped restriction
Date: Wed, 4 Sep 2024 18:48:13 +0800
Message-ID: <20240904104824.1844082-9-ivanov.mikhail1@huawei-partners.com>
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

Add test that validates Landlock behaviour with overlapped socket
restriction.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
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
 .../testing/selftests/landlock/socket_test.c  | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index d323f649a183..e7b4165a85cd 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -417,4 +417,50 @@ TEST_F(protocol, rule_with_empty_access)
 	ASSERT_EQ(0, close(ruleset_fd));
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
+TEST_F(protocol, ruleset_overlap)
+{
+	const struct landlock_socket_attr create_socket_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = self->prot.family,
+		.type = self->prot.type,
+	};
+
+	/* socket(2) is allowed if there are no restrictions. */
+	ASSERT_EQ(0, test_socket_variant(&self->prot));
+
+	/* Creates ruleset with socket(2) allowed. */
+	add_ruleset_layer(_metadata, &create_socket_attr);
+	EXPECT_EQ(0, test_socket_variant(&self->prot));
+
+	/* Adds ruleset layer with socket(2) restricted. */
+	add_ruleset_layer(_metadata, NULL);
+	EXPECT_EQ(EACCES, test_socket_variant(&self->prot));
+
+	/*
+	 * Adds ruleset layer with socket(2) allowed. socket(2) is restricted
+	 * by second layer of the ruleset.
+	 */
+	add_ruleset_layer(_metadata, &create_socket_attr);
+	EXPECT_EQ(EACCES, test_socket_variant(&self->prot));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

