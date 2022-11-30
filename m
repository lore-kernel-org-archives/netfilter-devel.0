Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5C7C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 14:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiK3OrX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 09:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiK3OrW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 09:47:22 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972902FA6D
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 06:47:21 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p0OMq-0003HA-1O; Wed, 30 Nov 2022 15:47:20 +0100
Date:   Wed, 30 Nov 2022 15:47:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [RFC ebtables-nft] unify ether type and meta protocol decoding
Message-ID: <Y4ds+Pk4ZrR+NxtT@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20221130113718.85576-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130113718.85576-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 30, 2022 at 12:37:18PM +0100, Florian Westphal wrote:
> Handle "ether protocol" and "meta protcol" the same.
> 
> Problem is that this breaks the test case *again*:
> 
> I: [EXECUTING]   iptables/tests/shell/testcases/ebtables/0006-flush_0
> --A FORWARD --among-dst fe:ed:ba:be:13:37=10.0.0.1 -j ACCEPT
> --A OUTPUT --among-src c0:ff:ee:90:0:0=192.168.0.1 -j DROP
> +-A FORWARD -p IPv4 --among-dst fe:ed:ba:be:13:37=10.0.0.1 -j ACCEPT
> +-A OUTPUT -p IPv4 --among-src c0:ff:ee:90:0:0=192.168.0.1 -j DROP
> 
> ... because ebtables-nft will now render meta protocol as "-p IPv4".
> 
> ebtables-legacy does not have any special handling for this.
> 
> Solving this would need more internal annotations during decode, so
> we can suppress/ignore "meta protocol" once a "among-type" set is
> encountered.
> 
> Any (other) suggestions?

Since ebtables among does not support IPv6, match elimination should be
pretty simple, no? Entirely untested:

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 08c93feeba2c9..0daebfd983127 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -520,6 +520,10 @@ static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
        if (set_elems_to_among_pairs(among_data->pairs + poff, s, cnt))
                xtables_error(OTHER_PROBLEM,
                              "ebtables among pair parsing failed");
+
+       if (!(ctx->cs.eb.bitmask & EBT_NOPROTO) &&
+           ctx->cs.eb.ethproto == htons(0x0800))
+               ctx->cs.eb.bitmask |= EBT_NOPROTO;
 }
 
 static void parse_watcher(void *object, struct ebt_match **match_list,

Cheers, Phil
