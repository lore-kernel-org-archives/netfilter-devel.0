Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED89BCDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 14:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbjJROiY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 10:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbjJROiL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 10:38:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAF8D6D;
        Wed, 18 Oct 2023 07:37:55 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qt7gF-0003IX-IA; Wed, 18 Oct 2023 16:37:51 +0200
Date:   Wed, 18 Oct 2023 16:37:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     "U.Mutlu" <um@mutluit.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, imnozi@gmail.com,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: [nftables/nft] nft equivalent of "ipset test"
Message-ID: <ZS/tv6BVsXwFN2iZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, "U.Mutlu" <um@mutluit.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, imnozi@gmail.com,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
References: <652EC034.7090501@mutluit.com>
 <20231017213507.GD5770@breakpoint.cc>
 <652F02EC.2050807@mutluit.com>
 <20231017220539.GE5770@breakpoint.cc>
 <652F0C75.8010006@mutluit.com>
 <20231017200057.57cfce21@playground>
 <ZS+nJS/4dolCsIk8@calendula>
 <652FAB56.5060200@mutluit.com>
 <ZS+srsBsJSynJ7Tm@calendula>
 <652FBC5B.5000006@mutluit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <652FBC5B.5000006@mutluit.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 18, 2023 at 01:07:07PM +0200, U.Mutlu wrote:
[...]
> Lately I've extended this to make it a 2-stage: if blocked IP
> continues sending more than x packets while in timeout of y minutes,
> then add this attacker to the second set that has a much higher timeout of z 
> minutes.
> One additional practical benefit of this approach is that
> now one sees the hardcore attackers grouped (they are those in set2).
> 
> The correct managing of these two sets requires the said
> atomicity by testing of BOTH sets before adding the IP to the first set...

I may lack context, but IMO you may simplify your scripts/algorithm:

If a daemon (or fail2ban) identifies an IP to block, it must not have
been in either of the sets (or otherwise the firewall had dropped the
packet already). So they may just unconditionally add to the first set.

Also, you may get away with a single set only:

| table t {
|   set ban {
| 	type ipv4_addr
| 	timeout 2s
|   }
| }

You may add elements like so:

| add element t ban { 1.2.3.4 timeout 5m }

I.e., override the default 2s timeout and set a larger one for
individual elements. This may happen from packet path, as well:

| add rule t input ip saddr @ban update @ban { ip saddr timeout 5m }

Cheers, Phil
