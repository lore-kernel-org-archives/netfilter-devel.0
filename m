Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8EEC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Nov 2022 21:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiKVVbB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 16:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbiKVVbA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 16:31:00 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75842BF5A2;
        Tue, 22 Nov 2022 13:30:59 -0800 (PST)
Date:   Tue, 22 Nov 2022 22:30:56 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next/netfilter] netfilter: nft_inner: fix IS_ERR() vs
 NULL check
Message-ID: <Y30/kKlNvupSO20h@salvia>
References: <Y2PTO4xIJrwhcgyM@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2PTO4xIJrwhcgyM@kili>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 15, 2022 at 04:26:07PM +0300, Dan Carpenter wrote:
> The __nft_expr_type_get() function returns NULL on error.  It never
> returns error pointers.

Applied to nf-next, thanks
