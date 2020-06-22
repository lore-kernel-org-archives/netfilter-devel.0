Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D7EC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 04:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7F5A20702
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 04:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgFVEuV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 00:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgFVEuV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 00:50:21 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10125C061794
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2020 21:50:21 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 9606558734298; Mon, 22 Jun 2020 06:50:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 88CED60D22B93;
        Mon, 22 Jun 2020 06:50:18 +0200 (CEST)
Date:   Mon, 22 Jun 2020 06:50:18 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Florian Westphal <fw@strlen.de>
cc:     Eugene Crosser <crosser@average.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: Expose skb_gso_validate_network_len() [Was: ebtables: load-on-demand
 extensions]
In-Reply-To: <20200621235236.GN26990@breakpoint.cc>
Message-ID: <nycvar.YFH.7.77.849.2006220643340.24160@n3.vanv.qr>
References: <nycvar.YFH.7.77.849.2006161717590.16107@n3.vanv.qr> <1566db8a-00d4-d9de-8c3d-6625fe2149fa@average.org> <nycvar.YFH.7.77.849.2006161830320.16707@n3.vanv.qr> <874fd8a8-dfd2-f6c3-ae01-61884ca9bcff@average.org> <20200619151530.GA3894@salvia>
 <13977ee9-d93b-62fd-c86a-6c4466f63e38@average.org> <20200620110404.GF26990@breakpoint.cc> <2dad5797-6643-da2b-3dcf-350d1d501be1@average.org> <20200621032429.GH26990@breakpoint.cc> <nycvar.YFH.7.77.849.2006211201270.18408@n3.vanv.qr>
 <20200621235236.GN26990@breakpoint.cc>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Monday 2020-06-22 01:52, Florian Westphal wrote:
>Jan Engelhardt <jengelh@inai.de> wrote:
>> >Why?  Maybe someone wants to collect statistics on encountered packet
>> >size or something like that.
>> 
>> Possibly so, but you would not want to penalize users who do
>> want the short-circuiting behavior when they are not interested
>> in the statistics.
>
>What short-circuit behaviour?
>
>The difference we're talking about is:
>*reg = get_gso_segment_or_nh_len(skb);
>vs.
>if (!skb_is_gso(skb) || get_gso_segment_len(skb) <= priv->len))
>       regs->verdict.code = NFT_BREAK;

I was under the impression the discussion had steered on

  *reg1 = skb_gso_size_check(skb, skb_gso_validate_network_len(skb, priv->len));
  verdict = *reg1 ? NFT_CONTINUE : NFT_BREAK;

vs.

  *reg1 = 0;
  skb_walk_frags(skb, iter)
      *reg1 += seg_len + skb_headlen(iter);
  // and leave reg1 for the next nft op (lt/gt/feeding it to a counter/etc.)
