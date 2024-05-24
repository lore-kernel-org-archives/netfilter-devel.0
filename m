Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850A885297;
	Fri, 24 May 2024 09:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543074; cv=none; b=PRIQE/AKgPcTSwmID/X+HcUizr5y1xMyWykfcsLrJLHFRIZl6yXOySLWp/bncHxUgcYli05RTN2e7PmqfXATPpNPAoCszw96vxiUfChZLKS3uTzdeV2MJwHQIwNadnDr9ONXnwAyQK2REbBz4HYFRibnmjI0yAj9EtgQxkMWOH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543074; c=relaxed/simple;
	bh=bL/0fFmFj3v4Jqh3lYGlL7CUYnF1mKWXXjO+y6Y+fak=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OpvSe6ubLfZZ1IL+guwVlYfgNygG6uIW0CnaQrMjzx9PfqXTBo+jRe+6SDvjjwVVnyHSqiADjh4FjFBrQhQnbKP09TlbO6QROzhpI7kuiu4u/EDz68hkkhdAxlQC4MI72RsEjRu7OIg5fVsHHtJzpQvnx3vVins3EorYvYXKSOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Vm07M0bBKzsRhb;
	Fri, 24 May 2024 17:27:27 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id A41D518007E;
	Fri, 24 May 2024 17:31:10 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 24 May 2024 17:31:08 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 09/12] selftests/landlock: Add mini.ruleset_with_unknown_access to socket tests
Date: Fri, 24 May 2024 17:30:12 +0800
Message-ID: <20240524093015.2402952-10-ivanov.mikhail1@huawei-partners.com>
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

* Add fixture mini for tests that check specific cases.

* Add test that validates behavior of landlock after ruleset with
  unknown access is created.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Refactors commit message.
---
 .../testing/selftests/landlock/socket_test.c  | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 52edc1a8ac21..c81f02ffef6c 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -408,4 +408,35 @@ TEST_F(tcp_layers, ruleset_overlap)
 	}
 }
 
+/* clang-format off */
+FIXTURE(mini) {};
+/* clang-format on */
+
+FIXTURE_SETUP(mini)
+{
+	disable_caps(_metadata);
+
+	setup_namespace(_metadata);
+};
+
+FIXTURE_TEARDOWN(mini)
+{
+}
+
+TEST_F(mini, ruleset_with_unknown_access)
+{
+	__u64 access_mask;
+
+	for (access_mask = 1ULL << 63; access_mask != ACCESS_LAST;
+	     access_mask >>= 1) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_socket = access_mask,
+		};
+
+		EXPECT_EQ(-1, landlock_create_ruleset(&ruleset_attr,
+						      sizeof(ruleset_attr), 0));
+		EXPECT_EQ(EINVAL, errno);
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

