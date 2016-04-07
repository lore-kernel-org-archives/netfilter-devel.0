From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: evaluate: Show error for fanout without balance
Date: Thu, 7 Apr 2016 19:13:17 +0200
Message-ID: <20160407171317.GA6225@salvia>
References: <20160407093640.GA5034@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58115 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbcDGRNW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:13:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C1559C9ED3
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:13:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B230EDA386
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:13:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9C9D9DA386
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:13:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160407093640.GA5034@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 07, 2016 at 03:06:40PM +0530, Shivani Bhardwaj wrote:
> The idea of fanout option is to improve the performance by indexing CPU
> ID to map packets to the queues. This is used for load balancing.
> Fanout option is not required when there is a single queue specified.
> 
> According to iptables, queue balance should be specified in order to use
> fanout, following that, throw an error in nftables if the range of
> queues for load balancing is not specified with the fanout option.

Curious, how does iptables behave when you pass fanout and a single
queue?

Could you also include how the nft error output looks like after your
patch in your description?

Thanks.
