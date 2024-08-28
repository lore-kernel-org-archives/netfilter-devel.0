Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEE014C5BF;
	Wed, 28 Aug 2024 07:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724828537; cv=none; b=c/2Y99e/HkD2iRQIkLxjm/Tx/ojJVPZ7/EkHKlX6jF5FfVtE9vjaYUlZSRW5fP9u3lvOXZoQqKzBrjg2wVDVLlQYwta3QFw9i1FowVIn5Lv3IG5FoaLXTbNqKryxn6N4dqiMrVK/J/qap2yrYyLPY9Rjb1dgv6C8B6PK8+TNj0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724828537; c=relaxed/simple;
	bh=y3Yy8UtEbYLSW7FqOzp1afcPSCmxgE4guwIdTYLZBCY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fFjS6m0jIakxkVb7KJ18+n/fdkM+E+g78AqSr0D/Oz0x2dl8hd8DTaBjCE+uohGZPcexi8lmA+Bff8b/o9NRHIs4Dt/hb99tP00sW0kolFn7Xd7Un7weRngpR1NUj6ful3UrGO6R5EjU/0R+/qOt3dUgKBk8pf2tRxnrEBvxqk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WtwLW0wbMzyQVp;
	Wed, 28 Aug 2024 15:01:23 +0800 (CST)
Received: from kwepemh500013.china.huawei.com (unknown [7.202.181.146])
	by mail.maildlp.com (Postfix) with ESMTPS id 5DC76180AE8;
	Wed, 28 Aug 2024 15:02:11 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemh500013.china.huawei.com
 (7.202.181.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 28 Aug
 2024 15:02:10 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <roopa@nvidia.com>,
	<razor@blackwall.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <dsahern@kernel.org>,
	<krzk@kernel.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <bridge@lists.linux.dev>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH -next 0/5] net: Use kmemdup_array() instead of kmemdup() for multiple allocation
Date: Wed, 28 Aug 2024 15:09:59 +0800
Message-ID: <20240828071004.1245213-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
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

Jinjie Ruan (5):
  nfc: core: Use kmemdup_array() instead of kmemdup() for multiple
    allocation
  netfilter: Use kmemdup_array() instead of kmemdup() for multiple
    allocation
  netfilter: arptables: Use kmemdup_array() instead of kmemdup() for
    multiple allocation
  netfilter: iptables: Use kmemdup_array() instead of kmemdup() for
    multiple allocation
  netfilter: nf_nat: Use kmemdup_array() instead of kmemdup() for
    multiple allocation

 net/bridge/netfilter/ebtables.c | 2 +-
 net/ipv4/netfilter/arp_tables.c | 2 +-
 net/ipv4/netfilter/ip_tables.c  | 2 +-
 net/netfilter/nf_nat_core.c     | 2 +-
 net/nfc/core.c                  | 5 ++---
 5 files changed, 6 insertions(+), 7 deletions(-)

-- 
2.34.1

