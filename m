Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61878C43334
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Jul 2022 02:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiGBCTw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Jul 2022 22:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGBCTv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Jul 2022 22:19:51 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 634A0205F9
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2022 19:19:50 -0700 (PDT)
Date:   Sat, 2 Jul 2022 04:19:47 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: release elements in clone
 from abort path
Message-ID: <Yr+rQ3pKsQBjJAep@salvia>
References: <20220628164527.101413-1-pablo@netfilter.org>
 <20220702003928.1ae75aaa@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220702003928.1ae75aaa@elisabeth>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 02, 2022 at 12:39:28AM +0200, Stefano Brivio wrote:
[...]
> Other than that, it looks good to me.
> 
> I would also specify in the commit message that we additionally look
> for elements pointers in the cloned matching data if priv->dirty is
> set, because that means that cloned data might point to additional
> elements we didn't commit to the working copy yet (such as the abort
> path case, but perhaps not limited to it).

This v2, I forgot to tag it properly:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220702021631.796822-2-pablo@netfilter.org/

it is updating documentation and it also adds a paragraph to the
commit description as you suggested.
