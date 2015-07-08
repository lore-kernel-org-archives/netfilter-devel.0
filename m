From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH -next 3/4] netfilter: xtables: don't save/restore jumpstack
 offset
Date: Wed, 8 Jul 2015 23:47:57 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1507082344210.16936@nerf40.vanv.qr>
References: <1436390139-4405-1-git-send-email-fw@strlen.de> <1436390139-4405-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:45443 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbbGHVr7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 17:47:59 -0400
In-Reply-To: <1436390139-4405-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-07-08 23:15, Florian Westphal wrote:

>The jump stack overflow tests are no longer needed as well -- since 
>->stacksize is the largest call depth we cannot exceed it.

The tests were once added for the rare case that a cloned packet hits 
another TEE. Can we be sure they are no longer needed?


>+	/* No TEE support for arptables, so no need to switch to alternate
>+	 * stack.  All targets that reenter must return absolte verdicts.

absolute

>+	/* Switch to alternate jumpstack if we're being invoked via TEE.
>+	 * The problem is that TEE issues XT_CONTINUE verdict on original
>+	 * skb so we must not clobber the jumpstack.

Well that is not really a problem but a feature :)

>+	/* Switch to alternate jumpstack if we're being invoked via TEE.
>+	 * The problem is that TEE issues XT_CONTINUE verdict on original
>+	 * skb so we must not clobber the jumpstack.
>+	 *
>+	 * For recursion via REJECT or SYNPROXY the stack will be clobbered
>+	 * but its no problem since absolute verdict is issued by these.

"but it is no problem"
