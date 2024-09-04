Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8961482E1;
	Wed,  4 Sep 2024 10:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446925; cv=none; b=gA9vKQ/Cm9DxzTV62HkXBFcJg4LEbn6PzfSeavPNMju9tnnTOJ0AsmG3D9tonUvi8GHknirC8DT8ndn2Mqfm96TMKrMs06Pi+t0BQv2g67EewJbVjxkXbmtzT/kSDy1uWBYvxYl0jtA221RWanGd3GTH2NAkQUSSsDFCGN8BPjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446925; c=relaxed/simple;
	bh=XUNlpDrTDDyxqVvAj2OosIsnUgTacBe2iUBuvvfCjCM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AxkLU96dXuKqCR96ZmRWYykW2bQjBtBuhTrH3tdniK+FdBz2jZVEjBGOgMZ0g6aSnY9o9VKKhtmEYU+q3rjHqX71whn1/+oQxSjRZq0yjW+mIFIvP4MWnomIG624p/ZR97AtJVXkLmBkPt2h1/o/ik/EmrKWCZckBQntZiueFVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzJzY2DDCz1HJ8v;
	Wed,  4 Sep 2024 18:45:13 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id C1C8E1400D7;
	Wed,  4 Sep 2024 18:48:40 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:39 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 04/19] selftests/landlock: Test adding a rule with each supported access
Date: Wed, 4 Sep 2024 18:48:09 +0800
Message-ID: <20240904104824.1844082-5-ivanov.mikhail1@huawei-partners.com>
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

Add test that checks the possibility of adding rule of
`LANDLOCK_RULE_SOCKET` type with all possible access rights.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v2:
* Replaces EXPECT_EQ with ASSERT_EQ for close().
* Refactors commit message and title.

Changes since v1:
* Formats code with clang-format.
* Refactors commit message.
---
 .../testing/selftests/landlock/socket_test.c  | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 63bb269c9d07..cb23efd3ccc9 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -16,6 +16,9 @@
 
 #include "common.h"
 
+#define ACCESS_LAST LANDLOCK_ACCESS_SOCKET_CREATE
+#define ACCESS_ALL LANDLOCK_ACCESS_SOCKET_CREATE
+
 struct protocol_variant {
 	int family;
 	int type;
@@ -294,4 +297,32 @@ TEST_F(protocol, create)
 	EXPECT_EQ(EACCES, test_socket_variant(&self->prot));
 }
 
+TEST_F(protocol, socket_access_rights)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = ACCESS_ALL,
+	};
+	struct landlock_socket_attr protocol = {
+		.family = self->prot.family,
+		.type = self->prot.type,
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
 TEST_HARNESS_MAIN
-- 
2.34.1

