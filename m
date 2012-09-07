From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] extensions: libxt_addrtype: fix type in help
 message
Date: Fri, 7 Sep 2012 18:20:33 +0200
Message-ID: <20120907162033.GA14331@1984>
References: <1347008119-3835-1-git-send-email-pablo@netfilter.org>
 <1347008119-3835-2-git-send-email-pablo@netfilter.org>
 <alpine.LNX.2.01.1209071659560.25370@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43981 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab2IGQUm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:20:42 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209071659560.25370@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 07, 2012 at 05:01:44PM +0200, Jan Engelhardt wrote:
> On Friday 2012-09-07 10:55, pablo@netfilter.org wrote:
> 
> >From: Pablo Neira Ayuso <pablo@netfilter.org>
> >
> > --limit-iface-out          Match only on the packet's incoming device
> >
> >Note that it says "incoming" when it should say "outcoming"
> 
> Language time! :D
> 
> "to come" is a movement of an object into the direction of the 
> speaker/viewer, "to go" the movement away from the viewer.
> 
> Since iptables as a viewer is always at the machine, "outgoing" is the 
> term that is being used.

You're quite right :-), while writing it with my Spanish mind it
looked to me quite reasonable.

Of course, it's not. I'll fix it, thanks Jan.
