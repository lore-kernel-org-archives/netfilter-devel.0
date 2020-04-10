Return-Path: <SRS0=rxVU=52=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B065BC2BA2B
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Apr 2020 09:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B1BB206A1
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Apr 2020 09:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgDJJOW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Apr 2020 05:14:22 -0400
Received: from nautica.notk.org ([91.121.71.147]:33521 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgDJJOW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Apr 2020 05:14:22 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id E3F95C009; Fri, 10 Apr 2020 11:14:20 +0200 (CEST)
Date:   Fri, 10 Apr 2020 11:14:05 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Andreas Jaggi <andreas.jaggi@waterwave.ch>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Subject: Re: ipv6 rpfilter and.. fw mark? problems with wireguard
Message-ID: <20200410091405.GA5893@nautica>
References: <20200409203843.GA6881@nautica>
 <CA65DC1B-209F-4C64-9497-38B98406DCFF@waterwave.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA65DC1B-209F-4C64-9497-38B98406DCFF@waterwave.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


Thanks for the prompt reply!

(I just noticed the netfilter@ list, sorry for having asked the question
here instead)

Andreas Jaggi wrote on Fri, Apr 10, 2020:
> > table inet test {
> >    chain raw_PREROUTING {
> >        type filter hook prerouting priority raw; policy accept;
> >        meta nfproto ipv6 fib saddr . iif oif missing log prefix "rpfilter_DROP: " drop
> >    }
> > }
> > 
> > or
> > 
> > ip6tables -t raw -A PREROUTING -m rpfilter --invert -j LOG --log-prefix "rpfilter_DROP: "
> > ip6tables -t raw -A PREROUTING -m rpfilter --invert -j DROP
> 
> This does not consider the fwmark for the reverse-routing lookup.
> Using the --validmark option for the rpfilter match should get you the correct result.
> 
> And for nft the already suggested:
> meta nfproto ipv6 fib saddr . iif . mark  oif missing log prefix "rpfilter_DROP: " drop

Ok.

> I suspect the main problem is the rpfilter check happening in the raw
> table, but the fwmark only being written in the mangle table.
> Thus the rpfilter lookup happens without the correct fwmark and fails
> to return the correct result.
> 
> I would move the rpfilter check into the mangle table and place it
> after the fwmark is written.

Ok, firewalld rules are in a different table but they set priorities to
mangle + 10 so I tested something similar and it does work:

table inet test {
    chain premangle {
        type filter hook prerouting priority mangle + 10; policy accept;
        meta nfproto ipv6 fib saddr . mark . iif oif missing log prefix "rpfilter_DROP: " drop
    }
}

(I also confirmed moving the iptables, unsurprisingly it works and does
require the --validmark switch suggested)



I also found that adding --loose to the ip6tables rule also works, I've
had a look at the man page[1] and can't say I understand how to make an
equivalent 'loose' rule as nft, but I'll keep trying a while longer.
(I'm asking because the ipv4 default seems to be loose on my setup, so
I'm surprised ipv6 would be different; not decided on what to actually
use)

[1] https://www.netfilter.org/projects/nftables/manpage.html#lbBR



I'll get back to the firewalld developer to discuss what would be
the preferred solution, thanks again for the help.

Cheers,
-- 
Dominique
