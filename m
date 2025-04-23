Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91BC28DEEB
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 15:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421455; cv=none; b=WJgMOGRU0GNTepBrWgNEFwCvUEXoImKJdRf3gkOEfjV7MCbipORzT/jIsBbvJRT2RHlAhYwNGZQJD/TQ25Q/iPwBHNIsPp3+SsJnkzRh66RDueYW9vfNYsDH8u+sMUNtnh5gHFU0nB6JrgCLqAqe2kBkXfbxUaLiZxH2TSomlMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421455; c=relaxed/simple;
	bh=pWRg8BAIyr2c4WxhDHeVeGC69OEa0FAG0SGhve8CH+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hAEljvifXDHVKcLWytMP3aRg3YC3MRSjVjBVODo0tns/pKFtMlEmotlc8+yYwcLXt2Q6kquHjF5g7K8m7lYh94gGYG34u3eQlgaAGQOlkvtWPoRJ2x1DH7IZPrt/Ya96g8zzP6n2ELpcP4tU73YyfRErAK8ZjtIw5Z8HQZPyKqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u7bqt-0003dZ-4J; Wed, 23 Apr 2025 17:17:31 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: fix debug splat when dumping pipapo avx2 set
Date: Wed, 23 Apr 2025 17:16:59 +0200
Message-ID: <20250423151702.17438-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

debug kernel gives:
 ------------[ cut here ]------------
 WARNING: CPU: 3 PID: 265 at net/netfilter/nf_tables_api.c:4780 nf_tables_fill_set_info+0x1c8/0x210 [nf_tables]
 Modules linked in: nf_tables
 CPU: 3 UID: 0 PID: 265 Comm: nft Not tainted 6.15.0-rc2-virtme #1 PREEMPT(full)
 Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 RIP: 0010:nf_tables_fill_set_info+0x1c8/0x210 [nf_tables]

... because '%ps' includes the module name, so the output
string is truncated.

Fixes: 2cbe307c6046 ("netfilter: nf_tables: export set count and backend name to userspace")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 You can squash merge this if you prefer.

 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 90e73462fb69..b28f6730e26d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4769,7 +4769,7 @@ static noinline_for_stack int
 nf_tables_fill_set_info(struct sk_buff *skb, const struct nft_set *set)
 {
 	unsigned int nelems;
-	char str[32];
+	char str[40];
 	int ret;
 
 	ret = snprintf(str, sizeof(str), "%ps", set->ops);
-- 
2.49.0

