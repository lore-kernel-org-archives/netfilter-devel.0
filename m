From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_compat: check match/targetinfo attr size
Date: Thu, 10 Mar 2016 17:47:10 +0100
Message-ID: <20160310164710.GA3267@salvia>
References: <1457478261-11247-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55693 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbcCJQrQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 11:47:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 433F9114F41
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 17:47:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D5F90DA383
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 17:47:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 80197DA386
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 17:47:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1457478261-11247-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 09, 2016 at 12:04:21AM +0100, Florian Westphal wrote:
> We copy accoring to ->target|matchsize, so check that the netlink attribute
> (which can include padding and might be larger) contains enough data.
> 
> Reported-by: Julia Lawall <Julia.Lawall@lip6.fr>
> Signed-off-by: Florian Westphal <fw@strlen.de>

I think xt_check_match() and xt_check_target() already validate this
for us.
