Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C0C17BA1;
	Sun, 28 Jul 2024 00:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722126391; cv=none; b=e1cEywJ5Tar9CCNdr7uTjzJ+QkTXBPDaGLn5BI99wY7oG/4rnDGXguYqgGxhxeonbNu+U/KvOToZGV/tfPXMeHVUXLJCC5TfnGCqWaBaJFtEBZ6GIJ1FmzA174Nwui3exqtfH/r40ofTCcUOEmloZ+6c2QP330c1zQe39j651sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722126391; c=relaxed/simple;
	bh=VrJ239tW2DJaSArHyYIINEr9yioxZR92psI9DPag0cs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dUkxNsgcLE8HGJBohUmG597mSEeyLYKCKuaNot2Rixix6g1h1MxRJ7rgdh856I2+5S/ndKV/PDRd8jJkoWePd1zD01tIMBhTpNgM9csVP6Bse5H35qXTYXVt1ZllCzi0FAm8sGrKPMcjPFjNPerKmQ8pDecLX0fySq4zAyZdvn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WWhxS21vmzyNfn;
	Sun, 28 Jul 2024 08:21:32 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id CEE781800A4;
	Sun, 28 Jul 2024 08:26:26 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 28 Jul 2024 08:26:25 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 8/9] selftests/landlock: Test changing socket backlog with listen(2)
Date: Sun, 28 Jul 2024 08:26:01 +0800
Message-ID: <20240728002602.3198398-9-ivanov.mikhail1@huawei-partners.com>
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

listen(2) can be used to change length of the pending connections queue
of the listening socket. Such scenario shouldn't be restricted by Landlock
since socket doesn't change its state.

* Implement test that validates this case.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/net_test.c | 26 +++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index caf5f38996ed..31ab7e7442e4 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -1747,6 +1747,32 @@ TEST_F(ipv4_tcp, espintcp_listen)
 	EXPECT_EQ(0, close(listen_fd));
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

