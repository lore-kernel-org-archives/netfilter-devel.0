From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [stable-3.7 00/14] netfilter stable fixes for 3.7
Date: Fri, 1 Feb 2013 17:39:15 +0100
Message-ID: <20130201163915.GA17407@kroah.com>
References: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
 <20130201123436.GA31102@kroah.com>
 <20130201162556.GA4908@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, davem@davemloft.net,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51389 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115Ab3BAQhU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:37:20 -0500
Content-Disposition: inline
In-Reply-To: <20130201162556.GA4908@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 01, 2013 at 05:25:57PM +0100, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> On Fri, Feb 01, 2013 at 01:34:36PM +0100, Greg KH wrote:
> > On Mon, Jan 28, 2013 at 08:31:19PM +0100, pablo@netfilter.org wrote:
> > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > 
> > > This patchset contain netfilter stable fixes for 3.7, original
> > > commits (in no particular order) are:
> > > 
> > > 0c36b48 netfilter: nfnetlink_log: fix mac address for 6in4 tunnels
> > > e035edd netfilter: nfnetlink_log: fix possible compilation issue due to missing include
> > > 665e205 netfilter: xt_recent: fix namespace destroy path
> > > 2727de7 netfilter: xt_recent: avoid high order page allocations
> > > 5b76c49 netfilter: x_tables: print correct hook names for ARP
> > > 4fe198e netfilter: ipset: Fix range bug in hash:ip,port,net
> > 
> > This patch didn't apply as a straight 'git cherrypick', so I didn't take
> > it.  You also didn't send it, so something is odd here.
> 
> My fault, sorry, that slipped through the list but it should be this
> instead:
> 
> 6bbc7f3 netfilter: xt_CT: fix unset return value if conntrack zone are disabled

That commit id doesn't match up with any git commit id that I can find
in Linus's tree.  Are you sure you git it right?

> http://patchwork.ozlabs.org/patch/216343/
> 
> I send it to you as patch 11/14.
> 
> I can resend it if that makes things easier.

Please do, along with the correct git commit id for the patch.

thanks,

greg k-h
