From: Loganaden Velvindron <logan@hackers.mu>
Subject: Re: [PATCH] nf-next: x_tables: Replace kmalloc(s*n) with
 kmalloc_array(n,s)
Date: Fri, 12 Aug 2016 11:12:06 +0400
Message-ID: <20160812071204.GA16394@void>
References: <20160810141146.GA22890@void>
 <20160811231352.GA4972@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout04.yourhostingaccount.com ([65.254.254.70]:48738 "EHLO
	walmailout04.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbcHLHm6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 03:42:58 -0400
Received: from mailscan05.yourhostingaccount.com ([10.1.15.5] helo=walmailscan05.yourhostingaccount.com)
	by walmailout04.yourhostingaccount.com with esmtp (Exim)
	id 1bY6dg-0000TM-PH
	for netfilter-devel@vger.kernel.org; Fri, 12 Aug 2016 03:12:20 -0400
Received: from [10.114.3.31] (helo=walimpout11)
	by walmailscan05.yourhostingaccount.com with esmtp (Exim)
	id 1bY6dg-0008EJ-L3
	for netfilter-devel@vger.kernel.org; Fri, 12 Aug 2016 03:12:20 -0400
Content-Disposition: inline
In-Reply-To: <20160811231352.GA4972@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 01:13:52AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 10, 2016 at 06:11:51PM +0400, Loganaden Velvindron wrote:
> > It is easier to check that the calculation doesn't wrap or return a smaller
> > allocation.
> 
> Could you review the netfilter tree in search for similar kmalloc()
> invocation that can be replaced? I could at least find one more at
> quick glace.
> 
> Thanks.

Yes. I am currently working on that !

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
