Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5A13093A8;
	Tue, 18 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473631; cv=none; b=mwFzGnwwBqdIbAQgn5Odrl2qpWaMrl2efWlHHb9AYDUwd7gNCCN3tNeO7JTZWLUlNB9QGo7xE19fq0vENB4XK1KetwS4GcsAdHV1mRl7F92L6D0B1wL/hUDRLyxSEh3YelW3lIhd+ifw799yYkQSU/Rv92c5rOpeEf/UOudRs6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473631; c=relaxed/simple;
	bh=AN5wWCP5i8wXqwyVqSh5IPzEL5qACzwPVGyOCmRP224=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmmAvvdbKYiYL8d3+aE/yrv/vD3SRYpa9L+6hwQp4A+Q6Ve36IVMehwn3mKI63Z0XgUZlvcijNOZpCGRb2CzQgcpti2YN3qGC2M39lyeGjcX4Madqy30hrWm8hT+pfDiX6kKWhqWqWJEoeZlvWdKBtB9CTZjRCX+Gakqbbm+fPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9X2sPgzJ46dM;
	Tue, 18 Nov 2025 21:46:24 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id AEE12140446;
	Tue, 18 Nov 2025 21:47:06 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:06 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 14/19] selftests/landlock: Test that accept(2) is not restricted
Date: Tue, 18 Nov 2025 21:46:34 +0800
Message-ID: <20251118134639.3314803-15-ivanov.mikhail1@huawei-partners.com>
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

Add test validating that socket creation with accept(2) is not restricted
by Landlock.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v3:
* Minor fixes.
---
 .../testing/selftests/landlock/socket_test.c  | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index e9f56a86f456..ea1590e555b7 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -1049,4 +1049,66 @@ TEST_F(connection_restriction, sctp_peeloff)
 	ASSERT_EQ(0, close(server_fd));
 }
 
+TEST_F(connection_restriction, accept)
+{
+	int status;
+	pid_t child;
+	struct sockaddr_in addr;
+	int server_fd, client_fd;
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+
+	server_fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
+	ASSERT_LE(0, server_fd);
+
+	addr.sin_family = AF_INET;
+	addr.sin_port = htons(loopback_port);
+	addr.sin_addr.s_addr = inet_addr(loopback_ipv4);
+
+	ASSERT_EQ(0, bind(server_fd, &addr, sizeof(addr)));
+	ASSERT_EQ(0, listen(server_fd, backlog));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		/* Connects to server once and exits. */
+
+		/* Closes listening socket for the child. */
+		ASSERT_EQ(0, close(server_fd));
+
+		client_fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
+		ASSERT_LE(0, client_fd);
+
+		ASSERT_EQ(0, connect(client_fd, &addr, sizeof(addr)));
+
+		ASSERT_EQ(0, close(client_fd));
+		_exit(_metadata->exit_code);
+		return;
+	}
+
+	if (variant->sandboxed) {
+		int ruleset_fd;
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+
+		enforce_ruleset(_metadata, ruleset_fd);
+		ASSERT_EQ(0, close(ruleset_fd));
+	}
+
+	client_fd = accept(server_fd, NULL, 0);
+
+	/* accept(2) should not be restricted by Landlock. */
+	ASSERT_LE(0, client_fd);
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	ASSERT_EQ(0, close(server_fd));
+	ASSERT_EQ(0, close(client_fd));
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

