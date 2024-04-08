Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B779482C2;
	Mon,  8 Apr 2024 09:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569211; cv=none; b=BoAo50xC/4MQEi2T9tUxYP19yHnTvo06CXGjP2cPWKaCwOiwHlA7MvSXJDmvoU31ulDzmZQWSVyhms9yGpqNBmpI3PK1B/vLHpOlc6652xnBM28IRFQuoYkkv5zOgBcNDlASgf+JdOWa+k8OEhHLjcVTJ8f7QXJdTB+f59G2xMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569211; c=relaxed/simple;
	bh=kcCTq1AVFjWJZMDG2thNPXI906vRF5PYNOxjJx4Zcls=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Se3qKK5SF99tl9dHprO4Yf7N7bXt9NOXldz6ZYvxj4kOBAQngBE5VcHcX4or9bO9zscawwVDD3YBlnKvSKZiE8CzwTYfVeG7dxdnPV/VQaUDibsQbmgXn+sVWx3x7JCRpV9TY0J/JY0k7onHnj5qDZ9+e6nZ2ckli/VyjCARqeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VCkWv691kz29dPS;
	Mon,  8 Apr 2024 17:37:15 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id F020E1401E9;
	Mon,  8 Apr 2024 17:40:05 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:40:03 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 01/10] landlock: Support socket access-control
Date: Mon, 8 Apr 2024 17:39:18 +0800
Message-ID: <20240408093927.1759381-2-ivanov.mikhail1@huawei-partners.com>
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

Add new socket-related rule type, presented via landlock_socket_attr
struct. Add all neccessary entities for socket ruleset support.
Add flag LANDLOCK_ACCESS_SOCKET_CREATE that will provide the
ability to control socket creation.

Change landlock_key.data type from uinptr_t to u64. Socket rule has to
contain 32-bit socket family and type values, so landlock_key can be
represented as 64-bit number the first 32 bits of which correspond to
the socket family and last - to the type.

Change ABI version to 5.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 include/uapi/linux/landlock.h                | 49 +++++++++++++++++
 security/landlock/Makefile                   |  2 +-
 security/landlock/limits.h                   |  5 ++
 security/landlock/net.c                      |  2 +-
 security/landlock/ruleset.c                  | 35 +++++++++++--
 security/landlock/ruleset.h                  | 44 ++++++++++++++--
 security/landlock/socket.c                   | 43 +++++++++++++++
 security/landlock/socket.h                   | 17 ++++++
 security/landlock/syscalls.c                 | 55 ++++++++++++++++++--
 tools/testing/selftests/landlock/base_test.c |  2 +-
 10 files changed, 241 insertions(+), 13 deletions(-)
 create mode 100644 security/landlock/socket.c
 create mode 100644 security/landlock/socket.h

diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index 25c8d7677..8551ade38 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -37,6 +37,13 @@ struct landlock_ruleset_attr {
 	 * rule explicitly allow them.
 	 */
 	__u64 handled_access_net;
+
+	/**
+	 * @handled_access_net: Bitmask of actions (cf. `Socket flags`_)
+	 * that is handled by this ruleset and should then be forbidden if no
+	 * rule explicitly allow them.
+	 */
+	__u64 handled_access_socket;
 };
 
 /*
@@ -65,6 +72,11 @@ enum landlock_rule_type {
 	 * landlock_net_port_attr .
 	 */
 	LANDLOCK_RULE_NET_PORT,
+	/**
+	 * @LANDLOCK_RULE_SOCKET: Type of a &struct
+	 * landlock_socket_attr .
+	 */
+	LANDLOCK_RULE_SOCKET,
 };
 
 /**
@@ -115,6 +127,27 @@ struct landlock_net_port_attr {
 	__u64 port;
 };
 
+/**
+ * struct landlock_socket_attr - Socket definition
+ *
+ * Argument of sys_landlock_add_rule().
+ */
+struct landlock_socket_attr {
+	/**
+	 * @allowed_access: Bitmask of allowed access for a socket
+	 * (cf. `Socket flags`_).
+	 */
+	__u64 allowed_access;
+	/**
+	 * @domain: Protocol family used for communication (see socket(2)).
+	 */
+	int domain;
+	/**
+	 * @type: Socket type (see socket(2)).
+	 */
+	int type;
+};
+
 /**
  * DOC: fs_access
  *
@@ -244,4 +277,20 @@ struct landlock_net_port_attr {
 #define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
 #define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
 /* clang-format on */
