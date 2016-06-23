From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_meta: set skb->nf_trace
 appropriately
Date: Thu, 23 Jun 2016 13:07:33 +0200
Message-ID: <20160623110733.GA2615@salvia>
References: <1465388410-23879-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56140 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbcFWLHh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 07:07:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6774C10079E
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:07:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 56FBE9EBA1
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:07:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 28F426447D
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:07:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465388410-23879-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 08, 2016 at 08:20:10PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> When user add a nft rule to set nftrace to zero, for example:
>   # nft add rule ip filter input nftrace set 0
> 
> We should set nf_trace to zero also.

This is indeed fixing something broken, so I'm applying this to nf.

Thanks.
