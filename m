From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: Add size check on u8 nft_exthdr
 attributes
Date: Wed, 10 Aug 2016 12:58:38 +0200
Message-ID: <20160810105838.GA4490@salvia>
References: <20160809184614.GA8947@sonyv>
 <20160810105745.GA4466@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47912 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbcHJSFV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:05:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1D781186AC6
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:58:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0F963FC61A
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:58:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DAAB1100A59
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:58:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160810105745.GA4466@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 12:57:45PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 09, 2016 at 08:46:16PM +0200, Laura Garcia Liebana wrote:
> > Fix the direct assignment of offset and length attributes included in
> > nft_exthdr structure from u32 data to u8.
> 
> Applied to my nf tree, I just made a minor edition on this patch.

It would be good to search for similar issues in other existing
expressions, BTW. Let me know if you can take care of it. Thanks.
