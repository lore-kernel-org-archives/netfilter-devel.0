Return-Path: <SRS0=hx3k=AC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F72DC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jun 2020 23:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23269252F1
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jun 2020 23:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbgFUXwj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jun 2020 19:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgFUXwj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jun 2020 19:52:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CBFC061794
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2020 16:52:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jn9lM-0008MO-3N; Mon, 22 Jun 2020 01:52:36 +0200
Date:   Mon, 22 Jun 2020 01:52:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Florian Westphal <fw@strlen.de>,
        Eugene Crosser <crosser@average.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: Expose skb_gso_validate_network_len() [Was: ebtables:
 load-on-demand extensions]
Message-ID: <20200621235236.GN26990@breakpoint.cc>
References: <nycvar.YFH.7.77.849.2006161717590.16107@n3.vanv.qr>
 <1566db8a-00d4-d9de-8c3d-6625fe2149fa@average.org>
 <nycvar.YFH.7.77.849.2006161830320.16707@n3.vanv.qr>
 <874fd8a8-dfd2-f6c3-ae01-61884ca9bcff@average.org>
 <20200619151530.GA3894@salvia>
 <13977ee9-d93b-62fd-c86a-6c4466f63e38@average.org>
 <20200620110404.GF26990@breakpoint.cc>
 <2dad5797-6643-da2b-3dcf-350d1d501be1@average.org>
 <20200621032429.GH26990@breakpoint.cc>
 <nycvar.YFH.7.77.849.2006211201270.18408@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.77.849.2006211201270.18408@n3.vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> wrote:
> >Why?  Maybe someone wants to collect statistics on encountered packet
> >size or something like that.
> 
> Possibly so, but you would not want to penalize users who do
> want the short-circuiting behavior when they are not interested
> in the statistics.

What short-circuit behaviour?

The difference we're talking about is:

*reg = get_gso_segment_or_nh_len(skb);

vs.

if (!skb_is_gso(skb) ||
    get_gso_segment_len(skb) <= priv->len))
       regs->verdict.code = NFT_BREAK;
