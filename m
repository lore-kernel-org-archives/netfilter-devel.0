Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F57E17C233;
	Tue, 16 Jul 2024 12:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721133524; cv=none; b=esUBwd1TzRDrcXKwXkIXJ2jfIGLP2LBuy5jAH5RN94SGIGX1z5hXpDclSAUVLIc2gWeTp4PyJASU0U0XjusUkO0kL/cZd7bHi+lEm+9wYdNs6hYzK0w7ZXefxwiIl5dTq+xbBuKE0pBtHaM8/8CxbWW4E3+0Kz5Tu8cnhhBlTCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721133524; c=relaxed/simple;
	bh=0oabOHX/QPzJD+4fYrLgFnoPAHFQbC17iX5l3pOxPxE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BTUEtD1P8pPg35wDgiM+Fbc8K/XrLAOkLKMmshQhVP4KWGjkEGv0wqdDZl2YKSIWbT85b5kUOpxNUwma4hQgXYHefeUk5cDWsAfjuxBbyNUbVB1rFiIo60Hv8disKB9QEfV/0jOqXdxuZFf0JAnhLQEM3RmkWuILjSuGRTk1b0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WNdlv5JdDz1JCgk;
	Tue, 16 Jul 2024 20:33:47 +0800 (CST)
Received: from kwepemg100015.china.huawei.com (unknown [7.202.181.56])
	by mail.maildlp.com (Postfix) with ESMTPS id 46685180064;
	Tue, 16 Jul 2024 20:38:38 +0800 (CST)
Received: from localhost.huawei.com (10.137.16.203) by
 kwepemg100015.china.huawei.com (7.202.181.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Jul 2024 20:38:36 +0800
From: renmingshuai <renmingshuai@huawei.com>
To: <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
	<davem@davemloft.net>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <renmingshuai@huawei.com>, <yanan@huawei.com>, <qiangxiaojun@huawei.com>,
	<mengkanglai2@huawei.com>, <caowangbao@huawei.com>,
	<chentongbiao@huawei.com>, <tanqi8@huawei.com>
Subject: Are there Any Side Effects when net.netfilter.nf_conntrack_tcp_be_liberal is set to 1?
Date: Tue, 16 Jul 2024 20:22:41 +0800
Message-ID: <20240716122241.200224-1-renmingshuai@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg100015.china.huawei.com (7.202.181.56)

Hello, everyone:
I want to consult a sysctl option net.netfilter.nf_conntrack_tcp_be_liberal.
Commit fb366fc7541a ("netfilter: conntrack: correct window scaling with
retransmitted SYN") fix bug that results in packets incorrectly being marked
invalid for being out-of-window. I encountered this bug, and i found set
net.netfilter.nf_conntrack_tcp_be_liberal is to 1 also can solve this problem.
I want to enable nf_conntrack_tcp_be_liberal=1 but i don't know the side effects
of this sysctl option, for example if this will cause some network security problem.
If there are any other impacts, please let me know as well.
thanks.
