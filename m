From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: xt_time: add support to ignore day
 transition
Date: Mon, 17 Sep 2012 12:32:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209171230550.21480@nerf07.vanv.qr>
References: <1347877389-15728-1-git-send-email-fw@strlen.de> <1347877389-15728-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:36909 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab2IQKdB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:33:01 -0400
In-Reply-To: <1347877389-15728-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2012-09-17 12:23, Florian Westphal wrote:

>Currently, if you want to do something like:
>"match Monday, starting 23:00, for two hours"
>You need two rules, one for Mon 23:00 to 0:00 and one for Tue 0:00-1:00.
>The rule
>--weekdays Mo --timestart 23:00  --timestop 01:00
>looks correct, but it will first match on monday from midnight to 1 a.m.
>and then again for another hour from 23:00 onwards.

I think stop < start should be outright rejected in the user interface 
because of its confusion potential. Given what it currently does, it 
does not seem like it was ever desired.
