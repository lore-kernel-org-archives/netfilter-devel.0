From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/04]: xt_iprange: add missing
Date: Wed,  6 Feb 2008 14:34:04 +0100 (MET)
Message-ID: <20080206133404.15303.14349.sendpatchset@localhost.localdomain>
References: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54115 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763535AbYBFNeF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:34:05 -0500
In-Reply-To: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_iprange: add missing #include

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 51bab7aa121dc46efef9f227543f7ae207b2c5f2
tree e99439b75b3d005c6d901fdaeb7e4378cf4af87f
parent a9fd46af7dc44d5d5c0e547b82c73ce01024e74d
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 04 Feb 2008 21:51:45 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 06 Feb 2008 02:51:15 +0100

 net/netfilter/xt_iprange.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 97715e3..4f984dc 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -13,6 +13,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_iprange.h>
 #include <linux/netfilter_ipv4/ipt_iprange.h>
 
 static bool
