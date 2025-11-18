Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF38B2FFFBF;
	Tue, 18 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473633; cv=none; b=dXgOHUe6PPVoXJz0GFxZ6I3c7QQjf2nPP40i/M1UJZ+nzCwRJzAiR9xvT5k4PuZxNRF2sJ1HmkFO33V8SrBjsHviBiS6cn75XKcldy5RbdVa0l42cuzdiT/IrgPnIJeeDuf/6lE4jydDYLPvOIuQMuYRVM7w8HUW6gVNbFla4HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473633; c=relaxed/simple;
	bh=g0fCpdNajERd4igEeSpO9CPnA5TN8K7LcUUIlccGq7s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A99JzAnSSI7ojoCJTH1x9gNkRALLZ0LveSjjBAB4cWUfKItAEnDboHhPg9lh1a3VKtPvYrmlaYFbTKvV51hgDMlju1p8uOEHcn2dniwNlqrbxHngf7IBUJsQrjNJGuECtAqh9nbI6WQh6AzpudQ2JEE2RIKOdS3JmfPq+ipsTE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9k022ZzHnH6M;
	Tue, 18 Nov 2025 21:46:34 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id E1CBB14033F;
	Tue, 18 Nov 2025 21:47:04 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:04 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 02/19] selftests/landlock: Test creating a ruleset with unknown access
Date: Tue, 18 Nov 2025 21:46:22 +0800
Message-ID: <20251118134639.3314803-3-ivanov.mikhail1@huawei-partners.com>
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

Add test that validates behaviour of Landlock after ruleset with
unknown access is created.

Reviewed-by: Günther Noack <gnoack@google.com>
Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Adds fixture `mini`. Socket creation should be tested with capabilities
  disabled.

Changes since v2:
* Removes fixture `mini`. Network namespace is not used, so this
  fixture has become useless.
* Changes commit title and message.

Changes since v1:
* Refactors commit message.
---
 .../testing/selftests/landlock/socket_test.c  | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 tools/testing/selftests/landlock/socket_test.c

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
new file mode 100644
index 000000000000..d5716149d03f
--- /dev/null
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock tests - Socket
+ *
+ * Copyright © 2025 Huawei Tech. Co., Ltd.
+ */
+
+#define _GNU_SOURCE
+
+#include <linux/landlock.h>
+#include <sys/prctl.h>
+
+#include "common.h"
+
+#define ACCESS_LAST LANDLOCK_ACCESS_SOCKET_CREATE
+#define ACCESS_ALL LANDLOCK_ACCESS_SOCKET_CREATE
+
+/* clang-format off */
+FIXTURE(mini) {};
+/* clang-format on */
+
+FIXTURE_SETUP(mini)
+{
+	disable_caps(_metadata);
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
+		ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr,
+						      sizeof(ruleset_attr), 0));
+		ASSERT_EQ(EINVAL, errno);
+	}
+}
+
+TEST_HARNESS_MAIN
-- 
2.34.1

