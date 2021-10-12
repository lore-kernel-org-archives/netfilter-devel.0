Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D6DC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 12:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C558060E74
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 12:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbhJLM3f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 08:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbhJLM3f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 08:29:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E4FC06161C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Oct 2021 05:27:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1maGsW-0006mo-6b; Tue, 12 Oct 2021 14:27:32 +0200
Date:   Tue, 12 Oct 2021 14:27:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCHv2 nf] netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
Message-ID: <20211012122732.GC2942@breakpoint.cc>
References: <6ee8ec63c78925fadf0304c8a55cac73824234af.1634041093.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ee8ec63c78925fadf0304c8a55cac73824234af.1634041093.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:
> In rt_mt6(), when it's a nonlinear skb, the 1st skb_header_pointer()
> only copies sizeof(struct ipv6_rt_hdr) to _route that rh points to.
> The access by ((const struct rt0_hdr *)rh)->reserved will overflow
> the buffer. So this access should be moved below the 2nd call to
> skb_header_pointer().
> 
> Besides, after the 2nd skb_header_pointer(), its return value should
> also be checked, othersize, *rp may cause null-pointer-ref.
> 
> v1->v2:
>   - clean up some old debugging log.

Acked-by: Florian Westphal <fw@strlen.de>
