From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] netfilter: x_tables: fix unconditional helper
Date: Thu, 24 Mar 2016 21:18:39 +0100
Message-ID: <20160324201839.GD1937@salvia>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
 <1458666173-24318-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57594 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcCXUSs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2016 16:18:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5497B80B0F
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0110B11FE9E
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1E52CD1928
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:45 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458666173-24318-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 06:02:52PM +0100, Florian Westphal wrote:
> Ben Hawkes says:
> 
>  In the mark_source_chains function (net/ipv4/netfilter/ip_tables.c) it
>  is possible for a user-supplied ipt_entry structure to have a large
>  next_offset field. This field is not bounds checked prior to writing a
>  counter value at the supplied offset.
> 
> Problem is that mark_source_chains should not have been called --
> the rule doesn't have a next entry, so its supposed to return
> an absolute verdict of either ACCEPT or DROP.
> 
> However, the function conditional() doesn't work as the name implies.
> It only checks that the rule is using wildcard address matching.
> 
> However, an unconditional rule must also not be using any matches
> (no -m args).
> 
> The underflow validator only checked the addresses, therefore
> passing the 'unconditional absolute verdict' test, while
> mark_source_chains also tested for presence of matches, and thus
> proceeeded to the next (not-existent) rule.
> 
> Unify this so that all the callers have same idea of 'unconditional rule'.

Applied, thanks Florian.

