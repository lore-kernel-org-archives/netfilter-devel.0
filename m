From: "Jan Beulich" <JBeulich@suse.com>
Subject: [PATCH] xt_log.h: don't use xchg() for simple assignment
Date: Thu, 08 Mar 2012 09:45:44 +0000
Message-ID: <4F588DD8020000780007711C@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: <pablo@netfilter.org>, <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nat28.tlf.novell.com ([130.57.49.28]:63628 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab2CHJo7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-netfilter-devel@vger.kernel.org:3:1>);
	Thu, 8 Mar 2012 04:44:59 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

At least on ia64 the (bogus) use of xchg() here results in the compiler
warning about an unused expression result. As only an assignment is
intended here, convert it to such.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 include/net/netfilter/xt_log.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.3-rc6/include/net/netfilter/xt_log.h
+++ 3.3-rc6-netfilter-xt_log-no-xchg/include/net/netfilter/xt_log.h
@@ -47,7 +47,7 @@ static void sb_close(struct sbuff *m)
 	if (likely(m != &emergency))
 		kfree(m);
 	else {
-		xchg(&emergency_ptr, m);
+		emergency_ptr = m;
 		local_bh_enable();
 	}
 }



