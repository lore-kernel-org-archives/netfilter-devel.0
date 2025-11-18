Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF25E2EDD4D;
	Tue, 18 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473632; cv=none; b=c2dmR/kf9nTRtQMQj/f/WAhjHosSvA9zuRS5/Z0m8mfNbxhDH6NmKtpoAurpmMGT0DEu0tWZ6PkSAUJHynEX1DlhRykw6a7s+YAbM7MkBzxtQv0f6OR5x3yjuCOKcckgn3fWO/fnzjh6Vihzc8s1dPeFmtLxV7qJgvMh6LTXr94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473632; c=relaxed/simple;
	bh=PD4IvgtUa/fEOL7szby026IbFAsqsnNQ2UH6z9T0I0U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ij5dlfCI3VIr2FRXMGk0ZjyZo7mlFdM5f/bfqX0BDm8o7x0dmy6BkKvJTknP/7z9KR1cGzjR2jqDXsoiBEEweVwagPbhT/NpTS8gW3PcTSLFKMs3sW0JhC4fCt/XrCrM5jPIL65kbvQbDnmaZDt6+/6TobhrMLVsly3aL3xqW1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9j6Rb4zHnH66;
	Tue, 18 Nov 2025 21:46:33 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id C8A7014033F;
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
Subject: [RFC PATCH v4 01/19] landlock: Support socket access-control
Date: Tue, 18 Nov 2025 21:46:21 +0800
Message-ID: <20251118134639.3314803-2-ivanov.mikhail1@huawei-partners.com>
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

Landlock implements the `LANDLOCK_RULE_NET_PORT` rule type, which provides
fine-grained control of actions for a specific protocol. Any action or
protocol that is not supported by this rule can not be controlled. As a
result, protocols for which fine-grained control is not supported can be
used in a sandboxed system and lead to vulnerabilities or unexpected
behavior.

Controlling the protocols used will allow to use only those that are
necessary for the system and/or which have fine-grained Landlock control
through others types of rules (e.g. TCP bind/connect control with
`LANDLOCK_RULE_NET_PORT`, UNIX bind control with
`LANDLOCK_RULE_PATH_BENEATH`). Consider following examples:

* Server may want to use only TCP sockets for which there is fine-grained
  control of bind(2) and connect(2) actions [1].
* System that does not need a network or that may want to disable network
  for security reasons (e.g. [2]) can achieve this by restricting the use
  of all possible protocols.

This patch implements such control by restricting socket creation in a
sandboxed process. Introduced changes are listed below.

Add `LANDLOCK_RULE_SOCKET` rule type that restricts actions on sockets.
This rule uses values of protocol family, protocol number and socket type
(cf. socket(2)) to determine sockets that should be restricted. This is
represented in a struct landlock_socket_attr:

  struct landlock_socket_attr {
    __u64 allowed_access;
    __s32 family; /* same as domain in socket(2) */
    __s32 type; /* see socket(2) */
    __s32 protocol;
  };

Add `LANDLOCK_ACCESS_SOCKET_CREATE` access right that corresponds to the
creation of user space sockets (eg. by calling socket(2) system call).
In the case of connection-based socket types, this does not restrict the
actions that result in creation of sockets used for messaging between
already existing endpoints (e.g. accept(2), SCTP_SOCKOPT_PEELOFF).
Also, this does not restrict any other socket-related actions such as
bind(2) or send(2). All restricted actions are enlisted in the
documentation of this access right.

As with all other access rights, using `LANDLOCK_ACCESS_SOCKET_CREATE`
does not affect the actions on sockets which were created before
sandboxing.

In some cases it may be useful to define a single rule that will enable
entire protocol family or all protocols which correspond to specified
family and type.

Add "wildcard" values for type, protocol fields to make it possible to
define rule for a set of protocols. Setting wildcard means that rule
allows every socket type or protocol inside protocol family. For example,
following rule allows creating sockets of each protocol corresponding to
INET family (ie. TCP, SCTP, UDP, ..):

  struct landlock_socket_attr allow_inet {
    .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
    .family = AF_INET,
    .type = -1,
    .protocol = -1,
  };

It is possible to create sockets of the same protocol with different
protocol number values. For example, TCP sockets can be created using one
of the following commands:
    1. fd = socket(AF_INET, SOCK_STREAM, 0);
    2. fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
