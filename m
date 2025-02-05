Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B6822A4CB;
	Wed,  5 Feb 2025 09:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738748233; cv=none; b=PBcrF4m6HUyyCPy8bJOCWZA+Ov8gMrtYyoBH/WGx7yIiROSwSBp9a3VL2vyOIjJwAcuphWChvLOJ6E9eHpvv1XDClVXYaOKKRPvo9EGFnDM30hMwnrmMDLxKaOCkjQmh8vkK7cGSqF7VU3HbyWQTjy0foCEHrmGN6fD7dG/NYUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738748233; c=relaxed/simple;
	bh=/lvyM+4c00Uptw1xb4EFCq+H97FPcCnRl4CUQIR/xCo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQaFs/E04nOIxJhHbJICrSO0+0HQTdhsdW6F/CHEVPFuCyRo7lEtGjuZ21yxjUo2NnBgNQI3vpwcRJINU8el3dmUPMF+D2ttK4YRQgLsNXxPMUHvB9kafTM3qt0zh5kPYcw5CO6It1utYi+H3fsIHK9Y0KrpxbM3w1kHZgC/D2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Ynw7B3DpCz6M4S4;
	Wed,  5 Feb 2025 17:34:46 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id D2C04140498;
	Wed,  5 Feb 2025 17:37:01 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 5 Feb 2025 12:37:01 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 2/3] selftests/landlock: Test TCP accesses with protocol=IPPROTO_TCP
Date: Wed, 5 Feb 2025 17:36:50 +0800
Message-ID: <20250205093651.1424339-3-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250205093651.1424339-1-ivanov.mikhail1@huawei-partners.com>
References: <20250205093651.1424339-1-ivanov.mikhail1@huawei-partners.com>
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

Extend protocol_variant structure with protocol field (Cf. socket(2)).

Extend protocol fixture with TCP test suits with protocol=IPPROTO_TCP
which can be used as an alias for IPPROTO_IP (=0) in socket(2).

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/common.h   |  1 +
 tools/testing/selftests/landlock/net_test.c | 80 +++++++++++++++++----
 2 files changed, 67 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index a604ea5d8297..6064c9ac0532 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -207,6 +207,7 @@ enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
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

