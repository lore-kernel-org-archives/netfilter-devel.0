Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6215A83A09;
	Fri, 24 May 2024 09:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543063; cv=none; b=gHFb1JLyw/rN20EY2WTory+22Rno/uZCoPkPMltFme8MPR1sZ/Q5lugDC+rLYgDL/dJMHPHOcLTcHNjk3/yYy//RrFOpqnEbHmw6/0OfZijhZFx4ogw0zbLJYLEF2AWXkXP+c1uc36Z7wOBBB6gNCrzEBotlU8ZyhceY7fGlcIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543063; c=relaxed/simple;
	bh=rp1P44Lj4paszBTwxqlV9sGSYD1fJ72KyW0609FTmEQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sNpAsKWMSmJ6qWZL3rIWazj5V9M1RxK3TCqx9vygZh28c7jNWQd+/OfuInSvZOV3vf/U63HRDKgBfwVw/+hA+iqG57YPBuktDuBDCx7Iq0ef7h8Lu42E8t5V2XMPgcfE0xTJBL0B8mf2/VzqE5/H7Y2RZ9Z5TycmX0AU9sKtjGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Vm0775hFVzsRlm;
	Fri, 24 May 2024 17:27:15 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D33218007A;
	Fri, 24 May 2024 17:30:59 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 24 May 2024 17:30:57 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 02/12] landlock: Add hook on socket creation
Date: Fri, 24 May 2024 17:30:05 +0800
Message-ID: <20240524093015.2402952-3-ivanov.mikhail1@huawei-partners.com>
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

Add hook to security_socket_post_create(), which checks whether the socket
type and family are allowed by domain. Hook is called after initializing
the socket in the network stack to not wrongfully return EACCES for a
family-type pair, which is considered invalid by the protocol.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Use lsm hook arguments instead of struct socket fields as family-type
  values.
* Packs socket family and type using helper.
* Fixes commit message.
* Formats with clang-format.
---
 security/landlock/setup.c  |  2 ++
 security/landlock/socket.c | 70 ++++++++++++++++++++++++++++++++++++++
 security/landlock/socket.h |  2 ++
 3 files changed, 74 insertions(+)

diff --git a/security/landlock/setup.c b/security/landlock/setup.c
index 28519a45b11f..fd4e7e8f3cb2 100644
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
index 1249a4a36503..b2775473b3dc 100644
--- a/security/landlock/socket.c
+++ b/security/landlock/socket.c
@@ -8,7 +8,9 @@
 #include <linux/net.h>
 #include <linux/socket.h>
 #include <linux/stddef.h>
+#include <net/ipv6.h>
 
+#include "cred.h"
 #include "limits.h"
 #include "ruleset.h"
 #include "socket.h"
@@ -58,3 +60,71 @@ int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
 
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
+		access_dom |=
+			landlock_get_socket_access_mask(domain, layer_level);
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
+static int current_check_access_socket(struct socket *const sock, int family,
+				       int type,
+				       const access_mask_t access_request)
+{
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
+	id.key.data = pack_socket_key(family, type);
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
+static int hook_socket_create(struct socket *const sock, int family, int type,
+			      int protocol, int kern)
+{
+	return current_check_access_socket(sock, family, type,
+					   LANDLOCK_ACCESS_SOCKET_CREATE);
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
index 8519357f1c39..5c36eae9732f 100644
--- a/security/landlock/socket.h
+++ b/security/landlock/socket.h
@@ -10,6 +10,8 @@
 
 #include "ruleset.h"
 
+__init void landlock_add_socket_hooks(void);
+
 int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
 				const int family, const int type,
 				access_mask_t access_rights);
-- 
2.34.1

