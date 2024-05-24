Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D0A85275;
	Fri, 24 May 2024 09:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543070; cv=none; b=czVJkTBT/nHkbn/JSDJLVaEgwgBDJzgyv3795uM8I8Gyc9OtO8YN+8bXysJeoT1XWcnvYSSGeZk6AhXvRqbIc6Lr1E2Tra3EUwd6pCzfMPcNAPgnsgkodXmoRlkg6ieYAEXNJBTu1243LMBFBFbp/R+Ew8DF7XvFakVEQNGjh2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543070; c=relaxed/simple;
	bh=hEwvHWiLcPuJkjJV6oiQLy1VESlpWobpJivZ6lGSx6I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YFibgh6a+3KD55WYKOCqFWOlh+t58L4qi3nX7IFA0QkKafT5Zt/1vVpgc8AYr8q6E3rh02Hkbl7Uw6No8B9hazNvSoAqorpil0lV4m4kSm0y9miPdUgqBJcx1r+ynqjbNxlTTheIEXSrkvX3SYay0rbRBD/Yq0conpKaPAkxbB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Vm0833MhXz1ymXf;
	Fri, 24 May 2024 17:28:03 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E10C14037C;
	Fri, 24 May 2024 17:31:07 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 24 May 2024 17:31:05 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 07/12] selftests/landlock: Add protocol.inval to socket tests
Date: Fri, 24 May 2024 17:30:10 +0800
Message-ID: <20240524093015.2402952-8-ivanov.mikhail1@huawei-partners.com>
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

Add test that validates behavior of landlock with fully
access restriction.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Refactors commit message.
---
 .../testing/selftests/landlock/socket_test.c  | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 31af47de1937..751596c381fe 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -265,4 +265,38 @@ TEST_F(protocol, rule_with_unhandled_access)
 	EXPECT_EQ(0, close(ruleset_fd));
 }
 
+TEST_F(protocol, inval)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE
+	};
+
+	struct landlock_socket_attr protocol = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = self->srv0.protocol.family,
+		.type = self->srv0.protocol.type,
+	};
+
+	struct landlock_socket_attr protocol_denied = {
+		.allowed_access = 0,
+		.family = self->srv0.protocol.family,
+		.type = self->srv0.protocol.type,
+	};
+
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
+
+	/* Adds with legitimate values. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &protocol, 0));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

