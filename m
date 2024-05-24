Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722CF85297;
	Fri, 24 May 2024 09:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543077; cv=none; b=VNsxgdkXyn/Fg1NH6YwLiEyr/lGSRIFDyesNeQpfmZTH2eSuID9zUTCAA8LZONPAMIcq4oTP0juyiBJzhwaGcfYSPEoo4cS/KIszAEy1t7ZL0ji874dHUeCjDEGW+qyYkejXc7YtxVpQC2Y2lxWZ+e3Ot+oTq3zvgfSxQ8tR1nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543077; c=relaxed/simple;
	bh=Puej5jIel5y8wPIAmxPgow7Z7eZtFpvc/Z2nOyUo10Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QLFnj2NpMFZPB3Zf5CKJ/pFobL+Vswuvy2d6lLfHZYU9BIq4LLZHsdLocTq4mbtY0igEf3sNi5g1OSusXIfv3TP5ysjrS9oDeqRTrmkqxWSzt7/vSZQZVjWCSh2Z5F/t2jHLvZctE84F18loiI7DWwyiXZUV36ryiK7iVux9ySA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Vm07Q1z4lzsRlm;
	Fri, 24 May 2024 17:27:30 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id D428418007E;
	Fri, 24 May 2024 17:31:13 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 24 May 2024 17:31:12 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 11/12] selftests/landlock: Add mini.socket_invalid_type to socket tests
Date: Fri, 24 May 2024 17:30:14 +0800
Message-ID: <20240524093015.2402952-12-ivanov.mikhail1@huawei-partners.com>
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

Add test validating that landlock doesn't wrongfully return EACCES for
socket with invalid type (e.g. UNIX socket with PACKET type).

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 .../testing/selftests/landlock/socket_test.c  | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 80c904380075..b062001a778e 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -532,4 +532,50 @@ TEST_F(mini, socket_overflow)
 	EXPECT_EQ(EACCES, test_socket(&srv_denied));
 }
 
+TEST_F(mini, socket_invalid_type)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	/*
+	 * SOCK_PACKET is invalid type for UNIX socket
+	 * (see net/unix/af_unix.c:unix_create()).
+	 */
+	const struct landlock_socket_attr create_unix_invalid = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_UNIX,
+		.type = SOCK_PACKET,
+	};
+	const struct protocol_variant protocol_invalid = {
+		.family = create_unix_invalid.family,
+		.type = create_unix_invalid.type,
+	};
+	struct service_fixture srv_unix_invalid;
+	int ruleset_fd;
+
+	srv_unix_invalid.protocol = protocol_invalid;
+
+	/* Allowed created */
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &create_unix_invalid, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(&srv_unix_invalid));
+
+	/* Denied create */
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(&srv_unix_invalid));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

