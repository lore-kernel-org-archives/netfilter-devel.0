Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E5267B07
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 11:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768822656; cv=none; b=eHe9mn9X/YkLY74VQr+rUUhHco5tMwHapUMLejTeSpJbLCCfkjnYiI43Kn+PJKcTdGIc6VJ09+H5Q4b+CYd5/+v4A0gKrvsKvGdaTA89M2CYkqObSxF0yNW3/c+YVvYfzYet6hN2g3ByVUiE8vLjJclKL1Ek5xSZt+FN9biRNME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768822656; c=relaxed/simple;
	bh=nzVXgQAQoyL8xiY7gW4NenIUPxls1oLfHqIsY8KhDhI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SDBX3znqccY1tTJSVkkfVIAtxrAInvSky0Vyx6BtIr2JCK6Gk0wYvIyuJEvkJ1+81v+KaNI9dqgRfeV++ofOWvjjkgGWQxbXZrn2Cn7HndWu3KLJ32t1OCZMvXGrhE30Kv4xU5n3+CVIzYdDAx56tRzPKwWcxiwvix2uaRDTIRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A3C41603A1; Mon, 19 Jan 2026 12:37:32 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: edumazet@google.com,
	Florian Westphal <fw@strlen.de>,
	sungzii <sungzii@pm.me>
Subject: [PATCH nf] netfilter: xt_tcpmss: check remaining length before reading optlen
Date: Mon, 19 Jan 2026 12:37:15 +0100
Message-ID: <20260119113719.30363-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Quoting reporter:
  In net/netfilter/xt_tcpmss.c (lines 53-68), the TCP option parser reads
 op[i+1] directly without validating the remaining option length.

  If the last byte of the option field is not EOL/NOP (0/1), the code attempts
  to index op[i+1]. In the case where i + 1 == optlen, this causes an
  out-of-bounds read, accessing memory past the optlen boundary
  (either reading beyond the stack buffer _opt or the
  following payload).

Reported-by: sungzii <sungzii@pm.me>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_tcpmss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 37704ab01799..0d32d4841cb3 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -61,7 +61,7 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			return (mssval >= info->mss_min &&
 				mssval <= info->mss_max) ^ info->invert;
 		}
-		if (op[i] < 2)
+		if (op[i] < 2 || i == optlen - 1)
 			i++;
 		else
 			i += op[i+1] ? : 1;
-- 
2.52.0

