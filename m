From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: x_tables: deal with bogus nextoffset values
Date: Thu, 10 Mar 2016 15:12:31 +0100
Message-ID: <20160310141231.GA13006@salvia>
References: <1457571362-25441-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, hawkes@google.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51439 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbcCJOMj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 09:12:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8FE02C1077
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 15:12:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7EE94DA380
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 15:12:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 883FEDA38A
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 15:12:34 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1457571362-25441-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 01:56:02AM +0100, Florian Westphal wrote:
> Ben Hawkes says:
> 
>  In the mark_source_chains function (net/ipv4/netfilter/ip_tables.c) it
>  is possible for a user-supplied ipt_entry structure to have a large
>  next_offset field. This field is not bounds checked prior to writing a
>  counter value at the supplied offset.
> 
> Problem is that xt_entry_foreach() macro stops iterating once e->next_offset
> is out of bounds, assuming this is the last entry.
> 
> With malformed data thats not necessarily the case so we can
> write outside of allocated area later as we might not have walked the
> entire blob.
> 
> Fix this by simplifying mark_source_chains -- it already has to check
> if nextoff is in range to catch invalid jumps, so just do the check
> when we move to a next entry as well.

Thanks for posting this patch so fast Florian.

It's sad that Ben didn't even take the time to reach the people that
the MAINTAINERS file shows in first place *sigh*.

I'll place this in nf-next together with remaining pending fixes, it
seems we'll have 4.5 just after this -rc7 so I don't think we'll get
there in time for this.

I'll pass this to -stable once this hits master, these patches apply
cleanly to every kernel starting 3.2.

