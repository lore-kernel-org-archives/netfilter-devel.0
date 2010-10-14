From: Nick Bowler <nbowler@elliptictech.com>
Subject: [PATCH] netfilter: Install missing ebtables headers for userspace.
Date: Thu, 14 Oct 2010 16:56:34 -0400
Message-ID: <1287089794-15997-1-git-send-email-nbowler@elliptictech.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:49133 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752038Ab0JNU4h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:56:37 -0400
Received: from nbowler by mail.ellipticsemi.com with local (Exim 4.72)
	(envelope-from <nbowler@elliptictech.com>)
	id 1P6Uqo-0004Ac-Ju
	for netfilter-devel@vger.kernel.org; Thu, 14 Oct 2010 16:56:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The ebt_ip6.h and ebt_nflog.h headers are not not known to Kbuild and
therefore not installed by make headers_install.  Fix that up.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 include/linux/netfilter_bridge/Kbuild |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_bridge/Kbuild b/include/linux/netfilter_bridge/Kbuild
index d4d7867..e48f1a3 100644
--- a/include/linux/netfilter_bridge/Kbuild
+++ b/include/linux/netfilter_bridge/Kbuild
@@ -3,11 +3,13 @@ header-y += ebt_among.h
 header-y += ebt_arp.h
 header-y += ebt_arpreply.h
 header-y += ebt_ip.h
+header-y += ebt_ip6.h
 header-y += ebt_limit.h
 header-y += ebt_log.h
 header-y += ebt_mark_m.h
 header-y += ebt_mark_t.h
 header-y += ebt_nat.h
+header-y += ebt_nflog.h
 header-y += ebt_pkttype.h
 header-y += ebt_redirect.h
 header-y += ebt_stp.h
-- 
1.7.2.2

