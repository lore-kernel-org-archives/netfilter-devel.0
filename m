From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: inclusion of xt_SYSRQ
Date: Thu, 12 Jul 2012 22:35:41 +0200
Message-ID: <20120712203541.GB9927@breakpoint.cc>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
 <1341964350-13809-5-git-send-email-jengelh@inai.de>
 <20120712154957.GE18793@1984>
 <alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr>
 <20120712202608.GA9927@breakpoint.cc>
 <alpine.LNX.2.01.1207122229420.27546@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49097 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756290Ab2GLUfm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 16:35:42 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1207122229420.27546@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> >Jan Engelhardt <jengelh@inai.de> wrote:
> >> David Miller has stated his opinion already last year, and he's
> >> for the Netfilter variant:
> >> http://markmail.org/message/d7kpczdbtpcxwli6
> >
> >We now have udp encap support also for ipv6, so this could now
> >be solved outside of netfilter without impacting the ability to
> >filter sysreq packets.
> 
> How does xt_SYSRQ inhibit filtering sysrq packets?

Not at all.  But the last 'do it outside of netfilter' approaches
suffered from that.  With encap sockets this should no longer be a
problem.
