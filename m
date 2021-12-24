Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE40EC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 16:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353101AbhLXP7P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 10:59:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44564 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241840AbhLXP7O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 10:59:14 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9A3C3607C1;
        Fri, 24 Dec 2021 16:56:37 +0100 (CET)
Date:   Fri, 24 Dec 2021 16:59:09 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_set_pipapo_avx2: remove redundant pointer
 lt
Message-ID: <YcXuTSFXRGPKyf0x@salvia>
References: <20211221193757.662152-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211221193757.662152-1-colin.i.king@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 21, 2021 at 07:37:57PM +0000, Colin Ian King wrote:
> The pointer lt is being assigned a value and then later
> updated but that value is never read. The pointer is
> redundant and can be removed.

Applied to nf-next, thanks
