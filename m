Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BF03AC0D4
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 09:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775726443; cv=none; b=iuEtGOQ/WuSlCTvOTtvuVd/rDaE7E6SPsfbOg/T9LULRzZF2Ti7wT8slY2MT+fRJnG7XTZQb6TyduBYt4zRfH1lPErhLx+eLAFVqZXaNAWingQ9v6bOyc+MPEWRDf62jANo1GTF0gNdqqwj13WaZ3zAhU5ZpLtwAg20vVfUfvlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775726443; c=relaxed/simple;
	bh=XqHxoNgdDCyDwUGeqbCFgqx2ZOrydpbC7b4ossIFUkg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iUyc+mAaGlGFeTnDFkWglpMMnI0UO/pJVdzGDL+gs9BCuhWOgxdHtMNtD61jB66mKa+rkfxDlJ5Y/zB0YdBlvEihsIze2GERDvhsrLc7OBs0VvKsspZ8hViB5JcxtK3iPy91tMZ3BN7x7K4AxMauABpfEquhHETkEPGkMuRbCDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A949460344; Thu, 09 Apr 2026 11:20:29 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: x_physdev: reject empty or not-nul terminated device names
Date: Thu,  9 Apr 2026 11:20:19 +0200
Message-ID: <20260409092022.486-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reject names that lack a \0 character and reject the empty string as
well. iptables allows this but it fails to re-parse iptables-save output
that contain such rules.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_physdev.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 343e65f377d4..1494259fb518 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -107,6 +107,21 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	}
 
+#define X(memb) strnlen(info->memb , sizeof(info->memb)) >= sizeof(info->memb)
+	if (X(physindev))
+		return -ENAMETOOLONG;
+	if (X(physoutdev))
+		return -ENAMETOOLONG;
+	if (X(in_mask))
+		return -ENAMETOOLONG;
+	if (X(out_mask))
+		return -ENAMETOOLONG;
+#undef X
+	if (info->bitmask & XT_PHYSDEV_OP_IN && info->physindev[0] == 0)
+		return -EINVAL;
+	if (info->bitmask & XT_PHYSDEV_OP_OUT && info->physoutdev[0] == 0)
+		return -EINVAL;
+
 	if (!brnf_probed) {
 		brnf_probed = true;
 		request_module("br_netfilter");
-- 
2.52.0

