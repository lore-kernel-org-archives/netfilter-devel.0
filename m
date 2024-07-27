Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE6936B17
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116218; cv=none; b=tC4dSltaskOFqjbD81igjDnHREHDwRxN8esHv9WdUTNmFH+d7DKUtueuHYxgO49slA38NvSiUAQ3ADMlRRq55e9t0UUYdVDHdVkeoTfpBd8xkcUbvvfUSXBRi7ax1Q2iFRn29Wi9e1sNqxhLI1r/XyJb5fQs7A8iYQKWFSVSYP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116218; c=relaxed/simple;
	bh=cGilONYv+a4QUx4EKmcd9QYBhPlgb6h68d6N1wJ3baE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah2dD8KO2C1wsnCfYLOUbMLfPygYgp94gCqhJcfMdbTR+5ltDf9+64S5wkV2r1QlK2HGiu2bZOwsoaHcQhKmXCeNV2lf4+l8rRhzfQ4ktJmBRO9BsjezKuSGvhILeggKSSfAnlq8RKOBnpZqLTi5zFNZPs1Z/tr13k/RqF+RF4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZFUPC4pa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZFUPC4pa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aKhifz/0GM1mF1iUMvT9SibPemxnYK1uUlykbcZUWQA=; b=ZFUPC4paz7BVqfL9l/3jYuzXe4
	39ZLKED7TArr2Jui6jq0VwJ9uKhz+ay+ykdQvBznZTyx5SU65uaGVJxo9o3HCUZDOTb8jgvXfXCBr
	yjol6koi8u00XQJN8Kc36vmP6DX24y0cl9RvxFit+4trYXv6lOaOH0LMSXuoVRMsIUOFm8U9T63vF
	LBEU9bFJArBsNb+oepKsmmMeSTOy0UV7RBq9wOkg+h+n/ZKyLDHSkDVVH/q9A6U3BwvbMmTVG3SUG
	xfhHSPg9L6p7Z9xhH1egp0j+y5qImmYhwnIVHNqVbQj/a9hPeJiO03CMhULFZcIjMic6+rAF1Q/iW
	+n9w5Vow==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp5z-000000002Ub-15CQ
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/14] extensions: conntrack: Use the right callbacks
Date: Sat, 27 Jul 2024 23:36:38 +0200
Message-ID: <20240727213648.28761-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These version-agnostic conntrack match aliases emulating the 'state'
extension introduced by commit 0d70163162589 ("libxt_state: replace as
an alias to xt_conntrack") had incompatible print and save callbacks
assigned. These callbacks expected struct xt_state_info in match->data
which is incompatible to any of the actual xt_conntrack_mtinfo* structs
used.

Fixes: b28d4dcc9f555 ("iptables: state match incompatibilty across versions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_conntrack.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index ffbc7467bbf2e..ccbf731de7c4d 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1502,8 +1502,8 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 		.help          = state_help,
-		.print         = state_print,
-		.save          = state_save,
+		.print         = conntrack1_mt4_print,
+		.save          = conntrack1_mt4_save,
 		.x6_parse      = state_ct1_parse,
 		.x6_options    = state_opts,
 	},
@@ -1517,8 +1517,8 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
 		.help          = state_help,
-		.print         = state_print,
-		.save          = state_save,
+		.print         = conntrack2_mt_print,
+		.save          = conntrack2_mt_save,
 		.x6_parse      = state_ct23_parse,
 		.x6_options    = state_opts,
 	},
@@ -1532,8 +1532,8 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
 		.help          = state_help,
-		.print         = state_print,
-		.save          = state_save,
+		.print         = conntrack3_mt_print,
+		.save          = conntrack3_mt_save,
 		.x6_parse      = state_ct23_parse,
 		.x6_options    = state_opts,
 		.xlate         = state_xlate,
-- 
2.43.0

