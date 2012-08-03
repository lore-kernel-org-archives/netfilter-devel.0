From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-restore: move code to add_param_to_argv,
 cleanup (fix gcc-4.7)
Date: Fri, 3 Aug 2012 11:15:35 +0200
Message-ID: <20120803091535.GA11165@1984>
References: <1343039903-7230-1-git-send-email-pablo@netfilter.org>
 <1343042946.2626.10727.camel@edumazet-glaptop>
 <1343043528.2626.10755.camel@edumazet-glaptop>
 <20120730013707.GA2350@1984>
 <alpine.LNX.2.01.1208022136350.21772@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53475 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab2HCJPi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:15:38 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1208022136350.21772@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 02, 2012 at 09:37:10PM +0200, Jan Engelhardt wrote:
> 
> On Monday 2012-07-30 03:37, Pablo Neira Ayuso wrote:
> >> > // here param_buffer[1024] is lost, so any var pointing 
> >> > // to it can mess stack
> >> > 
> >> > previous gcc were probably not so aggressive.
> >> 
> >> Oh well, add_argv() does a strdup(), so iptables code seems fine.
> >
> >I thought the same, but one contributor has put some on light on this.
> >
> >I'm going to revert the patch that I applied to fix this and apply
> >the one that comes with this email instead.
> >
> >It contains a simple description of the problem, I think it's good for
> >the record (distro maintainers will likely google for this).
> 
> Your code cleanup, by moving the code into a separate function,
> is however still desired :)

OK, it's back:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commit;h=23a98b56935c42ef460020e37a9ff8006eee58e2
