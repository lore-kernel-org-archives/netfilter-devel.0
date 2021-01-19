Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A31C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jan 2021 14:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68255206E5
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jan 2021 14:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbhASOiB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:38:01 -0500
Received: from smtprelay02.isp.plutex.de ([91.202.40.194]:34263 "EHLO
        smtprelay02.isp.plutex.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389854AbhASOW6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Jan 2021 09:22:58 -0500
Received: from mail01.plutex.de (mail01.plutex.de [91.202.40.205])
        by smtprelay02.isp.plutex.de (Postfix) with ESMTP id 355C580100;
        Tue, 19 Jan 2021 15:22:06 +0100 (CET)
Received: from [IPv6:2a02:16d0:0:6:1:0:6aff:a53] (unknown [IPv6:2a02:16d0:0:6:1:0:6aff:a53])
        by mail01.plutex.de (Postfix) with ESMTPSA id 15D65CC0806;
        Tue, 19 Jan 2021 15:22:06 +0100 (CET)
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <21ed8188-a202-f578-6f8b-303dec37a266@plutex.de>
 <20210114224057.GA5392@salvia>
Reply-To: jpl+netfilter-devel@plutex.de
From:   Jan-Philipp Litza <jpl@plutex.de>
Subject: Re: [PATCH] netfilter: Reverse nft_set_lookup_byid list traversal
Message-ID: <00ff9577-21d5-177b-33ed-f8de85a11929@plutex.de>
Date:   Tue, 19 Jan 2021 15:22:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210114224057.GA5392@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

> If the .nft file contains lots of (linear syntax):
> 
> add rule x y ... { ... }
> ...
> add rule x y ... { ... }
> 
> then, this patch is a real gain. In this case, nft currently places
> the new anonymous set right before the rule, so your patch makes it
> perform nicely.
> 
> I hesitate with the nested syntax, ie.
> 
> table x {
>        chain y {
>                 ... { ... }
>                 ...
>                 ... { ... }
>        }
> }
> 
> In this case, nft adds all the anonymous sets at the beginning of the
> netlink message, then rules don't find it right at the end.

Maybe I don't quite understand "at the beginning of the netlink message"
the way you meant it, but we are actually using nested syntax - just
with hundreds of (short) chains - and the performance gains I cited were
from this ruleset, which basically looks like

table filter {
	chain if1 {
		tcp dport 22 ip saddr { x, y, z } accept
	}
}
table filter {
	chain if2 {
		ip saddr { a, b, c } accept
		tcp dport 80 accept
	}
}
...

(Yes, the "table filter" is repeated every time, because the ruleset is
generated. Don't know if that matters.)

So I suspect that nft adds the anonymous sets maybe not immediately
before the elements, but maybe at the beginning of the chain (or the
beginning of the table block, which we repeat).

But maybe, if I have one chain with hundreds of rules, then this patch
degrades loading performance.

> Probably it's better to convert this code to use a rhashtable for fast
> lookups on the transaction so we don't mind about what userspace does
> in the future.

I totally agree. As a non-kernel-hacker, however, this was out of reach
for me. ;-)

Best regards,
Jan-Philipp Litza
