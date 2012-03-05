From: akpm@linux-foundation.org
Subject: [patch 1/1] net/netfilter/nfnetlink_acct.c: use linux/atomic.h
Date: Mon, 05 Mar 2012 15:12:35 -0800
Message-ID: <20120305231236.00A45A02EB@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
	davem@davemloft.net, pablo@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44785 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab2CEXmn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:42:43 -0500
Received: by faaa19 with SMTP id a19so168564faa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Mar 2012 15:42:42 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: net/netfilter/nfnetlink_acct.c: use linux/atomic.h

There's no known problem here, but this is one of only two non-arch files
in the kernel which use asm/atomic.h instead of linux/atomic.h.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nfnetlink_acct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/netfilter/nfnetlink_acct.c~net-netfilter-nfnetlink_acctc-use-linux-atomich net/netfilter/nfnetlink_acct.c
--- a/net/netfilter/nfnetlink_acct.c~net-netfilter-nfnetlink_acctc-use-linux-atomich
+++ a/net/netfilter/nfnetlink_acct.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
+#include <linux/atomic.h>
 #include <linux/netlink.h>
 #include <linux/rculist.h>
 #include <linux/slab.h>
@@ -17,7 +18,6 @@
 #include <linux/errno.h>
 #include <net/netlink.h>
 #include <net/sock.h>
-#include <asm/atomic.h>
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
_
