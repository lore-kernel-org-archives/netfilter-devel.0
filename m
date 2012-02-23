From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Thu, 23 Feb 2012 16:46:46 +0100
Message-ID: <20120223154646.GA4790@1984>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20120221145234.GB25826@1984>
 <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
 <20120223101250.GA3547@1984>
 <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49073 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab2BWPqw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 10:46:52 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 23, 2012 at 01:43:06PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> On Thu, 23 Feb 2012, Pablo Neira Ayuso wrote:
> 
> > On Tue, Feb 21, 2012 at 04:06:59PM +0100, Jozsef Kadlecsik wrote:
> > > Or do I miss something else here?
> > 
> > I just noticed one problem.
> > 
> > With your approach, we may lose race if one packet inserts same conntrack
> > entry while we're adding one conntrack. Thus resulting in two conntracks
> > with the same tuples in the table.
> 
> Yes, you're right, that race condition is possible.
>  
> > One possible solution would be to check if it already exists before
> > adding it to the list, but this will add too many extra cycles for
> > each conntrack that is added via ctnetlink.
> 
> Actually, netfilter for normal conntrack entries does the same in 
> __nf_conntrack_confirm. So entries added via ctnetlink would not be 
> penalized if the same checking were added to ctnetlink_create_conntrack
> in the locked region. Shall I send a patch over the previous one?

Yes, please.
