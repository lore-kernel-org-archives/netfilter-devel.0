Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9A1B676;
	Sun, 28 Jul 2024 00:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722126388; cv=none; b=EwkH3lA8JtlLwVJCgJfLwyMDhW3sLV7i0de8hoI4pCQ2RSWUPSePeVl+VjAYZiFEhpqs3JgmX1YMaIryYvj2DP/VrYgOsIFQMyFqY5d/Z0zjn5BRBzwJeDAioInYyKLa8glGi57OivIpckFC/+txz4QPXZ1QunuvrxOqiaoepQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722126388; c=relaxed/simple;
	bh=sbsAmMH2Do9sbVqtKEAT3otrqWu0IWd9rsy6FrLSOhY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ap1AQkKw86Q+sCoiGynjhw+9kqe/gX9usRp/iKlnv8OkLgl8BDJRVG8ENTL0kIuJrTgnFALkcT9+4xSMreaPlsYOJBa3KeEOf2UQog2wG3dj4KJCxBXpZOryWB7KayexNJVrsgbevNAuKGOjKGrc+aJlL6vRUsnDVgLuEf+he5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WWj2w3xzGz1L9Cq;
	Sun, 28 Jul 2024 08:26:16 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A2B41800A4;
	Sun, 28 Jul 2024 08:26:23 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 28 Jul 2024 08:26:21 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 6/9] selftests/landlock: Test listening without explicit bind restriction
Date: Sun, 28 Jul 2024 08:25:59 +0800
Message-ID: <20240728002602.3198398-7-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
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

Test scenarios where listen(2) call without explicit bind(2) is allowed
and forbidden.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/net_test.c | 83 +++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index a8385f1373f6..1a4c4d1cabc2 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -1842,6 +1842,89 @@ TEST_F(port_specific, bind_connect_zero)
 	EXPECT_EQ(0, close(bind_fd));
 }
 
+TEST_F(port_specific, listen_without_bind_allowed)
+{
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+					      LANDLOCK_ACCESS_NET_LISTEN_TCP
+		};
+		const struct landlock_net_port_attr tcp_listen_zero = {
+			.allowed_access = LANDLOCK_ACCESS_NET_LISTEN_TCP,
+			.port = 0,
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/*
+		 * Allow listening without explicit bind
+		 * (cf. landlock_net_port_attr).
+		 */
+		EXPECT_EQ(0,
+			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+					    &tcp_listen_zero, 0));
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+	int listen_fd, connect_fd;
+	__u64 port;
+
+	listen_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, listen_fd);
+
+	connect_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, connect_fd);
+	/*
+	 * Allow listen(2) to select a random port for the socket,
+	 * since bind(2) wasn't called.
+	 */
+	EXPECT_EQ(0, listen_variant(listen_fd, backlog));
+
+	/* Connects on the binded port. */
+	port = get_binded_port(listen_fd, &variant->prot);
+	EXPECT_NE(0, port);
+	set_port(&self->srv0, port);
+	EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
+
+	EXPECT_EQ(0, close(connect_fd));
+	EXPECT_EQ(0, close(listen_fd));
+}
+
+TEST_F(port_specific, listen_without_bind_denied)
+{
+	if (variant->sandbox == TCP_SANDBOX) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_net = LANDLOCK_ACCESS_NET_LISTEN_TCP
+		};
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		/* Deny listening. */
+		enforce_ruleset(_metadata, ruleset_fd);
+		EXPECT_EQ(0, close(ruleset_fd));
+	}
+	int listen_fd, ret;
+
+	listen_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, listen_fd);
+
+	/* Checks that listening without explicit binding is prohibited. */
+	ret = listen_variant(listen_fd, backlog);
+	if (is_restricted(&variant->prot, variant->sandbox)) {
+		/* Denied by Landlock. */
+		EXPECT_EQ(-EACCES, ret);
+	} else {
+		EXPECT_EQ(0, ret);
+	}
+}
+
 TEST_F(port_specific, port_1023)
 {
 	int bind_fd, connect_fd, ret;
-- 
2.34.1

