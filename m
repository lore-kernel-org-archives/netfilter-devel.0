From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Thu, 12 Jun 2014 11:48:43 +0200
Message-ID: <20140612094842.GA1982@breakpoint.cc>
References: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
 <20140612001807.GB22240@breakpoint.cc>
 <CAGCkEt02-WGJBKBr8kkDYq0uBk84bovuXp2wkKw5SDuypSEFhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54620 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932784AbaFLJso (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:48:44 -0400
Content-Disposition: inline
In-Reply-To: <CAGCkEt02-WGJBKBr8kkDYq0uBk84bovuXp2wkKw5SDuypSEFhg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> I see, thanks.
> 
> > when we hit the NFCT_CMP_STRICT conditional, i.e.
> 
> # I may not understand what you told me...

Understandable, I meant CMP_MASK.  But I think we can
get away with an even simpler change.

What about this:

static int cmp_zone(const struct nf_conntrack *ct1,
	const struct nf_conntrack *ct2, unsigned int flags)
{
 return nfct_get_attr_u16(ct1, ATTR_ZONE) == nfct_get_attr_u16(ct2, ATTR_ZONE);
}

Then it should be sufficient to not call __cmp at all, i.e.:

- if (!__cmp(ATTR_ZONE, ct1, ct2, flags, cmp_zone))
+ if (!cmp_zone(ct1, ct2, flags))

ct1 and ct2 zones would then always be equal except if
both have ATTR_ZONE set and the zones are different.

What do you think?
