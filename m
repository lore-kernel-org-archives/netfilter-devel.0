From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: inclusion of xt_SYSRQ
Date: Thu, 12 Jul 2012 22:29:51 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207122229420.27546@frira.zrqbmnf.qr>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de> <1341964350-13809-5-git-send-email-jengelh@inai.de> <20120712154957.GE18793@1984> <alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr> <20120712202608.GA9927@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:43511 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab2GLU3x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 16:29:53 -0400
In-Reply-To: <20120712202608.GA9927@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-07-12 22:26, Florian Westphal wrote:

>Jan Engelhardt <jengelh@inai.de> wrote:
>> On Thursday 2012-07-12 17:49, Pablo Neira Ayuso wrote:
>> >> +config NETFILTER_XT_TARGET_SYSRQ
>> >> +	tristate '"SYSRQ" - remote sysrq invocation'
>> >
>> >I guess this is useful for user, eg. you can reboot your crashed
>> >system from your office in case that cheap comodity hardware without
>> >remote management tools (eg. HP's ILO or Dell's iDRAC).
>> >
>> >Still, I think that including this in Netfilter is a bit of abuse
>> >since this is out of the scope of providing some firewalling feature.
>> 
>> David Miller has stated his opinion already last year, and he's
>> for the Netfilter variant:
>> http://markmail.org/message/d7kpczdbtpcxwli6
>
>We now have udp encap support also for ipv6, so this could now
>be solved outside of netfilter without impacting the ability to
>filter sysreq packets.

How does xt_SYSRQ inhibit filtering sysrq packets?
