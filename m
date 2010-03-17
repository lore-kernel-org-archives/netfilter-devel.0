From: wzt.wzt@gmail.com
Subject: [PATCH] Netfilter: Remove unused headers in net/netfilter/nfnetlink.c
Date: Wed, 17 Mar 2010 21:35:02 +0800
Message-ID: <20100317133502.GB2696@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48707 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0CQFgK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 01:36:10 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove unused headers in net/netfilter/nfnetlink.c

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 net/netfilter/nfnetlink.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 8eb0cc2..0794f9a 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -18,12 +18,9 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/kernel.h>
-#include <linux/major.h>
-#include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
 #include <linux/net.h>
-#include <linux/fcntl.h>
 #include <linux/skbuff.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
-- 
1.6.5.3

