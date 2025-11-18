Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4EA303A35;
	Tue, 18 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473632; cv=none; b=pVOuRnv813Mj5yOd86ChhGwZW88PfVX3yzvpriQtUQ/+JAsqDEQ1U2p0s7mlDezBSpf6XGrjgJ5V35GLiDQdciKBZS+oBb0BJScHF0DalllJKwCcvOWbEQrC1Wdj4hTNle36y7167TOCQ83AVe+YHac0n1b+OivG38QDhBDiPqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473632; c=relaxed/simple;
	bh=FvUlVmqmrFy72R3zt/Uem5SLj/EAsS7fzgFAnNlqGI8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AB1f0Exm4XzClWe/dzLru/HHhZ+xjBLfdHMwU0Y33ZMz8QW782mteGwn/VwyIrE2P79phSJb0Qz3QE/+jp1PjUhr394Fp0rsa8tirmkk3CCOOkuM/3EbRM0WcoJFvFKvnJ1ZR7SYJUE6Praq9j4rB3PJY5Qa0Uc9eSCMvM3aNug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9k1SldzHnH71;
	Tue, 18 Nov 2025 21:46:34 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E8C014033F;
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
Subject: [RFC PATCH v4 04/19] selftests/landlock: Testing adding rule with wildcard value
Date: Tue, 18 Nov 2025 21:46:24 +0800
Message-ID: <20251118134639.3314803-5-ivanov.mikhail1@huawei-partners.com>
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

Add test that validates behaviour of Landlock when rule with
wildcard value is added.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 .../testing/selftests/landlock/socket_test.c  | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index fcc0f92075a7..abcef11aaf39 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -151,4 +151,43 @@ TEST_F(mini, rule_with_empty_access)
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 
+/* Validates landlock behaviour when using wildcard (-1) values in socket rules. */
+TEST_F(mini, rule_with_wildcard)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_socket_attr create_family_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_INET,
+		.type = -1,
+		.protocol = -1,
+	};
+	const struct landlock_socket_attr create_family_type_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = -1,
+	};
+	const struct landlock_socket_attr create_family_protocol_attr = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_INET,
+		.type = -1,
+		.protocol = 0,
+	};
+	int ruleset_fd;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &create_family_attr, 0));
+	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &create_family_type_attr, 0));
+	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &create_family_protocol_attr, 0));
+	ASSERT_EQ(0, close(ruleset_fd));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

