Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B593FE4C;
	Wed, 21 Feb 2024 11:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708515013; cv=none; b=RuIWYc9zJiKgnlkqbFN6P8O/g2i+NW+Fk8hn9jTcNZN3v0qd0EoHV+45HwxaPooDN5vHvsWqE3kqf9/gZwIyZgRhPpQZLBqeDBufS6Ip9L8USowEU7Xpu3sSPiZZeaOpv+BLgiRHC7AtnpuUuxau1ktg0xCIJUobuFWQyxsDe4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708515013; c=relaxed/simple;
	bh=5JmIV5KBRuiB5rVg6Pzp94kME3zztS/rsXK7adO/Nzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaAR+LMDQpH/lg41hZZe9EEBV7UvnA22t+YPBFsqTNDnvIdaG/Wh3CSNqNGZtTL+TrFeDwZNXq3LuPpjXBAyn1+BZjK8Nq1SPBAbQfP7naOCLEjRdHOl8YnJauIoelWR35ThHy41GYxFoo2SKu2THWOMUQ5ixGyyfvY95n/OF9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rcknJ-0003sP-VK; Wed, 21 Feb 2024 12:29:45 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 03/12] netfilter: nf_log: validate nf_logger_find_get()
Date: Wed, 21 Feb 2024 12:26:05 +0100
Message-ID: <20240221112637.5396-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240221112637.5396-1-fw@strlen.de>
References: <20240221112637.5396-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

Sanitize nf_logger_find_get() input parameters, no caller in the tree
passes invalid values.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.43.0

