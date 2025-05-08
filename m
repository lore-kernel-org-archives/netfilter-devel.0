Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8596F073;
	Thu,  8 May 2025 08:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746692090; cv=none; b=fWtv/mWP1AmO1VOby5DBkuUL7CJtItFqFcFFd9NxvB1AWiVuRoaZUPXq/7UB/0xO9rJ3NM5L3EOIvzZHsdaZtlkt2u7Ky3X1VB+hJu1uZTBdmQsp/ZW6u8nbeSpcHEtlp4g9dpOdhanrQU7C9Gu/XjEknufSiRCabxPKhXqQLQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746692090; c=relaxed/simple;
	bh=74xPf07Id1YjwyWpiTLsgusd9YeNBekMVBvnho/qu28=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UBu0uMHjQAqUEQmhksLBZyLXaGYpfnStga2H0UmbsunoKuvrRYOZAxPn0Okqj3PKjYkp+2jqeDUga7TxGFInGgAM7M9uZ1nJ5Nc7nPt5Q9OXvhBGlLVS3efgEKBy893tLXXVMUP5iwI2IZr5ahM2POI76zdEP8I96P9KR6YxtSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ltzca0ey; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ltzca0ey"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=9u
	i4tQhpd/K6rp/B6uUyA+cBe3CYrRp23mZq06w97t4=; b=ltzca0eytM1zjYG1Jy
	T+gihYRZ+MS9YhUgPLCUOCz5/f65rEba2pav49UWM6nmpqGzH71fCgM1y7qj8LOv
	KQtxFjLVFRlJip9oBCoGPwg9FaXt4QgW2mTlCHhYUsVnVW+QZ7twc+mkiEu/ZDDw
	K7hch19A/HxmfDLDATJ7tOAAM=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgC3xJPHZxxosVC1BQ--.11373S4;
	Thu, 08 May 2025 16:14:00 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: lvxiafei <lvxiafei@sensetime.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nf_conntrack: table full detailed log
Date: Thu,  8 May 2025 16:13:12 +0800
Message-Id: <20250508081313.57914-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgC3xJPHZxxosVC1BQ--.11373S4
X-Coremail-Antispam: 1Uf129KBjvdXoWruF4kCF4UWry8XrW8JF1xGrg_yoWfKFXEk3
	92qFyjqF1Fvr9Fkr48XwsrWF9Fga4fAFZ3ZryUZrZF9a4DtryDKFWkZF4Yv34UGr4qyF9r
	Cr93XF1a9w47GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8l38UUUUUU==
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiKBlGU2gbtOMAywACsJ

From: lvxiafei <lvxiafei@sensetime.com>

Add the netns field in the "nf_conntrack: table full,
dropping packet" log to help locate the specific netns
when the table is full.

Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
---
 net/netfilter/nf_conntrack_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7f8b245e287a..71849960cf0c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1659,7 +1659,8 @@ __nf_conntrack_alloc(struct net *net,
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
 			atomic_dec(&cnet->count);
-			net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
+			net_warn_ratelimited("nf_conntrack: table full in netns %u, dropping packet\n",
+					     net->ns.inum);
 			return ERR_PTR(-ENOMEM);
 		}
 	}
-- 
2.40.1

