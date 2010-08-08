From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: newbie: writing custom target, need help with getting it to
 work
Date: Sun, 8 Aug 2010 22:34:15 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008082230200.15133@obet.zrqbmnf.qr>
References: <00fe01cb3737$19358d20$4ba0a760$@com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Yossi Weihs <yw@seafire.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54005 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab0HHUeQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Aug 2010 16:34:16 -0400
In-Reply-To: <00fe01cb3737$19358d20$4ba0a760$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-08-08 22:20, Yossi Weihs wrote:

>I?m seeing dev:TAPPY, which I think means the user space library correctly
>parsed the parameters. Since I manually inserted the module, I know it?s
>there, although I did not see the module initialization kernel info
>message... Any ideas on where to look next? I have attached my target code.

>#include "compat_xtables.h"
>#include "seabatch.h"
>#include "xt_TAP.h"
>
>static unsigned int
>tap_tg4(struct sk_buff **pskb, const struct xt_target_param *par)
>{
...
>	// Time to grab mutex
>	if (down_interruptible(private_info->tap_filter[fidx].lock)) {

Your tap makes for water damage. You must not sleep in Xtables kernel
code, that is, anythiing higher of a class than a spinlock_bh
is a no-no.

>		printk(KERN_CRIT "TAP down_interruptible %s %d\n",__FILE__,__LINE__);
>		return XT_CONTINUE;
>	}
>
>	// snip some code removed
>	
>	// Fall out
>	fallout:
>	// Release Mutex
>	up(private_info->tap_filter[fidx].lock);
>	// done
>	return XT_CONTINUE;
>}
>
