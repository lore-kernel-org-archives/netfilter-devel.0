Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6063587A7;
	Tue, 18 Nov 2025 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473635; cv=none; b=jldAvRSUaPaO+X01YjwERrCWKFqLm1g3ZEY9bO5gUKyM+qn88Cn3L1gVMIY3SNubxypvrNPe1+MouppuF7Uo87UnJPrNc9cTcG5by/fVDAVm0Fx6klGSX7FiiRQ3zDCtJUnmlS0ZUmHq93RSNZLTPPuQCa0gd3Z5k44av0v2goc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473635; c=relaxed/simple;
	bh=8vhB7t6ZImu0vEenaXgZH0BbBgdFX1eOpzorYrl15EM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=US+c+6zbk4lJ6EEaHTSBVfsp88WANtUTF9+KCB/Y8vJXeMq2Uvc6zYMOVKkMRAZT+RjaZozlUFzUX6RSSZXDXS5nsrteYk9sDEOHYPIMBVpWj9q2HN5tjyRmRAex9XwxhKD1AcLeJQTUGfVm02OjEunBsxghbltxbh1EwSt2BE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9k2tplzHnGkN;
	Tue, 18 Nov 2025 21:46:34 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 4F2E3140446;
	Tue, 18 Nov 2025 21:47:05 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:05 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 06/19] landlock: Add hook on socket creation
Date: Tue, 18 Nov 2025 21:46:26 +0800
Message-ID: <20251118134639.3314803-7-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Add hook on security_socket_create(), which checks whether the socket
of requested protocol is allowed by domain.

Due to support of masked protocols Landlock tries to find one of the
4 rules that can allow creation of requested protocol.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Changes LSM hook from socket_post_create to socket_create so
  creation would be blocked before socket allocation and initialization.
* Uses credential instead of domain in hook_socket create.
* Removes get_raw_handled_socket_accesses.
* Adds checks for rules with wildcard type and protocol values.
* Minor refactoring, fixes.

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
 security/landlock/setup.c  |  2 +
 security/landlock/socket.c | 78 ++++++++++++++++++++++++++++++++++++++
 security/landlock/socket.h |  2 +
 3 files changed, 82 insertions(+)

diff --git a/security/landlock/setup.c b/security/landlock/setup.c
index bd53c7a56ab9..140a53b022f7 100644
--- a/security/landlock/setup.c
+++ b/security/landlock/setup.c
@@ -17,6 +17,7 @@
 #include "fs.h"
 #include "id.h"
 #include "net.h"
+#include "socket.h"
 #include "setup.h"
 #include "task.h"
 
@@ -68,6 +69,7 @@ static int __init landlock_init(void)
 	landlock_add_task_hooks();
 	landlock_add_fs_hooks();
 	landlock_add_net_hooks();
+	landlock_add_socket_hooks();
 	landlock_init_id();
 	landlock_initialized = true;
 	pr_info("Up and running.\n");
diff --git a/security/landlock/socket.c b/security/landlock/socket.c
index 28a80dcad629..d7e6e7b92b7a 100644
--- a/security/landlock/socket.c
+++ b/security/landlock/socket.c
@@ -103,3 +103,81 @@ int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
 
 	return err;
 }
+
+static int check_socket_access(const struct landlock_ruleset *dom,
+			       uintptr_t key,
+			       layer_mask_t (*const layer_masks)[],
+			       access_mask_t handled_access)
+{
+	const struct landlock_rule *rule;
+	struct landlock_id id = {
+		.type = LANDLOCK_KEY_SOCKET,
+	};
+
+	id.key.data = key;
+	rule = landlock_find_rule(dom, id);
+	if (landlock_unmask_layers(rule, handled_access, layer_masks,
+				   LANDLOCK_NUM_ACCESS_SOCKET))
+		return 0;
+	return -EACCES;
+}
+
+static int hook_socket_create(int family, int type, int protocol, int kern)
+{
+	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_SOCKET] = {};
+	access_mask_t handled_access;
+	const struct access_masks masks = {
+		.socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	const struct landlock_cred_security *const subject =
+		landlock_get_applicable_subject(current_cred(), masks, NULL);
+	uintptr_t key;
+
+	if (!subject)
+		return 0;
+	/* Checks only user space sockets. */
+	if (kern)
+		return 0;
+
+	handled_access = landlock_init_layer_masks(
+		subject->domain, LANDLOCK_ACCESS_SOCKET_CREATE, &layer_masks,
+		LANDLOCK_KEY_SOCKET);
+	/*
+	 * Error could happen due to parameters are outside of the allowed range,
+	 * so this combination couldn't be added in ruleset previously.
+	 * Therefore, it's not permitted.
+	 */
+	if (pack_socket_key(family, type, protocol, &key) == -EACCES)
+		return -EACCES;
+	if (check_socket_access(subject->domain, key, &layer_masks,
+				handled_access) == 0)
+		return 0;
+
+	/* Ranges were already checked. */
+	(void)pack_socket_key(family, TYPE_ALL, protocol, &key);
+	if (check_socket_access(subject->domain, key, &layer_masks,
+				handled_access) == 0)
+		return 0;
+
+	(void)pack_socket_key(family, type, PROTOCOL_ALL, &key);
+	if (check_socket_access(subject->domain, key, &layer_masks,
+				handled_access) == 0)
+		return 0;
+
+	(void)pack_socket_key(family, TYPE_ALL, PROTOCOL_ALL, &key);
+	if (check_socket_access(subject->domain, key, &layer_masks,
+				handled_access) == 0)
+		return 0;
+
+	return -EACCES;
+}
+
+static struct security_hook_list landlock_hooks[] __ro_after_init = {
+	LSM_HOOK_INIT(socket_create, hook_socket_create),
+};
+
+__init void landlock_add_socket_hooks(void)
+{
+	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
+			   &landlock_lsmid);
+}
diff --git a/security/landlock/socket.h b/security/landlock/socket.h
index bd0ac74c39e2..3980a3d46534 100644
--- a/security/landlock/socket.h
+++ b/security/landlock/socket.h
@@ -15,4 +15,6 @@ int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
 				const s32 protocol,
 				access_mask_t access_rights);
 
+__init void landlock_add_socket_hooks(void);
+
 #endif /* _SECURITY_LANDLOCK_SOCKET_H */
-- 
2.34.1

