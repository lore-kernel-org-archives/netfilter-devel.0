From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: libxt_connlabel: fix crash when connlabel.conf is empty
Date: Sat, 16 Jul 2016 19:39:53 +0800
Message-ID: <1468669193-28298-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:35858 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbcGPLke (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jul 2016 07:40:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

When connlabel.conf is empty, nfct_labelmap_new will return NULL and
set errno to 0. So we will miss to check this situation, and cause NULL
deference in nfct_labelmap_get_bit.

Input the following commands will reproduce this crash:
  # echo > /etc/xtables/connlabel.conf
  # iptables -A INPUT -m connlabel --label abc
  Segmentation fault (core dumped)

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_connlabel.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
index 96b9aec..7e4ff26 100644
--- a/extensions/libxt_connlabel.c
+++ b/extensions/libxt_connlabel.c
@@ -38,9 +38,16 @@ static void connlabel_open(void)
 		return;
 
 	map = nfct_labelmap_new(NULL);
-	if (!map && errno)
-		xtables_error(RESOURCE_PROBLEM, "cannot open connlabel.conf: %s\n",
-			strerror(errno));
+	if (map != NULL)
+		return;
+
+	if (errno) {
+		xtables_error(RESOURCE_PROBLEM,
+			"cannot open connlabel.conf: %s", strerror(errno));
+	} else {
+		xtables_error(RESOURCE_PROBLEM,
+			"cannot parse label, maybe valid label map is empty");
+	}
 }
 
 static void connlabel_mt_parse(struct xt_option_call *cb)
-- 
2.5.5


