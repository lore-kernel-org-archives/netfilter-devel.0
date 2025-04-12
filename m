Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68B42367A7;
	Sat, 12 Apr 2025 17:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744479080; cv=none; b=eJ+2bCIwR3MUk1rnQdaYdUBodLtO1xGHJrO7DJOUOdCrxSqO1/Amx1aF3FIcK82gwdZ1QdphykAWyyf3tvTvGwxxCfk8oGSm/xgUqfwJuSlP7fN74q9RquRBsIt3fK4SlOCo2gadwB6gfBAbZ6AWdev9lPgTSNXbt/viyiGHDZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744479080; c=relaxed/simple;
	bh=+CE3twRV3jboNZJg51rkK5bgDxYPMjxIrspDFfgrPbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mcDJGeW5S5LC1YzxQcmvjDeMwLMVjfvybdjbOifib7IYPZjk0bzr3OsCV8+bkAgOzfOkiGi4ps8HJT9a5GE4lTttSak7rVrYM99D1XqCY+bSmHcwm3BkrGSubkbpesn4xntALz3UyPR+ay6WBiydBzRHCVZJb6LGHc7igRe3WQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pFN77tRy; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pFN77tRy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=qZ57c
	KcPHDsonx2xR32UZykpc5BjXHVv/WVTwJqRQlc=; b=pFN77tRyse76vY7pk+5T2
	DeEVMVqcdU8oBaInLke6/988HJ+scBQC7/tJ9/0BCE3d+ZzW4ssn2PAgUUQHZ8CQ
	BImUXzdiaDHDksLDTj7Pqw1NeXTkFxq6aUbrPPdVUOssrL2fg2KB7XkIC3OIuO7a
	jDnTNHUHMUFgqegPVb6XGQ=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAXb5Q2o_pnQbjAAA--.21687S4;
	Sun, 13 Apr 2025 01:30:31 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: xiafei_xupt@163.com
Cc: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kadlec@netfilter.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org
Subject: Re: [PATCH V5] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Sun, 13 Apr 2025 01:30:30 +0800
Message-Id: <20250412173030.39142-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250412172610.37844-1-xiafei_xupt@163.com>
References: <20250412172610.37844-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAXb5Q2o_pnQbjAAA--.21687S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Wr13trW8Kr47GF1rur4xtFb_yoW8Jry8pw
	1fGry7J348Jr4UXF15Jw4DAr1UJw4fJw1jkFn8trW8Xw1qkry5Jr4UJF1xXFy2y34xJw18
	AFWUJryUJr4jyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUppB3UUUUU=
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/xtbBMRstU2f6mL7bhgAAsy

The limit of other netns cannot be greater than init_net netns.
    +----------------+-------------+----------------+
    | init_net netns | other netns | limit behavior |
    +----------------+-------------+----------------+
    | 0              | 0           | unlimited      |
    +----------------+-------------+----------------+
    | 0              | not 0       | other          |
    +----------------+-------------+----------------+
    | not 0          | 0           | init_net       |
    +----------------+-------------+----------------+
    | not 0          | not 0       | min            |
    +----------------+-------------+----------------+

0,0
[Apr12 17:16] init_net.ct.sysctl_max 0, net->ct.sysctl_max 0, ct_max 0
0,1
[Apr12 17:17] init_net.ct.sysctl_max 0, net->ct.sysctl_max 1, ct_max 1
[  +0.000004] nf_conntrack: nf_conntrack: table full, dropping packet
1,0
Apr12 17:18] init_net.ct.sysctl_max 1, net->ct.sysctl_max 0, ct_max 1
[  +0.000006] nf_conntrack: nf_conntrack: table full, dropping packet
1,2
[Apr12 17:19] init_net.ct.sysctl_max 1, net->ct.sysctl_max 2, ct_max 1
[  +0.000004] nf_conntrack: nf_conntrack: table full, dropping packet
2,1
[Apr12 17:21] init_net.ct.sysctl_max 2, net->ct.sysctl_max 1, ct_max 1
[  +0.000004] nf_conntrack: nf_conntrack: table full, dropping packet