+
+/**
+ * DOC: socket_acess
+ *
+ * Socket flags
+ * ~~~~~~~~~~~~~~~~
+ *
+ * These flags enable to restrict a sandboxed process to a set of
+ * socket-related actions for specific protocols. This is supported
+ * since the Landlock ABI version 5.
+ *
+ * - %LANDLOCK_ACCESS_SOCKET_CREATE: Create a socket
+ */
+/* clang-format off */
+#define LANDLOCK_ACCESS_SOCKET_CREATE			(1ULL << 0)
+/* clang-format on */
 #endif /* _UAPI_LINUX_LANDLOCK_H */
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index b4538b7cf..ff1dd98f6 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
 landlock-y := setup.o syscalls.o object.o ruleset.o \
-	cred.o task.o fs.o
+	cred.o task.o fs.o socket.o
 
 landlock-$(CONFIG_INET) += net.o
diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index 93c9c6f91..ebdab587c 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -28,6 +28,11 @@
 #define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
 #define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS
 
+#define LANDLOCK_LAST_ACCESS_SOCKET	    LANDLOCK_ACCESS_SOCKET_CREATE
+#define LANDLOCK_MASK_ACCESS_SOCKET	    ((LANDLOCK_LAST_ACCESS_SOCKET << 1) - 1)
+#define LANDLOCK_NUM_ACCESS_SOCKET		__const_hweight64(LANDLOCK_MASK_ACCESS_SOCKET)
+#define LANDLOCK_SHIFT_ACCESS_SOCKET	LANDLOCK_NUM_ACCESS_SOCKET
+
 /* clang-format on */
 
 #endif /* _SECURITY_LANDLOCK_LIMITS_H */
diff --git a/security/landlock/net.c b/security/landlock/net.c
index c8bcd29bd..0e3770d14 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -159,7 +159,7 @@ static int current_check_access_socket(struct socket *const sock,
 			return -EINVAL;
 	}
 
-	id.key.data = (__force uintptr_t)port;
+	id.key.data = (__force u64)port;
 	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
 
 	rule = landlock_find_rule(dom, id);
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index e0a5fbf92..1f1ed8181 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -40,6 +40,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 #if IS_ENABLED(CONFIG_INET)
 	new_ruleset->root_net_port = RB_ROOT;
 #endif /* IS_ENABLED(CONFIG_INET) */
+	new_ruleset->root_socket = RB_ROOT;
 
 	new_ruleset->num_layers = num_layers;
 	/*
@@ -52,12 +53,13 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 
 struct landlock_ruleset *
 landlock_create_ruleset(const access_mask_t fs_access_mask,
-			const access_mask_t net_access_mask)
+			const access_mask_t net_access_mask,
+			const access_mask_t socket_access_mask)
 {
 	struct landlock_ruleset *new_ruleset;
 
 	/* Informs about useless ruleset. */
-	if (!fs_access_mask && !net_access_mask)
+	if (!fs_access_mask && !net_access_mask && !socket_access_mask)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
 	if (IS_ERR(new_ruleset))
@@ -66,6 +68,8 @@ landlock_create_ruleset(const access_mask_t fs_access_mask,
 		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
 	if (net_access_mask)
 		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
+	if (socket_access_mask)
+		landlock_add_socket_access_mask(new_ruleset, socket_access_mask, 0);
 	return new_ruleset;
 }
 
@@ -89,6 +93,9 @@ static bool is_object_pointer(const enum landlock_key_type key_type)
 		return false;
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	case LANDLOCK_KEY_SOCKET:
+		return false;
+
 	default:
 		WARN_ON_ONCE(1);
 		return false;
