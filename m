Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C9517BECC;
	Wed,  4 Sep 2024 10:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446923; cv=none; b=EDadu0Q6b4srU1tSMUN1/iNueMlqVvl8ab9rNG8CW7P/PQF9iUj//Br/9eUTFgBQj/B/PN1GaJgLcJISUzILYoLkqjmLOaGMKLWfqzTLGBgvoIIuDIArDQF17cnepKutz7WfLZrxJu2PxJRkLsLeqQkjs4Knedi5XQFV8YnTLrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446923; c=relaxed/simple;
	bh=9cgw1uMixmrGnP5Q7HvLQkDkkHx6GoAcxELiQiyBbHQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JjaVztLAJg+/u0UuyiE/tpiD5340q6mkdPooM+kPxhsMRs96eg/E0qxmKY2ZGJyQtyDaoazQ5pkXoY1dSt7NBlTtv+naBYsAndgIaO16eu6l2irQg9lb4uCPqQwjHOLwMhiAP7KcCNwwap9YP2Pu7bDD128hXUwAiTPd0ht5mDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzK352N5xz1j839;
	Wed,  4 Sep 2024 18:48:17 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 7878A180042;
	Wed,  4 Sep 2024 18:48:37 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:35 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 02/19] landlock: Add hook on socket creation
Date: Wed, 4 Sep 2024 18:48:07 +0800
Message-ID: <20240904104824.1844082-3-ivanov.mikhail1@huawei-partners.com>
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

Add hook on security_socket_post_create(), which checks whether the socket
type and address family are allowed by domain. Hook is called after
initializing the socket to let network stack to perform all necessary
internal checks.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v2:
* Adds check in `hook_socket_create()` to not restrict kernel space
  sockets.
* Inlines `current_check_access_socket()` in the `hook_socket_create()`.
* Fixes commit message.

Changes since v1:
* Uses lsm hook arguments instead of struct socket fields as family-type
  values.
* Packs socket family and type using helper.
* Fixes commit message.
* Formats with clang-format.
---
 security/landlock/setup.c  |  2 ++
 security/landlock/socket.c | 68 ++++++++++++++++++++++++++++++++++++++
 security/landlock/socket.h |  2 ++
 3 files changed, 72 insertions(+)

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
index cad89bb91678..60dbcf38540e 100644
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
@@ -67,3 +69,69 @@ int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
 
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
+static int hook_socket_create(struct socket *const sock, int family, int type,
+			      int protocol, int kern)
+{
+	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_SOCKET] = {};
+	const struct landlock_rule *rule;
+	access_mask_t handled_access;
+	struct landlock_id id = {
+		.type = LANDLOCK_KEY_SOCKET,
+	};
+	const struct landlock_ruleset *dom;
+
+	/* Checks only user space sockets. */
+	if (kern)
+		return 0;
+
+	dom = get_current_socket_domain();
+	if (!dom)
+		return 0;
+	if (WARN_ON_ONCE(dom->num_layers < 1))
+		return -EACCES;
+
+	id.key.data = pack_socket_key(family, type);
+
+	rule = landlock_find_rule(dom, id);
+	handled_access =
+		landlock_init_layer_masks(dom, LANDLOCK_ACCESS_SOCKET_CREATE,
+					  &layer_masks, LANDLOCK_KEY_SOCKET);
+	if (landlock_unmask_layers(rule, handled_access, &layer_masks,
+				   ARRAY_SIZE(layer_masks)))
+		return 0;
+	return -EACCES;
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

