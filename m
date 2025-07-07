Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05BD219A6B
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2025 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751920376; cv=none; b=Svml9sIOPxkKqoO0ycSavZTBftNGaphrctl8gb2DvUjdGBmmk1jrQVFizipemNvheqN8zIvw6UOIiw3rwO/wfc9Amlrmv36rO48KkRNYsp/v9bSP/oKOUxl3Aa+6FdDlSQlO09EUUs74RljLGQwVwK11EBZNq4iAdFvd/hKSIqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751920376; c=relaxed/simple;
	bh=JZXdQ73xR7uOEqFHmL92LW5dUJc0oC47Dwwnv1MWYsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fBIu2HYEi0jij1eyARBrceDN7Dmot6u+I06HgcAj8ZT8a1fWJ48W/zd+HbSnKUwRL7SFSA3yClgWjoxgFBD0hQFoUpz3F4nNCV4LfNdf7IdZ+Z1FWCAOTeeBo1aybh+WA/5COSmlLOhxa8jjxOsAwh2T/XFZAdrggdvnDCkUfoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 84673604EE; Mon,  7 Jul 2025 22:32:52 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: hide clash bit from userspace
Date: Mon,  7 Jul 2025 22:32:44 +0200
Message-ID: <20250707203247.25155-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its a kernel implementation detail, at least at this time:

We can later decide to revert this patch if there is a compelling
reason, but then we should also remove the ifdef that prevents exposure
of ip_conntrack_status enum IPS_NAT_CLASH value in the uapi header.

Clash entries are not included in dumps (true for both old /proc
and ctnetlink) either.  So for now exlude the clash bit when dumping.

Fixes: 7e5c6aa67e6f ("netfilter: nf_tables: add packets conntrack state to debug trace info")
Link: https://lore.kernel.org/netfilter-devel/aGwf3dCggwBlRKKC@strlen.de/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index ae3fe87195ab..a88abae5a9de 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -127,6 +127,9 @@ static int nf_trace_fill_ct_info(struct sk_buff *nlskb,
 		if (nla_put_be32(nlskb, NFTA_TRACE_CT_ID, (__force __be32)id))
 			return -1;
 
+		/* Kernel implementation detail, withhold this from userspace for now */
+		status &= ~IPS_NAT_CLASH;
+
 		if (status && nla_put_be32(nlskb, NFTA_TRACE_CT_STATUS, htonl(status)))
 			return -1;
 	}
-- 
2.49.0

