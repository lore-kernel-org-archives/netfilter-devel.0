From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ipv6: nf_defrag: fix NULL deref panic
Date: Wed, 9 Dec 2015 14:27:02 +0100
Message-ID: <20151209132702.GA29572@salvia>
References: <1449614119-5584-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Valdis.Kletnieks@vt.edu
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34005 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbbLIN1H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 08:27:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B12B11324EC
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:27:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9A123DA863
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:27:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CB6E1DA86D
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:27:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449614119-5584-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 08, 2015 at 11:35:19PM +0100, Florian Westphal wrote:
> Valdis reports NULL deref in nf_ct_frag6_gather.
> Problem is bogus use of skb_queue_walk() -- we miss first skb in the list
> since we start with head->next instead of head.
> 
> In case the element we're looking for was head->next we won't find
> a result and then trip over NULL iter.
> 
> (defrag uses plain NULL-terminated list rather than one terminated by
>  head-of-list-pointer, which is what skb_queue_walk expects).

Applied, thanks Florian.
