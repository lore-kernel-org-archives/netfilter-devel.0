From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] netfilter: xtables: inclusion of xt_SYSRQ
Date: Fri, 13 Jul 2012 11:16:48 +0200
Message-ID: <20120713091648.GA20796@1984>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
 <1341964350-13809-5-git-send-email-jengelh@inai.de>
 <20120712154957.GE18793@1984>
 <alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33740 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab2GMJQv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jul 2012 05:16:51 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 12, 2012 at 06:25:13PM +0200, Jan Engelhardt wrote:
> 
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

I think that affirmation is true in the context of:

[PATCH]: Add Network Sysrq Support

but not sure it's out of it.

He probably prefered the Netfilter option because, comparing it to the
Netfilter approach, it looks nicer. Well, just look at all those sysfs
and proc interfaces he was proposing for that approach (it seems quite
ugly to me).

You can use the udp_encap hook (that Florian mentioned) plus some
genetlink interface and little user-space tool to make it out of
netfilter. Most of the xt_SYSRQ code can be reused and the genetlink
interface plus one library can be added with little extra work.

@David: just to put you into context. Jan is proposing to merge
xt_SYSRQ into mainstream, we are discussing if it would be better to
make it out of it (so people do not depend on the firewalling
utilities to get it working) based on a different proposal described
above.
