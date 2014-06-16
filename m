From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Mon, 16 Jun 2014 09:04:03 +0900
Message-ID: <CAGCkEt2KCUmMYU5nDuKnZh14YofB_bbwVSF3HvE-FQ83kWGrPg@mail.gmail.com>
References: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
	<20140612001807.GB22240@breakpoint.cc>
	<CAGCkEt02-WGJBKBr8kkDYq0uBk84bovuXp2wkKw5SDuypSEFhg@mail.gmail.com>
	<20140612094842.GA1982@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64237 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaFPAEG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jun 2014 20:04:06 -0400
Received: by mail-lb0-f175.google.com with SMTP id q8so319030lbi.6
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2014 17:04:04 -0700 (PDT)
In-Reply-To: <20140612094842.GA1982@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello,

2014-06-12 18:48 GMT+09:00 Florian Westphal <fw@strlen.de>:
> What about this:
>
> static int cmp_zone(const struct nf_conntrack *ct1,
>         const struct nf_conntrack *ct2, unsigned int flags)
> {
>  return nfct_get_attr_u16(ct1, ATTR_ZONE) == nfct_get_attr_u16(ct2, ATTR_ZONE);
> }
>
> Then it should be sufficient to not call __cmp at all, i.e.:
>
> - if (!__cmp(ATTR_ZONE, ct1, ct2, flags, cmp_zone))
> + if (!cmp_zone(ct1, ct2, flags))
>
> ct1 and ct2 zones would then always be equal except if
> both have ATTR_ZONE set and the zones are different.

Sorry, it did not work with NFCT_CMP_MASK in case of
only ct2 has attr. We need to think of NCFT_CMP_MASK
as you told.

  static int cmp_zone(const struct nf_conntrack *ct1,
                                  const struct nf_conntrack *ct2,
                                  unsigned int flags)
  {
      return (flags & NFCT_CMP_MASK &&
                 !test_bit(ATTR_ZONE, ct1->head.set)) ||
                 nfct_get_attr_u16(ct1, ATTR_ZONE)
                 == nfct_get_attr_u16(ct2, ATTR_ZONE);
  }

What about this?
Could I resend the patch if it is acceptable?