@@ -146,6 +153,9 @@ static struct rb_root *get_root(struct landlock_ruleset *const ruleset,
 		return &ruleset->root_net_port;
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	case LANDLOCK_KEY_SOCKET:
+		return &ruleset->root_socket;
+
 	default:
 		WARN_ON_ONCE(1);
 		return ERR_PTR(-EINVAL);
@@ -175,7 +185,8 @@ static void build_check_ruleset(void)
 	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
 	BUILD_BUG_ON(access_masks <
 		     ((LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS) |
-		      (LANDLOCK_MASK_ACCESS_NET << LANDLOCK_SHIFT_ACCESS_NET)));
+		      (LANDLOCK_MASK_ACCESS_NET << LANDLOCK_SHIFT_ACCESS_NET) |
+			  (LANDLOCK_MASK_ACCESS_SOCKET << LANDLOCK_SHIFT_ACCESS_SOCKET)));
 }
 
 /**
@@ -399,6 +410,11 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 		goto out_unlock;
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	/* Merges the @src socket tree. */
+	err = merge_tree(dst, src, LANDLOCK_KEY_SOCKET);
+	if (err)
+		goto out_unlock;
+
 out_unlock:
 	mutex_unlock(&src->lock);
 	mutex_unlock(&dst->lock);
@@ -462,6 +478,11 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
 		goto out_unlock;
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	/* Copies the @parent socket tree. */
+	err = inherit_tree(parent, child, LANDLOCK_KEY_SOCKET);
+	if (err)
+		goto out_unlock;
+
 	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
 		err = -EINVAL;
 		goto out_unlock;
@@ -498,6 +519,10 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
 		free_rule(freeme, LANDLOCK_KEY_NET_PORT);
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	rbtree_postorder_for_each_entry_safe(freeme, next,
+					     &ruleset->root_socket, node)
+		free_rule(freeme, LANDLOCK_KEY_SOCKET);
+
 	put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
 }
@@ -708,6 +733,10 @@ landlock_init_layer_masks(const struct landlock_ruleset *const domain,
 		break;
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	case LANDLOCK_KEY_SOCKET:
+		get_access_mask = landlock_get_socket_access_mask;
+		num_access = LANDLOCK_NUM_ACCESS_SOCKET;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return 0;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index c7f152678..f4213db09 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -72,10 +72,10 @@ union landlock_key {
 	 */
 	struct landlock_object *object;
 	/**
-	 * @data: Raw data to identify an arbitrary 32-bit value
+	 * @data: Raw data to identify an arbitrary 64-bit value
 	 * (e.g. a TCP port).
 	 */
-	uintptr_t data;
+	u64 data;
 };
 
 /**
@@ -92,6 +92,12 @@ enum landlock_key_type {
 	 * node keys.
 	 */
 	LANDLOCK_KEY_NET_PORT,
+
+	/**
+	 * @LANDLOCK_KEY_SOCKET: Type of &landlock_ruleset.root_socket's
+	 * node keys.
+	 */
+	LANDLOCK_KEY_SOCKET,
 };
 
 /**
@@ -177,6 +183,15 @@ struct landlock_ruleset {
 	struct rb_root root_net_port;
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	/**
+	 * @root_socket: Root of a red-black tree containing &struct
+	 * landlock_rule nodes with socket type, described by (domain, type)
+	 * pair (see socket(2)). Once a ruleset is tied to a
+	 * process (i.e. as a domain), this tree is immutable until @usage
+	 * reaches zero.
+	 */
+	struct rb_root root_socket;
+
 	/**
 	 * @hierarchy: Enables hierarchy identification even when a parent
 	 * domain vanishes.  This is needed for the ptrace protection.
@@ -233,7 +248,8 @@ struct landlock_ruleset {
 
 struct landlock_ruleset *
 landlock_create_ruleset(const access_mask_t access_mask_fs,
-			const access_mask_t access_mask_net);
+			const access_mask_t access_mask_net,
+			const access_mask_t socket_access_mask);
 
 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
@@ -282,6 +298,19 @@ landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,
 		(net_mask << LANDLOCK_SHIFT_ACCESS_NET);
 }
 
+static inline void
+landlock_add_socket_access_mask(struct landlock_ruleset *const ruleset,
+			     const access_mask_t socket_access_mask,
+			     const u16 layer_level)
+{
+	access_mask_t socket_mask = socket_access_mask & LANDLOCK_MASK_ACCESS_SOCKET;
+
+	/* Should already be checked in sys_landlock_create_ruleset(). */
+	WARN_ON_ONCE(socket_access_mask != socket_mask);
+	ruleset->access_masks[layer_level] |=
+		(socket_mask << LANDLOCK_SHIFT_ACCESS_SOCKET);
+}
+
 static inline access_mask_t
 landlock_get_raw_fs_access_mask(const struct landlock_ruleset *const ruleset,
 				const u16 layer_level)
