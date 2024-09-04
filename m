Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2779A1D1720;
	Wed,  4 Sep 2024 10:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446940; cv=none; b=ScvXQO85QeCtyvxT4gBv66get0FYR2yMznQclYwu5kpnm/ilqHgTNdaSog7ZuV0OCH6J9EJvP+Gri0nB7a8LMDF4XkgPAuOsZXvZD2gUKLNmcdZ6x2yl+JJL00UsQfAgyDObI+0/HYbAkx7Sry9byQ0Vz8OMGxHrUPiuhzORYJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446940; c=relaxed/simple;
	bh=D5KHLBvSpUNoPH0YzEK4QnfJ06v6mtAo4+KLOZb9oSI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xoa/HsJcAS624E4dWucTL/7zT9j3m/NmntqWvGidF6uz9KpK4tcAOdxYNtlcbJezGOLakpf+wMXvBqR5ISa7xKod13pRULYW/N1D7dk3Dpqa5oD9BfWktkQk9EkZJLnwkJ97DunAWc4EAmcbQ2IprdGdiYQHuozQnWH9Zme3iuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WzK1N546zzgYvP;
	Wed,  4 Sep 2024 18:46:48 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id E6BB7180AE6;
	Wed,  4 Sep 2024 18:48:55 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:54 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 13/19] selftests/landlock: Test packet protocol alias
Date: Wed, 4 Sep 2024 18:48:18 +0800
Message-ID: <20240904104824.1844082-14-ivanov.mikhail1@huawei-partners.com>
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

(AF_INET, SOCK_PACKET) is an alias for (AF_PACKET, SOCK_PACKET)
(Cf. __sock_create). Landlock shouldn't restrict one pair if the other
was allowed. Add `packet_protocol` fixture and test to
validate these scenarios.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 .../testing/selftests/landlock/socket_test.c  | 75 ++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 23698b8c2f4d..8fc507bf902a 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -7,7 +7,7 @@
 
 #define _GNU_SOURCE
 
-#include "landlock.h"
+#include <linux/landlock.h>
 #include <linux/pfkeyv2.h>
 #include <linux/kcm.h>
 #include <linux/can.h>
@@ -665,4 +665,77 @@ TEST(kernel_socket)
 	EXPECT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
 }
 
+FIXTURE(packet_protocol)
+{
+	struct protocol_variant prot_allowed, prot_tested;
+};
+
+FIXTURE_VARIANT(packet_protocol)
+{
+	bool packet;
+};
+
+FIXTURE_SETUP(packet_protocol)
+{
+	self->prot_allowed.type = self->prot_tested.type = SOCK_PACKET;
+
+	self->prot_allowed.family = variant->packet ? AF_PACKET : AF_INET;
+	self->prot_tested.family = variant->packet ? AF_INET : AF_PACKET;
+
+	/* Packet protocol requires NET_RAW to be set (Cf. packet_create). */
+	set_cap(_metadata, CAP_NET_RAW);
+};
+
+FIXTURE_TEARDOWN(packet_protocol)
+{
+	clear_cap(_metadata, CAP_NET_RAW);
+}
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(packet_protocol, packet_allows_inet) {
+	/* clang-format on */
+	.packet = true,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(packet_protocol, inet_allows_packet) {
+	/* clang-format on */
+	.packet = false,
+};
+
+TEST_F(packet_protocol, alias_restriction)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	struct landlock_socket_attr packet_socket_create = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = self->prot_allowed.family,
+		.type = self->prot_allowed.type,
+	};
+	int ruleset_fd;
+
+	/*
+	 * Checks that packet socket is created sucessfuly without
+	 * landlock restrictions.
+	 */
+	ASSERT_EQ(0, test_socket_variant(&self->prot_tested));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
+				       &packet_socket_create, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * (AF_INET, SOCK_PACKET) is an alias for the (AF_PACKET, SOCK_PACKET)
+	 * (Cf. __sock_create). Checks that Landlock does not restrict one pair
+	 * if the other was allowed.
+	 */
+	EXPECT_EQ(0, test_socket_variant(&self->prot_tested));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

