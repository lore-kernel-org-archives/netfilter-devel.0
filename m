Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0198B14F9D5;
	Wed, 28 Aug 2024 07:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724828537; cv=none; b=Z1sEe8wvpj/HykJuDALF3752bAZXbgp8g1fRb0sUxmYCwgDPJ94CCwttho6VWEJ4fcSofbZyX/G3CycChm5QeyKe5Y8njXw4EgGy8zkY7E4RXQEGcpCInfQRMIwOJljuE/neqSjf7cUfWc7XAMi/RXbOitR22MEe6mik3neU0Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724828537; c=relaxed/simple;
	bh=ia+QMXx6wK488wPA1+TuPYkqM0Y+z8p8bHzHWG6wQX0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LSC167M+zwUYDfgDhxnBxCOB96bAfAXRb7zxJmbJtI5gbQsl/SwwndglT2ujX+nr0Yu9YBnY5j8iWDKFx36cAtgM1IyV7N71/2myasx4paPpAe0lBoqS3LLLJpZhM6zKALS825RBvcB8AiwQTl74KUA25zaDQY/QroehCvzfIDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4WtwKB2tl1z1xwRP;
	Wed, 28 Aug 2024 15:00:14 +0800 (CST)
Received: from kwepemh500013.china.huawei.com (unknown [7.202.181.146])
	by mail.maildlp.com (Postfix) with ESMTPS id F0D771A016C;
	Wed, 28 Aug 2024 15:02:11 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemh500013.china.huawei.com
 (7.202.181.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 28 Aug
 2024 15:02:11 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <roopa@nvidia.com>,
	<razor@blackwall.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <dsahern@kernel.org>,
	<krzk@kernel.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <bridge@lists.linux.dev>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH -next 1/5] nfc: core: Use kmemdup_array() instead of kmemdup() for multiple allocation
Date: Wed, 28 Aug 2024 15:10:00 +0800
Message-ID: <20240828071004.1245213-2-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240828071004.1245213-1-ruanjinjie@huawei.com>
References: <20240828071004.1245213-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemh500013.china.huawei.com (7.202.181.146)

Let the kmemdup_array() take care about multiplication and possible
overflows.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 net/nfc/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index e58dc6405054..cbc2f718aece 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -790,9 +790,8 @@ int nfc_targets_found(struct nfc_dev *dev,
 	dev->targets = NULL;
 
 	if (targets) {
-		dev->targets = kmemdup(targets,
-				       n_targets * sizeof(struct nfc_target),
-				       GFP_ATOMIC);
+		dev->targets = kmemdup_array(targets, n_targets,
+					     sizeof(struct nfc_target), GFP_ATOMIC);
 
 		if (!dev->targets) {
 			dev->n_targets = 0;
-- 
2.34.1

