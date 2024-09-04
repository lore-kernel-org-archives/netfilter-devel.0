Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283741CF7A7;
	Wed,  4 Sep 2024 10:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446936; cv=none; b=DIaXRfBE289RD/f3CpsHGAA/65b57wYtz81iymIswr/2JlJcNZfutgnlZX7/6UsX3290kc3J36K/mqJhsW4thbJgHSY4RM6zfF1O+icMuraQ7bnI/WikDHTGnUcZCa3SrIbcaMNkYgdM4WQIF7eWeib6bfy64LLABvD3g12hepg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446936; c=relaxed/simple;
	bh=mKZP5+CKYGd+y0oYMNEDWGiKmfZ+LyvUbBETAARZ7JQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DBrHkGDDMWjXNQ99TgXVcPiqdf5IxrHrgCEe4EsK94o5yECLWUCsO6uiy+i82e8OUDWFgaEEqiUh0C4pen9EDUorhl2hv8kabwvyfclceGvilBUy8iG2jbEaXJPcwCCP6TX0pZ61My3rdZDdEKN3whbQCHFkHlvfeKMKYdiI6NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzJzl3lkHz1HJ8v;
	Wed,  4 Sep 2024 18:45:23 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 01AEA1402CC;
	Wed,  4 Sep 2024 18:48:51 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:49 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 10/19] selftests/landlock: Test adding a rule with family and type outside the range
Date: Wed, 4 Sep 2024 18:48:15 +0800
Message-ID: <20240904104824.1844082-11-ivanov.mikhail1@huawei-partners.com>
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

Create `prot_outside_range` fixture. It is used to iterate through
the various family and type pairs that do not fit the valid range.

Add test validating that adding a rule for sockets that do not match
the ranges (0 <= domain < AF_MAX), (0 <= type < SOCK_MAX) is prohibited.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v2:
* Removes restriction checks on maximum family and type values. Such
  checking is performed in protocol.create now.
* Renames this test into `rule_with_prot_outside_range`
* Creates `prot_outside_range` fixture. It is used to iterate through
  the various family and type pairs that doesn't fit valid range.
  Removes CHECK_RULE_OVERFLOW entries.
* Checks unrestricted socket(2) with family and type outside the range.
* Closes ruleset_fd.
* Refactors commit title.
---
 .../testing/selftests/landlock/socket_test.c  | 102 ++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index dee676c11227..047603abc5a7 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -479,4 +479,106 @@ TEST(ruleset_with_unknown_access)
 	}
 }
 
+FIXTURE(prot_outside_range)
+{
+	struct protocol_variant prot;
+};
+
+FIXTURE_VARIANT(prot_outside_range)
+{
+	struct protocol_variant prot;
+};
+
+FIXTURE_SETUP(prot_outside_range)
+{
+	self->prot = variant->prot;
+};
+
+FIXTURE_TEARDOWN(prot_outside_range)
+{
+}
+
+/* Cf. include/linux/net.h */
+#define SOCK_MAX (SOCK_PACKET + 1)
+#define NEGATIVE_MAX (-1)
+/* Cf. linux/net.h */
+#define SOCK_TYPE_MASK 0xf
+
+#define SOCK_STREAM_FLAG1 (SOCK_STREAM | SOCK_NONBLOCK)
+#define SOCK_STREAM_FLAG2 (SOCK_STREAM | SOCK_CLOEXEC)
+
+#define INVAL_PROTOCOL_VARIANT_ADD(family_, type_)                 \
+	FIXTURE_VARIANT_ADD(prot_outside_range, family_##_##type_) \
+	{                                                          \
+		.prot = {                                          \
+			.family = family_,                         \
+			.type = type_,                             \
+		},                                                 \
+	}
+
+INVAL_PROTOCOL_VARIANT_ADD(INT32_MIN, INT32_MIN);
+INVAL_PROTOCOL_VARIANT_ADD(INT32_MIN, NEGATIVE_MAX);
+INVAL_PROTOCOL_VARIANT_ADD(INT32_MIN, SOCK_STREAM);
+INVAL_PROTOCOL_VARIANT_ADD(INT32_MIN, SOCK_MAX);
+INVAL_PROTOCOL_VARIANT_ADD(INT32_MIN, INT32_MAX);
+
+INVAL_PROTOCOL_VARIANT_ADD(NEGATIVE_MAX, INT32_MIN);
+INVAL_PROTOCOL_VARIANT_ADD(NEGATIVE_MAX, NEGATIVE_MAX);
+INVAL_PROTOCOL_VARIANT_ADD(NEGATIVE_MAX, SOCK_STREAM);
+INVAL_PROTOCOL_VARIANT_ADD(NEGATIVE_MAX, SOCK_MAX);
+INVAL_PROTOCOL_VARIANT_ADD(NEGATIVE_MAX, INT32_MAX);
+
+INVAL_PROTOCOL_VARIANT_ADD(AF_INET, INT32_MIN);
+INVAL_PROTOCOL_VARIANT_ADD(AF_INET, NEGATIVE_MAX);
+INVAL_PROTOCOL_VARIANT_ADD(AF_INET, SOCK_MAX);
+INVAL_PROTOCOL_VARIANT_ADD(AF_INET, INT32_MAX);
+
+INVAL_PROTOCOL_VARIANT_ADD(AF_MAX, INT32_MIN);
+INVAL_PROTOCOL_VARIANT_ADD(AF_MAX, NEGATIVE_MAX);
+INVAL_PROTOCOL_VARIANT_ADD(AF_MAX, SOCK_STREAM);
+INVAL_PROTOCOL_VARIANT_ADD(AF_MAX, SOCK_MAX);
+INVAL_PROTOCOL_VARIANT_ADD(AF_MAX, INT32_MAX);
+
+INVAL_PROTOCOL_VARIANT_ADD(INT32_MAX, INT32_MIN);
+INVAL_PROTOCOL_VARIANT_ADD(INT32_MAX, NEGATIVE_MAX);
+INVAL_PROTOCOL_VARIANT_ADD(INT32_MAX, SOCK_STREAM);
+INVAL_PROTOCOL_VARIANT_ADD(INT32_MAX, SOCK_MAX);
+INVAL_PROTOCOL_VARIANT_ADD(INT32_MAX, INT32_MAX);
+
+TEST_F(prot_outside_range, add_rule)
+{
+	int family = self->prot.family;
+	int type = self->prot.type;
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	struct landlock_socket_attr create_socket_overflow = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = family,
+		.type = type,
+	};
+	int ruleset_fd;
+
+	/* Checks type flags using __sys_socket_create. */
+	if ((type & ~SOCK_TYPE_MASK) & ~(SOCK_CLOEXEC | SOCK_NONBLOCK)) {
+		ASSERT_EQ(EINVAL, test_socket_variant(&self->prot));
+	}
+	/* Checks range using __sock_create. */
+	else if (family >= AF_MAX || family < 0) {
+		ASSERT_EQ(EAFNOSUPPORT, test_socket_variant(&self->prot));
+	} else {
+		ASSERT_EQ(EINVAL, test_socket_variant(&self->prot));
+	}
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+					&create_socket_overflow, 0));
+	EXPECT_EQ(EINVAL, errno);
+
+	ASSERT_EQ(0, close(ruleset_fd));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

