Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5946F18A95E;
	Wed,  4 Sep 2024 09:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725441857; cv=none; b=Y1NQF5gH335+7LBJxxwAoYBYwqeE7pb+C6xq8Mq3qfkwybqyUjouEZJJyoUezKAHylpEKncOWimElGwxSrf0/tP69u8uIta8jNGTpAUHceLsoCSIW+sv3g/0qJJyPlTkQc9FKNdnSr+2nHuj/J4xcjL5+993Kh9lgN2hwJPT5Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725441857; c=relaxed/simple;
	bh=oE9Stb6+bAQcPyENRZbspP2lpEs/2To/u5FLnr7doxk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Te7nPLuL+IbzptEgEvIhQICbCknK9lo+eJYAKtQeDHXwFeFdWFNXQRVDbAI3qMgUAZbnN8v9Qbg25KY984jU4yg+Laboib5OIsU0Br9Uf8vszruDFaxWmgkl2r/FbipBSvnKnb+HqDO0vHjmGAh1gcg/oXgllO7SGjYru0eCtP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzH6568tMz1HHLV;
	Wed,  4 Sep 2024 17:20:45 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 47E641401E9;
	Wed,  4 Sep 2024 17:24:13 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 4 Sep
 2024 17:24:13 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<horms@kernel.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<lihongbo22@huawei.com>
Subject: [PATCH net-next v2 0/5] make use of the helper macro LIST_HEAD()
Date: Wed, 4 Sep 2024 17:32:38 +0800
Message-ID: <20240904093243.3345012-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The macro LIST_HEAD() declares a list variable and
initializes it, which can be used to simplify the steps
of list initialization, thereby simplifying the code.
These serials just do some equivalatent substitutions,
and with no functional modifications.

Changes in v2:
  - Keep the reverse xmas tree order as Simon's and
    Pablo's suggested.

Hongbo Li (5):
  net/ipv4: make use of the helper macro LIST_HEAD()
  net/tipc: make use of the helper macro LIST_HEAD()
  net/netfilter: make use of the helper macro LIST_HEAD()
  net/ipv6: make use of the helper macro LIST_HEAD()
  net/core: make use of the helper macro LIST_HEAD()

 net/core/dev.c       | 6 ++----
 net/ipv4/ip_input.c  | 6 ++----
 net/ipv6/ip6_input.c | 6 ++----
 net/netfilter/core.c | 4 +---
 net/tipc/socket.c    | 6 ++----
 5 files changed, 9 insertions(+), 19 deletions(-)

-- 
2.34.1

