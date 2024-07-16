Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06041991B0
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 12:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721132897; cv=none; b=qkGgAHHlMhlcImBFvm4b/3/XVm4IZqWbBQlX4H1MaJl+ZGyAQKsm4raA4ZnQQNNhQw+tfSZb2L5sEfLfLfpr4kYK9UIPCm1oV6I7TI+x86nXJhJEVJDXihnpj7IaGwZVyMZ+v3Dkf4HTYCmCA1E5RLzEKgAR7o7vJtQZl8CoSnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721132897; c=relaxed/simple;
	bh=b73EsrS/R6t+V7OTN3jajRGaOmaVtljrkHPnEmdYVLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkR2HuriXYsKE4NPNVta4AVJexuylYA9j17KhIFr1r2h/TF7Nv5bQP1ns/vZ/T+fNbpeDZosTeewCLqJfP3CQYGErDGStcWzs4DEUGq4jqNregvSjXl0BWgiVMWQSKaM3SWmrdrgtdCOWkMXvsf2tK/azy2OBB6vG7bcDbrOBV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Pi1P7ALH; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Pi1P7ALH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lJMjF38+6RBWuo2sqp3DiNSvhyqMHD/6P51kfLbobJI=; b=Pi1P7ALHVk1TITt0KqQS92ui/e
	DsXq7GpZdDuyPo1RvzODPhD04NDIsPhf1L7d+L/r2pA9NFo/CP/ZCOc8i6K/nN8K94dLolZJsXvJw
	mKEQqEzXAL3Vt9k1vR2SOnM0/Uo9bMaHw6NjExztnqwcX2OEBAgYMNL6ElHRLOAvwi83yY1PFZsU6
	zQ7uLOSIyNoicgwrZZeE+89RshJSFo4GZcD2fSJnmM34J7bqAJgEjRM0RzvabgeZi8drNqSl5lIsY
	Di5erqIZOsHRqngkh8bTb3mERseeaoJGsmiudWXD99WHX+GL8rV30dyhXrqRUZJW5Hnjh27V92PqM
	NAV8BpNw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sThHy-000000007th-1S8H;
	Tue, 16 Jul 2024 14:28:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 3/8] xtables-monitor: Align builtin chain and table output
Date: Tue, 16 Jul 2024 14:28:00 +0200
Message-ID: <20240716122805.22331-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240716122805.22331-1-phil@nwl.cc>
References: <20240716122805.22331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the leading hash sign and add "NEW/DEL chain" annotation.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-monitor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 90d1cc5e37f31..e136e9b722e92 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -153,7 +153,8 @@ static int chain_cb(const struct nlmsghdr *nlh, void *data)
 		break;
 	default:
 		nftnl_chain_snprintf(buf, sizeof(buf), c, NFTNL_OUTPUT_DEFAULT, 0);
-		printf("# nft: %s\n", buf);
+		printf("nft: %s chain: %s\n",
+		       type == NFT_MSG_NEWCHAIN ? "NEW" : "DEL", buf);
 		goto err_free;
 	}
 
-- 
2.43.0

