Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3312F1D88C7;
	Thu, 17 Oct 2024 11:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729163164; cv=none; b=ovsLIkHhBdPLiVPwxO3y3rnSccVJGq1eV87lsm5h7jSkTzW0BBB5MAuYC5TDAuBp9Qssv5RV7AE7g1QdM/rHXNRuZ2sBIF8q0pvXfecgRr4SCehUejNFhRH48/EmMjSOXlhV8Gl0IFV2wsmOa2j7RxLLg09qiaZeyQY8QcvQMg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729163164; c=relaxed/simple;
	bh=7hy/y+njkQ+wmUrDxXAkntJvM3F5c3M0E/VMN2VyrZw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q52ka64rtLHokMTdMoyPOsClpXfllbvA+hs56MtNS7/IVQ9CU7kJ+6xSI3E1RS1zOczOqftBbi/UKH4Yxt1NLhBHjGone4FRMFmfDNy7tObZWR5XkiPh7NSV+3S+Ye4PUzic5i1FflfI5GnZB8yj9Kw3Ah3xjVq8RFIrcZITOgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XTlMm19kQz2DdqL;
	Thu, 17 Oct 2024 19:04:20 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id A7297140360;
	Thu, 17 Oct 2024 19:05:35 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 17 Oct 2024 19:05:33 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 8/8] selftests/landlock: Test that SCTP actions are not restricted
Date: Thu, 17 Oct 2024 19:04:54 +0800
Message-ID: <20241017110454.265818-9-ivanov.mikhail1@huawei-partners.com>
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

Extend protocol fixture with test suits for SCTP protocol.
Add CONFIG_IP_SCTP option in config.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 tools/testing/selftests/landlock/config     |  1 +
 tools/testing/selftests/landlock/net_test.c | 83 ++++++++++++++++++---
 2 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 52988e8a56cc..a96d42dc850d 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -1,6 +1,7 @@
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_INET=y
+CONFIG_IP_SCTP=y
 CONFIG_IPV6=y
 CONFIG_KEYS=y
 CONFIG_LSM="landlock"
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 30b29bf10bdc..fa382a2e3b58 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -97,13 +97,28 @@ static void setup_loopback(struct __test_metadata *const _metadata)
 	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
 }
 
-static bool prot_is_tcp(const struct protocol_variant *const prot)
+static bool prot_is_inet_stream(const struct protocol_variant *const prot)
 {
 	return (prot->domain == AF_INET || prot->domain == AF_INET6) &&
-	       prot->type == SOCK_STREAM &&
+	       prot->type == SOCK_STREAM;
+}
+
+static bool prot_is_tcp(const struct protocol_variant *const prot)
+{
+	return prot_is_inet_stream(prot) &&
 	       (prot->protocol == IPPROTO_TCP || prot->protocol == IPPROTO_IP);
 }
 
+static bool prot_is_sctp(const struct protocol_variant *const prot)
+{
+	return prot_is_inet_stream(prot) && prot->protocol == IPPROTO_SCTP;
+}
+
+static bool prot_is_unix_stream(const struct protocol_variant *const prot)
+{
+	return prot->domain == AF_UNIX && prot->type == SOCK_STREAM;
+}
+
 static bool is_restricted(const struct protocol_variant *const prot,
 			  const enum sandbox_type sandbox)
 {
@@ -357,6 +372,17 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_mptcp) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_sctp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SCTP,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp1) {
 	/* clang-format on */
@@ -391,6 +417,17 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_mptcp) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_sctp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SCTP,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_udp) {
 	/* clang-format on */
@@ -465,6 +502,17 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_mptcp) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_sctp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SCTP,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp1) {
 	/* clang-format on */
@@ -499,6 +547,17 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_mptcp) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_sctp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_SCTP,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_udp) {
 	/* clang-format on */
@@ -793,7 +852,7 @@ TEST_F(protocol, bind_unspec)
 
 	/* Allowed bind on AF_UNSPEC/INADDR_ANY. */
 	ret = bind_variant(bind_fd, &self->unspec_any0);
-	if (variant->prot.domain == AF_INET) {
+	if (variant->prot.domain == AF_INET && !prot_is_sctp(&variant->prot)) {
 		EXPECT_EQ(0, ret)
 		{
 			TH_LOG("Failed to bind to unspec/any socket: %s",
@@ -819,7 +878,7 @@ TEST_F(protocol, bind_unspec)
 
 	/* Denied bind on AF_UNSPEC/INADDR_ANY. */
 	ret = bind_variant(bind_fd, &self->unspec_any0);
-	if (variant->prot.domain == AF_INET) {
+	if (variant->prot.domain == AF_INET && !prot_is_sctp(&variant->prot)) {
 		if (is_restricted(&variant->prot, variant->sandbox)) {
 			EXPECT_EQ(-EACCES, ret);
 		} else {
@@ -834,7 +893,7 @@ TEST_F(protocol, bind_unspec)
 	bind_fd = socket_variant(&self->srv0);
 	ASSERT_LE(0, bind_fd);
 	ret = bind_variant(bind_fd, &self->unspec_srv0);
-	if (variant->prot.domain == AF_INET) {
+	if (variant->prot.domain == AF_INET && !prot_is_sctp(&variant->prot)) {
 		EXPECT_EQ(-EAFNOSUPPORT, ret);
 	} else {
 		EXPECT_EQ(-EINVAL, ret)
@@ -899,17 +958,18 @@ TEST_F(protocol, connect_unspec)
 
 		/* Disconnects already connected socket, or set peer. */
 		ret = connect_variant(connect_fd, &self->unspec_any0);
-		if (self->srv0.protocol.domain == AF_UNIX &&
-		    self->srv0.protocol.type == SOCK_STREAM) {
+		if (prot_is_unix_stream(&variant->prot)) {
 			EXPECT_EQ(-EINVAL, ret);
+		} else if (prot_is_sctp(&variant->prot)) {
+			EXPECT_EQ(-EOPNOTSUPP, ret);
 		} else {
 			EXPECT_EQ(0, ret);
 		}
 
 		/* Tries to reconnect, or set peer. */
 		ret = connect_variant(connect_fd, &self->srv0);
-		if (self->srv0.protocol.domain == AF_UNIX &&
-		    self->srv0.protocol.type == SOCK_STREAM) {
+		if (prot_is_unix_stream(&variant->prot) ||
+		    prot_is_sctp(&variant->prot)) {
 			EXPECT_EQ(-EISCONN, ret);
 		} else {
 			EXPECT_EQ(0, ret);
@@ -926,9 +986,10 @@ TEST_F(protocol, connect_unspec)
 		}
 
 		ret = connect_variant(connect_fd, &self->unspec_any0);
-		if (self->srv0.protocol.domain == AF_UNIX &&
-		    self->srv0.protocol.type == SOCK_STREAM) {
+		if (prot_is_unix_stream(&variant->prot)) {
 			EXPECT_EQ(-EINVAL, ret);
+		} else if (prot_is_sctp(&variant->prot)) {
+			EXPECT_EQ(-EOPNOTSUPP, ret);
 		} else {
 			/* Always allowed to disconnect. */
 			EXPECT_EQ(0, ret);
-- 
2.34.1

