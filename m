Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36191DC1B2;
	Thu, 17 Oct 2024 11:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729163140; cv=none; b=Zt+jk/4NuPVc3GmRMu5P8bCZS7nVKZbUzbgVWDMilYfCW5g4D51RbQ8eFiN1CFh6uSucEprVYo+ioME6g8fwgB4vFdhjXet8O0CuOWAOcJVkWYHJEFoq1Uc2hMtTtE+y76CdwRKjbLk9aanmke80U/MmtZDTSqtAv7cjF1bUqXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729163140; c=relaxed/simple;
	bh=aiZUdN9CrJgffhvAzeA9go8XeX4Cx1wM9+TSjIIY92M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gEFOepOKLG90FxetEfL8+NkSXxbpvGm0D6uTvjPh3pthNERREaYNMrEajcWpIANgh85jaPuq5UAz+UDB44RvdkJFXRuq9n2Ypz2XOW9YDZfiv0chaJvre+WzbSN8TLsLpGuKpu8/lrmlVptBg9wWqeHsdGOtAVpuEomIuqwGfhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XTlNJ1BHvzQrmG;
	Thu, 17 Oct 2024 19:04:48 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 9B6591800D2;
	Thu, 17 Oct 2024 19:05:33 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 17 Oct 2024 19:05:31 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 7/8] landlock: Add note about errors consistency in documentation
Date: Thu, 17 Oct 2024 19:04:53 +0800
Message-ID: <20241017110454.265818-8-ivanov.mikhail1@huawei-partners.com>
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

Add recommendation to specify Landlock first in CONFIG_LSM list, so user
can have better LSM errors consistency provided by Landlock.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 Documentation/userspace-api/landlock.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
index bb7480a05e2c..0db5eee9bffa 100644
--- a/Documentation/userspace-api/landlock.rst
+++ b/Documentation/userspace-api/landlock.rst
@@ -610,7 +610,8 @@ time as the other security modules.  The list of security modules enabled by
 default is set with ``CONFIG_LSM``.  The kernel configuration should then
 contains ``CONFIG_LSM=landlock,[...]`` with ``[...]``  as the list of other
 potentially useful security modules for the running system (see the
-``CONFIG_LSM`` help).
+``CONFIG_LSM`` help). It is recommended to specify Landlock first of all other
+modules in CONFIG_LSM list since it provides better errors consistency.
 
 Boot time configuration
 -----------------------
-- 
2.34.1

