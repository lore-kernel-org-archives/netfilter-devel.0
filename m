From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xtables-addons: ipset: fix semaphore.h include
Date: Thu, 28 Aug 2008 20:24:54 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808282023080.3581@fbirervta.pbzchgretzou.qr>
References: <38bcb3ec0808261812g423694eds19463f14c4997de2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	James King <t.james.king@gmail.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46538 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYH2AY4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Aug 2008 20:24:56 -0400
In-Reply-To: <38bcb3ec0808261812g423694eds19463f14c4997de2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2008-08-26 21:12, James King wrote:

>As of 2351ec533ed0dd56052ab96988d2161d5ecc8ed9 semaphore.h was moved
>from asm/ to linux/, which breaks building of ipset.  Add compat
>glue to ip_set.c to fix building on 2.6.27+

Ok, applied.
Let Jozsef know of this one so he can integrate it too.

>diff --git a/extensions/ipset/ip_set.c b/extensions/ipset/ip_set.c
>index 8be9274..21e62bd 100644
>--- a/extensions/ipset/ip_set.c
>+++ b/extensions/ipset/ip_set.c
>@@ -24,7 +24,11 @@
> #include <linux/errno.h>
> #include <asm/uaccess.h>
> #include <asm/bitops.h>
>+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
> #include <asm/semaphore.h>
>+#else
>+#include <linux/semaphore.h>
>+#endif
> #include <linux/spinlock.h>
> #include <linux/vmalloc.h>
>
>-- 
>1.5.5.1
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

