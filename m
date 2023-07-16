Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CD1C001DE
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jul 2023 19:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjGPTYS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Jul 2023 15:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjGPTYR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Jul 2023 15:24:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320FCE4C;
        Sun, 16 Jul 2023 12:24:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4CEF60E08;
        Sun, 16 Jul 2023 19:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B9CC433C7;
        Sun, 16 Jul 2023 19:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1689535456;
        bh=8SZG6MweqQupl18LdDej1VNRU9ECsYFDQBEZInQpzss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xHEMZhV2m88eW9MLGJ672IZoAqaCmXgLzcwXdEyjFuGw52DeKpx+CXPgPjwXuIKRU
         oyKOYz23YWAXEJOPg2BTJZElO+tjMq+2PaDOrpGVfNKhTVQ+5F0+sJIj4NITE6IeSx
         IIMIMl3DbWAxi0zLp6giteCAPmQChozOw+Mzv2aM=
Date:   Sun, 16 Jul 2023 21:23:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH -stable,4.19 00/10] stable fixes for 4.19
Message-ID: <2023071646-egotism-chief-f641@gregkh>
References: <20230705165516.50145-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705165516.50145-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 05, 2023 at 06:55:06PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> The following list shows the backported patches, I am using original
> commit IDs for reference:
> 
> 1) 1e9451cbda45 ("netfilter: nf_tables: fix nat hook table deletion")
> 
> 2) 81ea01066741 ("netfilter: nf_tables: add rescheduling points during loop detection walks")
> 
> 3) 802b805162a1 ("netfilter: nftables: add helper function to set the base sequence number")
> 
> 4) 19c28b1374fb ("netfilter: add helper function to set up the nfnetlink header and use it")
> 
> 5) 0854db2aaef3 ("netfilter: nf_tables: use net_generic infra for transaction data")
> 
> 6) 1240eb93f061 ("netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE")
> 
> 7) 26b5a5712eb8 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain")
> 
> 8) 938154b93be8 ("netfilter: nf_tables: reject unbound anonymous set before commit phase")
> 
> 9) 3e70489721b6 ("netfilter: nf_tables: unbind non-anonymous set if rule construction fails")
> 
> 10) 2024439bd5ce ("netfilter: nf_tables: fix scheduling-while-atomic splat")
> 
> Please, apply,

Now queued up, thanks.

greg k-h
