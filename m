Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF598485;
	Wed, 14 Aug 2024 03:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723604532; cv=none; b=jaILJno+Hd82RsMs2o+X/zGgSw7fBA4BxHd/n/Y70daGcFg4RWAqpBKyi+Jcn5qntZSUC2GJG04sS+rQYcTFzgLhWeJwiUT7Wj6in+uA7EETMLFdlnPVh35wX0BGPC5zw8fvNACIwbEJ1Oon3qp22UO1wYVd2ukqJLK0rSoS0Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723604532; c=relaxed/simple;
	bh=T1d68LYJQ5PF2V9H1ruSPor7SPuyYu1pjOYSMUxNP3E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aleYE/U4Y1zTs9v0x8meB5zydh5TFASX+9oV2OxwaypRDQ9IUhkXqemLkNj8pPVJLaE4O5y3l+IesJYJfHf2moShiD18cGkuG1HYO0bYT3/4c6feuetfZKmjH1fI8/SiG6cg7tBIO+dRVGcrkHRqsRpxGNkJ4ctnO3dx+ksDGVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WkCbf3v9xz20l6c;
	Wed, 14 Aug 2024 10:57:34 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A5531402CF;
	Wed, 14 Aug 2024 11:02:08 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 11:02:06 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 4/9] selftests/landlock: Test listening restriction
Date: Wed, 14 Aug 2024 11:01:46 +0800
Message-ID: <20240814030151.2380280-5-ivanov.mikhail1@huawei-partners.com>
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

Add a test for listening restriction. It's similar to protocol.bind and
protocol.connect tests.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/net_test.c | 44 +++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 8126f5c0160f..b6fe9bde205f 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -689,6 +689,50 @@ TEST_F(protocol, connect)
 				    restricted, restricted);
 }
 
+TEST_F(protocol, listen)
+{
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = ACCESS_ALL,
+		};
+		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
+			.allowed_access = ACCESS_ALL,
+			.port = self->srv0.port,
+		};
+		const struct landlock_net_port_attr tcp_denied_listen_p1 = {
+			.allowed_access = ACCESS_ALL &
+					  ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
+			.port = self->srv1.port,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Allows all actions for the first port. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_not_restricted_p0, 0));
+
+		/* Allows all actions despite listen. */
+		ASSERT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_denied_listen_p1, 0));
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+	bool restricted = is_restricted(&variant->prot, variant->sandbox);
+
+	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
+				    false);
+	test_restricted_net_fixture(_metadata, &self->srv1, false, false,
+				    restricted);
+	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
+				    restricted, restricted);
+}
+
 TEST_F(protocol, bind_unspec)
 {
 	const struct landlock_ruleset_attr ruleset_attr = {
-- 
2.34.1

