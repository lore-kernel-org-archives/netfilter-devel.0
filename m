From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iptables v2] nfnl_osf: use the right nfnetlink lib
Date: Wed,  3 Apr 2013 11:21:02 +0200
Message-ID: <1364980862-17696-1-git-send-email-nicolas.dichtel@6wind.com>
References: <alpine.LNX.2.01.1304030415450.14642@nerf07.vanv.qr>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: jengelh@inai.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:43934 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761029Ab3DCJVI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:21:08 -0400
In-Reply-To: <alpine.LNX.2.01.1304030415450.14642@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the user specify libnfnetlink_LIBS during the configure, we must use it.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

v2: remove duplicate -lnfnetlink

 utils/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/Makefile.am b/utils/Makefile.am
index f1bbfc5..66f5c5c 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -7,4 +7,4 @@ AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include \
 sbin_PROGRAMS = nfnl_osf
 pkgdata_DATA = pf.os
 
-nfnl_osf_LDADD = -lnfnetlink
+nfnl_osf_LDADD = ${libnfnetlink_LIBS}
-- 
1.8.0.1

