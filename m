Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC7F635;
	Wed,  4 Sep 2024 10:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446938; cv=none; b=fNmsp/95rjdRbDoe9Ildmj4Fv08PMzdiop1i9frl8VceFNGdgY4eI78zlKIDed83tZ+mU/0/Xo9JZjswLp/azgjy2xUOSdpUIPrTVAXcGRyRU+I9qtHl1yUQwJYK6MdXSngk1+OFwa7QTAdLcxMWn4sHVofPl858TH2gPr1MfJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446938; c=relaxed/simple;
	bh=tPvunVaZWlh8tfqE1t0F9FXoxdU7bk6AXubYP/7CZJw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kuXT+bgbGPyakc8PcrMMUgk0Doax892w9SBT0VTRgTeSFiKU4SCohKRtWGnpNtixpFHKbG5snftopPwNfLdpAqPNaxqO630KOLQqhCc21aI2G9go+sEkIWJ1zTbNYWZfCohMmlT0qivP/n0JuBidkkl7clqedL3grUiNDn72m1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WzK2h6TN5z13Kwk;
	Wed,  4 Sep 2024 18:47:56 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 49AF4180105;
	Wed,  4 Sep 2024 18:48:54 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:52 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 12/19] selftests/landlock: Test that kernel space sockets are not restricted
Date: Wed, 4 Sep 2024 18:48:17 +0800
Message-ID: <20240904104824.1844082-13-ivanov.mikhail1@huawei-partners.com>
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

Add test validating that Landlock provides restriction of user space
sockets only.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 .../testing/selftests/landlock/socket_test.c  | 39 ++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index ff5ace711697..23698b8c2f4d 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -7,7 +7,7 @@
 
 #define _GNU_SOURCE
 
-#include <linux/landlock.h>
+#include "landlock.h"
 #include <linux/pfkeyv2.h>
 #include <linux/kcm.h>
 #include <linux/can.h>
@@ -628,4 +628,41 @@ TEST(unsupported_af_and_prot)
 	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
 }
 
+TEST(kernel_socket)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	struct landlock_socket_attr smc_socket_create = {
+		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
+		.family = AF_SMC,
+		.type = SOCK_STREAM,
+	};
+	int ruleset_fd;
+
+	/*
+	 * Checks that SMC socket is created sucessfuly without
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

