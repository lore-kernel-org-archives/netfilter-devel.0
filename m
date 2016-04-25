From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: conntrack: prepare for hashtable
 merge, take 1
Date: Mon, 25 Apr 2016 14:26:53 +0200
Message-ID: <20160425122653.GA3523@salvia>
References: <1460989021-10780-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60853 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbcDYM3A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 08:29:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 21E13C124F
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:28:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 10D63FAB51
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:28:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CFE04FAB53
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:28:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460989021-10780-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 18, 2016 at 04:16:58PM +0200, Florian Westphal wrote:
> This small series prepares for upcoming merge of the per-namespace hash tables
> into a single table (or rater, three tables
> -- conntrack hash, expect hash and nat bysrc hash).
> 
> Arguments for merging it:
> - We stop wasting (assuming default size) 250k backing store per namespace
> - net namespace is just another part of the connection id, much like
>   ip addresses or conntrack zones -- no need to treat it specially
> - allows to get rid of the per-netns conntrack slab as well
> 
> These patches are first preparations.
> We replace per-netns conntrack has generation seqcount by single one.
> 
> While at it, this replaces the method used to obtain the hash seed
> by the (nowadays) more common get_random_once().

Series applied, thanks Florian.
