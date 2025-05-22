Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25555C2EF;
	Thu, 22 May 2025 09:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747905637; cv=none; b=FMYyj4KoIpV8JLFNPLB3eF35SBwR5fnTSoEzmPNepnJg5SoASJ2ofRvbXG6SfTL9smsuul9q+gEuatxvIBqzG0q+73xLzQ8DFogjGbTSMqhhUD5cT2UpSKGcc8RzsvRoTfUUQMR4e+lImShOpEOiN9rVEMJEOvy6QE0vJqhJOfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747905637; c=relaxed/simple;
	bh=VOMYkfn8okgIuSk+pl336x/i9QyHXpI6lNpvzzFN+Zg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dYEoc9lh4K+LdVeZms7Ls7/S1P+lRXt5p8OCRqOI1E+D7dY8Dx/Yy/zuF8uwdR9pgYlUXzBfIkbRUfQcUuVW1kJ3aSYfmZs1wPKFMTdyasf7aVew3SxpP1TYEs9VNMHwFxadj0fwh8Rr7PgdJF4E/rxO+NrE5cLdfxHgObRHn6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=l7eqyi6+; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="l7eqyi6+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Lz
	ZSyR7lfrWgPlDATwZPFPKac5SmNUgOuGtetvBfY3I=; b=l7eqyi6+ZjdINNiE8f
	85aO95XCIVkbfJr2VnqpBZG+ZByNdr+nvYJe+RkzGw9BUBRIgXPkJdjoT75bzeIc
	bnTXQkIvLRyWevdfp4YLhQxkZXIT6fdFys4IsPqGespJq0ieow5yzboIDR+RvQTY
	8uTavmLdWGo+K2TlV904ru8Ao=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wBnuuk_7C5o4j17DA--.19816S4;
	Thu, 22 May 2025 17:19:59 +0800 (CST)
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
Subject: [PATCH V2] netfilter: nf_conntrack: table full detailed log
Date: Thu, 22 May 2025 17:19:54 +0800
Message-Id: <20250522091954.47067-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250508081313.57914-1-xiafei_xupt@163.com>
References: <20250508081313.57914-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnuuk_7C5o4j17DA--.19816S4
X-Coremail-Antispam: 1Uf129KBjvdXoWruF4kCF4UWry8XrW8JF1xGrg_yoWDKrbEk3
	92qFyjqFy5Kr9Fkr48XwsrW342ga4fAFZ3ZryUZrZF9a4DtryDKFWkZF4Yva4UCr4qyF9r
	Cr93Xr13uw47GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRCwZcUUUUUU==
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiKBZVU2gu6Mpf4QAAsi

From: lvxiafei <lvxiafei@sensetime.com>

Add the netns field in the "nf_conntrack: table full,
dropping packet" log to help locate the specific netns
when the table is full.

Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
---
 net/netfilter/nf_conntrack_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7f8b245e287a..47036a9d4acc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1659,7 +1659,11 @@ __nf_conntrack_alloc(struct net *net,
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
 			atomic_dec(&cnet->count);
-			net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
+			if (net == &init_net)
+				net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
+			else
+				net_warn_ratelimited("nf_conntrack: table full in netns %u, dropping packet\n",
+						     net->ns.inum);
 			return ERR_PTR(-ENOMEM);
 		}
 	}
-- 
2.40.1

