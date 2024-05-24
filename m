Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFA03FBB7;
	Fri, 24 May 2024 09:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543066; cv=none; b=GC45rji10o3lNnmOnLn8TG54n0cPr0ECfo0IUx9U82w3iWXPmIsejyfekJfMDnamCruF4UzMVM/vLPDjYT1d96LYH4hI7EWCOyEpmr4HGBMZvbVtb0HMyV5fWdAauk4eJgal/xd1FGhwwYB/TFA294T//EbSq+AFwiq1rQMfMCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543066; c=relaxed/simple;
	bh=ciE6nblL9ir8n009raQIHua22NLhPElD//QfkV0PARY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aig2LUhqZlnUIkVleftFMeHbANJHJRP00565+IqIGd2JbrolKuU6CZRxQhNVZTLD6sC3ND940e3f3chiQztNYlt40CxxCUgavMdgg8imkputWLkR4S8mb84tREHlO9oh5LJKNb4QTg6s6x2/mHt255yCw25dtnKBbinBDZosBys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Vm07R3P3vz1S5bR;
	Fri, 24 May 2024 17:27:31 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 806891A016C;
	Fri, 24 May 2024 17:31:02 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 24 May 2024 17:31:00 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 04/12] selftests/landlock: Add protocol.socket_access_rights to socket tests
Date: Fri, 24 May 2024 17:30:07 +0800
Message-ID: <20240524093015.2402952-5-ivanov.mikhail1@huawei-partners.com>
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

Add test that checks possibility of adding rule with every possible
access right.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Formats code with clang-format.
* Refactors commit message.
---
 .../testing/selftests/landlock/socket_test.c  | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 4c51f89ed578..eb5d62263460 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -178,4 +178,32 @@ TEST_F(protocol, create)
 	ASSERT_EQ(EAFNOSUPPORT, test_socket(&self->unspec_srv0));
 }
 
+TEST_F(protocol, socket_access_rights)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = ACCESS_ALL,
+	};
+	struct landlock_socket_attr protocol = {
+		.family = self->srv0.protocol.family,
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
+		EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					       &protocol, 0))
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

