From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: inclusion of xt_SYSRQ
Date: Thu, 12 Jul 2012 22:26:08 +0200
Message-ID: <20120712202608.GA9927@breakpoint.cc>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
 <1341964350-13809-5-git-send-email-jengelh@inai.de>
 <20120712154957.GE18793@1984>
 <alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49070 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754931Ab2GLU0M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 16:26:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Thursday 2012-07-12 17:49, Pablo Neira Ayuso wrote:
> >> +config NETFILTER_XT_TARGET_SYSRQ
> >> +	tristate '"SYSRQ" - remote sysrq invocation'
> >
> >I guess this is useful for user, eg. you can reboot your crashed
> >system from your office in case that cheap comodity hardware without
> >remote management tools (eg. HP's ILO or Dell's iDRAC).
> >
> >Still, I think that including this in Netfilter is a bit of abuse
> >since this is out of the scope of providing some firewalling feature.
> 
> David Miller has stated his opinion already last year, and he's
> for the Netfilter variant:
> http://markmail.org/message/d7kpczdbtpcxwli6

We now have udp encap support also for ipv6, so this could now
be solved outside of netfilter without impacting the ability to
filter sysreq packets.
