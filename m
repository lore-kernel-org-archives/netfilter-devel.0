From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [arptables] rfc: add classify target
Date: Sun, 7 Nov 2010 16:18:34 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
References: <20101107152636.56f62235@caresse>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Frederic Leroy <fredo@starox.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47126 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab0KGPSf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Nov 2010 10:18:35 -0500
In-Reply-To: <20101107152636.56f62235@caresse>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-11-07 15:26, Frederic Leroy wrote:
>
>I wrote a new classify target. Patches for both current linux-stable and
>arptables cvs are joined.
>
>+++ b/net/ipv4/netfilter/arpt_classify.c
>@@ -0,0 +1,41 @@
>+/* module that allows classification of arp packet */
>+#include <linux/module.h>
>+#include <linux/netfilter.h>
>+#include <linux/netfilter/x_tables.h>
>+#include <linux/netfilter_arp/arpt_classify.h>
>+
>+MODULE_LICENSE("GPL");
>+MODULE_AUTHOR("Frederic Leroy <fredo@starox.org>");
>+MODULE_DESCRIPTION("arptables arp classify target");
>+
>+static unsigned int
>+target(struct sk_buff *skb, const struct xt_action_param *par)
>+{
>+	const struct arpt_classify *classify = par->targinfo;
>+
>+	skb->priority=classify->priority;
>+
>+	return XT_CONTINUE;
>+}

Why did you not update xt_CLASSIFY instead?
