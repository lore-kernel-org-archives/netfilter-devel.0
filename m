Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EFC1DC18B;
	Thu, 17 Oct 2024 11:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729163172; cv=none; b=kUcFKUaEECOQykftKMUsjFbYZ/OQzedcBeiSQQVKVUvlWG5+kUevXMyi+WK4KS1485PD4X4WfZm/PAh8LA9UgP4cE88ge0CTf1anwP66XR3K3z1ezoQ9AVSTu00fi/0ii1Fw6eDFwEJ9TyUh1/yxctyKZKbQXZZUUMGtNLoVeu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729163172; c=relaxed/simple;
	bh=CNy4tFk/oJMe69u+X5tvMuo8DdxjVbr73T+cNCTyB4E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNYi5vk2d9Ebe/eDz36qKTq20LaK/9ORRzuGAjUhgSvBLc5/U4HVz8FaxKgRYtzFxtTybrNFYHoATmnszn5k1Ed5CmL7ID4xyxSxJSiI60JEToQCKzl4JkH2aAfaJ9wjlCeZDikWg9QDd5HemCLp8NCrNW4pbHp07RMELVLwb6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XTlMV4hwnz1SCq8;
	Thu, 17 Oct 2024 19:04:06 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id B644F140109;
	Thu, 17 Oct 2024 19:05:22 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 17 Oct 2024 19:05:20 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 2/8] landlock: Make network stack layer checks explicit for each TCP action
Date: Thu, 17 Oct 2024 19:04:48 +0800
Message-ID: <20241017110454.265818-3-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Move port extraction and TCP checks required for errors consistency
to hook_socket_bind() and hook_socket_connect(). This separation
simplifies the comparison with the order of network stack layer errors
for each controlled operation.

Replace current_check_access_socket() with check_access_port().

Use sk->sk_family instead of sk->__sk_common.skc_family.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 security/landlock/net.c | 414 ++++++++++++++++++++++------------------
 1 file changed, 228 insertions(+), 186 deletions(-)
 rewrite security/landlock/net.c (22%)

