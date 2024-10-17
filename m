Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F531DC1A7;
	Thu, 17 Oct 2024 11:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729163170; cv=none; b=W6MAdm2Jwylj10w+ehcNSmGCWg+Y5wCamMVuBbsSwZmEBFKJIabygC9IbZuAKAv33OowmRv40sSrK4otCrHyHMhi+mBQ1G0F9aecTPQqO/2mDpIps8shppb/ZzRulCuLJ/yInzuDu44iDQycDmIQVEn9n8mF2KMUPGWsKizhKxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729163170; c=relaxed/simple;
	bh=A7+g72QjPlUQUIWPTKMLnaCm8tb54u9e4q8eS9BE0lU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dOVXRKfHogHi33jhOP1iCAH327Hw6wOkljoYp2ZMVGgmavP2Zi72D5MrxOVzXz2N957JiQQ32uOcVatt2r3nuOpwvzlP9SWnL+LR+gsqmBuoSnEQDhjcFG3VcjS0r5CPBpUg753WYWwGkVcAth6A05EJT3d36qKDh8/TQUpEv48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XTlMd0HgQz1SCqZ;
	Thu, 17 Oct 2024 19:04:13 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 226F4140109;
	Thu, 17 Oct 2024 19:05:29 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 17 Oct 2024 19:05:26 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 5/8] selftests/landlock: Test that MPTCP actions are not restricted
Date: Thu, 17 Oct 2024 19:04:51 +0800
Message-ID: <20241017110454.265818-6-ivanov.mikhail1@huawei-partners.com>
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

Extend protocol fixture with test suits for MPTCP protocol.
Add CONFIG_MPTCP and CONFIG_MPTCP_IPV6 options in config.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Removes SMC test suits and puts SCTP test suits in a separate commit.
---
 tools/testing/selftests/landlock/config     |  2 +
 tools/testing/selftests/landlock/net_test.c | 44 +++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 29af19c4e9f9..a8982da4acbd 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -3,6 +3,8 @@ CONFIG_CGROUP_SCHED=y
 CONFIG_INET=y
 CONFIG_IPV6=y
 CONFIG_KEYS=y
+CONFIG_MPTCP=y
+CONFIG_MPTCP_IPV6=y
 CONFIG_NET=y
 CONFIG_NET_NS=y
 CONFIG_OVERLAY_FS=y
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 333263780fae..d9de0ee49ebc 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -312,6 +312,17 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp2) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_mptcp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp1) {
 	/* clang-format on */
@@ -335,6 +346,17 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp2) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_mptcp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_udp) {
 	/* clang-format on */
@@ -398,6 +420,17 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp2) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_mptcp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp1) {
 	/* clang-format on */
@@ -421,6 +454,17 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp2) {
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_mptcp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_udp) {
 	/* clang-format on */
-- 
2.34.1

