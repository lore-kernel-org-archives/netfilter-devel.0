Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC4E85C69;
	Fri, 24 May 2024 09:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543070; cv=none; b=jIjyGB+nKCTyeG0ZUQPJhIkFMwoloLHXUjBh+8lsuMKu6W+zEoGJij6zGnTec00AFUPEA76wKxhAZAjvcpbAmdzoGdSL3gRCbyUGRqJkQ589FHGY6iDxWzHPXjxcjT1OXOltfIwIOavwqA6CspFPqJSEyL8Jl/7RxUfTqy5XYnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543070; c=relaxed/simple;
	bh=lctE3ZYtTldW/LPpaaEZTsFFKQkydhhY+bZxY4gyC18=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s8GvBGXgRul6P8B6J/lgdC9jfCL1c9hjfx2GbdOiSvHFjNddJkOe5V1QuFzeGKvBI7UbdW8qaJnC6pp74CET4r42LV6pcj2GbZtPxh2Ae/ZX5MNo/3swxAtpzXW+SVtjWqNwj7py+/oqoeVSEzOPg6EXCOnODsBm2V26djsSu0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Vm0813RlfzPkWS;
	Fri, 24 May 2024 17:28:01 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id ADA5A1400D1;
	Fri, 24 May 2024 17:31:05 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 24 May 2024 17:31:04 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 06/12] selftests/landlock: Add protocol.rule_with_unhandled_access to socket tests
Date: Fri, 24 May 2024 17:30:09 +0800
Message-ID: <20240524093015.2402952-7-ivanov.mikhail1@huawei-partners.com>
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

Add test that validates behavior of landlock after rule with
unhandled access is added.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Refactors commit message.
---
 .../testing/selftests/landlock/socket_test.c  | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 57d5927906b8..31af47de1937 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -232,4 +232,37 @@ TEST_F(protocol, rule_with_unknown_access)
 	EXPECT_EQ(0, close(ruleset_fd));
 }
 
+TEST_F(protocol, rule_with_unhandled_access)
+{
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	struct landlock_socket_attr protocol = {
+		.family = self->srv0.protocol.family,
+		.type = self->srv0.protocol.type,
+	};
+	int ruleset_fd;
+	__u64 access;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	for (access = 1; access > 0; access <<= 1) {
+		int err;
+
+		protocol.allowed_access = access;
+		err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					&protocol, 0);
+		if (access == ruleset_attr.handled_access_socket) {
+			EXPECT_EQ(0, err);
+		} else {
+			EXPECT_EQ(-1, err);
+			EXPECT_EQ(EINVAL, errno);
+		}
+	}
+
+	EXPECT_EQ(0, close(ruleset_fd));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

