From: Reese Moore <ram@vt.edu>
Subject: [PATCH] net/netfilter/nf_conntrack_pptp.c: Fix comment referring to incorrect RFC.
Date: Wed,  7 Nov 2012 12:05:08 -0500
Message-ID: <1352307908-24733-1-git-send-email-ram@vt.edu>
Cc: netfilter-devel@vger.kernel.org, Reese Moore <ram@vt.edu>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:39040 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2KGRFU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:05:20 -0500
Received: from zidane.cc.vt.edu (zidane.cc.vt.edu [198.82.163.227])
	by lennier.cc.vt.edu (8.13.8/8.13.8) with ESMTP id qA7H2XU3009355
	for <netfilter-devel@vger.kernel.org>; Wed, 7 Nov 2012 12:05:19 -0500
Received: by mail-vb0-f70.google.com with SMTP id fo1so2945864vbb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Nov 2012 09:05:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The header of this file cites to "RFFC2673" which is "Binary Labels in the
Domain Name System". It should refer to "RFC 2637" which is "Point-to-Point
Tunneling Protocol (PPTP)".

This patch corrects the double 'F' and the transposition of the last two
numbers.

Signed-off-by: Reese Moore <ram@vt.edu>
---
 net/netfilter/nf_conntrack_pptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index cc7669e..e6678d2 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -14,7 +14,7 @@
  * Limitations:
  * 	 - We blindly assume that control connections are always
  * 	   established in PNS->PAC direction.  This is a violation
- * 	   of RFFC2673
+ *	   of RFC 2637
  * 	 - We can only support one single call within each session
  * TODO:
  *	 - testing of incoming PPTP calls
-- 
1.8.0

