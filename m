Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE717CE79AF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 09:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbjITJ13 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 05:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbjITJ1Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 05:27:25 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627D093;
        Wed, 20 Sep 2023 02:27:05 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RrCmY220Yz6HJc3;
        Wed, 20 Sep 2023 17:25:01 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 20 Sep 2023 10:27:02 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
Subject: [PATCH v12 09/12] selftests/landlock: Share enforce_ruleset()
Date:   Wed, 20 Sep 2023 17:26:37 +0800
Message-ID: <20230920092641.832134-10-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
References: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500002.china.huawei.com (7.188.26.138) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This commit moves enforce_ruleset() helper function to common.h so that
it can be used both by filesystem tests and network ones.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v11:
* None.

Changes since v10:
* Refactors commit message.

Changes since v9:
* None.

Changes since v8:
* Adds __maybe_unused attribute for enforce_ruleset() helper.

Changes since v7:
* Refactors commit message.

Changes since v6:
* None.

Changes since v5:
* Splits commit.
* Moves enforce_ruleset helper into common.h
* Formats code with clang-format-14.

---
 tools/testing/selftests/landlock/common.h  | 10 ++++++++++
 tools/testing/selftests/landlock/fs_test.c | 12 +-----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index d7987ae8d7fc..0fd6c4cf5e6f 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -256,3 +256,13 @@ static int __maybe_unused send_fd(int usock, int fd_tx)
 		return -errno;
 	return 0;
 }
+
+static void __maybe_unused
+enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
+{
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
+	{
+		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
+	}
+}
diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 251594306d40..7c94d3933b68 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -677,17 +677,7 @@ static int create_ruleset(struct __test_metadata *const _metadata,
 	return ruleset_fd;
 }

-static void enforce_ruleset(struct __test_metadata *const _metadata,
-			    const int ruleset_fd)
-{
-	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
-	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
-	{
-		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
-	}
-}
-
-TEST_F_FORK(layout0, proc_nsfs)
+TEST_F_FORK(layout1, proc_nsfs)
 {
 	const struct rule rules[] = {
 		{
--
2.25.1

