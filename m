Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939791CFECB;
	Wed,  4 Sep 2024 10:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446927; cv=none; b=NjpFGJY96Mh2wKuJm9f9ZjHtsots+eVFyXpsSC+Oyq57G/N4jknBlrLX2aH13I2MM9kYA1qKQPbzSpxA4aarAskALUiLfTBW+tPfzTCxkaXA7+pni3kiRoz/ZdaNk8aLraewiffrBdtHDLw6/8KcVe50XWjJluGddCvO+OSW3oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446927; c=relaxed/simple;
	bh=DMWIp23DCEJuE85kq8d8o/CuzEiXpGfF0Ueszsrw4oE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhrgwuqAyvWigfmw2CtuhX1y5U5AvZOXX+Cg9K3TWFxgSU4RD9FvdVZc+ND7O3ObTzZqKbkQsCZVMmOr1KV3OXdVlegcK3JAVmytrxfUwUrsnihWsXKa4wQPn4FkNkNYj3KAbzga9oP/JDqVr2ImBj0cD3JElJn+3RTbwvychGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzJzZ6cDpz1HJ8y;
	Wed,  4 Sep 2024 18:45:14 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 651601402CC;
	Wed,  4 Sep 2024 18:48:42 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:40 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 05/19] selftests/landlock: Test adding a rule for each unknown access
Date: Wed, 4 Sep 2024 18:48:10 +0800
Message-ID: <20240904104824.1844082-6-ivanov.mikhail1@huawei-partners.com>
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

Add test that validates behaviour of Landlock after rule with
unknown access is added.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v2:
* Replaces EXPECT_EQ with ASSERT_EQ for close().
* Refactors commit title.

Changes since v1:
* Refactors commit messsage.
---
 .../testing/selftests/landlock/socket_test.c  | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index cb23efd3ccc9..811bdaa95a7a 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -325,4 +325,30 @@ TEST_F(protocol, socket_access_rights)
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 
+TEST_F(protocol, rule_with_unknown_access)
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
 TEST_HARNESS_MAIN
-- 
2.34.1

