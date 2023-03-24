Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AFFC6FD1C
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Mar 2023 14:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCXOTA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 10:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbjCXOS7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 10:18:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C33BDEA
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 07:18:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pfiFs-0001bU-M3; Fri, 24 Mar 2023 15:18:56 +0100
Date:   Fri, 24 Mar 2023 15:18:56 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 0/8] Support for shifted port-ranges in NAT
Message-ID: <20230324141856.GA1871@breakpoint.cc>
References: <20230305101418.2233910-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230305101418.2233910-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> Support for shifted port-ranges was added to iptables for DNAT in 2018.
> This allows one to redirect packets intended for one port to another in
> a range in such a way that the new port chosen has the same offset in
> the range as the original port had from a specified base value.
> 
> For example, by using the base value 2000, one could redirect packets
> intended for 10.0.0.1:2000-3000 to 10.10.0.1:12000-13000 so that the old
> and new ports were at the same offset in their respective ranges, i.e.:
>
>   10.0.0.1:2345 -> 10.10.0.1:12345
> 
> This patch-set adds support for doing likewise to nftables.  In contrast
> to iptables, this works for `snat`, `redirect` and `masquerade`
> statements as well as well as `dnat`.

Could you rebase and resend the kernel patches now that the
refactoring patches have been merged?

I'd like to have another look at it now that the fixes and
refactoring ones are in.

Background: I wonder if going with NF_NAT_RANGE_PROTO_OFFSET
is really a good idea or not, because it seems rather iptables-kludgy.

But if its not much work it might be simpler to jsut go along with it.
An alternate approach would be to support addition in nft, so one
could do:

dnat to tcp dport + 2000

... to get such a 'shift effect'.

[ yes, the bison parser might not like this syntax, I made it up for
illustrative purposes. ]

Something like this would also allow to emulate TTL/HL target of
iptables, ATM we can set a fixed value but cannot add or decrement
them.

Thanks.
