Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3FF1CF7B6;
	Wed,  4 Sep 2024 10:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446937; cv=none; b=PdRoqjLdRcxQpKkzciFFw58IfKXA7zef3uOgCBMetsqEPINo7niw2bQvi37CtArHZX3hrT/HiYexV9EUsCcOoCreP4pjzG0+U7beoJB5wDw0xj9YiX/3Ex4zWh8KRRm2DK02CR5R8HhMqCFZcsah+wIxobeYwpdy64SkJbJE+9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446937; c=relaxed/simple;
	bh=VjOv1Lsiw2OAH0XdfkzBC/mSzqms7nq+pG+WZu42Ksc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uglZgdXroozOC/R/u4AvlOVZ5WXjZM+DHSK0NsgeHP+XzrpAzQqQ5dcgQCW9pTbYebIonD6fuyFIjJegBNTMtUmdfwjYx5UB4gSgJ1JNmDw0fpqpkE8voqSAtRV5qvj5965rmlOzJFnMUd/o+Vs1HW9ND1sy3osMQoxWI1qR6FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WzK2f6rmxzyR1J;
	Wed,  4 Sep 2024 18:47:54 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E36C1402E1;
	Wed,  4 Sep 2024 18:48:52 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:50 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 11/19] selftests/landlock: Test unsupported protocol restriction
Date: Wed, 4 Sep 2024 18:48:16 +0800
Message-ID: <20240904104824.1844082-12-ivanov.mikhail1@huawei-partners.com>
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

Add test validating that Landlock doesn't wrongfully
return EACCES for unsupported address family and protocol.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v1:
* Adds socket(2) error code check when ruleset is not established.
* Tests unsupported family for error code consistency.
* Renames test to `unsupported_af_and_prot`.
* Refactors commit title and message.
* Minor fixes.
---
 .../testing/selftests/landlock/socket_test.c  | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 047603abc5a7..ff5ace711697 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -581,4 +581,51 @@ TEST_F(prot_outside_range, add_rule)
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 
+TEST(unsupported_af_and_prot)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	struct landlock_socket_attr socket_af_unsupported = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_UNSPEC,
+		.type = SOCK_STREAM,
+	};
+	struct landlock_socket_attr socket_prot_unsupported = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_UNIX,
+		.type = SOCK_PACKET,
+	};
+	int ruleset_fd;
+
+	/* Tries to create a socket when ruleset is not established. */
+	ASSERT_EQ(EAFNOSUPPORT, test_socket(AF_UNSPEC, SOCK_STREAM, 0));
+	ASSERT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &socket_af_unsupported, 0));
+	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &socket_prot_unsupported, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tries to create a socket when protocols are allowed. */
+	EXPECT_EQ(EAFNOSUPPORT, test_socket(AF_UNSPEC, SOCK_STREAM, 0));
+	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tries to create a socket when protocols are restricted. */
+	EXPECT_EQ(EAFNOSUPPORT, test_socket(AF_UNSPEC, SOCK_STREAM, 0));
+	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

