From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Tue, 14 Feb 2012 00:05:43 +0100
Message-ID: <20120213230543.GA23839@1984>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
 <20120210111801.GA9827@1984>
 <CAFntDkzUvtyKZ1in3tKE4jUyhL5C4p3HmMSCGhMVORxxqJEGGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Darren Willis <djw@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38821 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab2BMXGB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Feb 2012 18:06:01 -0500
Content-Disposition: inline
In-Reply-To: <CAFntDkzUvtyKZ1in3tKE4jUyhL5C4p3HmMSCGhMVORxxqJEGGA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 13, 2012 at 01:07:18PM +0900, Darren Willis wrote:
> Hi Pablo,
> 
> On Fri, Feb 10, 2012 at 20:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > why not just adding the rule that allows udp traffic for this?
> 
> Distros don't seem to want to (see the bug I linked where some red hat
> people have decided a module is the way to go). Possibly people are
> concerned that such a firewall rule leaves a port open on the local
> link permanently (and possibly with an /sbin/dhclient binary, or
> similar, listening on it).
> DHCPv4 seems to get away with it because, IIRC, it uses raw sockets
> and bypasses netfilter completely. So it's still open, but people
> don't tend to think/know about it (this isn't really a good thing...)

I see.

> > I still don't see the need for this extra module if you can get it
> > done with iptables itself.
> 
> I think it's nice to firewall things as much as is feasible, and this
> particular case isn't really complex at all. All this module does (and
> all that needs doing) is lets through the first reply to the right
> port, and after that normal connection tracking takes care of it.
> 
> Possibly in the future conntrack should have some kind of extendable
> broadcast/multicast helpers module that can set up simple helpers like
> this for various different protocols (mDNS, etc)

Yes, we need some appropriate broadcast/multicast tracking. I don't
like the idea of using the expectation infrastructure for this, but
well, it's what we have by now.
