From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: x_tables: deal with bogus nextoffset values
Date: Thu, 10 Mar 2016 17:22:08 +0100
Message-ID: <20160310162208.GB1526@salvia>
References: <1457571362-25441-1-git-send-email-fw@strlen.de>
 <20160310141231.GA13006@salvia>
 <CABWXx8Ek1PbyPnw6mcsGeMTseDUpqW3deFipOBMmS-+7EszZeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Ben Hawkes <hawkes@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51270 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbcCJQWN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 11:22:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B3824114819
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 17:22:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9FC22DA385
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 17:22:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7AF85DA394
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 17:22:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CABWXx8Ek1PbyPnw6mcsGeMTseDUpqW3deFipOBMmS-+7EszZeA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 06:41:24AM -0800, Ben Hawkes wrote:
> On Thu, Mar 10, 2016 at 6:12 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Mar 10, 2016 at 01:56:02AM +0100, Florian Westphal wrote:
> >> Ben Hawkes says:
> >>
> >>  In the mark_source_chains function (net/ipv4/netfilter/ip_tables.c) it
> >>  is possible for a user-supplied ipt_entry structure to have a large
> >>  next_offset field. This field is not bounds checked prior to writing a
> >>  counter value at the supplied offset.
> >>
> >> Problem is that xt_entry_foreach() macro stops iterating once e->next_offset
> >> is out of bounds, assuming this is the last entry.
> >>
> >> With malformed data thats not necessarily the case so we can
> >> write outside of allocated area later as we might not have walked the
> >> entire blob.
> >>
> >> Fix this by simplifying mark_source_chains -- it already has to check
> >> if nextoff is in range to catch invalid jumps, so just do the check
> >> when we move to a next entry as well.
> >
> > Thanks for posting this patch so fast Florian.
> >
> > It's sad that Ben didn't even take the time to reach the people that
> > the MAINTAINERS file shows in first place *sigh*.
> 
> What is sad about this precisely? I followed the documented process
> for reporting a security issue
> (https://www.kernel.org/doc/Documentation/SecurityBugs), and then
> followed the instructions I received from this list. If you have a
> problem with my actions, then I suggest you raise this with
> security@kernel.org.

As in any kind of bug, you should Cc maintainers of the corresponding
subsystem. In that sense, as in any kind of bug, it would be nice if
you participate testing and reviewing the patches that were posted to
address the bug.

Thanks.
