From: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Subject: Re: conntrackd [ERROR] commit: Invalid argument
Date: Mon, 16 Jun 2008 22:28:16 +0200
Message-ID: <200806162228.17436.sabelka@iue.tuwien.ac.at>
References: <e1aa27e00806090621r3fa83ac0s7bb89d903de3be41@mail.gmail.com> <200806130122.16216.sabelka@iue.tuwien.ac.at> <4855B44B.5030504@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Marco Barbero <marco.barbero@gmail.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mr1-n.kom.tuwien.ac.at ([128.130.2.109]:37305 "EHLO
	mr.tuwien.ac.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753509AbYFPU2k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:28:40 -0400
In-Reply-To: <4855B44B.5030504@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 16 June 2008 02:31:07 Pablo Neira Ayuso wrote:
> Rainer Sabelka wrote:
> > I tried to debug this a bit and added some printk()s in the
> > ctnetlink_create_conntrack() function to find out where the ENOMEM is
> > coming from:
> > So, now I see that nf_conntrack_alloc() is not returning this error, but
> > it is coming from a couple of lines below in the same function:
> >
> >         helper = nf_ct_helper_find_get(rtuple);
> >         if (helper) {
> >                 help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
> >                 if (help == NULL) {
> >                         nf_ct_helper_put(helper);
> >                         err = -ENOMEM;
> >                         goto err;
> >                 }
> >
> > There, nf_ct_helper_ext_add() returns NULL, which causes ENOMEM to be
> > returned.
> >
> > I didn't debug this further because I'm rather lost in the code. But
> > maybe this gives you some hint what's wrong.
>
> I just noticed a bug that may be the reason for EINVAL while injecting
> connections that have a helper. The messages that contained connections
> with helpers were malformed (one attribute was missing). Attached a
> patch to fix this problem in libnetfilter_conntrack (already applied to
> git, so probably it is better if you check out a working copy). With
> regards to ENOMEM, probably we're hitting it because of some malformed
> message.
>
> The other patch is not directly related but it reduces the size of the
> messages that are sent to kernel space to check for the existence of a
> conntrack.
>
> I have put a lot effort on the synchronization protocols in this release
> but it seems that the commit still need one spin. As always, any help
> testing and reporting problems is appreciated.

Thanks Pablo. I've tested your patches but unfortunately I still get "Cannot 
allocate memory" sometimes.

Jun 16 22:24:45 fw1b conntrack-tools[5599]: committing external cache
Jun 16 22:24:45 fw1b conntrack-tools[5599]: commit-create: Cannot allocate 
memory
Jun 16 22:24:45 fw1b conntrack-tools[5599]: Committed 623 new entries
Jun 16 22:24:45 fw1b conntrack-tools[5599]: 1 entries can't be committed

-Rainer
