Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC9EC77B7D
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 May 2023 16:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242667AbjEOQOr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 May 2023 12:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242558AbjEOQO2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2023 12:14:28 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85F6213A;
        Mon, 15 May 2023 09:14:23 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QKkts02QTz67lVg;
        Tue, 16 May 2023 00:13:24 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 17:14:21 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
Subject: [PATCH v11 09/12] selftests/landlock: Share enforce_ruleset()
Date:   Tue, 16 May 2023 00:13:36 +0800
Message-ID: <20230515161339.631577-10-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
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
 tools/testing/selftests/landlock/fs_test.c | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

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
index b6c4be3faf7a..b762b5419a89 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -598,16 +598,6 @@ static int create_ruleset(struct __test_metadata *const _metadata,
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
 TEST_F_FORK(layout1, proc_nsfs)
 {
 	const struct rule rules[] = {
--
2.25.1

