Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952E4C5519F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 23:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 547D42076C
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 23:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgKVX4Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Nov 2020 18:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbgKVX4Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Nov 2020 18:56:16 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63345C0613CF
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2020 15:56:16 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kgzDI-0007rI-N6; Mon, 23 Nov 2020 00:56:12 +0100
Date:   Mon, 23 Nov 2020 00:56:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Derek Dai <daiderek@gmail.com>,
        guigom@riseup.net
Subject: Re: [nft PATCH] json: echo: Speedup seqnum_to_json()
Message-ID: <20201122235612.GP11766@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Derek Dai <daiderek@gmail.com>,
        guigom@riseup.net
References: <20201120191640.21243-1-phil@nwl.cc>
 <20201121121724.GA21214@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121121724.GA21214@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sat, Nov 21, 2020 at 01:17:24PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Nov 20, 2020 at 08:16:40PM +0100, Phil Sutter wrote:
> > Derek Dai reports:
> > "If there are a lot of command in JSON node, seqnum_to_json() will slow
> > down application (eg: firewalld) dramatically since it iterate whole
> > command list every time."
> > 
> > He sent a patch implementing a lookup table, but we can do better: Speed
> > this up by introducing a hash table to store the struct json_cmd_assoc
> > objects in, taking their netlink sequence number as key.
> > 
> > Quickly tested restoring a ruleset containing about 19k rules:
> > 
> > | # time ./before/nft -jeaf large_ruleset.json >/dev/null
> > | 4.85user 0.47system 0:05.48elapsed 97%CPU (0avgtext+0avgdata 69732maxresident)k
> > | 0inputs+0outputs (15major+16937minor)pagefaults 0swaps
> > 
> > | # time ./after/nft -jeaf large_ruleset.json >/dev/null
> > | 0.18user 0.44system 0:00.70elapsed 89%CPU (0avgtext+0avgdata 68484maxresident)k
> > | 0inputs+0outputs (15major+16645minor)pagefaults 0swaps
> 
> LGTM.
> 
> BTW, Jose (he's on Cc) should rewrite his patch to exercise the
> monitor path when --echo and --json are combined _and_ input is _not_
> json.
> 
> Hence, leaving --echo and --json where input is json in the way you
> need (using the sequence number to reuse the json input
> representation).
> 
> OK?

Yes, that's fine with me!

Thanks, Phil
