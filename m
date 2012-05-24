From: Krishna Kumar2 <krkumar2@in.ibm.com>
Subject: Re: [v4 PATCH 1/1] netfilter: Add fail-open support
Date: Thu, 24 May 2012 16:01:58 +0530
Message-ID: <OF029AE6DA.E5969DF9-ON65257A08.003984EF-65257A08.0039E951@in.ibm.com>
References: <20120524082518.13146.25740.sendpatchset@localhost.localdomain> <20120524082531.13146.347.sendpatchset@localhost.localdomain> <20120524093043.GA30569@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, sri@us.ibm.com,
	Sulakshan Vajipayajula <svajipay@in.ibm.com>, vivk@us.ibm.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58209 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2EXKoW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 May 2012 06:44:22 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Thu, 24 May 2012 16:06:52 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4OAWaNY40173740
	for <netfilter-devel@vger.kernel.org>; Thu, 24 May 2012 16:02:36 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q4OG1pbx006644
	for <netfilter-devel@vger.kernel.org>; Fri, 25 May 2012 02:01:51 +1000
In-Reply-To: <20120524093043.GA30569@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote on 05/24/2012 03:00:43 PM:

> What about this:
>
> if (queue->queue_total >= queue->queue_maxlen) {
>    if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
>       nf_reinject(entry, NF_ACCEPT);
>       err = 0;
>       goto err_out_free_nskb;
>    }
>    queue->queue_dropped++;
>    net_warn_ratelimited("nf_queue: full at %d entries, dropping packets
(s)\n",
>
> [..]
>
> Do you see any problems with that?

No, I think it should work fine. Do this after dropping the lock?

> It should do the same as the nf_hook_slow/nf_queue ENOSPC changes while
> avoiding modifications outside the queueing backend.

Yes, that will help remove quite some code from front-end.

> > +   if (nfqa[NFQA_CFG_FLAGS]) {
> > +      __be32 flags, mask;
>
> [..]
>
> > +      flags = ntohl(nla_get_be32(nfqa[NFQA_CFG_FLAGS]));
> > +      mask = ntohl(nla_get_be32(nfqa[NFQA_CFG_MASK]));
>
> ntohl returns __u32 type.

Maybe just use __u32 type for flags/mask?

Thanks,
- KK

