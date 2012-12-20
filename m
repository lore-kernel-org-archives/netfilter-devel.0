From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NOTRACK removal breaks working configurations
Date: Thu, 20 Dec 2012 14:02:27 +0100
Message-ID: <20121220130227.GA4623@1984>
References: <20121220102358.GC17461@breakpoint.cc>
 <20121220115451.GA31838@1984>
 <20121220122839.GD17461@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Cong Wang <xiyou.wangcong@gmail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42563 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2LTNCb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:02:31 -0500
Content-Disposition: inline
In-Reply-To: <20121220122839.GD17461@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 20, 2012 at 01:28:39PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > commit 965505015beccc4ec900798070165875b8e8dccf
> > > Author: Cong Wang <xiyou.wangcong@gmail.com>
> > > Subject: netfilter: remove xt_NOTRACK
> > > 
> > > It breaks working netfilter configurations.
> > > At the very least, NOTRACK should have printk'd
> > > 
> > > BIG FAT REMOVAL WARNING
> > > 
> > > for a year or so.  Which it didn't do.
> > 
> > This was announced in Documentation/feature-removal-schedule.txt and
> > the aliasing infrastructure was added to iptables
> 
> I know.
> 
> > it was agressive since I think not many users have checked that file /
> > they may no have upgrade iptables to latest.
> 
> Right.
> 
> > Can you see any problem with the patch attached?
> 
> No.  The patch works.
> [   21.870092] xt_CT: netfilter: NOTRACK target is deprecated, use CT instead or upgrade iptables
> 
> Even better than a revert.

Thanks, I'll pass this to David in the next batch and then ask for
-stable submission.
