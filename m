From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iptables] nfnl_osf: use the right nfnetlink lib
Date: Fri, 29 Mar 2013 15:21:10 +0100
Message-ID: <1364566870-7320-1-git-send-email-nicolas.dichtel@6wind.com>
Cc: netfilter-devel@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:39627 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab3C2OVZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:21:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the user specify libnfnetlink_LIBS during the configure, we must use it.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 utils/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/Makefile.am b/utils/Makefile.am
index f1bbfc5..8a85396 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -7,4 +7,4 @@ AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include \
 sbin_PROGRAMS = nfnl_osf
 pkgdata_DATA = pf.os
 
-nfnl_osf_LDADD = -lnfnetlink
+nfnl_osf_LDADD = ${libnfnetlink_LIBS} -lnfnetlink
-- 
1.8.0.1

