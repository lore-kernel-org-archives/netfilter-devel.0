From: Florian Westphal <fw@strlen.de>
Subject: Re: NOTRACK removal breaks working configurations
Date: Thu, 20 Dec 2012 13:28:39 +0100
Message-ID: <20121220122839.GD17461@breakpoint.cc>
References: <20121220102358.GC17461@breakpoint.cc>
 <20121220115451.GA31838@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Cong Wang <xiyou.wangcong@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33923 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956Ab2LTM2k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:28:40 -0500
Content-Disposition: inline
In-Reply-To: <20121220115451.GA31838@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > commit 965505015beccc4ec900798070165875b8e8dccf
> > Author: Cong Wang <xiyou.wangcong@gmail.com>
> > Subject: netfilter: remove xt_NOTRACK
> > 
> > It breaks working netfilter configurations.
> > At the very least, NOTRACK should have printk'd
> > 
> > BIG FAT REMOVAL WARNING
> > 
> > for a year or so.  Which it didn't do.
> 
> This was announced in Documentation/feature-removal-schedule.txt and
> the aliasing infrastructure was added to iptables

I know.

> it was agressive since I think not many users have checked that file /
> they may no have upgrade iptables to latest.

Right.

> Can you see any problem with the patch attached?

No.  The patch works.
[   21.870092] xt_CT: netfilter: NOTRACK target is deprecated, use CT instead or upgrade iptables

Even better than a revert.

Thanks,
Florian
