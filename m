From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 5/8] extensions: libxt_ipcomp: add range support in translation
Date: Fri,  7 Oct 2016 19:08:53 +0800
Message-ID: <1475838536-28816-6-git-send-email-zlpnobody@163.com>
References: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:59349 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752225AbcJGLKC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 07:10:02 -0400
In-Reply-To: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

When translate to nft rules, ipcompspi range is not supported, so:
  # iptables-translate -A OUTPUT -m ipcomp --ipcompspi 1:2
  nft add rule ip filter OUTPUT comp cpi 1 counter

  # iptables-translate -A OUTPUT -m ipcomp ! --ipcompspi 3:30
  nft add rule ip filter OUTPUT comp cpi != 3 counter

Apply this patch:
  # iptables-translate -A OUTPUT -m ipcomp --ipcompspi 1:2
  nft add rule ip filter OUTPUT comp cpi 1-2 counter

  # iptables-translate -A OUTPUT -m ipcomp ! --ipcompspi 3:30
  nft add rule ip filter OUTPUT comp cpi != 3-30 counter

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_ipcomp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_ipcomp.c b/extensions/libxt_ipcomp.c
index 9f7c0ef..b5c4312 100644
--- a/extensions/libxt_ipcomp.c
+++ b/extensions/libxt_ipcomp.c
@@ -101,9 +101,13 @@ static int comp_xlate(struct xt_xlate *xl,
 	const struct xt_ipcomp *compinfo =
 		(struct xt_ipcomp *)params->match->data;
 
-	xt_xlate_add(xl, "comp cpi %s%u",
-		     (compinfo->invflags & XT_IPCOMP_INV_SPI) ? "!= " : "",
-		     compinfo->spis[0]);
+	xt_xlate_add(xl, "comp cpi %s",
+		     compinfo->invflags & XT_IPCOMP_INV_SPI ? "!= " : "");
+	if (compinfo->spis[0] != compinfo->spis[1])
+		xt_xlate_add(xl, "%u-%u", compinfo->spis[0],
+			     compinfo->spis[1]);
+	else
+		xt_xlate_add(xl, "%u", compinfo->spis[0]);
 
 	return 1;
 }
-- 
2.5.5


