Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208FEC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Nov 2022 08:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiKBI1B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 04:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiKBI05 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 04:26:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FEB822515;
        Wed,  2 Nov 2022 01:26:57 -0700 (PDT)
Date:   Wed, 2 Nov 2022 09:26:52 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>, stable@vger.kernel.org
Subject: Re: [PATCH] ipvs: use explicitly signed chars
Message-ID: <Y2IpzHKuRmDA++dO@salvia>
References: <20221026123216.1575440-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221026123216.1575440-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 26, 2022 at 02:32:16PM +0200, Jason A. Donenfeld wrote:
> The `char` type with no explicit sign is sometimes signed and sometimes
> unsigned. This code will break on platforms such as arm, where char is
> unsigned. So mark it here as explicitly signed, so that the
> todrop_counter decrement and subsequent comparison is correct.

Applied, thanks
