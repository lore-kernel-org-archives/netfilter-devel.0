From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/05]: Fix NF_QUEUE_NR() parenthesis
Date: Wed, 27 Feb 2008 14:14:26 +0100 (MET)
Message-ID: <20080227131434.26831.91147.sendpatchset@localhost.localdomain>
References: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53811 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbYB0NO1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:14:27 -0500
In-Reply-To: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Fix NF_QUEUE_NR() parenthesis

Properly add parens around the macro argument. This is not needed by
the kernel but the macro is exported to userspace, so it shouldn't
make any assumptions.

Also use NF_VERDICT_BITS instead of NF_VERDICT_QBTIS for the left-shift
since thats whats logically correct.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 81d9aa76da78b14124638e761a4c0acab3d43508
tree d9ec5a1792894c1068aaf4eaab865a5b6001c939
parent c31b70def66807822dc973e66757507a5fd4c3b6
author Patrick McHardy <kaber@trash.net> Wed, 27 Feb 2008 13:23:58 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 27 Feb 2008 13:23:58 +0100

 include/linux/netfilter.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index b74b615..f0680c2 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -31,7 +31,7 @@
 #define NF_VERDICT_QMASK 0xffff0000
 #define NF_VERDICT_QBITS 16
 
-#define NF_QUEUE_NR(x) (((x << NF_VERDICT_QBITS) & NF_VERDICT_QMASK) | NF_QUEUE)
+#define NF_QUEUE_NR(x) ((((x) << NF_VERDICT_BITS) & NF_VERDICT_QMASK) | NF_QUEUE)
 
 /* only for userspace compatibility */
 #ifndef __KERNEL__
