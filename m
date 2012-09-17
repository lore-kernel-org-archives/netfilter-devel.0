From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: xt_time: add support to ignore day
 transition
Date: Mon, 17 Sep 2012 13:02:29 +0200
Message-ID: <20120917110229.GB9909@breakpoint.cc>
References: <1347877389-15728-1-git-send-email-fw@strlen.de>
 <1347877389-15728-2-git-send-email-fw@strlen.de>
 <alpine.LNX.2.01.1209171230550.21480@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35510 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693Ab2IQLCb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:02:31 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209171230550.21480@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> >Currently, if you want to do something like:
> >"match Monday, starting 23:00, for two hours"
> >You need two rules, one for Mon 23:00 to 0:00 and one for Tue 0:00-1:00.
> >The rule
> >--weekdays Mo --timestart 23:00  --timestop 01:00
> >looks correct, but it will first match on monday from midnight to 1 a.m.
> >and then again for another hour from 23:00 onwards.
> 
> I think stop < start should be outright rejected in the user interface 
> because of its confusion potential. Given what it currently does, it 
> does not seem like it was ever desired.

No, it works fine the way it is; in fact, the kernel
explicitly tests for stop < start to make things work.

Only when --weekdays is used with a stop < start rule
the behaviour gets weird.
