Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E557358D0A;
	Tue, 18 Nov 2025 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473636; cv=none; b=k52abI+Zyl7DajJyQlSfgAvwhMr6IUNa/PUivmgLTeJkKl5J6sYNQ2glUebS/gRRNeJYXIICVWnDZQiW7Wz2cSa372UX9LWLHWmMOTNuWrJDsSiQE/9gi7y/LbB3unRH7WHtwQ9YXQg/MEUlj4/fMBoOMT4rvD4gWUfa8eQ97vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473636; c=relaxed/simple;
	bh=HJjQtyTVvNT7HC9Be7YEiG2GLlErtduZ39YGD6r5Mzc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ApOLdNyyA8Fb3oDT2aEhlmDfqqGQVbIkqn4ikmjmE720BLCg12J61AmrkL9YilWlQ3JBjEsf+/JbvYhEpp52Xi35AC3CI5oZAeO8VxDoiogbOQD/rOBwuCxUqwuZYCgeJDz3JOt+4wBNqHfa0GpjBcF2WXxe//eukqOH7vdK69w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9m0k1mzHnH7d;
	Tue, 18 Nov 2025 21:46:36 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 04E531402F3;
	Tue, 18 Nov 2025 21:47:07 +0800 (CST)
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
Subject: [RFC PATCH v4 17/19] selftests/landlock: Test socket creation denial log for audit
Date: Tue, 18 Nov 2025 21:46:37 +0800
Message-ID: <20251118134639.3314803-18-ivanov.mikhail1@huawei-partners.com>
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

Test single socket blocker: socket.create.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 .../testing/selftests/landlock/socket_test.c  | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index ea1590e555b7..a091b8a883c8 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -17,6 +17,7 @@
 #include <linux/sctp.h>
 #include <arpa/inet.h>
 
+#include "audit.h"
 #include "common.h"
 
 #define ACCESS_LAST LANDLOCK_ACCESS_SOCKET_CREATE
@@ -1111,4 +1112,58 @@ TEST_F(connection_restriction, accept)
 	ASSERT_EQ(0, close(client_fd));
 }
 
+FIXTURE(audit)
+{
+	struct audit_filter audit_filter;
+	int audit_fd;
+};
+
+FIXTURE_SETUP(audit)
+{
+	set_cap(_metadata, CAP_AUDIT_CONTROL);
+	self->audit_fd = audit_init_with_exe_filter(&self->audit_filter);
+	EXPECT_LE(0, self->audit_fd);
+	disable_caps(_metadata);
+};
+
+FIXTURE_TEARDOWN(audit)
+{
+	set_cap(_metadata, CAP_AUDIT_CONTROL);
+	EXPECT_EQ(0, audit_cleanup(self->audit_fd, &self->audit_filter));
+	clear_cap(_metadata, CAP_AUDIT_CONTROL);
+}
+
+TEST_F(audit, socket_create)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
+	};
+	struct audit_records records;
+	int ruleset_fd;
+	const char log_template[] = REGEX_LANDLOCK_PREFIX
+		" blockers=socket.create family=%d sock_type=%d protocol=0$";
+	/* Family and type should not exceed 2-digit number. */
+	char log_match[sizeof(log_template) + 4];
+	int log_match_len;
+
+	log_match_len = snprintf(log_match, sizeof(log_match), log_template,
+				 AF_INET, SOCK_STREAM);
+	ASSERT_LT(log_match_len, sizeof(log_match));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	ASSERT_EQ(EACCES, test_socket(AF_INET, SOCK_STREAM, 0));
+
+	EXPECT_EQ(0, audit_match_record(self->audit_fd, AUDIT_LANDLOCK_ACCESS,
+					log_match, NULL));
+
+	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
+	EXPECT_EQ(0, records.access);
+	EXPECT_EQ(1, records.domain);
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

