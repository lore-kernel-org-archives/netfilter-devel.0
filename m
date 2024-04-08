Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28656495CB;
	Mon,  8 Apr 2024 09:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569216; cv=none; b=jo7CEP3ai5FNGHin8XztOSlVkTeMJ2BtReRHn2gO5hYopspsORGmY9JnC1Cn57smN6BdONQ+WhE5WQEJ1iCTPsEF8jh6EMFOL85b8RR/ws8KUWa0Mxi98gQHlnkNRsUuClrJ263XuNTgQX4ToL2IjVsJ20n5/wmougvxZtmiOFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569216; c=relaxed/simple;
	bh=YHPh52Z03W1pKn7SJKKJSBKFh12yRe6HRgBf4lWwxK4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JqOe6zxolCM4YCapsj+FOPiyTf/OW76s9KlMGtKnYc1X7vMcB8l3ypARGYGKgwaVTWjGXSugDGsscHzDPnvxynyuhUYOr808qI5/vK2m18eb4kPGvkcl9OL6DT72Hz+WcvYDvddeGrUYCkpaP5B46Ac2BVwXfTizeOHt78SAMic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VCkX20rKBz29dPS;
	Mon,  8 Apr 2024 17:37:22 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 3BCE518005F;
	Mon,  8 Apr 2024 17:40:12 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:40:10 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 04/10] selftests/landlock: Create 'socket_access_rights' test
Date: Mon, 8 Apr 2024 17:39:21 +0800
Message-ID: <20240408093927.1759381-5-ivanov.mikhail1@huawei-partners.com>
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

Add test that checks possibility of adding rule with every possible
access right.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 .../testing/selftests/landlock/socket_test.c  | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 525f4f7df..7f31594bf 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -194,4 +194,33 @@ TEST_F(protocol, create)
 	test_socket_create(_metadata, &self->srv0, true);
 }
 
+TEST_F(protocol, socket_access_rights)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = ACCESS_ALL,
+	};
+	struct landlock_socket_attr protocol = {
+		.domain = self->srv0.protocol.domain,
+		.type = self->srv0.protocol.type,
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
+		EXPECT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					    &protocol, 0))
+		{
+			TH_LOG("Failed to add rule with access 0x%llx: %s",
+			       access, strerror(errno));
+		}
+	}
+	EXPECT_EQ(0, close(ruleset_fd));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

