From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] extensions: libxt_NFQUEUE: Add translation to nft
Date: Mon, 8 Feb 2016 10:29:49 +0100
Message-ID: <20160208092949.GC32181@breakpoint.cc>
References: <20160207060721.GA11310@gmail.com>
 <20160207092504.GB32181@breakpoint.cc>
 <CAKHNQQGy8EDrMbPQb2Og_Dk8wf62GaeKq1zO+uz2UB6HbZ9hAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49687 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbcBHJ3u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Feb 2016 04:29:50 -0500
Content-Disposition: inline
In-Reply-To: <CAKHNQQGy8EDrMbPQb2Og_Dk8wf62GaeKq1zO+uz2UB6HbZ9hAQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> On Sun, Feb 7, 2016 at 2:55 PM, Florian Westphal <fw@strlen.de> wrote:

> > Seems this could be written similar to something like:
> >
> > if (info->flags & NFQ_FLAG_CPU_FANOUT) {
> >         bool sep_needed = info->bypass & NFQ_FLAG_BYPASS;
> >         xt_xlate_add(xl, "%sfanout ", sep_need ? "," : "");
> > ...
> 
> The pointer info used in both the versions (of NFQUEUE_xlate) is for
> different structures. Sadly, this doesn't work as v3 structure doesn't
> have a member for bypass field.

Oh, right.  However bypass & flags overlap -- I think you could just use
info->flags & NFQ_FLAG_BYPASS.

If you look at NFQUEUE_parse_v3() it just calls NFQUEUE_parse_v2() with
the v3 structure.
