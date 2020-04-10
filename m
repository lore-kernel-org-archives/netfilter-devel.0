Return-Path: <SRS0=rxVU=52=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5747C2BA2B
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Apr 2020 09:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA97E206F7
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Apr 2020 09:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgDJJSU convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Apr 2020 05:18:20 -0400
Received: from mxout012.mail.hostpoint.ch ([217.26.49.172]:32666 "EHLO
        mxout012.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725861AbgDJJSU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Apr 2020 05:18:20 -0400
X-Greylist: delayed 2371 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Apr 2020 05:18:19 EDT
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout012.mail.hostpoint.ch with esmtp (Exim 4.92.3 (FreeBSD))
        (envelope-from <andreas.jaggi@waterwave.ch>)
        id 1jMpBX-000DOw-I4; Fri, 10 Apr 2020 10:38:47 +0200
Received: from xdsl-31-165-67-144.adslplus.ch ([31.165.67.144] helo=[192.168.9.20])
        by asmtp013.mail.hostpoint.ch with esmtpa (Exim 4.92.3 (FreeBSD))
        (envelope-from <andreas.jaggi@waterwave.ch>)
        id 1jMpBX-000P35-FW; Fri, 10 Apr 2020 10:38:47 +0200
X-Authenticated-Sender-Id: andreas.jaggi@waterwave.ch
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: ipv6 rpfilter and.. fw mark? problems with wireguard
From:   Andreas Jaggi <andreas.jaggi@waterwave.ch>
In-Reply-To: <20200409203843.GA6881@nautica>
Date:   Fri, 10 Apr 2020 10:38:47 +0200
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <CA65DC1B-209F-4C64-9497-38B98406DCFF@waterwave.ch>
References: <20200409203843.GA6881@nautica>
To:     Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Dominique

> table inet test {
>    chain raw_PREROUTING {
>        type filter hook prerouting priority raw; policy accept;
>        meta nfproto ipv6 fib saddr . iif oif missing log prefix "rpfilter_DROP: " drop
>    }
> }
> 
> or
> 
> ip6tables -t raw -A PREROUTING -m rpfilter --invert -j LOG --log-prefix "rpfilter_DROP: "
> ip6tables -t raw -A PREROUTING -m rpfilter --invert -j DROP

This does not consider the fwmark for the reverse-routing lookup.
Using the --validmark option for the rpfilter match should get you the correct result.

And for nft the already suggested: meta nfproto ipv6 fib saddr . iif . mark  oif missing log prefix "rpfilter_DROP: " drop

> For completeness, the two nft commands there contain the following
> tables:
> table ip6 wg-quick-wg0 {
>    chain preraw {
>        type filter hook prerouting priority raw; policy accept;
>        iifname != "wg0" ip6 daddr fe80::2 fib saddr type != local drop
>    }
> 
>    chain premangle {
>        type filter hook prerouting priority mangle; policy accept;
>        meta l4proto udp meta mark set ct mark
>    }
> 
>    chain postmangle {
>        type filter hook postrouting priority mangle; policy accept;
>        meta l4proto udp meta mark 0x0000ca6c ct mark set meta mark
>    }
> }

I suspect the main problem is the rpfilter check happening in the raw table, but the fwmark only being written in the mangle table.
Thus the rpfilter lookup happens without the correct fwmark and fails to return the correct result.

I would move the rpfilter check into the mangle table and place it after the fwmark is written.

eg. something like:

table ip6 wg-quick-wg0 {
   chain preraw {
       type filter hook prerouting priority raw; policy accept;
       iifname != "wg0" ip6 daddr fe80::2 fib saddr type != local drop
   }

   chain premangle {
       type filter hook prerouting priority mangle; policy accept;
       meta l4proto udp meta mark set ct mark
       meta fib saddr . iif . mark  oif missing log prefix "rpfilter_DROP: " drop
   }

   chain postmangle {
       type filter hook postrouting priority mangle; policy accept;
       meta l4proto udp meta mark 0x0000ca6c ct mark set meta mark
   }
}


Cheers
Andreas

