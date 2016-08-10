From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: Add size check on u8 nft_exthdr
 attributes
Date: Wed, 10 Aug 2016 13:00:20 +0200
Message-ID: <20160810110019.GA32364@sonyv>
References: <20160809184614.GA8947@sonyv>
 <20160810105745.GA4466@salvia>
 <20160810105838.GA4490@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38658 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935772AbcHJT62 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:58:28 -0400
Received: by mail-wm0-f48.google.com with SMTP id o80so126849067wme.1
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:58:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160810105838.GA4490@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 12:58:38PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 10, 2016 at 12:57:45PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Aug 09, 2016 at 08:46:16PM +0200, Laura Garcia Liebana wrote:
> > > Fix the direct assignment of offset and length attributes included in
> > > nft_exthdr structure from u32 data to u8.
> > 
> > Applied to my nf tree, I just made a minor edition on this patch.
> 
> It would be good to search for similar issues in other existing
> expressions, BTW. Let me know if you can take care of it. Thanks.

Sure, count on it.

