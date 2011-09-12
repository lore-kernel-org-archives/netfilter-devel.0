From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/9] iptables-save: remove binary dumping dead code
Date: Mon, 12 Sep 2011 20:52:06 +0200
Message-ID: <20110912185206.GA4018@1984>
References: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
 <1315755359-7012-3-git-send-email-jengelh@medozas.de>
 <20110912093253.GC2194@1984>
 <alpine.LNX.2.01.1109121244070.32300@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52054 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab1ILSwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:52:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1109121244070.32300@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2011 at 12:48:36PM +0200, Jan Engelhardt wrote:
> 
> On Monday 2011-09-12 11:32, Pablo Neira Ayuso wrote:
> >>  
> >> -static int show_binary = 0, show_counters = 0;
> >> +static int show_counters = 0;
> >>  
> >>  static const struct option options[] = {
> >> -	{.name = "binary",   .has_arg = false, .val = 'b'},
> >
> >Please, better something less agressive like displaying a message
> >telling "-b option was never implemented, ignoring it".
> >
> >So if anyone, for some strange reason, is using it, their scripts will
> >not break.
> >
> >I know this may sound a bit nitpicking but I think it's good to make
> >sure that we don't break anything.
> 
> I think we are not talking about the same thing. If you run
> `iptables-save -b`, the program will exit with status 1 without
> printing anything related to rules. (Outputs "binary NYI" which, if
> you happen to be able to resolve the acronym, expands to "not yet
> implemented")
> 
> How would that be any better than getting "invalid option: -B"?

Well, we'll hit that anyway once you remove -b option.

> It is "NYI". Given the issues with binary representations that have
> come up within the last 10 years so far, I doubt that we have a
> reason to offer wanting to dump the packed ruleset right now.

Fair enough, go ahead.
