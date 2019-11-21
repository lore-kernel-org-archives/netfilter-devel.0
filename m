Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4061C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 20:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1BA32068D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 20:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKUUlT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 15:41:19 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:56042 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbfKUUlT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 15:41:19 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iXtGL-0007TG-5Z; Thu, 21 Nov 2019 21:41:13 +0100
Date:   Thu, 21 Nov 2019 21:41:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Kadlecsik =?iso-8859-15?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: Re: [PATCH nf-next 3/8] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20191121204113.GL20235@breakpoint.cc>
References: <cover.1574119038.git.sbrivio@redhat.com>
 <6da551247fd90666b0eca00fb4467151389bf1dc.1574119038.git.sbrivio@redhat.com>
 <20191120150609.GB20235@breakpoint.cc>
 <20191121205442.5eb3d113@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121205442.5eb3d113@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> > > +		kfree(*per_cpu_ptr(m->scratch, i));  
> > 
> > I was about to ask what would prevent nft_pipapo_lookup() from accessing
> > m->scratch.  Its because "m" is the private clone.  Perhaps add a
> > comment here to that effect.
> 
> I renamed 'm' to 'clone' and updated kerneldoc header, I think it's
> even clearer than a comment that way.

Agree, thats even better, thanks!

> > > + * @net:	Network namespace
> > > + * @set:	nftables API set representation
> > > + * @elem:	nftables API element representation containing key data
> > > + * @flags:	If NFT_SET_ELEM_INTERVAL_END is passed, this is the end element
> > > + * @ext2:	Filled with pointer to &struct nft_set_ext in inserted element
> > > + *
> > > + * In this set implementation, this functions needs to be called twice, with
> > > + * start and end element, to obtain a valid entry insertion. Calls to this
> > > + * function are serialised, so we can store element and key data on the first
> > > + * call with start element, and use it on the second call once we get the end
> > > + * element too.  
> > 
> > What guaranttess this?
> 
> Well, the only guarantee that I'm expecting here is that the insert
> function is not called concurrently in the same namespace, and as far
> as I understand that comes from nf_tables_valid_genid(). However:

Yes, insertion isn't parallel for same netns.

> > AFAICS userspace could send a single element, with either
> > NFT_SET_ELEM_INTERVAL_END, or only the start element.
> 
> this is all possible, and:
> 
> - for a single element with NFT_SET_ELEM_INTERVAL_END, we'll reuse the
>   last 'start' element ever seen, or an all-zero key if no 'start'
>   elements were seen at all
> 
> - for a single 'start' element, no element is added
> 
> If the user chooses to configure firewalling with syzbot, my assumption
> is that all we have to do is to avoid crashing or leaking anything.

Yes, exactly, we should only reject what either
1. would crash kernel
2. makes obviously no sense (missing or contradiction attributes).

anything more than that isn't needed.

> We could opt to be stricter indeed, by checking that a single netlink
> batch contains a corresponding number of start and end elements. This
> can't be done by the insert function though, we don't have enough
> context there.

Yes.  If such 'single element with no end interval' can't happen or
won't cause any problems then no action is needed.
