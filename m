Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7507A4AEC4;
	Mon,  8 Apr 2024 09:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569233; cv=none; b=j74CUmy6qP3pagWp5vqK1WEyI6FzSkcFSF7QresQCroK8WbLR5Iq5H+XjjKQ072032eYferD7/niT0NxrQSAqFF1hdjvNiyLO0tlUMe4gjXzqd7cSjEuClC4waqqBEbfOf6gIxtn2SNHmPG5fBewtgt4aZE2NHy/8OV4a8CRHxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569233; c=relaxed/simple;
	bh=jwu0EAwlmhLGvck+G5CvcpDLqvTG2JxNNqABG8lI7Jc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cpLT0yu2DZ75yoW/Vnji+fSQr94Y2sBPzZE4ExK444vmad271MN58ySRWjix8nSyFtn0Re+FNvJMJ0IQ6SjJiydYlpJ9Za+5vNRcJaV1d9gJvept55KShx/glsk97dfnOBoAcySpPDiZJbV94/wCc3/jNuukzethx+IBgJYchos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VCkWx3HX7zXl35;
	Mon,  8 Apr 2024 17:37:17 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A1EB140415;
	Mon,  8 Apr 2024 17:40:22 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 17:40:20 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 09/10] selftests/landlock: Create 'ruleset_with_unknown_access' test
Date: Mon, 8 Apr 2024 17:39:26 +0800
Message-ID: <20240408093927.1759381-10-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
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

Add fixture mini for tests that check specific cases.
Add test that validates behavior of landlock after ruleset with
unknown access is created.

Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 .../testing/selftests/landlock/socket_test.c  | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index 07f73618d..afc57556d 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -423,4 +423,35 @@ TEST_F(tcp_layers, ruleset_overlap)
 	test_socket_create(_metadata, &self->srv0, variant->num_layers >= 2);
 }
 
+/* clang-format off */
+FIXTURE(mini) {};
+/* clang-format on */
+
+FIXTURE_SETUP(mini)
+{
+	disable_caps(_metadata);
+
+	setup_namespace(_metadata);
+};
+
+FIXTURE_TEARDOWN(mini)
+{
+}
+
+TEST_F(mini, ruleset_with_unknown_access)
+{
+	__u64 access_mask;
+
+	for (access_mask = 1ULL << 63; access_mask != ACCESS_LAST;
+	     access_mask >>= 1) {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_socket = access_mask,
+		};
+
+		EXPECT_EQ(-1, landlock_create_ruleset(&ruleset_attr,
+						      sizeof(ruleset_attr), 0));
+		EXPECT_EQ(EINVAL, errno);
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.34.1

