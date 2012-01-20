From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: xtables2 a8, netlink interface
Date: Fri, 20 Jan 2012 08:50:55 -0800
Message-ID: <20120120085055.0957b16a@nehalam.linuxnetplumber.net>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
	<20120119165629.2f7c8112@nehalam.linuxnetplumber.net>
	<alpine.LNX.2.01.1201200931340.29049@frira.zrqbmnf.qr>
	<CAA93jw40yyZHiK7wbCxOp-CkRvXNT6s0gnmi3gh8MgE62Xu9zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Dave Taht <dave.taht@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:39458 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab2ATQu6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:50:58 -0500
In-Reply-To: <CAA93jw40yyZHiK7wbCxOp-CkRvXNT6s0gnmi3gh8MgE62Xu9zg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 20 Jan 2012 10:23:54 +0100
Dave Taht <dave.taht@gmail.com> wrote:

> On Fri, Jan 20, 2012 at 9:33 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
> > On Friday 2012-01-20 01:56, Stephen Hemminger wrote:
> >>>
> >>> So here is the first set of patches implementing part of the xt2 core
> >>> and nfnl interface. Please review, I am sure you will have something
> >>> to say :)
> >>>
> >>> The userspace part is at git://dev.medozas.de/libnetfilter_xtables,
> >>> the xtnl-test program compiled as part of the default make target
> >>> gives access to the kernel functions implemented by the patches.
> >>
> >>Does it allow for watching for iptables changes (notifications),
> >>similar to what is done for link, address, and qdisc changes?
> >
> > It certainly does not look like a big deal to write it, so yes, I
> > had that on my list of things to add. (Even though I could not come up
> > with a usecase for that feature myself yet.)
> 
> My use case would be for a routing daemon to detect when nat was present on
> an interface, so as to not advertise invalid routes.

Our use case is to control an external dataplane.
