From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Thu, 12 Jun 2014 02:18:07 +0200
Message-ID: <20140612001807.GB22240@breakpoint.cc>
References: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53778 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689AbaFLASK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:18:10 -0400
Content-Disposition: inline
In-Reply-To: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> This patch enables comparison of 0 value with mark and zone since
> both CTA_MARK and CTA_ZONE are not set in case of its value is 0.

I think the general idea is right.

When nfct_cmp is invoked with 'full compare' then two conntracks
should be regarded the same if they only differ in 'zone unset'
and 'zone set and it is 0', as a unset zone does imply a 0.

Maybe it is better to alter cmp_meta() and invoke a different
comparator for MARK and ZONE that will give 'extra chance'
when we hit the NFCT_CMP_STRICT conditional, i.e.

>         } else if (flags & NFCT_CMP_STRICT) {

One way might be to add __cmp_harder() which is same as __cmp() but
will invoke cmp() again in the CMP_STRICT case.

Then, cmp_zone() could be altered to do

return nfct_attr_get_u16(ct1) == nfct_attr_get_u16(ct2)

Which should fix this problem (get_u16 of unset attr returns 0).

Alternatively of course we could change __cmp() to always
invoke the cmp() function again in STRICT case but it probably
requires a lot more changes/care since we'd have to fix all the
other attribute specific comparators.
