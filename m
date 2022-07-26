Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B6EC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jul 2022 13:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiGZN1J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 09:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiGZN1J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 09:27:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A9283A6
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2022 06:27:04 -0700 (PDT)
Date:   Tue, 26 Jul 2022 15:26:58 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Domingo Dirutigliano <pwnzer0tt1@proton.me>
Subject: Re: [PATCH nf] netfilter: nf_queue: do not allow packet truncation
 below transport header offset
Message-ID: <Yt/roiIPwtTFbVXk@salvia>
References: <20220726104206.2036-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220726104206.2036-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 26, 2022 at 12:42:06PM +0200, Florian Westphal wrote:
> Domingo Dirutigliano and Nicola Guerrera report kernel panic when
> sending nf_queue verdict with 1-byte nfta_payload attribute.
> 
> The IP/IPv6 stack pulls the IP(v6) header from the packet after the
> input hook.
> 
> If user truncates the packet below the header size, this skb_pull() will
> result in a malformed skb (skb->len < 0).
> 
> Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
> Reported-by: Domingo Dirutigliano <pwnzer0tt1@proton.me>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> Signed-off-by: Florian Westphal <fw@strlen.de>
