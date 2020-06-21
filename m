Return-Path: <SRS0=hx3k=AC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708C8C433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jun 2020 10:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C67248B0
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jun 2020 10:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgFUKD1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jun 2020 06:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729628AbgFUKD1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jun 2020 06:03:27 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97166C061794
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2020 03:03:26 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 67D4F58734288; Sun, 21 Jun 2020 12:03:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 63F5460D93F84;
        Sun, 21 Jun 2020 12:03:23 +0200 (CEST)
Date:   Sun, 21 Jun 2020 12:03:23 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Florian Westphal <fw@strlen.de>
cc:     Eugene Crosser <crosser@average.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: Expose skb_gso_validate_network_len() [Was: ebtables: load-on-demand
 extensions]
In-Reply-To: <20200621032429.GH26990@breakpoint.cc>
Message-ID: <nycvar.YFH.7.77.849.2006211201270.18408@n3.vanv.qr>
References: <76cd59a3-6403-9408-1b8c-af5f11d5fa85@average.org> <nycvar.YFH.7.77.849.2006161717590.16107@n3.vanv.qr> <1566db8a-00d4-d9de-8c3d-6625fe2149fa@average.org> <nycvar.YFH.7.77.849.2006161830320.16707@n3.vanv.qr> <874fd8a8-dfd2-f6c3-ae01-61884ca9bcff@average.org>
 <20200619151530.GA3894@salvia> <13977ee9-d93b-62fd-c86a-6c4466f63e38@average.org> <20200620110404.GF26990@breakpoint.cc> <2dad5797-6643-da2b-3dcf-350d1d501be1@average.org> <20200621032429.GH26990@breakpoint.cc>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Sunday 2020-06-21 05:24, Florian Westphal wrote:

>Eugene Crosser <crosser@average.org> wrote:
>> > No, nft already has "< $value" logic.
>> > The only missing piece of the puzzle is a way to populate an nft
>> > register with the "size per segment" value.
>> 
>> I don't think that it works. `skb_gso_network_seglen()` gives the (same for all
>> segments) segment length _only_ when `shinfo->gso_size != GSO_BY_FRAGS`. If we
>> were to expose maximum segment length for skbs with `gso_size == GSO_BY_FRAGS`,
>> we'd need a new function that basically replicates the functionality of
>> `skb_gso_size_check()` and performs `skb_walk_frags()`, only instead of
>> returning `false` on first violation finds and then returns the maximum
>> encoutered value.
>
>Yes.
> 
>> That means we'd need to introduce a new function for the sole purpose of making
>> the proposed check fit in the "less-equal-greater" model.
>
>Yes and no.
>
>> And the only practical
>> use of the feature is to check "fits-doesn't fit" anyway.
>
>Why?  Maybe someone wants to collect statistics on encountered packet
>size or something like that.

Possibly so, but you would not want to penalize users who do
want the short-circuiting behavior when they are not interested
in the statistics.
