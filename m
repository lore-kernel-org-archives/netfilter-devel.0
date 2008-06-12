From: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Subject: Re: conntrackd [ERROR] commit: Invalid argument
Date: Fri, 13 Jun 2008 01:22:15 +0200
Message-ID: <200806130122.16216.sabelka@iue.tuwien.ac.at>
References: <e1aa27e00806090621r3fa83ac0s7bb89d903de3be41@mail.gmail.com> <200806111915.32313.sabelka@iue.tuwien.ac.at> <48513A30.1020908@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Marco Barbero <marco.barbero@gmail.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mr2-n.kom.tuwien.ac.at ([128.130.2.110]:4624 "EHLO
	mr.tuwien.ac.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760313AbYFLXW1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:22:27 -0400
In-Reply-To: <48513A30.1020908@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 12 June 2008 17:01:04 Pablo Neira Ayuso wrote:
> >> Yes, very strange. ctnetlink is hitting ENOMEM, ie. it cannot create the
> >> conntrack because there's no memory available. As for now ctnetlink is
> >> allocating conntracks via nf_conntrack_alloc() which uses GFP_ATOMIC.
> >> I'll send you a patch to relax this to check if that is the problem,
> >> otherwise I think that the error is bogus.
> >>
> >>> Jun 11 15:40:07 fw1b conntrack-tools[13383]: committing external cache
> >>> Jun 11 15:40:07 fw1b conntrack-tools[13383]: commit-create: Cannot
> >>> allocate memory
> >>> Jun 11 15:40:07 fw1b conntrack-tools[13383]: Committed 33 new entries
> >>> Jun 11 15:40:07 fw1b conntrack-tools[13383]: 25 entries ignored,
> >>> already exist Jun 11 15:40:07 fw1b conntrack-tools[13383]: 1 entries
> >>> can't be committed
> >>
> >> What it is really annoying is the fact that you hit error with that less
> >> entries. I cannot reproduce that in my testbed with ~20000 entries. Are
> >> you using some kind of embedded device? Architecture?
> >
> > This is a vitual machine (i686) which 128 MByte of memory running under
> > VMware server 1.0.4.
>
> Would you try this patch?

Pablo,

I tried to debug this a bit and added some printk()s in the 
ctnetlink_create_conntrack() function to find out where the ENOMEM is coming 
from:
So, now I see that nf_conntrack_alloc() is not returning this error, but it is 
coming from a couple of lines below in the same function:

        helper = nf_ct_helper_find_get(rtuple);
        if (helper) {
                help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
                if (help == NULL) {
                        nf_ct_helper_put(helper);
                        err = -ENOMEM;
                        goto err;
                }

There, nf_ct_helper_ext_add() returns NULL, which causes ENOMEM to be 
returned.

I didn't debug this further because I'm rather lost in the code. But maybe 
this gives you some hint what's wrong.

-Rainer
