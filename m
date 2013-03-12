From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH] xtables-addons: build against 3.8.y
Date: Tue, 12 Mar 2013 09:18:12 +0100
Message-ID: <20130312081812.GB11508@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61635 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab3CLISQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:18:16 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jan,

I see that xtables-addons 1.47.1 do not build against kernel 3.8.2,
because of ipv6_find_hdr() having moved to <net/ipv6.h>.  And this
include is missing from xt_SYSREQ.c:

extensions/xt_SYSRQ.c: In function 'sysrq_tg6':
extensions/xt_SYSRQ.c:251: xt_SYSRQ.c:251: error: implicit declaration \
	of function 'ipv6_find_ hdr'

The attached patch fixes that.

Please check.

 /Holger


--G4iJoqBmSsgzjUCe
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="0001-ipv6_find_hdr-has-moved.diff"

xt_SYSRQ: include <net/ipv6.h>

ipv6_find_hdr() has moved to <net/ipv6.h> since kernel
v3.8.  It is necessary to include this header as well.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: xtables-addons-1.47.1/extensions/xt_SYSRQ.c
===================================================================
--- xtables-addons-1.47.1.orig/extensions/xt_SYSRQ.c
+++ xtables-addons-1.47.1/extensions/xt_SYSRQ.c
@@ -24,6 +24,7 @@
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
 #include <net/ip.h>
+#include <net/ipv6.h>
 #include "compat_xtables.h"
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19) && \

--G4iJoqBmSsgzjUCe--
