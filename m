Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5703587A6;
	Tue, 18 Nov 2025 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473636; cv=none; b=lvqFrADu0qnfKYYn/XjB0stLXBlkD5VNg2wWM7q63/oRIU1XEWWfwr8nuFI+o0g9fEDcD1ByVq2+dk3EK+1bACwcAq9TFDf8KY+54li2M15i7dwNG0gvv5I8TrnNu97d2o+xssU9elWI0DmD6UHEfQ8DtFgLduZSYHeOi/q31No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473636; c=relaxed/simple;
	bh=ccudKUcKiKaSdcnUwDxgPnr2doxzk6DcoVKUahx8JlI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=teQfB7wRD2DbKh2sasQqNNFrIQLcbNPSVFK+khRrfVXxTg1JLM24EEQkhJZJxKerKA4gWlCjNjtU1rFwii/HOgEqj2HL0gwHcvjmyA+VmWl7Lqtp8UIpRWd7g+i5zag7cJDa4607yIq3vQCapRq21t24jVBFT26sInTdXWl9je4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9k6VyRzHnH76;
	Tue, 18 Nov 2025 21:46:34 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id CAE76140277;
	Tue, 18 Nov 2025 21:47:05 +0800 (CST)
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
Subject: [RFC PATCH v4 08/19] selftests/landlock: Test network stack error code consistency
Date: Tue, 18 Nov 2025 21:46:28 +0800
Message-ID: <20251118134639.3314803-9-ivanov.mikhail1@huawei-partners.com>
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

Add test validating that Landlock returns EACCES for unsupported
address family and protocol.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Access check doesn't handle error consistency due to change to
  socket_create from socket_post_create LSM hook.
* Renames commit.
* Minor changes.
---
 .../testing/selftests/landlock/socket_test.c  | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 1b6c709d2893..ebb39cbf9211 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -511,4 +511,71 @@ TEST_F(protocol, restrict_socket)
 					      self->requires_caps));
 }
 
+/*
+ * Errors related to AF internal validation of supported protocol attributes
+ * are not consistent in sandboxed mode.
+ */
+TEST_F(mini, unsupported_af_and_prot)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_socket_attr socket_af_unsupported = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_UNSPEC, /* cf __sock_create */
+		.type = SOCK_STREAM,
+		.protocol = 0,
+	};
+	const struct landlock_socket_attr socket_type_unsupported = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_UNIX,
+		.type = SOCK_PACKET, /* cf. unix_create */
+		.protocol = 0,
+	};
+	const struct landlock_socket_attr socket_proto_unsupported = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_UNIX,
+		.type = SOCK_STREAM,
+		.protocol = PF_UNIX + 1, /* cf. unix_create */
+	};
+	int ruleset_fd;
+
+	/* Tries to create a socket when ruleset is not established. */
+	ASSERT_EQ(EAFNOSUPPORT, test_socket(AF_UNSPEC, SOCK_STREAM, 0));
+	ASSERT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
+	ASSERT_EQ(EPROTONOSUPPORT,
+		  test_socket(AF_UNIX, SOCK_STREAM, PF_UNIX + 1));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Landlock allows creating rules for meaningless protocols. */
+	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &socket_af_unsupported, 0));
+	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &socket_type_unsupported, 0));
+	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &socket_proto_unsupported, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tries to create a socket when protocols are allowed. */
+	EXPECT_EQ(EAFNOSUPPORT, test_socket(AF_UNSPEC, SOCK_STREAM, 0));
+	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
+	EXPECT_EQ(EPROTONOSUPPORT,
+		  test_socket(AF_UNIX, SOCK_STREAM, PF_UNIX + 1));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tries to create a socket when protocols are restricted. */
+	EXPECT_EQ(EACCES, test_socket(AF_UNSPEC, SOCK_STREAM, 0));
+	EXPECT_EQ(EACCES, test_socket(AF_UNIX, SOCK_PACKET, 0));
+	EXPECT_EQ(EACCES, test_socket(AF_UNIX, SOCK_STREAM, PF_UNIX + 1));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

