From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 0/9] netfilter: remove per-netns conntrack
 tables, part 1
Date: Fri, 6 May 2016 00:36:32 +0200
Message-ID: <20160505223632.GB21687@breakpoint.cc>
References: <1461863628-23350-1-git-send-email-fw@strlen.de>
 <572BACA3.6070303@hpe.com>
 <20160505205418.GA21687@breakpoint.cc>
 <572BC7A5.1060503@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: Brian Haley <brian.haley@hpe.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55643 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbcEEWgh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2016 18:36:37 -0400
Content-Disposition: inline
In-Reply-To: <572BC7A5.1060503@hpe.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Brian Haley <brian.haley@hpe.com> wrote:
> >>I've seen cases where certain users are attacked, where the CT table is
> >>filled such that we start seeing "nf_conntrack: table full, dropping packet"
> >>messages (as expected).  But other users continue to function normally,
> >>unaffected.  Is this still the case - each netns has some limit it can't
> >>exceed?
> >
> >The limit is global, the accounting per namespace.
> 
> So this is a change from existing.

No, see __nf_conntrack_alloc():

        if (nf_conntrack_max &&
            unlikely(atomic_read(&net->ct.count) > nf_conntrack_max)) {
		...

ct.count is whatever number of entries the namespace has allocated,
so max number of possible conntracks is always infinite if number
of net namespaces is unlimited (barring memory constraints, of course).

I did not change this.
