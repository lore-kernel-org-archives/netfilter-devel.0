From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: How to access conntrack connection expiration in a netfilter
 module?
Date: Tue, 2 Oct 2012 20:17:47 +0200
Message-ID: <20121002181747.GB2397@1984>
References: <506A084E.5060505@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47503 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab2JBSRz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:17:55 -0400
Content-Disposition: inline
In-Reply-To: <506A084E.5060505@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 01, 2012 at 10:17:02PM +0100, Ed W wrote:
> Hi, I'm trying to update the opendpi-netfilter module to work with
> more recent kernels and the ntop ndpi fork of the code (now that
> opendpi seems to have gone away)
> 
> The netfilter module registers a conntrack notifier in order to
> release resources once a conntrack is destroyed
> https://github.com/ewildgoose/ndpi-netfilter/blob/master/src/main.c
> This is not possible though, if you also want to have conntrack
> events through netlink... ( NF_CT_NETLINK grabs the conntrack
> notifier first)
> 
> Now I have read the history on why this is the case, but what are
> the obvious workarounds to this situation?  Can we extend the
> conntrack connection with custom properties? Anything better than
> simply scanning my flows occasionally and comparing with the
> conntrack list to see if they have gone away?

We used to have notifier call chains to deliver in-kernel
nofitications to events. However, since it was overkill for just one
single client (ctnetlink), we removed it and use a single hook
function.

The workaround is to dig into the history, find that code and forward
port it.

But I have to warn you that I won't take that patch into mainstream
since there's only one single client in the official Linux kernel
code, and external clients like that ndpi thing do not justify such
change. Sorry.
