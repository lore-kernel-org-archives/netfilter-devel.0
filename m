Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDE8C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 23:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFEF023B51
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 23:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgLIXu7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 18:50:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730106AbgLIXut (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 18:50:49 -0500
Date:   Wed, 9 Dec 2020 15:50:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607557809;
        bh=W9dAN5rI9swhy8m0JMx+pOH4eDDaaA4dd5Bc2GHP24U=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=kwpDzHJ3GNyZxjgbhGxljZ3rz/wKR2D1OHkLqWXewdPnmLZGz/LDf6Y2V04yuni5T
         VdjoN5lOPJwVN78S/q7mn2BUKYn+0vpULEzWOpR+YOlXKD9IgtF3cVU8u8Wi5FKFOO
         YNrZjQ6sC+KShBrBIzVdauwAB+JgSmOHajGlBXhLtpalNYBExv6j6hNaSdWL+/oFC+
         4aYw5x9/cXy4sy3UztSrnryGLDDdqfC11ylXI7tDfwIo5j8axpalNXrEkzGQ/gLbmr
         ywEXJcM6/dJ6aEjgs/7WKGbFmJEcNcSq0knjp9/MDZD9TXdzSCws8qEkCInujiUY+c
         rWaMDBNjJHd1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sched: incorrect Kconfig dependencies on
 Netfilter modules
Message-ID: <20201209155008.42b12cfa@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208204707.11268-1-pablo@netfilter.org>
References: <20201208204707.11268-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue,  8 Dec 2020 21:47:07 +0100 Pablo Neira Ayuso wrote:
> - NET_ACT_CONNMARK and NET_ACT_CTINFO only require conntrack support.
> - NET_ACT_IPT only requires NETFILTER_XTABLES symbols, not
>   IP_NF_IPTABLES. After this patch, NET_ACT_IPT becomes consistent
>   with NET_EMATCH_IPT. NET_ACT_IPT dependency on IP_NF_IPTABLES predates
>   Linux-2.6.12-rc2 (initial git repository build).
> 
> Fixes: 22a5dc0e5e3e ("net: sched: Introduce connmark action")
> Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Doesn't seem too critical to remove unnecessary dependencies.

Applied to net-next, thanks!
