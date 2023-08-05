Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDAFFC0015E
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Aug 2023 19:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjHETZD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 5 Aug 2023 15:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjHETZC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 5 Aug 2023 15:25:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F5F194
        for <netfilter-devel@vger.kernel.org>; Sat,  5 Aug 2023 12:25:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 279C860EB9
        for <netfilter-devel@vger.kernel.org>; Sat,  5 Aug 2023 19:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C3FC433C8;
        Sat,  5 Aug 2023 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691263500;
        bh=qoVovonkDlCZAGyHdpkcLhNyRI9P5U68HXbWXLRHeeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iq9AqL8t+LduND4co3bPZubsqBrA8Kkg4SFb8PFmOr1qN6jUW7tjAUfETfvySdhaX
         bAsyX9TRz7XeysHeq6AGx4fbH7Oqod9pYfgnrhOeBNoXhwWB/RJX/diSv1Wx5cDVJG
         sNBkpQx0jPieBMlbjpgSdXjkebLkRXSEoBMf6We5460yRi907NIp5PVFzLdAJ0MZMd
         5g2X6remQeEZklQa1pTIp6C4uQ5Dqdk994YVa1kBK1V+2oJzzoKI7KUYgvsHM5sKNv
         sKTxx4wuG8ak23vOgxl4TnY8xyXfbNHvS6TCeZ2Wpq+fAHwW7puNZHGJ1H38aZQQR5
         wOK4ERwfqOxNg==
Date:   Sat, 5 Aug 2023 21:24:53 +0200
From:   Simon Horman <horms@kernel.org>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: conntrack: Remove unused function
 declarations
Message-ID: <ZM6iBSr3/Sd8Uarl@vergenet.net>
References: <20230804134149.39748-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804134149.39748-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 04, 2023 at 09:41:49PM +0800, Yue Haibing wrote:
> Commit 1015c3de23ee ("netfilter: conntrack: remove extension register api")
> leave nf_conntrack_acct_fini() and nf_conntrack_labels_init() unused, remove it.
> And commit a0ae2562c6c4 ("netfilter: conntrack: remove l3proto abstraction")
> leave behind nf_ct_l3proto_try_module_get() and nf_ct_l3proto_module_put().
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>

Reviewed-by: Simon Horman <horms@kernel.org>

