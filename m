Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233BD1D9A6A;
	Thu, 17 Oct 2024 11:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729163142; cv=none; b=pHBCn/V8SMTZ2UQXS8/x72aJR7p7v6iN8TIhXWuBGKrnO/SILcEPN/lPx5dtXEwf9MgsT9XYxiUqbKP0AEg72Gs7fRf5oVh7CHDkT5MGuN+2VLDfcJNHa/FRgmDnnB2n6rbgfzn2eMChDsIBV5kIfOQZaydARNJXYEWyuYDIM6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729163142; c=relaxed/simple;
	bh=SFo/qf1jlxlSrQNRtYJ8JeTCBUfpYjPZjkJTwlvtWCc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DeKmZB67fZ90vVPtMptY9NHY7BzXLy/5jG4bqP0ycYpmfLBdC8KsBItXm2XfY9UimhjBY2EU863MeA2OLaeVJnpvGgi03R+D4QvlpqnFrF3fjB9CS6COTk0sAeCPFD3eiGZLNEdhbJiXHwh5fPpI/I8HJNKk8Kd5IQh3/yxr4ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XTlLm6MXMzcpSD;
	Thu, 17 Oct 2024 19:03:28 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 1328018007C;
	Thu, 17 Oct 2024 19:05:27 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 17 Oct 2024 19:05:24 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 4/8] selftests/landlock: Test TCP accesses with protocol=IPPROTO_TCP
Date: Thu, 17 Oct 2024 19:04:50 +0800
Message-ID: <20241017110454.265818-5-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Extend protocol_variant structure with protocol field (Cf. socket(2)).

Extend protocol fixture with TCP test suits with protocol=IPPROTO_TCP
which can be used as an alias for IPPROTO_IP (=0) in socket(2).

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/common.h   |  1 +
 tools/testing/selftests/landlock/net_test.c | 80 +++++++++++++++++----
 2 files changed, 67 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 61056fa074bb..40a2def50b83 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -234,6 +234,7 @@ enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
 struct protocol_variant {
 	int domain;
 	int type;
+	int protocol;
 };
 
 struct service_fixture {
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 4e0aeb53b225..333263780fae 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -85,18 +85,18 @@ static void setup_loopback(struct __test_metadata *const _metadata)
 	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
 }
 
+static bool prot_is_tcp(const struct protocol_variant *const prot)
+{
+	return (prot->domain == AF_INET || prot->domain == AF_INET6) &&
+	       prot->type == SOCK_STREAM &&
+	       (prot->protocol == IPPROTO_TCP || prot->protocol == IPPROTO_IP);
+}
+
 static bool is_restricted(const struct protocol_variant *const prot,
 			  const enum sandbox_type sandbox)
 {
-	switch (prot->domain) {
-	case AF_INET:
-	case AF_INET6:
-		switch (prot->type) {
-		case SOCK_STREAM:
-			return sandbox == TCP_SANDBOX;
-		}
-		break;
-	}
+	if (sandbox == TCP_SANDBOX)
+		return prot_is_tcp(prot);
 	return false;
 }
 
@@ -105,7 +105,7 @@ static int socket_variant(const struct service_fixture *const srv)
 	int ret;
 
 	ret = socket(srv->protocol.domain, srv->protocol.type | SOCK_CLOEXEC,
-		     0);
+		     srv->protocol.protocol);
 	if (ret < 0)
 		return -errno;
 	return ret;
@@ -290,22 +290,48 @@ FIXTURE_TEARDOWN(protocol)
 }
 
 /* clang-format off */
-FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp) {
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp1) {
 	/* clang-format on */
 	.sandbox = NO_SANDBOX,
 	.prot = {
 		.domain = AF_INET,
 		.type = SOCK_STREAM,
+		/* IPPROTO_IP == 0 */
+		.protocol = IPPROTO_IP,
 	},
 };
 
 /* clang-format off */
-FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp) {
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp2) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_TCP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp1) {
 	/* clang-format on */
 	.sandbox = NO_SANDBOX,
 	.prot = {
 		.domain = AF_INET6,
 		.type = SOCK_STREAM,
+		/* IPPROTO_IP == 0 */
+		.protocol = IPPROTO_IP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp2) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_TCP,
 	},
 };
 
@@ -350,22 +376,48 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_unix_datagram) {
 };
 
 /* clang-format off */
-FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp) {
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp1) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		/* IPPROTO_IP == 0 */
+		.protocol = IPPROTO_IP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp2) {
 	/* clang-format on */
 	.sandbox = TCP_SANDBOX,
 	.prot = {
 		.domain = AF_INET,
 		.type = SOCK_STREAM,
+		.protocol = IPPROTO_TCP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp1) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		/* IPPROTO_IP == 0 */
+		.protocol = IPPROTO_IP,
 	},
 };
 
 /* clang-format off */
-FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp) {
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp2) {
 	/* clang-format on */
 	.sandbox = TCP_SANDBOX,
 	.prot = {
 		.domain = AF_INET6,
 		.type = SOCK_STREAM,
+		.protocol = IPPROTO_TCP,
 	},
 };
 
-- 
2.34.1

