Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751E7442138
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jul 2026 10:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783332111; cv=none; b=tf+faQZU++fHvAVN4dhxmmHJdF6VP3Wm2eN4hIdZHpemmmPj83UOkpbBM3lKtvtRDWDFd8wTOJf1MscHnIcFAxcZFdvyEder07YRcrKhvgXLfK31tB5NQ1YO8aZLCtc6xaZJjXlrhnXNyY7qkPKPB/K+EU0OweUIHZH+JCAIGVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783332111; c=relaxed/simple;
	bh=7DvHgNZqry6QqFCCWoPIFpsi9BDqf+matqNl5vUSMAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D+yGv27uQphiQkL1xcAddKiFfbRHKM4U631WuGWpBDYJwAozjToR4+yDJOVn9QyedN+gWQZIhA28jTjvcZkkamYgnbvQwEBtwK6kUsSTYx0n6R18su16uvDrDuZ5btmSgu2gS6g71nu4FRDaCIGc7ZWcGS2GD+626KHw9Hz/qdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4C81E60491; Mon, 06 Jul 2026 12:01:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ebtables: module names must be null-terminated
Date: Mon,  6 Jul 2026 12:01:37 +0200
Message-ID: <20260706100137.32588-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to explicitly check the length, else we may pass non-null
terminated string to request_module().

Fixes: bcf493428840 ("netfilter: ebtables: Fix extension lookup with identical name")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 48187598cdd0..96c9a8f57c87 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -403,6 +403,9 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 	    left - sizeof(struct ebt_entry_match) < m->match_size)
 		return -EINVAL;
 
+	if (strnlen(m->u.name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return -EINVAL;
+
 	match = xt_find_match(NFPROTO_BRIDGE, m->u.name, m->u.revision);
 	if (IS_ERR(match) || match->family != NFPROTO_BRIDGE) {
 		if (!IS_ERR(match))
-- 
2.54.0

