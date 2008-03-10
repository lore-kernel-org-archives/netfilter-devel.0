From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/09]: nfnetlink: fix ifdef in nfnetlink_compat.h
Date: Mon, 10 Mar 2008 19:26:14 +0100 (MET)
Message-ID: <20080310182616.20404.61195.sendpatchset@localhost.localdomain>
References: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34255 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYCJS0P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:26:15 -0400
In-Reply-To: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink: fix ifdef in nfnetlink_compat.h

Use __KERNEL__ instead of __KERNEL to make sure the headers are not
usable by the kernel.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a0866e6699bd8bd0f5016eaf8a194c0f4dfd5f7e
tree 6794b755e7e2fbc0e9318fd6086f0065cc2b1577
parent ac840248700f1675ae55fe629dd7bd0a5eb17c4f
author Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 17:50:41 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 17:50:41 +0100

 include/linux/netfilter/nfnetlink_compat.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_compat.h b/include/linux/netfilter/nfnetlink_compat.h
index 02a42d8..e145176 100644
--- a/include/linux/netfilter/nfnetlink_compat.h
+++ b/include/linux/netfilter/nfnetlink_compat.h
@@ -1,6 +1,6 @@
 #ifndef _NFNETLINK_COMPAT_H
 #define _NFNETLINK_COMPAT_H
-#ifndef __KERNEL
+#ifndef __KERNEL__
 /* Old nfnetlink macros for userspace */
 
 /* nfnetlink groups: Up to 32 maximum */
