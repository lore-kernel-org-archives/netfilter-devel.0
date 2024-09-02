Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20D2186E46
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2024 23:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725319432; cv=none; b=FPJ63BC0RYlSrOQW7pkMrRhrAJGIdW8PuTMKNyInG8VQ60Vjkej5EnM/BXKWDtW1cL7wu7TwsNqDQ9h7x40Hg5V5OUH9lnT/XDdc8A76lORpIZcgUrossC+Tfw5NHGVIy5doc+iyVoY0lStucOZP04yxateQ5QvI+HthFGD7NQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725319432; c=relaxed/simple;
	bh=twNRMG2HQ4tv541QUOIrae637ghf6kNUC3IXYiDbeYA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=igwblPZNErPCXOWK2UIm7EJElz03S75urWThFeUFOSW274a54ndX0NmK0qgo+VuROZ5/B2gW1pGSc7UeayECLTKtkFOt8V9VjA8aADPrwbuQfapvxVJi3LEIROLOvELeV3ns09H5HyRC4RTnHErFfj+NQLjZHjkuzwfMmvXQQWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nf-next,v2 1/9] netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
Date: Tue,  3 Sep 2024 01:17:18 +0200
Message-Id: <20240902231726.171964-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Element timeout that is below CONFIG_HZ never expires because the
timeout extension is not allocated given that nf_msecs_to_jiffies64()
returns 0. Set timeout to the minimum value to honor timeout.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: as per Phil Sutter, set it to minimum value in this case.

 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0a2f79346958..6de74dae50fc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4587,7 +4587,7 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 		return -ERANGE;
 
 	ms *= NSEC_PER_MSEC;
-	*result = nsecs_to_jiffies64(ms);
+	*result = nsecs_to_jiffies64(ms) ? : !!ms;
 	return 0;
 }
 
-- 
2.30.2

