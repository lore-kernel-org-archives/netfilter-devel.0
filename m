From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] Reserve nfnetlink subsys ids.
Date: Thu, 11 Jun 2009 13:36:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906111334090.28605@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:56037 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761585AbZFKLgO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:36:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

A tiny patch to add nfnetlink subsys ids for nftables and ipset. :-)

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/nfnetlink.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index c600083..e0f2ab0 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -46,7 +46,9 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_CTNETLINK_EXP	2
 #define NFNL_SUBSYS_QUEUE		3
 #define NFNL_SUBSYS_ULOG		4
-#define NFNL_SUBSYS_COUNT		5
+#define NFNL_SUBSYS_NFTABLES		5
+#define NFNL_SUBSYS_IPSET		6
+#define NFNL_SUBSYS_COUNT		7
 
 #ifdef __KERNEL__
 
-- 
1.5.4.3

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
