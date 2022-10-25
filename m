Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F821C04A95
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Oct 2022 11:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiJYLtR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 07:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiJYLtP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 07:49:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70E09181979
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Oct 2022 04:49:15 -0700 (PDT)
Date:   Tue, 25 Oct 2022 13:49:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: reduce nft_pktinfo by 8
 bytes
Message-ID: <Y1fNM14tTqacKOGM@salvia>
References: <20221014222050.26304-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221014222050.26304-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Oct 15, 2022 at 12:20:50AM +0200, Florian Westphal wrote:
> structure is reduced from 32 to 24 bytes.  While at it, also check
> that iphdrlen is sane, this is guaranteed for NFPROTO_IPV4 but not
> for ingress or bridge, so add checks for this.

Applied to nf-next, thanks