@@ -309,6 +338,15 @@ landlock_get_net_access_mask(const struct landlock_ruleset *const ruleset,
 	       LANDLOCK_MASK_ACCESS_NET;
 }
 
+static inline access_mask_t
+landlock_get_socket_access_mask(const struct landlock_ruleset *const ruleset,
+			     const u16 layer_level)
+{
+	return (ruleset->access_masks[layer_level] >>
+		LANDLOCK_SHIFT_ACCESS_SOCKET) &
+	       LANDLOCK_MASK_ACCESS_SOCKET;
+}
+
 bool landlock_unmask_layers(const struct landlock_rule *const rule,
 			    const access_mask_t access_request,
 			    layer_mask_t (*const layer_masks)[],
diff --git a/security/landlock/socket.c b/security/landlock/socket.c
new file mode 100644
index 000000000..88b4ef3a1
--- /dev/null
+++ b/security/landlock/socket.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - Socket management and hooks
+ *
+ * Copyright © 2024 Huawei Tech. Co., Ltd.
+ */
+
+#include "limits.h"
+#include "ruleset.h"
+#include "socket.h"
+
+union socket_key {
+	struct {
+		int domain;
+		int type;
+	} __packed content;
+	u64 val;
+};
+
+int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
+			     const int domain, const int type, access_mask_t access_rights)
+{
+	int err;
+	const union socket_key socket_key = {
+		.content.domain = domain,
+		.content.type = type
+	};
+
+	const struct landlock_id id = {
+		.key.data = socket_key.val,
+		.type = LANDLOCK_KEY_SOCKET,
+	};
+
+	/* Transforms relative access rights to absolute ones. */
+	access_rights |= LANDLOCK_MASK_ACCESS_SOCKET &
+			 ~landlock_get_socket_access_mask(ruleset, 0);
+
+	mutex_lock(&ruleset->lock);
+	err = landlock_insert_rule(ruleset, id, access_rights);
+	mutex_unlock(&ruleset->lock);
+
+	return err;
+}
diff --git a/security/landlock/socket.h b/security/landlock/socket.h
new file mode 100644
index 000000000..2b8f9ae7d
--- /dev/null
+++ b/security/landlock/socket.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - Socket management and hooks
+ *
+ * Copyright © 2024 Huawei Tech. Co., Ltd.
+ */
+
+#ifndef _SECURITY_LANDLOCK_SOCKET_H
+#define _SECURITY_LANDLOCK_SOCKET_H
+
+#include "ruleset.h"
+
+int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
+				 const int domain, const int type,
+				 access_mask_t access_rights);
+
+#endif /* _SECURITY_LANDLOCK_SOCKET_H */
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 6788e73b6..66c9800c2 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -30,6 +30,7 @@
 #include "fs.h"
 #include "limits.h"
 #include "net.h"
+#include "socket.h"
 #include "ruleset.h"
 #include "setup.h"
 
@@ -88,7 +89,8 @@ static void build_check_abi(void)
 	struct landlock_ruleset_attr ruleset_attr;
 	struct landlock_path_beneath_attr path_beneath_attr;
 	struct landlock_net_port_attr net_port_attr;
-	size_t ruleset_size, path_beneath_size, net_port_size;
+	struct landlock_socket_attr socket_attr;
+	size_t ruleset_size, path_beneath_size, net_port_size, socket_size;
 
 	/*
 	 * For each user space ABI structures, first checks that there is no
@@ -97,8 +99,9 @@ static void build_check_abi(void)
 	 */
 	ruleset_size = sizeof(ruleset_attr.handled_access_fs);
 	ruleset_size += sizeof(ruleset_attr.handled_access_net);