Whereas IPPROTO_TCP = 6. Protocol number 0 correspond to the default
protocol of the given protocol family and can be mapped to another
value.

Socket rules do not perform such mappings to not increase complexity
of rules definition and their maintenance.

Add socket.c file that will contain socket rules management and LSM hooks.

Support socket rule storage in landlock ruleset. Acceptable ranges for
family and type fields are [0, U8_MAX) and for the protocol field it is
[0, U16_MAX).

Implement helper pack_socket_key() to convert 32-bit family, type and
protocol values into uintptr_t. This is possible due to the fact that
family and type values are limited to AF_MAX (= 46), SOCK_MAX (= 11)
constants. These assumption is checked in build-time. Protocol value is
expected to be less than UINT16_MAX. If user tries to define a rule with
values outside ranges, landlock_add_rule returns with -EINVAL.

Support socket rules in landlock syscalls. Change ABI version to 8.

[1] https://lore.kernel.org/all/ZJvy2SViorgc+cZI@google.com/
[2] https://cr.yp.to/unix/disablenetwork.html

Closes: https://github.com/landlock-lsm/linux/issues/6
Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Changes ABI version from 6 to 8.
* landlock_socket_attr changes:
  * Supports protocol field.
  * Supports wildcard values for type, protocol fields.
  * Changes data type of family and type fields from int to __s32
* Rewrites commit message.
* Fixes grammar.
* Minor fixes.

Changes since v2:
* Refactors access_mask for `LANDLOCK_RULE_SOCKET`.
* Changes type of 'socket_key.packed' from 'uintptr_t' to 'unsigned int'
  in order to fix UB in pack_socket_key().
* Accepts (AF_INET, SOCK_PACKET) as an alias for (AF_PACKET, SOCK_PACKET)
  in landlock_append_socket_rule().
* Fixes documentation.
* Rewrites commit message.
* Fixes grammar.
* Minor fixes.

Changes since v1:
* Reverts landlock_key.data type from u64 to uinptr_t.
* Adds helper to pack domain and type values into uintptr_t.
* Denies inserting socket rule with invalid family and type.
* Renames 'domain' to 'family' in landlock_socket_attr.
* Updates ABI version to 6 since ioctl patches changed it to 5.
* Formats code with clang-format.
* Minor fixes.
---
 include/uapi/linux/landlock.h                |  60 ++++++++++-
 security/landlock/Makefile                   |   2 +-
 security/landlock/access.h                   |   3 +
 security/landlock/limits.h                   |   4 +
 security/landlock/ruleset.c                  |  37 +++++--
 security/landlock/ruleset.h                  |  46 ++++++--
 security/landlock/socket.c                   | 105 +++++++++++++++++++
 security/landlock/socket.h                   |  18 ++++
 security/landlock/syscalls.c                 |  61 ++++++++++-
 tools/testing/selftests/landlock/base_test.c |   2 +-
 10 files changed, 319 insertions(+), 19 deletions(-)
 create mode 100644 security/landlock/socket.c
 create mode 100644 security/landlock/socket.h

diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index f030adc462ee..030c96cb5d25 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -45,6 +45,11 @@ struct landlock_ruleset_attr {
 	 * flags`_).
 	 */
 	__u64 handled_access_net;
+	/**
+	 * @handled_access_socket: Bitmask of handled actions performed on sockets
+	 * (cf. `Socket flags`).
+	 */
+	__u64 handled_access_socket;
 	/**
 	 * @scoped: Bitmask of scopes (cf. `Scope flags`_)
 	 * restricting a Landlock domain from accessing outside
@@ -140,6 +145,11 @@ enum landlock_rule_type {
 	 * landlock_net_port_attr .
 	 */
 	LANDLOCK_RULE_NET_PORT,
+	/**
+	 * @LANDLOCK_RULE_SOCKET: Type of a &struct
+	 * landlock_socket_attr.
+	 */
+	LANDLOCK_RULE_SOCKET,
 };
 
 /**
@@ -191,6 +201,33 @@ struct landlock_net_port_attr {
 	__u64 port;
 };
 
+/**
+ * struct landlock_socket_attr - Socket protocol definition
+ *
+ * Argument of sys_landlock_add_rule().
+ */
+struct landlock_socket_attr {
+	/**
+	 * @allowed_access: Bitmask of allowed access for a socket protocol
+	 * (cf. `Socket flags`_).
+	 */
+	__u64 allowed_access;
+	/**
+	 * @family: Protocol family used for communication
+	 * (cf. include/linux/socket.h).
+	 */
+	__s32 family;
+	/**
+	 * @type: Socket type (cf. include/linux/net.h)
+	 */
+	__s32 type;
+	/**
+	 * @protocol: Communication protocol specific to protocol family set in
+	 * @family field.
+	 */
+	__s32 protocol;
+} __attribute__((packed));
+
 /**
  * DOC: fs_access
  *
@@ -327,7 +364,7 @@ struct landlock_net_port_attr {
  * DOC: net_access
  *
  * Network flags
- * ~~~~~~~~~~~~~~~~
+ * ~~~~~~~~~~~~~
  *
  * These flags enable to restrict a sandboxed process to a set of network
  * actions.
@@ -345,6 +382,27 @@ struct landlock_net_port_attr {
 #define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
 /* clang-format on */
 
+/**
+ * DOC: socket_access
+ *
+ * Socket flags
+ * ~~~~~~~~~~~~
+ *
+ * These flags restrict actions on sockets for a sandboxed process (e.g. creation
+ * of a socket via socket(2)). Sockets opened before sandboxing are not subject
+ * to these restrictions. This is supported since the Landlock ABI version 8.
+ *
+ * The following access right applies only to sockets:
+ *
+ * - %LANDLOCK_ACCESS_SOCKET_CREATE: Create a user space socket. This access
+ *   right restricts the following operations: :manpage:`socket(2)`,
+ *   :manpage:`socketpair(2)`, ``IORING_OP_SOCKET`` (cf.
+ *   :manpage:`io_uring_enter(2)`).
+ */
+/* clang-format off */
+#define LANDLOCK_ACCESS_SOCKET_CREATE			(1ULL << 0)
+/* clang-format on */
+
 /**
  * DOC: scope
  *
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index 3160c2bdac1d..89f0d12d3af1 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,7 +1,7 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
 landlock-y := setup.o syscalls.o object.o ruleset.o \
-	cred.o task.o fs.o
+	cred.o task.o fs.o socket.o
 
 landlock-$(CONFIG_INET) += net.o
 
diff --git a/security/landlock/access.h b/security/landlock/access.h
index 7961c6630a2d..03ccd6fbfe83 100644
--- a/security/landlock/access.h
+++ b/security/landlock/access.h
@@ -40,6 +40,8 @@ typedef u16 access_mask_t;
 static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
 /* Makes sure all network access rights can be stored. */
 static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_NET);
+/* Makes sure all socket access rights can be stored. */
+static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_SOCKET);
 /* Makes sure all scoped rights can be stored. */
 static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_SCOPE);
 /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
@@ -49,6 +51,7 @@ static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
 struct access_masks {
 	access_mask_t fs : LANDLOCK_NUM_ACCESS_FS;
 	access_mask_t net : LANDLOCK_NUM_ACCESS_NET;
+	access_mask_t socket : LANDLOCK_NUM_ACCESS_SOCKET;
 	access_mask_t scope : LANDLOCK_NUM_SCOPE;
 };
 
diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index 65b5ff051674..f87f2e8f2644 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -27,6 +27,10 @@
 #define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
 #define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
 
+#define LANDLOCK_LAST_ACCESS_SOCKET	LANDLOCK_ACCESS_SOCKET_CREATE
+#define LANDLOCK_MASK_ACCESS_SOCKET	((LANDLOCK_LAST_ACCESS_SOCKET << 1) - 1)
+#define LANDLOCK_NUM_ACCESS_SOCKET	__const_hweight64(LANDLOCK_MASK_ACCESS_SOCKET)
+
 #define LANDLOCK_LAST_SCOPE		LANDLOCK_SCOPE_SIGNAL
 #define LANDLOCK_MASK_SCOPE		((LANDLOCK_LAST_SCOPE << 1) - 1)
 #define LANDLOCK_NUM_SCOPE		__const_hweight64(LANDLOCK_MASK_SCOPE)
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index dfcdc19ea268..a34d2dbe3954 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -45,6 +45,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 #if IS_ENABLED(CONFIG_INET)
 	new_ruleset->root_net_port = RB_ROOT;
 #endif /* IS_ENABLED(CONFIG_INET) */
+	new_ruleset->root_socket = RB_ROOT;
 
 	new_ruleset->num_layers = num_layers;
 	/*
@@ -55,15 +56,15 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 	return new_ruleset;
 }
 
-struct landlock_ruleset *
-landlock_create_ruleset(const access_mask_t fs_access_mask,
-			const access_mask_t net_access_mask,
-			const access_mask_t scope_mask)
+struct landlock_ruleset *landlock_create_ruleset(
+	const access_mask_t fs_access_mask, const access_mask_t net_access_mask,
+	const access_mask_t socket_access_mask, const access_mask_t scope_mask)
 {
 	struct landlock_ruleset *new_ruleset;
 
 	/* Informs about useless ruleset. */
-	if (!fs_access_mask && !net_access_mask && !scope_mask)
+	if (!fs_access_mask && !net_access_mask && !socket_access_mask &&
+	    !scope_mask)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
 	if (IS_ERR(new_ruleset))
@@ -72,6 +73,9 @@ landlock_create_ruleset(const access_mask_t fs_access_mask,
 		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
 	if (net_access_mask)
 		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
+	if (socket_access_mask)
+		landlock_add_socket_access_mask(new_ruleset, socket_access_mask,
+						0);
 	if (scope_mask)
 		landlock_add_scope_mask(new_ruleset, scope_mask, 0);
 	return new_ruleset;
@@ -101,6 +105,8 @@ static bool is_object_pointer(const enum landlock_key_type key_type)
 		return false;
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	case LANDLOCK_KEY_SOCKET:
+		return false;
 	default:
 		WARN_ON_ONCE(1);
 		return false;
@@ -158,6 +164,8 @@ static struct rb_root *get_root(struct landlock_ruleset *const ruleset,
 		return &ruleset->root_net_port;
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	case LANDLOCK_KEY_SOCKET:
+		return &ruleset->root_socket;
 	default:
 		WARN_ON_ONCE(1);
 		return ERR_PTR(-EINVAL);
@@ -396,6 +404,9 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 		goto out_unlock;
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	err = merge_tree(dst, src, LANDLOCK_KEY_SOCKET);
+	if (err)
+		goto out_unlock;
 out_unlock:
 	mutex_unlock(&src->lock);
 	mutex_unlock(&dst->lock);
@@ -459,6 +470,11 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
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
@@ -495,6 +511,9 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
 		free_rule(freeme, LANDLOCK_KEY_NET_PORT);
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	rbtree_postorder_for_each_entry_safe(freeme, next,
+					     &ruleset->root_socket, node)
+		free_rule(freeme, LANDLOCK_KEY_SOCKET);
 	landlock_put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
 }
@@ -679,8 +698,8 @@ get_access_mask_t(const struct landlock_ruleset *const ruleset,
  *
  * @domain: The domain that defines the current restrictions.
  * @access_request: The requested access rights to check.
- * @layer_masks: It must contain %LANDLOCK_NUM_ACCESS_FS or
- * %LANDLOCK_NUM_ACCESS_NET elements according to @key_type.
+ * @layer_masks: It must contain %LANDLOCK_NUM_ACCESS_{FS,NET,SOCKET}
+ * elements according to @key_type.
  * @key_type: The key type to switch between access masks of different types.
  *
  * Returns: An access mask where each access right bit is set which is handled
@@ -709,6 +728,10 @@ landlock_init_layer_masks(const struct landlock_ruleset *const domain,
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
index 1a78cba662b2..a60ede2fc2a5 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -66,6 +66,11 @@ enum landlock_key_type {
 	 * node keys.
 	 */
 	LANDLOCK_KEY_NET_PORT,
+	/**
+	 * @LANDLOCK_KEY_SOCKET: Type of &landlock_ruleset.root_socket's
+	 * node keys.
+	 */
+	LANDLOCK_KEY_SOCKET,
 };
 
 /**
@@ -135,6 +140,14 @@ struct landlock_ruleset {
 	struct rb_root root_net_port;
 #endif /* IS_ENABLED(CONFIG_INET) */
 
+	/**
+	 * @root_socket: Root of a red-black tree containing &struct
+	 * landlock_rule nodes with socket protocol definition. Once a
+	 * ruleset is tied to a process (i.e. as a domain), this tree is
+	 * immutable until @usage reaches zero.
+	 */
+	struct rb_root root_socket;
+
 	/**
 	 * @hierarchy: Enables hierarchy identification even when a parent
 	 * domain vanishes.  This is needed for the ptrace protection.
@@ -173,8 +186,10 @@ struct landlock_ruleset {
 			 */
 			u32 num_layers;
 			/**
-			 * @access_masks: Contains the subset of filesystem and
-			 * network actions that are restricted by a ruleset.
+			 * @access_masks: Contains the subset of filesystem,
+			 * network and socket actions that are restricted by
+			 * a ruleset.
+			 *
 			 * A domain saves all layers of merged rulesets in a
 			 * stack (FAM), starting from the first layer to the
 			 * last one.  These layers are used when merging
@@ -189,10 +204,9 @@ struct landlock_ruleset {
 	};
 };
 
-struct landlock_ruleset *
-landlock_create_ruleset(const access_mask_t access_mask_fs,
-			const access_mask_t access_mask_net,
-			const access_mask_t scope_mask);
+struct landlock_ruleset *landlock_create_ruleset(
+	const access_mask_t access_mask_fs, const access_mask_t access_mask_net,
+	const access_mask_t access_mask_socket, const access_mask_t scope_mask);
 
 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
@@ -267,6 +281,19 @@ landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,
 	ruleset->access_masks[layer_level].net |= net_mask;
 }
 
+static inline void
+landlock_add_socket_access_mask(struct landlock_ruleset *const ruleset,
+				const access_mask_t socket_access_mask,
+				const u16 layer_level)
+{
+	access_mask_t socket_mask = socket_access_mask &
+				    LANDLOCK_MASK_ACCESS_SOCKET;
+
+	/* Should already be checked in sys_landlock_create_ruleset(). */
+	WARN_ON_ONCE(socket_access_mask != socket_mask);
+	ruleset->access_masks[layer_level].socket |= socket_mask;
+}
+
 static inline void
 landlock_add_scope_mask(struct landlock_ruleset *const ruleset,
 			const access_mask_t scope_mask, const u16 layer_level)
@@ -294,6 +321,13 @@ landlock_get_net_access_mask(const struct landlock_ruleset *const ruleset,
 	return ruleset->access_masks[layer_level].net;
 }
 
+static inline access_mask_t
+landlock_get_socket_access_mask(const struct landlock_ruleset *const ruleset,
+				const u16 layer_level)
+{
+	return ruleset->access_masks[layer_level].socket;
+}
+
 static inline access_mask_t
 landlock_get_scope_mask(const struct landlock_ruleset *const ruleset,
 			const u16 layer_level)
diff --git a/security/landlock/socket.c b/security/landlock/socket.c
new file mode 100644
index 000000000000..28a80dcad629
--- /dev/null
+++ b/security/landlock/socket.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - Socket management and hooks
+ *
+ * Copyright © 2025 Huawei Tech. Co., Ltd.
+ */
+
+#include <linux/net.h>
+#include <linux/socket.h>
+#include <linux/stddef.h>
+#include <net/ipv6.h>
+
+#include "limits.h"
+#include "ruleset.h"
+#include "socket.h"
+#include "cred.h"
+
+#define TYPE_ALL (-1)
+#define PROTOCOL_ALL (-1)
+
+static int pack_socket_key(const s32 family, const s32 type, const s32 protocol,
+			   uintptr_t *val)
+{
+	int err = -EINVAL;
+	union {
+		struct {
+			u8 family;
+			u8 type;
+			u16 protocol;
+		} __packed data;
+		u32 packed;
+	} socket_key;
+
+	/* Checks that socket_key content can be stored in struct landlock_key. */
+	BUILD_BUG_ON(sizeof(socket_key.data) > sizeof(socket_key.packed));
+	BUILD_BUG_ON(sizeof(socket_key.packed) >
+		     sizeof_field(union landlock_key, data));
+
+	/*
+	 * Checks that all supported protocol families and socket types can be
+	 * stored in socket_key fields.
+	 */
+	BUILD_BUG_ON(AF_MAX - 1 > U8_MAX);
+	BUILD_BUG_ON(SOCK_MAX - 1 > U8_MAX);
+
+	/* Checks ranges and handles wildcard type and protocol value mapping. */
+	if (family >= 0 && family < U8_MAX)
+		socket_key.data.family = family;
+	else
+		goto out;
+
+	BUILD_BUG_ON(TYPE_ALL != -1);
+	if (type == TYPE_ALL)
+		socket_key.data.type = U8_MAX;
+	else if (type >= 0 && type < U8_MAX)
+		socket_key.data.type = type;
+	else
+		goto out;
+
+	BUILD_BUG_ON(PROTOCOL_ALL != -1);
+	if (protocol == PROTOCOL_ALL)
+		socket_key.data.protocol = U16_MAX;
+	else if (protocol >= 0 && protocol < U16_MAX)
+		socket_key.data.protocol = protocol;
+	else
+		goto out;
+
+	*val = socket_key.packed;
+	err = 0;
+out:
+	return err;
+}
+
+int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
+				s32 family, s32 type, s32 protocol,
+				access_mask_t access_rights)
+{
+	int err;
+	uintptr_t key;
+	/*
+	 * (AF_INET, SOCK_PACKET) is an alias for (AF_PACKET, SOCK_PACKET)
+	 * (cf. __sock_create).
+	 */
+	if (family == AF_INET && type == SOCK_PACKET)
+		family = AF_PACKET;
+
+	err = pack_socket_key(family, type, protocol, &key);
+	if (err)
+		return err;
+
+	const struct landlock_id id = {
+		.key.data = key,
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
index 000000000000..bd0ac74c39e2
--- /dev/null
+++ b/security/landlock/socket.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - Socket management and hooks
+ *
+ * Copyright © 2025 Huawei Tech. Co., Ltd.
+ */
+
+#ifndef _SECURITY_LANDLOCK_SOCKET_H
+#define _SECURITY_LANDLOCK_SOCKET_H
+
+#include "ruleset.h"
+
+int landlock_append_socket_rule(struct landlock_ruleset *const ruleset,
+				const s32 family, const s32 type,
+				const s32 protocol,
+				access_mask_t access_rights);
+
+#endif /* _SECURITY_LANDLOCK_SOCKET_H */
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 33eafb71e4f3..e9f500f97c86 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -27,6 +27,7 @@
 #include <linux/syscalls.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
+#include <linux/net.h>
 #include <uapi/linux/landlock.h>
 
 #include "cred.h"
@@ -34,6 +35,7 @@
 #include "fs.h"
 #include "limits.h"
 #include "net.h"
+#include "socket.h"
 #include "ruleset.h"
 #include "setup.h"
 
@@ -92,7 +94,8 @@ static void build_check_abi(void)
 	struct landlock_ruleset_attr ruleset_attr;
 	struct landlock_path_beneath_attr path_beneath_attr;
 	struct landlock_net_port_attr net_port_attr;
-	size_t ruleset_size, path_beneath_size, net_port_size;
+	struct landlock_socket_attr socket_attr;
+	size_t ruleset_size, path_beneath_size, net_port_size, socket_size;
 
 	/*
 	 * For each user space ABI structures, first checks that there is no
@@ -101,9 +104,10 @@ static void build_check_abi(void)
 	 */
 	ruleset_size = sizeof(ruleset_attr.handled_access_fs);
 	ruleset_size += sizeof(ruleset_attr.handled_access_net);
+	ruleset_size += sizeof(ruleset_attr.handled_access_socket);
 	ruleset_size += sizeof(ruleset_attr.scoped);
 	BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
-	BUILD_BUG_ON(sizeof(ruleset_attr) != 24);
+	BUILD_BUG_ON(sizeof(ruleset_attr) != 32);
 
 	path_beneath_size = sizeof(path_beneath_attr.allowed_access);
 	path_beneath_size += sizeof(path_beneath_attr.parent_fd);
@@ -114,6 +118,13 @@ static void build_check_abi(void)
 	net_port_size += sizeof(net_port_attr.port);
 	BUILD_BUG_ON(sizeof(net_port_attr) != net_port_size);
 	BUILD_BUG_ON(sizeof(net_port_attr) != 16);
+
+	socket_size = sizeof(socket_attr.allowed_access);
+	socket_size += sizeof(socket_attr.family);
+	socket_size += sizeof(socket_attr.type);
+	socket_size += sizeof(socket_attr.protocol);
+	BUILD_BUG_ON(sizeof(socket_attr) != socket_size);
+	BUILD_BUG_ON(sizeof(socket_attr) != 20);
 }
 
 /* Ruleset handling */
@@ -161,7 +172,7 @@ static const struct file_operations ruleset_fops = {
  * Documentation/userspace-api/landlock.rst should be updated to reflect the
  * UAPI change.
  */
-const int landlock_abi_version = 7;
+const int landlock_abi_version = 8;
 
 /**
  * sys_landlock_create_ruleset - Create a new ruleset
@@ -237,6 +248,11 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 	    LANDLOCK_MASK_ACCESS_NET)
 		return -EINVAL;
 
+	/* Checks socket content (and 32-bits cast). */
+	if ((ruleset_attr.handled_access_socket |
+	     LANDLOCK_MASK_ACCESS_SOCKET) != LANDLOCK_MASK_ACCESS_SOCKET)
+		return -EINVAL;
+
 	/* Checks IPC scoping content (and 32-bits cast). */
 	if ((ruleset_attr.scoped | LANDLOCK_MASK_SCOPE) != LANDLOCK_MASK_SCOPE)
 		return -EINVAL;
@@ -244,6 +260,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 	/* Checks arguments and transforms to kernel struct. */
 	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
 					  ruleset_attr.handled_access_net,
+					  ruleset_attr.handled_access_socket,
 					  ruleset_attr.scoped);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);
@@ -383,6 +400,40 @@ static int add_rule_net_port(struct landlock_ruleset *ruleset,
 					net_port_attr.allowed_access);
 }
 
+static int add_rule_socket(struct landlock_ruleset *ruleset,
+			   const void __user *const rule_attr)
+{
+	struct landlock_socket_attr socket_attr;
+	int res;
+	access_mask_t mask;
+	s32 family, type, protocol;
+
+	/* Copies raw user space buffer. */
+	res = copy_from_user(&socket_attr, rule_attr, sizeof(socket_attr));
+	if (res)
+		return -EFAULT;
+
+	/*
+	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
+	 * are ignored by socket actions.
+	 */
+	if (!socket_attr.allowed_access)
+		return -ENOMSG;
+
+	/* Checks that allowed_access matches the @ruleset constraints. */
+	mask = landlock_get_socket_access_mask(ruleset, 0);
+	if ((socket_attr.allowed_access | mask) != mask)
+		return -EINVAL;
+
+	family = socket_attr.family;
+	type = socket_attr.type;
+	protocol = socket_attr.protocol;
+
+	/* Imports the new rule. */
+	return landlock_append_socket_rule(ruleset, family, type, protocol,
+					   socket_attr.allowed_access);
+}
+
 /**
  * sys_landlock_add_rule - Add a new rule to a ruleset
  *
@@ -407,6 +458,8 @@ static int add_rule_net_port(struct landlock_ruleset *ruleset,
  *   &landlock_net_port_attr.allowed_access is not a subset of the ruleset
  *   handled accesses)
  * - %EINVAL: &landlock_net_port_attr.port is greater than 65535;
+ * - %EINVAL: &landlock_socket_attr.{family, type} are greater than 254 or
+ *   &landlock_socket_attr.protocol is greater than 65534;
  * - %ENOMSG: Empty accesses (e.g. &landlock_path_beneath_attr.allowed_access is
  *   0);
  * - %EBADF: @ruleset_fd is not a file descriptor for the current thread, or a
@@ -439,6 +492,8 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 		return add_rule_path_beneath(ruleset, rule_attr);
 	case LANDLOCK_RULE_NET_PORT:
 		return add_rule_net_port(ruleset, rule_attr);
+	case LANDLOCK_RULE_SOCKET:
+		return add_rule_socket(ruleset, rule_attr);
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
index 7b69002239d7..f4b1a275d8d9 100644
--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -76,7 +76,7 @@ TEST(abi_version)
 	const struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
 	};
-	ASSERT_EQ(7, landlock_create_ruleset(NULL, 0,
+	ASSERT_EQ(8, landlock_create_ruleset(NULL, 0,
 					     LANDLOCK_CREATE_RULESET_VERSION));
 
 	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0,
-- 
2.34.1

