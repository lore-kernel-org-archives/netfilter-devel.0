From: Thomas Graf <tgraf@infradead.org>
Subject: Re: [PATCH] ebtables: Clone xt_AUDIT to ebt_audit to return
 EBT_CONTINUE
Date: Wed, 16 Mar 2011 04:24:58 -0400
Message-ID: <20110316082458.GC26145@canuck.infradead.org>
References: <20110316003307.GB26145@canuck.infradead.org>
 <alpine.LNX.2.01.1103160138160.1189@obet.zrqbmnf.qr>
 <4D804D51.1010205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1CPIZF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:25:05 -0400
Content-Disposition: inline
In-Reply-To: <4D804D51.1010205@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 16, 2011 at 06:40:33AM +0100, Patrick McHardy wrote:
> Am 16.03.2011 01:43, schrieb Jan Engelhardt:
> > On Wednesday 2011-03-16 01:33, Thomas Graf wrote:
> > 
> >> Even though ebtables uses xtables it still requires targets to
> >> return EBT_CONTINUE instead of XT_CONTINUE. This prevented
> >> xt_AUDIT to work as ebt module.
> > 
> > Something that just came to mind is that you could probably do
> > to keep the code at a minimum:
> > 
> > 
> > static unsigned int ebt_audit(struct xt_target_param *par)
> > {
> > 	unsigned int ret = xt_audit_tg(par);
> > 
> > 	if (ret == XT_CONTINUE)
> > 		return EBT_CONTINUE;
> > 	...
> > }

That's a good idea, thanks Jan!

> Seems like a good idea to me. If more modules need this (f.i.
> MARK) we could also consider doing the mapping based on a target
> flag in ebtables itself.
> 
> However please see Dave's mail about net-next, until the merge
> window is over and -rc1 released only bugfixes will be accepted.

I was considering this a bugfix because the module as-is can be
loaded with ebtables, will create audit records but won't allow
for the next rule to drop/reject the packet.

Would you consider Jan's approach a bugfix or should I wait?
