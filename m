Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37803587D1;
	Tue, 18 Nov 2025 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473635; cv=none; b=m/FxDTTe8wzmJioWBx5/xcms+uBh4jQgds2gSBKEsc70SaeQP42eDNKwqiJSqLYtufQgm0nWoVNMgZl14GKHscWDuUcdEPTjoOG4ByhkCxRoeRCG1zKLPeG09cAZ2HPq+1ysx9XEpeplArk7/TYiE4fO8yuA+FjBzCf+gmVVbvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473635; c=relaxed/simple;
	bh=zviB7fmMmbIOiJcYevDPU2c/CDsvkEHMjtCpZgxUook=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ot2rDsRUy6anQrlp0TCFnlLl0ElEsbB1AY5ZbEiQ48J3KWlRvZKTmKg2TYqemL9T/xd2H3DQmv1K/Kg6glfNhy6gC8qAsF7KVBnKW8j6SsasDKZ4O53BnZahFtLfzr10LZjHl44mbb3OccR5xLJJLdiWzQCN3FRsnv96Z7mk/7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9l0r9VzHnH7S;
	Tue, 18 Nov 2025 21:46:35 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 092ED1402F5;
	Tue, 18 Nov 2025 21:47:06 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:05 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 10/19] selftests/landlock: Test that kernel space sockets are not restricted
Date: Tue, 18 Nov 2025 21:46:30 +0800
Message-ID: <20251118134639.3314803-11-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Add test validating that Landlock provides restriction of user space
sockets only.

Reviewed-by: Günther Noack <gnoack@google.com>
Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Grammar fixes.
* Adds mini fixture.
---
 .../testing/selftests/landlock/socket_test.c  | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 8b8913290a64..ce9a6e283be6 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -670,4 +670,43 @@ TEST_F(mini, ruleset_with_wildcards_overlap)
 	EXPECT_EQ(EACCES, test_socket(AF_INET, SOCK_DGRAM, 0));
 }
 
+/* mini.kernel_socket will fail with EAFNOSUPPORT if SMC is not supported. */
+TEST_F(mini, kernel_socket)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_socket_attr smc_socket_create = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_SMC,
+		.type = SOCK_STREAM,
+		.protocol = 0,
+	};
+	int ruleset_fd;
+
+	/*
+	 * Checks that SMC socket is created successfully without
+	 * landlock restrictions.
+	 */
+	ASSERT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &smc_socket_create, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * During the creation of an SMC socket, an internal service TCP socket
+	 * is also created (Cf. smc_create_clcsk).
+	 *
+	 * Checks that Landlock does not restrict creation of the kernel space
+	 * socket.
+	 */
+	EXPECT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