diff --git a/security/landlock/net.c b/security/landlock/net.c
dissimilarity index 22%
index 1e80782ba239..a3142f9b15ee 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -1,186 +1,228 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Landlock LSM - Network management and hooks
- *
- * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
- * Copyright © 2022-2023 Microsoft Corporation
- */
-
-#include <linux/in.h>
-#include <linux/net.h>
-#include <linux/socket.h>
-#include <net/ipv6.h>
-
-#include "common.h"
-#include "cred.h"
-#include "limits.h"
-#include "net.h"
-#include "ruleset.h"
-
-int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
-			     const u16 port, access_mask_t access_rights)
-{
-	int err;
-	const struct landlock_id id = {
-		.key.data = (__force uintptr_t)htons(port),
-		.type = LANDLOCK_KEY_NET_PORT,
-	};
-
-	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
-
-	/* Transforms relative access rights to absolute ones. */
-	access_rights |= LANDLOCK_MASK_ACCESS_NET &
-			 ~landlock_get_net_access_mask(ruleset, 0);
-
-	mutex_lock(&ruleset->lock);
-	err = landlock_insert_rule(ruleset, id, access_rights);
-	mutex_unlock(&ruleset->lock);
-
-	return err;
-}
-
-static const struct landlock_ruleset *get_current_net_domain(void)
-{
-	const union access_masks any_net = {
-		.net = ~0,
-	};
-
-	return landlock_match_ruleset(landlock_get_current_domain(), any_net);
-}
-
-static int current_check_access_socket(struct socket *const sock,
-				       struct sockaddr *const address,
-				       const int addrlen,
-				       access_mask_t access_request)
-{
-	__be16 port;
-	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
-	const struct landlock_rule *rule;
-	struct landlock_id id = {
-		.type = LANDLOCK_KEY_NET_PORT,
-	};
-	const struct landlock_ruleset *const dom = get_current_net_domain();
-
-	if (!dom)
-		return 0;
-	if (WARN_ON_ONCE(dom->num_layers < 1))
-		return -EACCES;
-
-	/* Do not restrict non-TCP sockets. */
-	if (!sk_is_tcp(sock->sk))
-		return 0;
-
-	/* Checks for minimal header length to safely read sa_family. */
-	if (addrlen < offsetofend(typeof(*address), sa_family))
-		return -EINVAL;
-
-	switch (address->sa_family) {
-	case AF_UNSPEC:
-	case AF_INET:
-		if (addrlen < sizeof(struct sockaddr_in))
-			return -EINVAL;
-		port = ((struct sockaddr_in *)address)->sin_port;
-		break;
-
-#if IS_ENABLED(CONFIG_IPV6)
-	case AF_INET6:
-		if (addrlen < SIN6_LEN_RFC2133)
-			return -EINVAL;
-		port = ((struct sockaddr_in6 *)address)->sin6_port;
-		break;
-#endif /* IS_ENABLED(CONFIG_IPV6) */
-
-	default:
-		return 0;
-	}
-
-	/* Specific AF_UNSPEC handling. */
-	if (address->sa_family == AF_UNSPEC) {
-		/*
-		 * Connecting to an address with AF_UNSPEC dissolves the TCP
-		 * association, which have the same effect as closing the
-		 * connection while retaining the socket object (i.e., the file
-		 * descriptor).  As for dropping privileges, closing
-		 * connections is always allowed.
-		 *
-		 * For a TCP access control system, this request is legitimate.
-		 * Let the network stack handle potential inconsistencies and
-		 * return -EINVAL if needed.
-		 */
-		if (access_request == LANDLOCK_ACCESS_NET_CONNECT_TCP)
-			return 0;
-
-		/*
-		 * For compatibility reason, accept AF_UNSPEC for bind
-		 * accesses (mapped to AF_INET) only if the address is
-		 * INADDR_ANY (cf. __inet_bind).  Checking the address is
-		 * required to not wrongfully return -EACCES instead of
-		 * -EAFNOSUPPORT.
-		 *
-		 * We could return 0 and let the network stack handle these
-		 * checks, but it is safer to return a proper error and test
-		 * consistency thanks to kselftest.
-		 */
-		if (access_request == LANDLOCK_ACCESS_NET_BIND_TCP) {
-			/* addrlen has already been checked for AF_UNSPEC. */
-			const struct sockaddr_in *const sockaddr =
-				(struct sockaddr_in *)address;
-
-			if (sock->sk->__sk_common.skc_family != AF_INET)
-				return -EINVAL;
-
-			if (sockaddr->sin_addr.s_addr != htonl(INADDR_ANY))
-				return -EAFNOSUPPORT;
-		}
-	} else {
-		/*
-		 * Checks sa_family consistency to not wrongfully return
-		 * -EACCES instead of -EINVAL.  Valid sa_family changes are
-		 * only (from AF_INET or AF_INET6) to AF_UNSPEC.
-		 *
-		 * We could return 0 and let the network stack handle this
-		 * check, but it is safer to return a proper error and test
-		 * consistency thanks to kselftest.
-		 */
-		if (address->sa_family != sock->sk->__sk_common.skc_family)
-			return -EINVAL;
-	}
-
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
-}
-
-static int hook_socket_bind(struct socket *const sock,
-			    struct sockaddr *const address, const int addrlen)
-{
-	return current_check_access_socket(sock, address, addrlen,
-					   LANDLOCK_ACCESS_NET_BIND_TCP);
-}
-
-static int hook_socket_connect(struct socket *const sock,
-			       struct sockaddr *const address,
-			       const int addrlen)
-{
-	return current_check_access_socket(sock, address, addrlen,
-					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
-}
-
-static struct security_hook_list landlock_hooks[] __ro_after_init = {
-	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
-	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
-};
-
-__init void landlock_add_net_hooks(void)
-{
-	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
-			   &landlock_lsmid);
-}
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - Network management and hooks
+ *
+ * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
+ * Copyright © 2022-2023 Microsoft Corporation
+ */
+
+#include <linux/in.h>
+#include <linux/net.h>
+#include <linux/socket.h>
+#include <net/ipv6.h>
+
+#include "common.h"
+#include "cred.h"
+#include "limits.h"
+#include "net.h"
+#include "ruleset.h"
+
+int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
+			     const u16 port, access_mask_t access_rights)
+{
+	int err;
+	const struct landlock_id id = {
+		.key.data = (__force uintptr_t)htons(port),
+		.type = LANDLOCK_KEY_NET_PORT,
+	};
+
+	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
+
+	/* Transforms relative access rights to absolute ones. */
+	access_rights |= LANDLOCK_MASK_ACCESS_NET &
+			 ~landlock_get_net_access_mask(ruleset, 0);
+
+	mutex_lock(&ruleset->lock);
+	err = landlock_insert_rule(ruleset, id, access_rights);
+	mutex_unlock(&ruleset->lock);
+
+	return err;
+}
+
+static const struct landlock_ruleset *get_current_net_domain(void)
+{
+	const union access_masks any_net = {
+		.net = ~0,
+	};
+
+	return landlock_match_ruleset(landlock_get_current_domain(), any_net);
+}
+
+static int check_access_port(const struct landlock_ruleset *const dom,
+			     __be16 port, access_mask_t access_request)
+{
+	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
+	const struct landlock_rule *rule;
+	struct landlock_id id = {
+		.type = LANDLOCK_KEY_NET_PORT,
+	};
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
+static int hook_socket_bind(struct socket *const sock,
+			    struct sockaddr *const address, const int addrlen)
+{
+	__be16 port;
+	struct sock *const sk = sock->sk;
+	const struct landlock_ruleset *const dom = get_current_net_domain();
+
+	if (!dom)
+		return 0;
+	if (WARN_ON_ONCE(dom->num_layers < 1))
+		return -EACCES;
+
+	if (sk_is_tcp(sk)) {
+		/* Checks for minimal header length to safely read sa_family. */
+		if (addrlen < offsetofend(typeof(*address), sa_family))
+			return -EINVAL;
+
+		switch (address->sa_family) {
+		case AF_UNSPEC:
+		case AF_INET:
+			if (addrlen < sizeof(struct sockaddr_in))
+				return -EINVAL;
+			port = ((struct sockaddr_in *)address)->sin_port;
+			break;
+
+#if IS_ENABLED(CONFIG_IPV6)
+		case AF_INET6:
+			if (addrlen < SIN6_LEN_RFC2133)
+				return -EINVAL;
+			port = ((struct sockaddr_in6 *)address)->sin6_port;
+			break;
+#endif /* IS_ENABLED(CONFIG_IPV6) */
+
+		default:
+			return 0;
+		}
+
+		/*
+		 * For compatibility reason, accept AF_UNSPEC for bind
+		 * accesses (mapped to AF_INET) only if the address is
+		 * INADDR_ANY (cf. __inet_bind).  Checking the address is
+		 * required to not wrongfully return -EACCES instead of
+		 * -EAFNOSUPPORT.
+		 *
+		 * We could return 0 and let the network stack handle these
+		 * checks, but it is safer to return a proper error and test
+		 * consistency thanks to kselftest.
+		 */
+		if (address->sa_family == AF_UNSPEC) {
+			/* addrlen has already been checked for AF_UNSPEC. */
+			const struct sockaddr_in *const sockaddr =
+				(struct sockaddr_in *)address;
+
+			if (sk->sk_family != AF_INET)
+				return -EINVAL;
+
+			if (sockaddr->sin_addr.s_addr != htonl(INADDR_ANY))
+				return -EAFNOSUPPORT;
+		} else {
+			/*
+			 * Checks sa_family consistency to not wrongfully return
+			 * -EACCES instead of -EINVAL.  Valid sa_family changes are
+			 * only (from AF_INET or AF_INET6) to AF_UNSPEC.
+			 *
+			 * We could return 0 and let the network stack handle this
+			 * check, but it is safer to return a proper error and test
+			 * consistency thanks to kselftest.
+			 */
+			if (address->sa_family != sk->sk_family)
+				return -EINVAL;
+		}
+		return check_access_port(dom, port,
+					 LANDLOCK_ACCESS_NET_BIND_TCP);
+	}
+	return 0;
+}
+
+static int hook_socket_connect(struct socket *const sock,
+			       struct sockaddr *const address,
+			       const int addrlen)
+{
+	__be16 port;
+	struct sock *const sk = sock->sk;
+	const struct landlock_ruleset *const dom = get_current_net_domain();
+
+	if (!dom)
+		return 0;
+	if (WARN_ON_ONCE(dom->num_layers < 1))
+		return -EACCES;
+
+	if (sk_is_tcp(sk)) {
+		/* Checks for minimal header length to safely read sa_family. */
+		if (addrlen < offsetofend(typeof(*address), sa_family))
+			return -EINVAL;
+
+		switch (address->sa_family) {
+		case AF_UNSPEC:
+		case AF_INET:
+			if (addrlen < sizeof(struct sockaddr_in))
+				return -EINVAL;
+			port = ((struct sockaddr_in *)address)->sin_port;
+			break;
+
+#if IS_ENABLED(CONFIG_IPV6)
+		case AF_INET6:
+			if (addrlen < SIN6_LEN_RFC2133)
+				return -EINVAL;
+			port = ((struct sockaddr_in6 *)address)->sin6_port;
+			break;
+#endif /* IS_ENABLED(CONFIG_IPV6) */
+
+		default:
+			return 0;
+		}
+
+		/*
+		 * Connecting to an address with AF_UNSPEC dissolves the TCP
+		 * association, which have the same effect as closing the
+		 * connection while retaining the socket object (i.e., the file
+		 * descriptor).  As for dropping privileges, closing
+		 * connections is always allowed.
+		 *
+		 * For a TCP access control system, this request is legitimate.
+		 * Let the network stack handle potential inconsistencies and
+		 * return -EINVAL if needed.
+		 */
+		if (address->sa_family == AF_UNSPEC)
+			return 0;
+		/*
+		 * Checks sa_family consistency to not wrongfully return
+		 * -EACCES instead of -EINVAL.  Valid sa_family changes are
+		 * only (from AF_INET or AF_INET6) to AF_UNSPEC.
+		 *
+		 * We could return 0 and let the network stack handle this
+		 * check, but it is safer to return a proper error and test
+		 * consistency thanks to kselftest.
+		 */
+		if (address->sa_family != sk->sk_family)
+			return -EINVAL;
+
+		return check_access_port(dom, port,
+					 LANDLOCK_ACCESS_NET_CONNECT_TCP);
+	}
+	return 0;
+}
+
+static struct security_hook_list landlock_hooks[] __ro_after_init = {
+	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
+	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
+};
+
+__init void landlock_add_net_hooks(void)
+{
+	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
+			   &landlock_lsmid);
+}
-- 
2.34.1

