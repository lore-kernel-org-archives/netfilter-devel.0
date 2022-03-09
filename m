Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633E2C43217
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Mar 2022 13:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbiCINrB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Mar 2022 08:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiCINqj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Mar 2022 08:46:39 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01B417C400;
        Wed,  9 Mar 2022 05:45:26 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD1k3PFDz6H7L5;
        Wed,  9 Mar 2022 21:43:54 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:24 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 12/15] seltest/landlock: connect() with AF_UNSPEC tests
Date:   Wed, 9 Mar 2022 21:44:56 +0800
Message-ID: <20220309134459.6448-13-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.71.64]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adds two selftests for connect() action with
AF_UNSPEC family flag.
The one is with no landlock restrictions
allows to disconnect already conneted socket
with connect(..., AF_UNSPEC, ...):
    - connect_afunspec_no_restictions;
The second one refuses landlocked process
to disconnect already connected socket:
    - connect_afunspec_with_restictions;

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Add connect_afunspec_no_restictions test.
* Add connect_afunspec_with_restictions test.

---
 .../testing/selftests/landlock/network_test.c | 94 +++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/tools/testing/selftests/landlock/network_test.c b/tools/testing/selftests/landlock/network_test.c
index 20f2d94d6d85..6fce31cad368 100644
--- a/tools/testing/selftests/landlock/network_test.c
+++ b/tools/testing/selftests/landlock/network_test.c
@@ -312,4 +312,98 @@ TEST_F_FORK(socket, connect_with_restrictions) {
 	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
 }

+TEST_F_FORK(socket, connect_afunspec_no_restictions) {
+
+	int sockfd;
+	pid_t child;
+	int status;
+
+	/* Creates a server socket 1 */
+	sockfd = create_socket(_metadata);
+	ASSERT_LE(0, sockfd);
+
+	/* Binds the socket 1 to address with port[0] */
+	ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&addr[0], sizeof(addr[0])));
+
+	/* Makes connection to socket with port[0] */
+	ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&addr[0],
+						   sizeof(addr[0])));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		struct sockaddr addr_unspec = {.sa_family = AF_UNSPEC};
+
+		/* Child tries to disconnect already connected socket */
+		ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&addr_unspec,
+						sizeof(addr_unspec)));
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+	/* Closes listening socket 1 for the parent*/
+	ASSERT_EQ(0, close(sockfd));
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+}
+
+TEST_F_FORK(socket, connect_afunspec_with_restictions) {
+
+	int sockfd;
+	pid_t child;
+	int status;
+
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	struct landlock_net_service_attr net_service_1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+
+		.port = port[0],
+	};
+
+	const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+					sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Allows connect and bind operations to the port[0] socket */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_1, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	/* Creates a server socket 1 */
+	sockfd = create_socket(_metadata);
+	ASSERT_LE(0, sockfd);
+
+	/* Binds the socket 1 to address with port[0] */
+	ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&addr[0], sizeof(addr[0])));
+
+	/* Makes connection to socket with port[0] */
+	ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&addr[0],
+						   sizeof(addr[0])));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		struct sockaddr addr_unspec = {.sa_family = AF_UNSPEC};
+
+		/* Child tries to disconnect already connected socket */
+		ASSERT_EQ(-1, connect(sockfd, (struct sockaddr *)&addr_unspec,
+						sizeof(addr_unspec)));
+		ASSERT_EQ(EACCES, errno);
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+	/* Closes listening socket 1 for the parent*/
+	ASSERT_EQ(0, close(sockfd));
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+}
 TEST_HARNESS_MAIN
--
2.25.1

