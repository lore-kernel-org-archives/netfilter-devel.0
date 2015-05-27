From: Florian Westphal <fw@strlen.de>
Subject: Re: REOUTE target extenstion
Date: Wed, 27 May 2015 14:11:30 +0200
Message-ID: <20150527121130.GC23992@breakpoint.cc>
References: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com>
 <20150527113746.GA23992@breakpoint.cc>
 <CADgXnSPkPdWdWcNJHrcv_9=oomWsE4ZfzoJZ3CTur=zW5LY9cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	jengelh@inai.de
To: Eddi Linder <eddi@guardicore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45734 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbbE0MLc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 08:11:32 -0400
Content-Disposition: inline
In-Reply-To: <CADgXnSPkPdWdWcNJHrcv_9=oomWsE4ZfzoJZ3CTur=zW5LY9cQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eddi Linder <eddi@guardicore.com> wrote:
> TEE is for gateway redirections, which means the redirected device has
> to have a configured ip, and to be reachable from the original device.

That makes no sense to me.  The to-redirected device always needs to be
reachable.  And iptables is L3 and upwards, so I don't see how 1:1
copying would fit in here.

> Florian, I didn't find the mirror target in the mainline documentation or code.

I meant the tc action:

tc filter add dev eth0 parent $parent protocol ip [..] action mirred egress redirect dev eth1

> REROUTE redirection is more like the openvswitch output action, copy
> the packet from one device into another.

Sorry, but my feeling is that this is out of scope for iptables.
