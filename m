Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB48CDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 11:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjJRLuI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 07:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjJRLuH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 07:50:07 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96DDF7;
        Wed, 18 Oct 2023 04:50:05 -0700 (PDT)
Received: from [78.30.34.192] (port=45006 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qt53o-00ClTF-G1; Wed, 18 Oct 2023 13:50:02 +0200
Date:   Wed, 18 Oct 2023 13:49:59 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "U.Mutlu" <um@mutluit.com>
Cc:     imnozi@gmail.com, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
Subject: Re: [nftables/nft] nft equivalent of "ipset test"
Message-ID: <ZS/GZxyC4vTx3Ln2@calendula>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <652FBC5B.5000006@mutluit.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 18, 2023 at 01:07:07PM +0200, U.Mutlu wrote:
> Pablo Neira Ayuso wrote on 10/18/23 12:00:
> > On Wed, Oct 18, 2023 at 11:54:30AM +0200, U.Mutlu wrote:
[...]
> > > I just don't understand why the author cannot simply add a real 'test'
> > > function to the nft tool...
> > 
> > I just don't understand your usecase :-), why do you need this atomic
> > check on two different sets?
> > 
> > Could you explain your ruleset in more detail?
> 
> It's maybe complicated: I've a restrictive firewall where
> the default is to block all ports for traffic from INPUT,
> except those explicitly allowed.

INPUT is late if you know what ports you want to allow, use
netdev/ingress instead.

> Then, at the end of the firewall rules I can _auto-add_ all
> the unhandled IPs to such a set for blocking. The blocking
> happens at top by testing whether the IP is in that set.

This should be easy to handle with a dynamic set, which allows for
packet path to add elements to set.

> But another feature of this solution is that not only
> the firewall can (auto-) add IPs to the set for blocking,
> but also the external handlers after ACCEPT can do it,
> ie. say a mailserver. It too has to be able to add an IP
> to the same set for  blocking. The blockign itself happens
> centrally in the firewall script at the next attempt of the attacker.
> 
> Lately I've extended this to make it a 2-stage: if blocked IP
> continues sending more than x packets while in timeout of y minutes,
> then add this attacker to the second set that has a much higher timeout of z
> minutes.
>
> One additional practical benefit of this approach is that
> now one sees the hardcore attackers grouped (they are those in set2).
> 
> The correct managing of these two sets requires the said
> atomicity by testing of BOTH sets before adding the IP to the first set...
>
> If you have got a better solution for this use-case,
> so let me/us know please. As said I'm new even to ipset
> but which I find very effective & useful in practice.

You should look at nftables concatenations, you do not have to split
this information accross two sets in nftables. For adding entries from
packet path, have a look at dynamic sets.

Two sets also means two lookups from packet path.

> If you have got a better solution for this use-case,
> so let me/us know please. As said I'm new even to ipset
> but which I find very effective & useful in practice.
> As said I'm still continuing using iptables with ipset,
> just evaluating whether it would make sense to switch to nftables/nft,
> though the learning-curve seems not that small, IMO.

You pick your poison. I keep listening to this argument, I think
things got a lot better. There is still room to improve documentation,
that I can take. I don't think it makes sense to start a firewall with
iptables/ipset in 2023.
