Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6EC30E822;
	Tue, 18 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473632; cv=none; b=Vw7n6xv8C3+YjBwIY/Ath7B9t4ugEPgopabjaQT/Wnq7uYsnLMlhArlN3i1QMN0ilozTwcy7b9Hv4L/zmY2eyiY3WWsC9QvAD9BzC0VDtpdfPDWfV6g1J5CWW/u4GCpdor0lOFsYEnzi14Ea8/QAXovYQZ2R9k5EVYWIGLvmi8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473632; c=relaxed/simple;
	bh=R0cUGuKzJt5XwuKJzwHeFVqVhaVCZK9i0w8g4pwL6Rc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=inuqe1kUYPVfjTQwam5o/4WeJQmQ15Ov04s75nTe/x4L+OA3kO2ArMX6al3lZZ4uxnCtskj+MmEy2wCN7ZnOHJRMgy8hbYw8FsmnRvLYBGqMyVLCMtjdccYM8BlpmsLzZtb3SJyiPPGRK4tVj6fH2T8mxFC6Ndd94ISvl1IckZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9k0lsZzHnH6v;
	Tue, 18 Nov 2025 21:46:34 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 05A2914033F;
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
Subject: [RFC PATCH v4 03/19] selftests/landlock: Test adding a socket rule
Date: Tue, 18 Nov 2025 21:46:23 +0800
Message-ID: <20251118134639.3314803-4-ivanov.mikhail1@huawei-partners.com>
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

Add test that validates behaviour of Landlock after rule of
LANDLOCK_RULE_SOCKET type is added
  * with all possible access rights;
  * with unknown access rights;
  * with unhandled access rights;
  * with empty access.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Squashes commits related to checking rule adding
* Removes "protocol" fixture dependency. Use single TCP protocol for
  testing instead.
* Fixes semantics of test "rule_with_unhandled_access".

Changes since v2:
* Replaces EXPECT_EQ with ASSERT_EQ for close().
* Refactors commit message and title.

Changes since v1:
* Formats code with clang-format.
* Refactors commit message.
---
 .../testing/selftests/landlock/socket_test.c  | 107 ++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index d5716149d03f..fcc0f92075a7 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -44,4 +44,111 @@ TEST_F(mini, ruleset_with_unknown_access)
 	}
 }
 
+TEST_F(mini, rule_with_supported_access)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = ACCESS_ALL,
+	};
+	struct landlock_socket_attr protocol = {
+		.family = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = 0,
+	};
+	int ruleset_fd;
+	__u64 access;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	for (access = 1; access <= ACCESS_LAST; access <<= 1) {
+		protocol.allowed_access = access;
+		EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					       &protocol, 0))
+		{
+			TH_LOG("Failed to add rule with access 0x%llx: %s",
+			       access, strerror(errno));
+		}
+	}
+	ASSERT_EQ(0, close(ruleset_fd));
+}
+
+TEST_F(mini, rule_with_unknown_access)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = ACCESS_ALL,
+	};
+	struct landlock_socket_attr protocol = { .family = AF_INET,
+						 .type = SOCK_STREAM,
+						 .protocol = 0 };
+	int ruleset_fd;
+	__u64 access;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	for (access = 1ULL << 63; access != ACCESS_LAST; access >>= 1) {
+		protocol.allowed_access = access;
+		EXPECT_EQ(-1,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					    &protocol, 0));
+		EXPECT_EQ(EINVAL, errno);
+	}
+	ASSERT_EQ(0, close(ruleset_fd));
+}
+
+TEST_F(mini, rule_with_unhandled_access)
+{
+	/* Prepares ruleset that handles network access instead of socket access. */
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
+	};
+	struct landlock_socket_attr protocol = { .family = AF_UNIX,
+						 .type = SOCK_STREAM,
+						 .protocol = 0 };
+	int ruleset_fd;
+	__u64 access;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	for (access = ACCESS_LAST; access > 0; access <<= 1) {
+		int err;
+
+		protocol.allowed_access = access;
+		err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					&protocol, 0);
+		EXPECT_EQ(-1, err);
+		EXPECT_EQ(EINVAL, errno);
+	}
+
+	ASSERT_EQ(0, close(ruleset_fd));
+}
+
+TEST_F(mini, rule_with_empty_access)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE
+	};
+	const struct landlock_socket_attr protocol_denied = {
+		.allowed_access = 0,
+		.family = AF_UNIX,
+		.type = SOCK_STREAM,
+		.protocol = 0,
+	};
+	int ruleset_fd;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Checks zero access value. */
+	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					&protocol_denied, 0));
+	EXPECT_EQ(ENOMSG, errno);
+	ASSERT_EQ(0, close(ruleset_fd));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

