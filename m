From: Florian Westphal <fw@strlen.de>
Subject: Re: [v3 PATCH 1/1] netfilter: Add fail-open support.
Date: Wed, 23 May 2012 09:54:56 +0200
Message-ID: <20120523075456.GC11818@breakpoint.cc>
References: <20120522121037.880.44203.sendpatchset@localhost.localdomain>
 <20120522121048.880.22605.sendpatchset@localhost.localdomain>
 <20120522143858.GB14029@breakpoint.cc>
 <OF2AAA0ADB.EE750110-ON65257A06.005144D9-65257A07.002538D4@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, kaber@trash.net,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	sri@us.ibm.com, Sulakshan Vajipayajula <svajipay@in.ibm.com>,
	vivk@us.ibm.com
To: Krishna Kumar2 <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57528 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932678Ab2EWHzB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 May 2012 03:55:01 -0400
Content-Disposition: inline
In-Reply-To: <OF2AAA0ADB.EE750110-ON65257A06.005144D9-65257A07.002538D4@in.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krishna Kumar2 <krkumar2@in.ibm.com> wrote:
> Florian Westphal <fw@strlen.de> wrote on 05/22/2012 08:08:58 PM:
> > I don't understand why this is needed at all.
> > Conceptually, what you're doing is identical to the
> > --nfqueue-bypass feature, so it should be enough to change
> 
> Yes, I could use the same code. However I am not clear about the
> ESRCH path since it doesn't seem to handle GSO skb correctly? See
> nf_queue below where it calls kfree_skb even for -ESRCH:
> 
> 	if (err == 0) {
> 		nf_bridge_adjust_segmented_data(segs);
> 		err = __nf_queue(segs, elem, pf, hook, indev,
> 					outdev, okfn, queuenum);
> 	}
> 	if (err == 0)
> 		queued++;
> 	else
> 		kfree_skb(segs);
> 
> Maybe this needs a check for ESRCH and return back to hook_slow
> to work correctly? If this is the case, I can submit a patch to
> fix this, and piggy-back ESRCH for fail-open too.

The idea for queue-bypass was to free the original (gso) skb
if we were able to queue at least one packet, i.e. the original
skb only continues traversal if queue bypassing is enabled
and no single segment could be queued.

If it is a requirement for you that any remaining segments
that could not be queued continue traversal, then yes,
the existing code won't work for you.

I don't think its necessary to piggyback ESRCH too; since
userspace should not bind/unbind the queue continuously
(i.e., a -ESRCH after some segments have been queued should
 be a rare condition).

However, if the code sharing is not too much of a burden
then it would be good to do it anyway.

> > > @@ -199,10 +226,18 @@ next_hook:
> > >           if (err == -ESRCH &&
> > >              (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
> > >              goto next_hook;
> > > +         if (err == -ENOSPC) {
> > > +            failopen = 1;
> > > +            goto next_hook;
> > > +         }
> > >           kfree_skb(skb);
> >
> > to
> >
> >  if (err == -ENOSPC || (err == -ESRCH && (verdict &
> > NF_VERDICT_FLAG_QUEUE_BYPASS))
> >      goto next_hook;
> 
> This would work if the skb was not GSO. So maybe the above
> fix for ESRCH will let me share the code for fail-open too?

See above; it works for GSO too if we could not queue a single segment.
I think that iff you need to handle the "some segments queued" case
and put that in here then handling -ESRCH with it too would be good.

> > [ or, take advantage of the existing -ECANCELED and have the queueing
> >   backend return that if queue is full and fail-open is enabled ]
> >
> > Yes, that means that if the userspace ruleset is
> > -j NFQUEUE
> > -j DROP
> >
> > then your packets will be dropped even if the userspace application
> > enables failopen.
> >
> > But thats a feature, since you could also do
> > -j NFQUEUE
> > -m limt ... -j LOG --log-prefix "queue overflow"
> >
> > or play extra games wrt. "drop if established, CONNMARK
> > for future bypass if --ctstate NEW", etc.
> >
> > If its a requirment for you that userspace can force ACCEPT
> > regardless of ruleset, then perhaps it might be better to
> > add a separate "default verdict" option and invoke
> > nf_reinject() directly from the qeueueing backend instead
> > of passing the fail-open information back to nf_hook_slow?
> >
> > > +      flags = nla_data(nfqa[NFQA_CFG_FLAGS]);
> > > +      mask = nla_data(nfqa[NFQA_CFG_MASK]);
> >
> > nla_get_be32()?
> > [ _u32 would make more sense to me, but other attributes are be32 too,
> >   so I'm ok with it ]
> 
> Yes, I will change to be32.
> 
> > > -      if (err == 0)
> > > +
> > > +      if (err == 0) {
> > >           queued++;
> > > -      else
> > > +      } else if (err == -ENOSPC) {
> > > +         /* Queue failed due to queue-full and handler is
> > > +          * in "fail-open" mode.
> > > +          */
> > > +         segs->next = nskb;
> > > +         skb->next = segs;
> > > +         break;
> > > +      } else {
> > >           kfree_skb(segs);
> > > +      }
> > >        segs = nskb;
> > >     } while (segs);
> > >
> > > -   if (queued) {
> > > +   if (queued && err != -ENOSPC) {
> > >        kfree_skb(skb);
> > >        return 0;
> > >     }
> >
> > Similarily, this shouldn't be needed either any more since you
> > no longer need to check for -ENOSPC (existing --queue-bypass behaviour
> > should handle your case, too).
> 
> Slight change could be needed here, since queued is 0 for --queue-bypass
> case (and hence return -ESRCH), while it could be >0 for fail-open,
> where we still want to return error as some segments were not queued.

Right, queued will almost certainly be 0 if the userspace listener is
not there anymore.

I wonder if it would be possible to just nf_reinject() directly
from nfqnl_enqueue_packet().

[ This means we loose the ability to add rules after NFQUEUE to detect
  the overflow case, but it would avoid adding code to nf_hook_slow et
  al. ]

Lets wait what others think.
