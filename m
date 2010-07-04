From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt2 table core
Date: Sun, 4 Jul 2010 20:00:37 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007041952340.25655@obet.zrqbmnf.qr>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de> <201007020532.12596.simonl@parknet.dk> <alpine.LSU.2.01.1007041440130.12356@obet.zrqbmnf.qr> <201007041922.39846.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Simon Lodal <simonl@parknet.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44535 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137Ab0GDSAi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Jul 2010 14:00:38 -0400
In-Reply-To: <201007041922.39846.simonl@parknet.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-07-04 19:22, Simon Lodal wrote:
>
>I think it is a question of granularity. At what level do we use lists, vs. 
>blobs? It seems to be a flexibility/performance tradeoff. I have hundreds of 
>kpps 24/7 and rarely reload rules, so I am strictly in the performance camp 
>:-)
>
>Chain granularity that we have now is maybe too big.

Xt1 has table-level granularity. And the problem with blobs is that
you first need to find a memory area large enough to fit it in - which
is why vmalloc is already in use today.

>Match/target granularity 
>that you use is apparently too small. Also, is the ability to edit matches and 
>targets really useful? Perhaps rule granularity (keep each rule as one blob) 
>is right.

I'll try.
