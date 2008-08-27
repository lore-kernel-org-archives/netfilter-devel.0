From: "James King" <t.james.king@gmail.com>
Subject: [PATCH] xtables-addons: ipset: fix semaphore.h include
Date: Tue, 26 Aug 2008 18:12:33 -0700
Message-ID: <38bcb3ec0808261812g423694eds19463f14c4997de2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Jan Engelhardt" <jengelh@medozas.de>,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.228]:5038 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYH0BMe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2008 21:12:34 -0400
Received: by qb-out-0506.google.com with SMTP id f11so144564qba.17
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2008 18:12:33 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[PATCH] xtables-addons: ipset: fix semaphore.h include

As of 2351ec533ed0dd56052ab96988d2161d5ecc8ed9 semaphore.h was moved
from asm/ to linux/, which breaks building of ipset.  Add compat
glue to ip_set.c to fix building on 2.6.27+

Signed-off-by: James King <t.james.king@gmail.com>
---
 extensions/ipset/ip_set.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/extensions/ipset/ip_set.c b/extensions/ipset/ip_set.c
index 8be9274..21e62bd 100644
--- a/extensions/ipset/ip_set.c
+++ b/extensions/ipset/ip_set.c
@@ -24,7 +24,11 @@
 #include <linux/errno.h>
 #include <asm/uaccess.h>
 #include <asm/bitops.h>
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
 #include <asm/semaphore.h>
+#else
+#include <linux/semaphore.h>
+#endif
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>

-- 
1.5.5.1
