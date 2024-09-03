Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAFC21CA690
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 13:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371742; cv=none; b=DewuDrAPIeL4wZx8olEqgP0z8DjOboBizMnFfXCqfxCYms4mkd1KnmJFNA+THIHTaXNooZO5Dsw0wbUbn3a3rUFqmHq9hggW6+Jm+zQTWuY7nrzdr8DMCdVoD5KIkKUQBFDKj2wZUpsxxwpgx7jHXDvbCiHNzZNNXOhe9hl2joo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371742; c=relaxed/simple;
	bh=wW9M6bnfXL8U4muPOYkHBnPtxwKhXksF/nJgEGGhvZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F22dNGiOqt152iTW+RW/7dogL26HRdDgNYyTq7xGDouq77veo8m/Y/kCJVIaFMBCWWHn3uRloDhs4AtaSsNG1m3C5LiSKiKFC7UCFgjh/XH4+Yg9t2a+PiXw7xsRb5ByVaKQxiIM3Au0hqWDXNfDi+fCMGP2Hmp4yhmHkyUakfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v3 1/9] netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
Date: Tue,  3 Sep 2024 15:55:25 +0200
Message-Id: <20240903135533.2021-1-pablo@netfilter.org>
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
v3: no changes

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

