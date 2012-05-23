From: Krishna Kumar2 <krkumar2@in.ibm.com>
Subject: Re: [v3 PATCH 1/1] netfilter: Add fail-open support.
Date: Wed, 23 May 2012 12:15:59 +0530
Message-ID: <OF2AAA0ADB.EE750110-ON65257A06.005144D9-65257A07.002538D4@in.ibm.com>
References: <20120522121037.880.44203.sendpatchset@localhost.localdomain> <20120522121048.880.22605.sendpatchset@localhost.localdomain> <20120522143858.GB14029@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, sri@us.ibm.com,
	Sulakshan Vajipayajula <svajipay@in.ibm.com>, vivk@us.ibm.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:38139 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2EWG4y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 May 2012 02:56:54 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Wed, 23 May 2012 12:16:48 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4N6kbZH52232402
	for <netfilter-devel@vger.kernel.org>; Wed, 23 May 2012 12:16:37 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q4NCGOtK009920
	for <netfilter-devel@vger.kernel.org>; Wed, 23 May 2012 22:16:24 +1000
In-Reply-To: <20120522143858.GB14029@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote on 05/22/2012 08:08:58 PM:

Thanks for your review.

> >
> >     NFQA_CFG_QUEUE_MAXLEN,      /* __u32 */
> > +   NFQA_CFG_MASK,         /* identify which flags to change */
> > +   NFQA_CFG_FLAGS,         /* value of these flags (__u32) */
>
> __be32?

Yes, I will change this.

> I see that QUEUE_MAXLEN gets ntohl treatment, too....
>
> > +static void handle_fail_open(struct sk_buff *skb,
> > +              int (*okfn)(struct sk_buff *))
> > +{
> > +   struct sk_buff *segs;
> > +   bool gso;
> > +
> > +   segs = skb->next ? : skb;
> > +   gso = skb->next != NULL;
> > +
> > +   do {
> > +      struct sk_buff *nskb = segs->next;
> > +
> > +      segs->next = NULL;
> > +      okfn(segs);
> > +      segs = nskb;
> > +   } while (segs);
> > +
> > +   if (gso)
> > +      kfree_skb(skb);
> > +}
>
> I don't understand why this is needed at all.
> Conceptually, what you're doing is identical to the
> --nfqueue-bypass feature, so it should be enough to change

Yes, I could use the same code. However I am not clear about the
ESRCH path since it doesn't seem to handle GSO skb correctly? See
nf_queue below where it calls kfree_skb even for -ESRCH:

	if (err == 0) {
		nf_bridge_adjust_segmented_data(segs);
		err = __nf_queue(segs, elem, pf, hook, indev,
					outdev, okfn, queuenum);
	}
	if (err == 0)
		queued++;
	else
		kfree_skb(segs);

Maybe this needs a check for ESRCH and return back to hook_slow
to work correctly? If this is the case, I can submit a patch to
fix this, and piggy-back ESRCH for fail-open too.

> > @@ -199,10 +226,18 @@ next_hook:
> >           if (err == -ESRCH &&
> >              (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
> >              goto next_hook;
> > +         if (err == -ENOSPC) {
> > +            failopen = 1;
> > +            goto next_hook;
> > +         }
> >           kfree_skb(skb);
>
> to
>
>  if (err == -ENOSPC || (err == -ESRCH && (verdict &
> NF_VERDICT_FLAG_QUEUE_BYPASS))
>      goto next_hook;

This would work if the skb was not GSO. So maybe the above
fix for ESRCH will let me share the code for fail-open too?

> [ or, take advantage of the existing -ECANCELED and have the queueing
>   backend return that if queue is full and fail-open is enabled ]
>
> Yes, that means that if the userspace ruleset is
> -j NFQUEUE
> -j DROP
>
> then your packets will be dropped even if the userspace application
> enables failopen.
>
> But thats a feature, since you could also do
> -j NFQUEUE
> -m limt ... -j LOG --log-prefix "queue overflow"
>
> or play extra games wrt. "drop if established, CONNMARK
> for future bypass if --ctstate NEW", etc.
>
> If its a requirment for you that userspace can force ACCEPT
> regardless of ruleset, then perhaps it might be better to
> add a separate "default verdict" option and invoke
> nf_reinject() directly from the qeueueing backend instead
> of passing the fail-open information back to nf_hook_slow?
>
> > +      flags = nla_data(nfqa[NFQA_CFG_FLAGS]);
> > +      mask = nla_data(nfqa[NFQA_CFG_MASK]);
>
> nla_get_be32()?
> [ _u32 would make more sense to me, but other attributes are be32 too,
>   so I'm ok with it ]

Yes, I will change to be32.

> > -      if (err == 0)
> > +
> > +      if (err == 0) {
> >           queued++;
> > -      else
> > +      } else if (err == -ENOSPC) {
> > +         /* Queue failed due to queue-full and handler is
> > +          * in "fail-open" mode.
> > +          */
> > +         segs->next = nskb;
> > +         skb->next = segs;
> > +         break;
> > +      } else {
> >           kfree_skb(segs);
> > +      }
> >        segs = nskb;
> >     } while (segs);
> >
> > -   if (queued) {
> > +   if (queued && err != -ENOSPC) {
> >        kfree_skb(skb);
> >        return 0;
> >     }
>
> Similarily, this shouldn't be needed either any more since you
> no longer need to check for -ENOSPC (existing --queue-bypass behaviour
> should handle your case, too).

Slight change could be needed here, since queued is 0 for --queue-bypass
case (and hence return -ESRCH), while it could be >0 for fail-open,
where we still want to return error as some segments were not queued.

Thanks,
- KK