+	ruleset_size += sizeof(ruleset_attr.handled_access_socket);
 	BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
-	BUILD_BUG_ON(sizeof(ruleset_attr) != 16);
+	BUILD_BUG_ON(sizeof(ruleset_attr) != 24);
 
 	path_beneath_size = sizeof(path_beneath_attr.allowed_access);
 	path_beneath_size += sizeof(path_beneath_attr.parent_fd);
@@ -109,6 +112,12 @@ static void build_check_abi(void)
 	net_port_size += sizeof(net_port_attr.port);
 	BUILD_BUG_ON(sizeof(net_port_attr) != net_port_size);
 	BUILD_BUG_ON(sizeof(net_port_attr) != 16);
+
+	socket_size = sizeof(socket_attr.allowed_access);
+	socket_size += sizeof(socket_attr.domain);
+	socket_size += sizeof(socket_attr.type);
+	BUILD_BUG_ON(sizeof(socket_attr) != socket_size);
+	BUILD_BUG_ON(sizeof(socket_attr) != 16);
 }
 
 /* Ruleset handling */
@@ -149,7 +158,7 @@ static const struct file_operations ruleset_fops = {
 	.write = fop_dummy_write,
 };
 
-#define LANDLOCK_ABI_VERSION 4
+#define LANDLOCK_ABI_VERSION 5
 
 /**
  * sys_landlock_create_ruleset - Create a new ruleset
@@ -213,9 +222,15 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 	    LANDLOCK_MASK_ACCESS_NET)
 		return -EINVAL;
 
+	/* Checks socket content (and 32-bits cast). */
+	if ((ruleset_attr.handled_access_socket | LANDLOCK_MASK_ACCESS_SOCKET) !=
+	    LANDLOCK_MASK_ACCESS_SOCKET)
+		return -EINVAL;
+
 	/* Checks arguments and transforms to kernel struct. */
 	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
-					  ruleset_attr.handled_access_net);
+					  ruleset_attr.handled_access_net,
+					  ruleset_attr.handled_access_socket);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);
 
@@ -371,6 +386,35 @@ static int add_rule_net_port(struct landlock_ruleset *ruleset,
 					net_port_attr.allowed_access);
 }
 
+static int add_rule_socket(struct landlock_ruleset *ruleset,
+			     const void __user *const rule_attr)
+{
+	struct landlock_socket_attr socket_attr;
+	int res;
+	access_mask_t mask;
+
+	/* Copies raw user space buffer. */
+	res = copy_from_user(&socket_attr, rule_attr, sizeof(socket_attr));
+	if (res)
+		return -EFAULT;
+
+	/*
+	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
+	 * are ignored by network actions.
+	 */
+	if (!socket_attr.allowed_access)
+		return -ENOMSG;
+
+	/* Checks that allowed_access matches the @ruleset constraints. */
+	mask = landlock_get_socket_access_mask(ruleset, 0);
+	if ((socket_attr.allowed_access | mask) != mask)
+		return -EINVAL;
+
+	/* Imports the new rule. */
+	return landlock_append_socket_rule(ruleset, socket_attr.domain,
+					socket_attr.type, socket_attr.allowed_access);
+}
+
 /**
  * sys_landlock_add_rule - Add a new rule to a ruleset
  *
@@ -429,6 +473,9 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	case LANDLOCK_RULE_NET_PORT:
 		err = add_rule_net_port(ruleset, rule_attr);
 		break;
+	case LANDLOCK_RULE_SOCKET:
+		err = add_rule_socket(ruleset, rule_attr);
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
index 646f778df..d292b419c 100644
--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -75,7 +75,7 @@ TEST(abi_version)
 	const struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
 	};
-	ASSERT_EQ(4, landlock_create_ruleset(NULL, 0,
+	ASSERT_EQ(5, landlock_create_ruleset(NULL, 0,
 					     LANDLOCK_CREATE_RULESET_VERSION));
 
 	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0,
-- 
2.34.1

