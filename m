Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04C7C001E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 11:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbjHPLQ5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 07:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244521AbjHPLQx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 07:16:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60D7E40;
        Wed, 16 Aug 2023 04:16:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63B8064E67;
        Wed, 16 Aug 2023 11:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E48C433C7;
        Wed, 16 Aug 2023 11:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692184611;
        bh=wfhySSnPK75SKJ9vyK9+QFR5+bImMQwF+/PIQmTua/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NI7KTXynb5crT3rAJwh9tudjya++J9+kamFqQjnVdxIWmv+inAgkrelMfl8d+Vg4U
         KU5PNDU4WAmY24PvegTFeIysG1P5Av4P/WgCg+FOu384kbsN7M4w7FEH2MTNu9k4DO
         P1RVMmI7lwqMXeZYwcGw7+bSh2fpVfy2K8Y8OvDraxNASkMGn+UYoYnMsoXflMwdKA
         O1HUknXRSyp8upNJfiT0CJ542nONDCsz8oFucll8yfF68QFhw8+W5Pzvjtul7sHzWw
         gFHQAk8LKUKLYmtQGFq6/SUKjAziJfDhEgw2xuj6HFg1SAX6WSvfjpQ2uh4oEduXqE
         PrGbtWqgXM2Kw==
Date:   Wed, 16 Aug 2023 13:16:46 +0200
From:   Simon Horman <horms@kernel.org>
To:     "GONG, Ruiqi" <gongruiqi@huaweicloud.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, gongruiqi1@huawei.com
Subject: Re: [PATCH net-next v2] netfilter: ebtables: replace zero-length
 array members
Message-ID: <ZNywHiWhaL6pRZsd@vergenet.net>
References: <20230816093443.1460204-1-gongruiqi@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230816093443.1460204-1-gongruiqi@huaweicloud.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 16, 2023 at 05:34:43PM +0800, GONG, Ruiqi wrote:
> From: "GONG, Ruiqi" <gongruiqi1@huawei.com>
> 
> As suggested by Kees[1], replace the old-style 0-element array members
> of multiple structs in ebtables.h with modern C99 flexible array.
> 
> [1]: https://lore.kernel.org/all/5E8E0F9C-EE3F-4B0D-B827-DC47397E2A4A@kernel.org/
> 
> Link: https://github.com/KSPP/linux/issues/21
> Signed-off-by: GONG, Ruiqi <gongruiqi1@huawei.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
> 
> v2: designate to net-next; cc more netdev maintainers

It's slightly unclear to me if this should be targeting
net-next or nf-next. But regardless, it doesn't seem
to apply cleanly to the main branch of either tree.

Please consider resolving that and posting again,
being sure to allow 24h before postings.

Link: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

-- 
pw-bot: changes-requested
