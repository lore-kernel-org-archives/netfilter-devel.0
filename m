Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C814D59B;
	Mon,  8 Apr 2024 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569219; cv=none; b=ttOvxAauvB+Hkep0NM3EXKXVtlBuiE0TO3WUsBMOmtL9MYDoLJmyOp1E4UokMWHzMtRpIWuyzzzrTCtTmk+VVhRFRzCBnrRhOyVfZFoKLSB8rJe6xM+Mowp4NQFpMwguw1aTIm9QgaQSXKyP/pRsMLfHPbXfSbC8DeFZHWhEI1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569219; c=relaxed/simple;
	bh=8SeWdBwFx4/0oEQ+jBIUZiY0+zJ2LpipA1kIPPkJMKY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JkDt2zICASc40hzMoVzw+fRtL8QHLrLY09RSHRAJzlG2NHhi6YvO6X2SsRkj/ULToButaJe9Ogq1Js3GF6NejohkA+K+y22jOlZF8piuxI6bLUYa+3MfStrsRTRb060el4iO1S4hwIJEg/H2hXuOCMSKWXbYxRm/HS5OXe7Wceo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VCkXp6FNvz1ymHY;
	Mon,  8 Apr 2024 17:38:02 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 572C01401E9;
	Mon,  8 Apr 2024 17:40:16 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:40:14 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 06/10] selftests/landlock: Create 'rule_with_unhandled_access' test
Date: Mon, 8 Apr 2024 17:39:23 +0800
Message-ID: <20240408093927.1759381-7-ivanov.mikhail1@huawei-partners.com>
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

Add test that validates behavior of landlock after rule with
unhandled access is added.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 .../testing/selftests/landlock/socket_test.c  | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 5577b08d5..c1c2b5d30 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -249,4 +249,37 @@ TEST_F(protocol, rule_with_unknown_access)
 	EXPECT_EQ(0, close(ruleset_fd));
 }
 
+TEST_F(protocol, rule_with_unhandled_access)
+{
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
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
+	for (access = 1; access > 0; access <<= 1) {
+		int err;
+
+		protocol.allowed_access = access;
+		err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					&protocol, 0);
+		if (access == ruleset_attr.handled_access_socket) {
+			EXPECT_EQ(0, err);
+		} else {
+			EXPECT_EQ(-1, err);
+			EXPECT_EQ(EINVAL, errno);
+		}
+	}
+
+	EXPECT_EQ(0, close(ruleset_fd));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

