Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC7EEB64DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 03:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjGSDNn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 23:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjGSDNm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 23:13:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8251BCA
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 20:13:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A922616DA
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2023 03:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED166C433C8;
        Wed, 19 Jul 2023 03:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689736420;
        bh=MCNEIFzz4msIUUVp+c7YBHexyIq1QAdwhHAR+zf0V5w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EyWkvphXPFcKR57nmr5tlsi5Ph2StInamVTxD9/Po4hVqVnsfZlongWBI+wxIfTY9
         kfb4kb/ZNTDYE9hbck3nw9HTowtRw+nIQHkz6JrXACRK4jRvMe8AiDr+Ax8P90YOPt
         JaFbbpXTOL29fBMgw68Xww8wQNMtV61K6yd9Cbsqcdgl91AHzWSr8ozy4XP5lWCywt
         ikgv0EsgGJYS+VhvezIzHtHPHw2489vmrwPF3RWL9HpXCu5QpyMPVCM/3CG56Zn+vO
         7ajMd2h0UipH9k+s7JAIfOANfldjhfplhli/HcMxZFWij73uiCXeAwxsMBllHwbake
         sIsKQ8VJNtIaQ==
Date:   Tue, 18 Jul 2023 20:13:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/2] netlink: allow be16 and be32 types in all
 uint policy checks
Message-ID: <20230718201338.3a4c5a05@kernel.org>
In-Reply-To: <20230719025323.GA27896@breakpoint.cc>
References: <20230718075234.3863-1-fw@strlen.de>
        <20230718075234.3863-2-fw@strlen.de>
        <20230718115633.3a15062d@kernel.org>
        <20230719025323.GA27896@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 19 Jul 2023 04:53:23 +0200 Florian Westphal wrote:
> > On a quick grep we were using it in the kernel -> user
> > direction but not validating on input. Is that right?  
> 
> Looks like ipset is the only user, it sets it for kernel->user
> dir.
> 
> I see ipset userspace even sets it on user -> kernel dir but
> like you say, its not checked and BE encoding is assumed on
> kernel side.
> 
> From a quick glance in ipset all Uxx types are always treated as
> bigendian, which would mean things should not fall apart if ipset
> stops announcing NLA_F_NET_BYTEORDER.  Not sure its worth risking
> any breakage though.
> 
> I suspect that in practice, given both producer and consumer need
> to agree of the meaning of type "12345" anyway its easier to just
> agree on the byte ordering as well.
> 
> Was there a specific reason for the question?

I was wondering what we should do with it going forward. Looks like it
was added by 8f4c1f9b049d ("[NETLINK]: Introduce nested and byteorder
flag to netlink attribute") which says:

    The byte-order flag is yet unused, it's intended use is to
    allow automatic byte order convertions for all atomic types.

That idea clearly never gained traction. If nobody knows of any use of
the flag outside of ipset I'm tempted to send a patch to officially
deprecate it and possibly reuse that bit for something else later on?
