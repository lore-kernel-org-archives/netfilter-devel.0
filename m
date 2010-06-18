From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] netfilter: xt_IDLETIMER needs kdev_t.h
Date: Fri, 18 Jun 2010 15:34:55 -0700
Message-ID: <20100618153455.dd33948b.randy.dunlap@oracle.com>
References: <20100618145443.77b7f8df.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	netdev <netdev@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:57867 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab0FRWgx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:36:53 -0400
In-Reply-To: <20100618145443.77b7f8df.sfr@canb.auug.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file to fix build error:
net/netfilter/xt_IDLETIMER.c:276: error: implicit declaration of function 'MKDEV'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/netfilter/xt_IDLETIMER.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100618.orig/net/netfilter/xt_IDLETIMER.c
+++ linux-next-20100618/net/netfilter/xt_IDLETIMER.c
@@ -36,6 +36,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_IDLETIMER.h>
+#include <linux/kdev_t.h>
 #include <linux/kobject.h>
 #include <linux/workqueue.h>
 #include <linux/sysfs.h>
