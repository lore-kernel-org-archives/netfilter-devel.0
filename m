Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FE1495CB;
	Mon,  8 Apr 2024 09:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569213; cv=none; b=hqxKKLSkl9B5db9Y66YTIa5X1LDCB3kePNXJH5fWbNlIRPFXrRZ2lNtbqfwKKwefqoZquFDuM59Afxwfkm6Cvnjdmm6JtFmV5mXOxwAH/K35nBe7LbRHXIXu7qJNC7+wajL9KjNSjl6B41nQqaK+igB6q69VtWAHZXEYozEQFlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569213; c=relaxed/simple;
	bh=q/+Fvly02sF3SZAhyGWyIMgwnxDakSyLqu51kle4Hvg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vq+akBrdxIHEcZaUPd6qXi15X4OAUfhLZsxRnBQFBc22ZSH/mcgKDh2xFyQmwyxb7k0yZ2b34bHhgDLC2yflB8IMvgKnE9npU0UigXrmY65NKg7f7aqvHK9WqIwIFkx3bdxLRCMT5cfEfoTMvxo0FkdUCeVp274NerSAB30zlk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4VCkZ94d1Rz21kf8;
	Mon,  8 Apr 2024 17:39:13 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 344C61401E9;
	Mon,  8 Apr 2024 17:40:08 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:40:06 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 02/10] landlock: Add hook on socket_create()
Date: Mon, 8 Apr 2024 17:39:19 +0800
Message-ID: <20240408093927.1759381-3-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Add hook on socket_create() method. Since it'll be better to have control
over possible socket changes after family-related create() call, hook is
called on socket_post_create(). Handler only checks if the socket type
and family are allowed by domain.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 security/landlock/setup.c  |  2 ++
 security/landlock/socket.c | 72 ++++++++++++++++++++++++++++++++++++++
 security/landlock/socket.h |  2 ++
 3 files changed, 76 insertions(+)

diff --git a/security/landlock/setup.c b/security/landlock/setup.c
index 28519a45b..fd4e7e8f3 100644
--- a/security/landlock/setup.c
+++ b/security/landlock/setup.c
@@ -14,6 +14,7 @@
 #include "cred.h"
 #include "fs.h"
 #include "net.h"
+#include "socket.h"
 #include "setup.h"
 #include "task.h"
 
@@ -37,6 +38,7 @@ static int __init landlock_init(void)
 	landlock_add_task_hooks();
 	landlock_add_fs_hooks();
 	landlock_add_net_hooks();
+	landlock_add_socket_hooks();
 	landlock_initialized = true;
 	pr_info("Up and running.\n");
 	return 0;
diff --git a/security/landlock/socket.c b/security/landlock/socket.c
index 88b4ef3a1..cba584543 100644
--- a/security/landlock/socket.c
+++ b/security/landlock/socket.c
@@ -5,6 +5,10 @@
  * Copyright © 2024 Huawei Tech. Co., Ltd.
  */
 
+#include <linux/net.h>
+#include <net/sock.h>
+
+#include "cred.h"
 #include "limits.h"
 #include "ruleset.h"
 #include "socket.h"
@@ -41,3 +45,71 @@ int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
 
 	return err;
 }
+
+static access_mask_t
+get_raw_handled_socket_accesses(const struct landlock_ruleset *const domain)
+{
+	access_mask_t access_dom = 0;
+	size_t layer_level;
+
+	for (layer_level = 0; layer_level < domain->num_layers; layer_level++)
+		access_dom |= landlock_get_socket_access_mask(domain, layer_level);
+	return access_dom;
+}
+
+static const struct landlock_ruleset *get_current_socket_domain(void)
+{
+	const struct landlock_ruleset *const dom =
+		landlock_get_current_domain();
+
+	if (!dom || !get_raw_handled_socket_accesses(dom))
+		return NULL;
+
+	return dom;
+}
+
+static int current_check_access_socket(struct socket *const sock,
+				       const access_mask_t access_request)
+{
+	union socket_key socket_key;
+	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_SOCKET] = {};
+	const struct landlock_rule *rule;
+	access_mask_t handled_access;
+	struct landlock_id id = {
+		.type = LANDLOCK_KEY_SOCKET,
+	};
+	const struct landlock_ruleset *const dom = get_current_socket_domain();
+
+	if (!dom)
+		return 0;
+	if (WARN_ON_ONCE(dom->num_layers < 1))
+		return -EACCES;
+
+	socket_key.content.type = sock->type;
+	socket_key.content.domain = sock->sk->__sk_common.skc_family;
+	id.key.data = socket_key.val;
+
+	rule = landlock_find_rule(dom, id);
+	handled_access = landlock_init_layer_masks(
+		dom, access_request, &layer_masks, LANDLOCK_KEY_SOCKET);
+	if (landlock_unmask_layers(rule, handled_access, &layer_masks,
+				   ARRAY_SIZE(layer_masks)))
+		return 0;
+	return -EACCES;
+}
+
+static int hook_socket_create(struct socket *const sock,
+			    int family, int type, int protocol, int kern)
+{
+	return current_check_access_socket(sock, LANDLOCK_ACCESS_SOCKET_CREATE);
+}
+
+static struct security_hook_list landlock_hooks[] __ro_after_init = {
+	LSM_HOOK_INIT(socket_post_create, hook_socket_create),
+};
+
+__init void landlock_add_socket_hooks(void)
+{
+	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
+			   &landlock_lsmid);
+}
diff --git a/security/landlock/socket.h b/security/landlock/socket.h
index 2b8f9ae7d..152f4d427 100644
--- a/security/landlock/socket.h
+++ b/security/landlock/socket.h
@@ -10,6 +10,8 @@
 
 #include "ruleset.h"
 
+__init void landlock_add_socket_hooks(void);
+
 int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
 				 const int domain, const int type,
 				 access_mask_t access_rights);
-- 
2.34.1

