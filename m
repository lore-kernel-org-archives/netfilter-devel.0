From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Thu, 12 Jun 2014 14:19:45 +0900
Message-ID: <CAGCkEt02-WGJBKBr8kkDYq0uBk84bovuXp2wkKw5SDuypSEFhg@mail.gmail.com>
References: <CAGCkEt0oek-eZxd9Xetpyj5iqaHK1c+qqLaNP6MJ58cMNLNnSQ@mail.gmail.com>
	<20140612001807.GB22240@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:55748 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaFLFTq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 01:19:46 -0400
Received: by mail-la0-f42.google.com with SMTP id el20so398274lab.1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 22:19:45 -0700 (PDT)
In-Reply-To: <20140612001807.GB22240@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello, thank you for your reply.

2014-06-12 9:18 GMT+09:00 Florian Westphal <fw@strlen.de>:
> Maybe it is better to alter cmp_meta() and invoke a different
> comparator for MARK and ZONE that will give 'extra chance'

I see, thanks.

> when we hit the NFCT_CMP_STRICT conditional, i.e.

# I may not understand what you told me...

nf_conntrack which is created by --zone 0 options is the first param
of nfct_cmp() with NFCT_CMP_MASK flag in conntrack command,
I think it's better to handle NFCT_CMP_MASK flag too.

How about creating new function __cmp_none_as_zero() which
is called from cmp_meta() in case of ZONE attr and its signature
is the same as __cmp():

    return __cmp(attr, ct1, ct2, flags, cmp) ||
            (!test_bit(attr, ct1->head.set || nfct_get_attr_u16(ct1,
attr) == 0) &&
             (!test_bit(attr, ct2->head.set || nfct_get_attr_u16(ct2,
attr) == 0));

But this can work only for u16 attrs. To work with another size,
I think we need adding switch-case statement of attr length to
code snippet above or adding a new similer functions for it.
Would you tell me which one is better?

Thanks,
