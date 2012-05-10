From: Krishna Kumar2 <krkumar2@in.ibm.com>
Subject: Re: [v2 PATCH 5/6] netfilter: GSO packet handling
Date: Thu, 10 May 2012 09:50:54 +0530
Message-ID: <OF8C520E3B.FA80800D-ON652579FA.001729CC-652579FA.0017D6E6@in.ibm.com>
References: <20120508094342.19531.51351.sendpatchset@localhost.localdomain> <20120508094442.19531.56563.sendpatchset@localhost.localdomain> <20120508122828.GA12801@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: fw@strlen.de, kaber@trash.net, netfilter-devel@vger.kernel.org,
	sri@us.ibm.com, Sulakshan Vajipayajula <svajipay@in.ibm.com>,
	vivk@us.ibm.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60200 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2EJEVf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 May 2012 00:21:35 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Thu, 10 May 2012 09:51:31 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4A4LS8Z7209278
	for <netfilter-devel@vger.kernel.org>; Thu, 10 May 2012 09:51:29 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q4A9q5ot024457
	for <netfilter-devel@vger.kernel.org>; Thu, 10 May 2012 19:52:05 +1000
In-Reply-To: <20120508122828.GA12801@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote on 05/08/2012 05:58:28 PM:


> > +   if (!skb_is_gso(skb)) {
> > +      err = __nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
> >                queuenum);
> > +      if (err > 0) {
> > +         /* Queue failed due to queue-full and handler
> > +          * returned >0 indicating fail-open - temporarily
> > +          * accept packets.
> > +          */
> > +         err = okfn(skb);
>
> You cannot invoke okfn here. If you do so, you'll skip the remaining
> hooks.
>
> Return the error and handle the -ENOSPC in nf_hook_slow.
>
> (Note that the -ENOSPC is the error value I'm proposing you to use for
> this special case).

Are you suggesting to change nf_hook_slow to:

	if (err == -ENOSPC || err == -ECANCELED)
		goto next_hook;

In that case, how should the GSO case be handled (code below)?

Thanks for your feedback,

- KK

> > @@ -268,14 +277,26 @@ int nf_queue(struct sk_buff *skb,
> >           err = __nf_queue(segs, elem, pf, hook, indev,
> >                    outdev, okfn, queuenum);
> >        }
> > -      if (err == 0)
> > +
> > +      if (err == 0) {
> >           queued++;
> > -      else
> > +      } else if (err > 0) {
> > +         /* Queue failed due to queue-full and handler
> > +          * returned >0 indicating fail-open - accept
> > +          * this and remaining segments.
> > +          */
> > +         okfn(segs);
> > +      } else {
> > +         /* Queue failed due to queue-full and handler
> > +          * returned <0 - free this and remaining skb
> > +          * segments.
> > +          */
> >           kfree_skb(segs);
> > +      }
> >        segs = nskb;
> >     } while (segs);
> >
> > -   if (queued) {
> > +   if (queued || err > 0) {
> >        kfree_skb(skb);
> >        return 0;
> >     }

