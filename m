From: Loganaden Velvindron <logan@hackers.mu>
Subject: Re: [PATCH] nf-next: x_tables: Replace kmalloc(s*n) with
 kmalloc_array(n,s)
Date: Fri, 12 Aug 2016 11:19:59 +0400
Message-ID: <20160812071958.GB16394@void>
References: <20160810141146.GA22890@void>
 <20160811231352.GA4972@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from walmailout03.yourhostingaccount.com ([65.254.253.150]:44098
	"EHLO walmailout03.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbcHLHub (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 03:50:31 -0400
Received: from mailscan11.yourhostingaccount.com ([10.1.15.11] helo=walmailscan11.yourhostingaccount.com)
	by walmailout03.yourhostingaccount.com with esmtp (Exim)
	id 1bY6lI-0007Df-GE
	for netfilter-devel@vger.kernel.org; Fri, 12 Aug 2016 03:20:12 -0400
Received: from [10.114.3.32] (helo=walimpout12)
	by walmailscan11.yourhostingaccount.com with esmtp (Exim)
	id 1bY6lI-0002hz-Ea
	for netfilter-devel@vger.kernel.org; Fri, 12 Aug 2016 03:20:12 -0400
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

I saw quite a few, but many have constants. OK with replacing the ones with
constants too ?

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
