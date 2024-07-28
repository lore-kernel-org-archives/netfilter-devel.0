Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AF810F2;
	Sun, 28 Jul 2024 00:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722126384; cv=none; b=KR2xi86THra8kEl5yOFl0HwYyNnALDuv3tlQrzMef6DEERyvkHDwkTTkKS1O7Rwv0DA9AGtK0iJe+2Fk9dbWgotGpBPfG9Eu5owT8hTq+2o3t+qqdyFu5dpJLH15ycDvJLdeKGYlxB483E8y5sXeTPCJYoWzUx8nb7ZJW3+637w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722126384; c=relaxed/simple;
	bh=Bq0J4dM/Ssad6W6jRFHjz+IF5IINDQDZBd7EC9wLw2M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQb4jBrTI2AZL5ZeMqVFvXN2yxAk/5EX5vZOao58XYgvaUOdQO6aSEblxzWY6iihfhdqu6sRhGEON1xDbXno8bcL4/ElFtSoYF73QH44Hr9g4zExw6koicebJBpekeCKVCXU/ovO4lvcr+1H79WWwbbCEcxEWSH/+rPo4D/GPMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WWj2l4v4fz1L9CK;
	Sun, 28 Jul 2024 08:26:07 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A6681800D0;
	Sun, 28 Jul 2024 08:26:14 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 28 Jul 2024 08:26:12 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 1/9] landlock: Refactor current_check_access_socket() access right check
Date: Sun, 28 Jul 2024 08:25:54 +0800
Message-ID: <20240728002602.3198398-2-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml100004.china.huawei.com (7.188.51.133) To
 dggpemm500020.china.huawei.com (7.185.36.49)

The current_check_access_socket() function contains a set of address
validation checks for bind(2) and connect(2) hooks. Separate them from
an actual port access right checking. It is required for the (future)
hooks that do not perform address validation.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 security/landlock/net.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/security/landlock/net.c b/security/landlock/net.c
index c8bcd29bde09..669ba260342f 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -2,7 +2,7 @@
 /*
  * Landlock LSM - Network management and hooks
  *
- * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
+ * Copyright © 2022-2024 Huawei Tech. Co., Ltd.
  * Copyright © 2022-2023 Microsoft Corporation
  */
 
@@ -61,17 +61,34 @@ static const struct landlock_ruleset *get_current_net_domain(void)
 	return dom;
 }
 
-static int current_check_access_socket(struct socket *const sock,
-				       struct sockaddr *const address,
-				       const int addrlen,
-				       access_mask_t access_request)
+static int check_access_socket(const struct landlock_ruleset *const dom,
+			       __be16 port, access_mask_t access_request)
 {
-	__be16 port;
 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
 	const struct landlock_rule *rule;
 	struct landlock_id id = {
 		.type = LANDLOCK_KEY_NET_PORT,
 	};
+
+	id.key.data = (__force uintptr_t)port;
+	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
+
+	rule = landlock_find_rule(dom, id);
+	access_request = landlock_init_layer_masks(
+		dom, access_request, &layer_masks, LANDLOCK_KEY_NET_PORT);
+	if (landlock_unmask_layers(rule, access_request, &layer_masks,
+				   ARRAY_SIZE(layer_masks)))
+		return 0;
+
+	return -EACCES;
+}
+
+static int current_check_access_socket(struct socket *const sock,
+				       struct sockaddr *const address,
+				       const int addrlen,
+				       access_mask_t access_request)
+{
+	__be16 port;
 	const struct landlock_ruleset *const dom = get_current_net_domain();
 
 	if (!dom)
@@ -159,17 +176,7 @@ static int current_check_access_socket(struct socket *const sock,
 			return -EINVAL;
 	}
 
-	id.key.data = (__force uintptr_t)port;
-	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
-
-	rule = landlock_find_rule(dom, id);
-	access_request = landlock_init_layer_masks(
-		dom, access_request, &layer_masks, LANDLOCK_KEY_NET_PORT);
-	if (landlock_unmask_layers(rule, access_request, &layer_masks,
-				   ARRAY_SIZE(layer_masks)))
-		return 0;
-
-	return -EACCES;
+	return check_access_socket(dom, port, access_request);
 }
 
 static int hook_socket_bind(struct socket *const sock,
-- 
2.34.1

