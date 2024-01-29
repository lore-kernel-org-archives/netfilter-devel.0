Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751774CB28
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 19:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706556275; cv=none; b=IA8yWqA52BeYkJMf4U7ggZW8RLIUAsbm2ib6kNozu4GqgNKTmc3J+JnA+jzVVQFGVZ4rTGlGsIPX7vWA2LHvOphncErCbviceu7NDngz9GUHtTp6k6X7X4RPWnfM1SYFGMySkc4Tg6YYept3eg/cbO6JiLNBin1VZN6Hfzjnshw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706556275; c=relaxed/simple;
	bh=faRUgKc4NejNpTO71EtULfGDZ863RXaj5rRl6rBKSac=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M4tMuLLNbhBGb00EFDfc2tb8wpU+C0AQwxBu9tg/PoEjPtGZLHwSH9NFPxGrNSu4VGQYG5yMJpNk8K4CnV5LlwctucBTdMAOKvfOpRbF7ZJHOd3CZBXq7F5wp3AbX0kmjpSDDl4HWC01DZnmr6HG0duy7XSGGnv/dLk+wgpUczE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/2] netfilter: nf_log: validate nf_logger_find_get()
Date: Mon, 29 Jan 2024 20:24:25 +0100
Message-Id: <20240129192425.148310-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240129192425.148310-1-pablo@netfilter.org>
References: <20240129192425.148310-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sanitize nf_logger_find_get() input parameters, no caller in the tree
passes invalid values.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index e0bfeb75766f..370f8231385c 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -156,6 +156,11 @@ int nf_logger_find_get(int pf, enum nf_log_type type)
 	struct nf_logger *logger;
 	int ret = -ENOENT;
 
+	if (pf >= ARRAY_SIZE(loggers))
+		return -EINVAL;
+	if (type >= NF_LOG_TYPE_MAX)
+		return -EINVAL;
+
 	if (pf == NFPROTO_INET) {
 		ret = nf_logger_find_get(NFPROTO_IPV4, type);
 		if (ret < 0)
-- 
2.30.2

