Return-Path: <SRS0=zc7w=DV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609B3C433E7
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 09:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 080BA20757
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 09:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgJNJsR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 05:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgJNJsR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 05:48:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82539C061755
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 02:48:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kSdOJ-00016m-Mf; Wed, 14 Oct 2020 11:48:15 +0200
Date:   Wed, 14 Oct 2020 11:48:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     timothee.cocault@orange.com
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Bug: ebtables snat drops small packets
Message-ID: <20201014094815.GB16895@breakpoint.cc>
References: <19748_1602667914_5F86C589_19748_131_22_585B71F7B267D04784B84104A88F7DEE0DB50179@OPEXCAUBM34.corporate.adroot.infra.ftgroup>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19748_1602667914_5F86C589_19748_131_22_585B71F7B267D04784B84104A88F7DEE0DB50179@OPEXCAUBM34.corporate.adroot.infra.ftgroup>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

timothee.cocault@orange.com <timothee.cocault@orange.com> wrote:
> Hi !
> 
> I noticed a bug when using the snat module of ebtables.
> If the ethernet payload of a packet is less than 12 bytes, the packet gets dropped.
> 
> I traced it down to this commit which changes calls to `skb_make_writable` to `skb_ensure_writable` :
> https://github.com/torvalds/linux/commit/c1a8311679014a79b04c039e32bde34fb68952fd
> 
> The diff gives a clear hint of the bug. For example, in `net/bridge/netfilter/ebt_snat.c` :
> 
> -   if (!skb_make_writable(skb, 0))
> +   if (skb_ensure_writable(skb, ETH_ALEN * 2))
>         return EBT_DROP;

Can you send a formal patch that fixes this up for all callers?

Thanks.
