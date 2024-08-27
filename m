Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7077E19F498;
	Tue, 27 Aug 2024 09:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724752574; cv=none; b=IC3yKpHVypBasxDtoITTcXdAREue08M7H2a/1pfuidoBsuyhtiL7XiZpIrdYENTqJNY7ZNiMpl2i6i+0w5qMlTcSREJN5bdRkTZ5LOajhaXOF+5pBWvUV+pTpykYO9CrMTzJSYU+kLlRWJpLn3RgBD4owMsqAkd7POsG5lEz30Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724752574; c=relaxed/simple;
	bh=4UOAYChPANrkYgj18yXPcjR9e8MqyGoYfOgAEkcdDSc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gV+1OoN8Dcc19eBwQeM5Mz1yUzu8ibZ6G6Cjh1324/pMA8bthsadt23mRU7dhyU/gBwFiXoO9qPZ/NMVM3YQGcZqjHpc6h4xDDvJcOtZw42zwJTK4G+CsmDiQfkbtjXPywH3V6zJXtyH/rzR0CPgzZPczcSGr297RQmx53iqhLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WtN946894zQqtL;
	Tue, 27 Aug 2024 17:51:20 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 80DAE1800FF;
	Tue, 27 Aug 2024 17:56:09 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 27 Aug
 2024 17:56:09 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <pablo@netfilter.org>, <kadlec@netfilter.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<lihongbo22@huawei.com>
Subject: [PATCH net-next 0/5] make use of the helper macro LIST_HEAD()
Date: Tue, 27 Aug 2024 18:04:02 +0800
Message-ID: <20240827100407.3914090-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The macro LIST_HEAD() declares a list variable and
initializes it, which can be used to simplify the steps
of list initialization, thereby simplifying the code.
These serials just do some equivalatent substitutions,
and with no functional modifications.

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

