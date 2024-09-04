Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF16A1D017D;
	Wed,  4 Sep 2024 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446929; cv=none; b=sD6Szo3jMBLvUtKJwpkLPAAkrXw1FYTl3DkrJ7dG6lN74/FI4J5KQnNd7/SQ/xElAQ1kIzKAmQvcUlGl3zeME/gm35jwlDmDV4xyoq//LVO3AFsBkaJwG8DAr3acv7xv1JeXVtrNHnKr9vN3xr5Dxt+zymGK/NDfyBwYL6fomdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446929; c=relaxed/simple;
	bh=INxD17Lg/eVdr27iVj8BOakDoLc9Zrxd0IomBcFihJA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mkZqSfYxfxO4qb1qYXHcEIUpwvRwUkKYOW0jpYKaxpvB0frkleHRMTy7tRH2YDlsYG5+zXLJQucy8qGBZob2XSdjiBGdIvZ8yRuRQKg5bErNEYk4xyqmhf2xL2+6j/Y6eJAB4MSbSo6zbI6O3D+HXxdPn21Ri8WeIDvgggStNlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WzJxw4QVcz20nPj;
	Wed,  4 Sep 2024 18:43:48 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id A9B52180042;
	Wed,  4 Sep 2024 18:48:45 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:43 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 07/19] selftests/landlock: Test adding a rule for empty access
Date: Wed, 4 Sep 2024 18:48:12 +0800
Message-ID: <20240904104824.1844082-8-ivanov.mikhail1@huawei-partners.com>
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
empty access is added.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v2:
* Renames protocol.inval into protocol.rule_with_empty_access.
* Replaces ASSERT_EQ with EXPECT_EQ for landlock_add_rule().
* Closes ruleset_fd.
* Refactors commit message and title.
* Minor fixes.

Changes since v1:
* Refactors commit message.
---
 .../testing/selftests/landlock/socket_test.c  | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index d2fedfca7193..d323f649a183 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -384,4 +384,37 @@ TEST_F(protocol, rule_with_unhandled_access)
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 
+TEST_F(protocol, rule_with_empty_access)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE
+	};
+	struct landlock_socket_attr protocol_allowed = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = self->prot.family,
+		.type = self->prot.type,
+	};
+	struct landlock_socket_attr protocol_denied = {
+		.allowed_access = 0,
+		.family = self->prot.family,
+		.type = self->prot.type,
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
+
+	/* Adds with legitimate value. */
+	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &protocol_allowed, 0));
+
+	ASSERT_EQ(0, close(ruleset_fd));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

