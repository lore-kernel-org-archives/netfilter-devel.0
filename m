Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0490D40BE3;
	Wed, 14 Aug 2024 03:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723604538; cv=none; b=U0aezoDBNLwHx3QMgwqI0ZjiPRspfmIWlQvoyLt1OTuxJiCKUVdN4Fm/ZWwi7XexVzEKv0inkNM9guAlw5/ysVclj64uaSLruxOsL3TBOZebnkzo1PntVf8jkkupaNUDm++dVUypRonAU8gX11ghNavQy2XU/ylTn4u5yZ43kcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723604538; c=relaxed/simple;
	bh=QJX08E9MiyUp0svpjG6vnvcvpVK6qgbDgGd3UgCoiS0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UuyRJTvz0SMjyxpioEsSm29kzgvhFGpGHWZybOMqoWlTf5mP/1Gpbx+LogaYrDKo6BdibUDzhqHEoU64G5oAI7f89vIjZ1te/JFGfCJFnERbwffMrSqEWbC/2jQQY6emuI7al7COa1HEnzp1kxNiJ/y51wojIEPYHBXwZUw3OQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WkCbR05ySz1S7r5;
	Wed, 14 Aug 2024 10:57:23 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id E9970180019;
	Wed, 14 Aug 2024 11:02:14 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 11:02:13 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 8/9] selftests/landlock: Test changing socket backlog with listen(2)
Date: Wed, 14 Aug 2024 11:01:50 +0800
Message-ID: <20240814030151.2380280-9-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 dggpemm500020.china.huawei.com (7.185.36.49)

listen(2) can be used to change length of the pending connections queue
of the listening socket. Such scenario shouldn't be restricted by Landlock
since socket doesn't change its state.

* Implement test that validates this case.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/net_test.c | 26 +++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 6831d8a2e9aa..dafc433a0068 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -1768,6 +1768,32 @@ TEST_F(ipv4_tcp, with_fs)
 	EXPECT_EQ(-EACCES, bind_variant(bind_fd, &self->srv1));
 }
 
+TEST_F(ipv4_tcp, double_listen)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_LISTEN_TCP,
+	};
+	int ruleset_fd;
+	int listen_fd;
+
+	listen_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, listen_fd);
+
+	EXPECT_EQ(0, bind_variant(listen_fd, &self->srv0));
+	EXPECT_EQ(0, listen_variant(listen_fd, backlog));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Denies listen. */
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	/* Tries to change backlog value of listening socket. */
+	EXPECT_EQ(0, listen_variant(listen_fd, backlog + 1));
+}
+
 FIXTURE(port_specific)
 {
 	struct service_fixture srv0;
-- 
2.34.1

