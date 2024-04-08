Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22D039FDD;
	Mon,  8 Apr 2024 09:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569736; cv=none; b=A5uzykAofttnQww54QbTDY3ov+8vuBY/40FdB8IhR+sWDf4tcg1MDlbpqNIQphkv4RoG5ttGDKCfdEtyWRk6lb1SYLG230ErztDtjxkxxMfC93tqqtEEmKlQkYwt0aAV3+5dnm44s5XHmeUd0dgL5JrcMcEVYdGl9cLkDjTtt+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569736; c=relaxed/simple;
	bh=7gG55KZ60vzKBlRodfDl94ICgIx8q4YVhjGOymAP7Rk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CcHyUvmWa5MKvnAi2xfWBWApojDV6v/MFQ/hzKZc/v3WD4mvC6Grp4zNzV+9h3BGXv0cWUqetKJFTKhAhNbMzo49K5DoAr34q+HIybEOo6+79LLfNCK8a7F85oFwpmw6Y+LXvVyRNM+bL9On26uDopqlGoQcBJJwuybBS3mEFRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4VCkjv3PyWz1RBl7;
	Mon,  8 Apr 2024 17:45:55 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id E51751402CF;
	Mon,  8 Apr 2024 17:48:45 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:48:44 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [PATCH 1/2] landlock: Add hook on socket_listen()
Date: Mon, 8 Apr 2024 17:47:46 +0800
Message-ID: <20240408094747.1761850-2-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Make hook for socket_listen(). It will check that the socket protocol is
TCP, and if the socket's local port number is 0 (which means,
that listen(2) was called without any previous bind(2) call),
then listen(2) call will be legitimate only if there is a rule for bind(2)
allowing binding to port 0 (or if LANDLOCK_ACCESS_NET_BIND_TCP is not
supported by the sandbox).

Create a new check_access_socket() function to prevent useless copy paste.
It should be called by hook handlers after they perform special checks and
calculate socket port value.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 security/landlock/net.c | 104 +++++++++++++++++++++++++++++++++-------
 1 file changed, 88 insertions(+), 16 deletions(-)

diff --git a/security/landlock/net.c b/security/landlock/net.c
index c8bcd29bde09..c6ae4092cfd6 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -10,6 +10,7 @@
 #include <linux/net.h>
 #include <linux/socket.h>
 #include <net/ipv6.h>
+#include <net/tcp.h>
 
 #include "common.h"
 #include "cred.h"
@@ -61,17 +62,36 @@ static const struct landlock_ruleset *get_current_net_domain(void)
 	return dom;
 }
 
-static int current_check_access_socket(struct socket *const sock,
-				       struct sockaddr *const address,
-				       const int addrlen,
-				       access_mask_t access_request)
+static int check_access_socket(const struct landlock_ruleset *const dom,
+			  __be16 port,
+			  access_mask_t access_request)
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
+
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
@@ -159,17 +179,7 @@ static int current_check_access_socket(struct socket *const sock,
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
@@ -187,9 +197,71 @@ static int hook_socket_connect(struct socket *const sock,
 					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
 }
 
+/*
+ * Check that socket state and attributes are correct for listen.
+ * It is required to not wrongfully return -EACCES instead of -EINVAL.
+ */
+static int check_tcp_socket_can_listen(struct socket *const sock)
+{
+	struct sock *sk = sock->sk;
+	unsigned char cur_sk_state = sk->sk_state;
+	const struct inet_connection_sock *icsk;
+
+	/* Allow only unconnected TCP socket to listen(cf. inet_listen). */
+	if (sock->state != SS_UNCONNECTED)
+		return -EINVAL;
+
+	/* Check sock state consistency. */
+	if (!((1 << cur_sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
+		return -EINVAL;
+
+	/* Sockets can listen only if ULP control hook has clone method. */
+	icsk = inet_csk(sk);
+	if (icsk->icsk_ulp_ops && !icsk->icsk_ulp_ops->clone)
+		return -EINVAL;
+	return 0;
+}
+
+static int hook_socket_listen(struct socket *const sock,
+			  const int backlog)
+{
+	int err;
+	int family;
+	const struct landlock_ruleset *const dom = get_current_net_domain();
+
+	if (!dom)
+		return 0;
+	if (WARN_ON_ONCE(dom->num_layers < 1))
+		return -EACCES;
+
+	/*
+	 * listen() on a TCP socket without pre-binding is allowed only
+	 * if binding to port 0 is allowed.
+	 */
+	family = sock->sk->__sk_common.skc_family;
+
+	if (family == AF_INET || family == AF_INET6) {
+		/* Checks if it's a (potential) TCP socket. */
+		if (sock->type != SOCK_STREAM)
+			return 0;
+
+		/* Socket is alredy binded to some port. */
+		if (inet_sk(sock->sk)->inet_num != 0)
+			return 0;
+
+		err = check_tcp_socket_can_listen(sock);
+		if (unlikely(err))
+			return err;
+
+		return check_access_socket(dom, 0, LANDLOCK_ACCESS_NET_BIND_TCP);
+	}
+	return 0;
+}
+
 static struct security_hook_list landlock_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
 	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
+	LSM_HOOK_INIT(socket_listen, hook_socket_listen),
 };
 
 __init void landlock_add_net_hooks(void)
-- 
2.34.1

