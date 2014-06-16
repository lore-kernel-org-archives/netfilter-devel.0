From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Mon, 16 Jun 2014 13:41:54 +0200
Message-ID: <20140616114154.GI1982@breakpoint.cc>
References: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
 <20140612001807.GB22240@breakpoint.cc>
 <CAGCkEt02-WGJBKBr8kkDYq0uBk84bovuXp2wkKw5SDuypSEFhg@mail.gmail.com>
 <20140612094842.GA1982@breakpoint.cc>
 <CAGCkEt2KCUmMYU5nDuKnZh14YofB_bbwVSF3HvE-FQ83kWGrPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33203 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbaFPLl4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:41:56 -0400
Content-Disposition: inline
In-Reply-To: <CAGCkEt2KCUmMYU5nDuKnZh14YofB_bbwVSF3HvE-FQ83kWGrPg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> 2014-06-12 18:48 GMT+09:00 Florian Westphal <fw@strlen.de>:
> > What about this:
> >
> > static int cmp_zone(const struct nf_conntrack *ct1,
> >         const struct nf_conntrack *ct2, unsigned int flags)
> > {
> >  return nfct_get_attr_u16(ct1, ATTR_ZONE) == nfct_get_attr_u16(ct2, ATTR_ZONE);
> > }
> >
> > Then it should be sufficient to not call __cmp at all, i.e.:
> >
> > - if (!__cmp(ATTR_ZONE, ct1, ct2, flags, cmp_zone))
> > + if (!cmp_zone(ct1, ct2, flags))
> >
> > ct1 and ct2 zones would then always be equal except if
> > both have ATTR_ZONE set and the zones are different.
> 
> Sorry, it did not work with NFCT_CMP_MASK in case of
> only ct2 has attr. We need to think of NCFT_CMP_MASK
> as you told.
i
Why?  cmp_zone() does not evaluate the 'flags' paramter.

So, if only ct2 has attr:
nfct_get_attr_u16(ct1, ATTR_ZONE) -> returns 0
nfct_get_attr_u16(ct2, ATTR_ZONE) -> returns the zone id

ct1 and ct2 would be equal if ct2 zone is 0.
