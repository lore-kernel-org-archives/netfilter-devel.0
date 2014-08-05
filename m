From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [nf-next 2/2] netfilter: Resolve missing-field-initializers warnings
Date: Tue,  5 Aug 2014 04:56:22 -0700
Message-ID: <1407239782-14078-2-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1407239782-14078-1-git-send-email-jeffrey.t.kirsher@intel.com>
Cc: Mark Rustad <mark.d.rustad@intel.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9342 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbaHEL40 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:56:26 -0400
In-Reply-To: <1407239782-14078-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve missing-field-initializers warnings by avoiding
implicit inner field initializer. The more explicit form
avoids the warning.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 net/netfilter/xt_set.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 80c2e2d..2671cc2 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -43,7 +43,7 @@ struct ip_set_adt_opt n = {		\
 	.dim = d,			\
 	.flags = fs,			\
 	.cmdflags = cfs,		\
-	.ext.timeout = t,		\
+	.ext = { .timeout = t }		\
 }
 
 /* Revision 0 interface: backward compatible with netfilter/iptables */
-- 
1.9.3

