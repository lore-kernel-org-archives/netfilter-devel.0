Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721921CF7A3;
	Wed,  4 Sep 2024 10:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446933; cv=none; b=FZFKIEeqIG7zURZekWpZ/c7TW4WZ+P2+dDSwuT+8FjRvWGrSWC49rEqtygh1CWSfZE8JHl16jnoJJ0/sckXmXnInS7Qcn2RR82IdpzXPZZVzibCgCOcACozYF6PdmpU0RO8E1Ewbyl06jUYxTyTKefnX3gurCyK8/8Q2z8B4oDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446933; c=relaxed/simple;
	bh=RVjnyh+6CO1rYLpDpkpy2GoNNQ7qT2FNCytzNZCL/dI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H4bTG9IfFawNYJlTl7XePcqoHYpADyNHEOCabXY8G8VpNjLCQrQuRjuYZ2hlu1TNjrf6U1t1m68yHgBJjQUnFc6ikd+qWPwO41gYJmRlmRg62QZhe832JcJWUafBcEH1uWTO2onwwcIIfRSeLhZvwp76rXr2gYuAB1ncvvT5cZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WzK2b65DQz1BJnD;
	Wed,  4 Sep 2024 18:47:51 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 3D714180105;
	Wed,  4 Sep 2024 18:48:49 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:48:47 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 09/19] selftests/landlock: Test creating a ruleset with unknown access
Date: Wed, 4 Sep 2024 18:48:14 +0800
Message-ID: <20240904104824.1844082-10-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Add test that validates behaviour of Landlock after ruleset with
unknown access is created.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v2:
* Removes fixture `mini`. Network namespace is not used, so this
  fixture has become useless.
* Changes commit title and message.

Changes since v1:
* Refactors commit message.
---
 tools/testing/selftests/landlock/socket_test.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
index e7b4165a85cd..dee676c11227 100644
--- a/tools/testing/selftests/landlock/socket_test.c
+++ b/tools/testing/selftests/landlock/socket_test.c
@@ -463,4 +463,20 @@ TEST_F(protocol, ruleset_overlap)
 	EXPECT_EQ(EACCES, test_socket_variant(&self->prot));
 }
 
+TEST(ruleset_with_unknown_access)
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

