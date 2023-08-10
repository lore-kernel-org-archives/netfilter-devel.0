Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBAAC04A6A
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 17:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjHJRql (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 13:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjHJRqk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 13:46:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1C62705;
        Thu, 10 Aug 2023 10:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5E316315E;
        Thu, 10 Aug 2023 17:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D40C433C7;
        Thu, 10 Aug 2023 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691689599;
        bh=EaDu9prGGj8Xp/56cS7AZW0QRKuH6aHT2nEEK5LKgzo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IM4wgmqSeXt/2KIS6PsYUllfZ6QXqbNM6KZWJr7oYG8GHY2/9ijox4yBlguCl0MCx
         VvD9Qc7isyg2L1M40rfQ6sElgnIz5Ei/+UyO9gA7sHCdPKtLtOieqKu0UOPBYSYQH7
         RJufBxiIp8IlcOvf/LIAyBQreab88AMKK75YNfajf3CdH5lpPwxdiXv2bnrc9M/Slh
         BC4VQWcx3jR7f6xpSO9S8TsyLDP6ktxPvjWy1fLRf9KzV2Ss6irvd/4x6l5JWACvJF
         y1UCrWv4l4u8i16Yh5v3aD3aEazIzxPfZBmdKQ2U2utQc29XU+OPwgs9G/CCge7Rm3
         D00i2jkulOE9A==
Date:   Thu, 10 Aug 2023 10:46:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH net 0/5] Netfilter fixes for net
Message-ID: <20230810104638.746e46f1@kernel.org>
In-Reply-To: <20230810070830.24064-1-pablo@netfilter.org>
References: <20230810070830.24064-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We've got some new kdoc warnings here:

net/netfilter/nft_set_pipapo.c:1557: warning: Function parameter or member '_set' not described in 'pipapo_gc'
net/netfilter/nft_set_pipapo.c:1557: warning: Excess function parameter 'set' description in 'pipapo_gc'
include/net/netfilter/nf_tables.h:577: warning: Function parameter or member 'dead' not described in 'nft_set'

Don't think Linus will care enough to complain but it'd be good to get
those cleaned up.
