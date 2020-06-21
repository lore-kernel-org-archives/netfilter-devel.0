Return-Path: <SRS0=hx3k=AC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFB5C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jun 2020 03:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B97247C9
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jun 2020 03:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgFUDYi convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jun 2020 23:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729165AbgFUDYi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jun 2020 23:24:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E48C061794
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2020 20:24:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jmqar-0003sO-RU; Sun, 21 Jun 2020 05:24:29 +0200
Date:   Sun, 21 Jun 2020 05:24:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eugene Crosser <crosser@average.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: Expose skb_gso_validate_network_len() [Was: ebtables:
 load-on-demand extensions]
Message-ID: <20200621032429.GH26990@breakpoint.cc>
References: <76cd59a3-6403-9408-1b8c-af5f11d5fa85@average.org>
 <nycvar.YFH.7.77.849.2006161717590.16107@n3.vanv.qr>
 <1566db8a-00d4-d9de-8c3d-6625fe2149fa@average.org>
 <nycvar.YFH.7.77.849.2006161830320.16707@n3.vanv.qr>
 <874fd8a8-dfd2-f6c3-ae01-61884ca9bcff@average.org>
 <20200619151530.GA3894@salvia>
 <13977ee9-d93b-62fd-c86a-6c4466f63e38@average.org>
 <20200620110404.GF26990@breakpoint.cc>
 <2dad5797-6643-da2b-3dcf-350d1d501be1@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <2dad5797-6643-da2b-3dcf-350d1d501be1@average.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eugene Crosser <crosser@average.org> wrote:
> > No, nft already has "< $value" logic.
> > The only missing piece of the puzzle is a way to populate an nft
> > register with the "size per segment" value.
> 
> I don't think that it works. `skb_gso_network_seglen()` gives the (same for all
> segments) segment length _only_ when `shinfo->gso_size != GSO_BY_FRAGS`. If we
> were to expose maximum segment length for skbs with `gso_size == GSO_BY_FRAGS`,
> we'd need a new function that basically replicates the functionality of
> `skb_gso_size_check()` and performs `skb_walk_frags()`, only instead of
> returning `false` on first violation finds and then returns the maximum
> encoutered value.

Yes.
 
> That means we'd need to introduce a new function for the sole purpose of making
> the proposed check fit in the "less-equal-greater" model.

Yes and no.

> And the only practical
> use of the feature is to check "fits-doesn't fit" anyway.

Why?  Maybe someone wants to collect statistics on encountered packet
size or something like that.

(Yes, they could also use tcpdump of course).

Or maybe someone wants to do QoS markings on packet sizes, so tehy could
have a map like

{ 0 - 64 : 0x1, 65-1280 : 0x2, 1281-1400 : 0x3 } or whatever.

Point is that nft tries to provide only basic building blocks and allow
users to plumb this together.

> Do you think this is a valid argument to implement a boolean predicate rather
> than expose an arithmetic value?

I would rather see an arithmetic value.

GSO_BY_FRAGS should not occur in forwarding path nornally, but I guess
it might show up with veth coming from a VM, and I indeed forgot about it.
