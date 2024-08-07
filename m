Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E635E093
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040652; cv=none; b=FDMIVx7ZLvnxFIqkm+oC7aai5XntPb4oH3Qor/+G7FiWfI6yw8EZj25hPOjbvteHRcGI9aty4Ul3rCPVXdfRnhtVcPeJxmlpKKsBJmMuyJhTFezG7f1M5bMJBhRij89xlInhBIpDFhQABYnTRQbQzy1pU6Yz3aTRdw08o3laObc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040652; c=relaxed/simple;
	bh=5Ibn+AvLioJ+7WZCoMUGFJKLC/axprBr73c11EBGqBw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uo9hNZN8zW/VtDJ/vwqPdGb1z8ahoI7z6bdzrK1bz/hIP9xYcvwwaFmVWbewclcBvLnUayxvhUJc9KxajCnWaITR6/OB8cioFFpT79voqc/s1dEgNQoufWAy5gqSJ77Iz9MHpkqm6TYN4BOwJVUurrhm2nGFt490uctZZ/rfWYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/8] netfilter: nf_tables: elements with timeout less than HZ/10 never expire
Date: Wed,  7 Aug 2024 16:23:50 +0200
Message-Id: <20240807142357.90493-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240807142357.90493-1-pablo@netfilter.org>
References: <20240807142357.90493-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Elements with less than HZ/10 milliseconds timeout never expire because
the element timeout extension is not allocated given that
nf_msecs_to_jiffies64() returns 0. Round up this timeout to HZ/10 to let
them time out.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 481ee78e77bc..0fb8f8f1ef66 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4586,6 +4586,9 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 	if (ms >= max)
 		return -ERANGE;
 
+	if (ms < HZ/10)
+		ms = HZ/10;
+
 	ms *= NSEC_PER_MSEC;
 	*result = nsecs_to_jiffies64(ms);
 	return 0;
-- 
2.30.2

