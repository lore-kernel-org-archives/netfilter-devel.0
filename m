Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134E7EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 21:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjGEV3e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 17:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjGEV3d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 17:29:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6129A19BB;
        Wed,  5 Jul 2023 14:29:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qHA41-0000eq-Po; Wed, 05 Jul 2023 23:29:29 +0200
Date:   Wed, 5 Jul 2023 23:29:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] netfilter: nf_tables: prevent OOB access in
 nft_byteorder_eval
Message-ID: <20230705212929.GI3751@breakpoint.cc>
References: <20230705201232.GG3751@breakpoint.cc>
 <20230705210535.943194-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705210535.943194-1-cascardo@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thadeu Lima de Souza Cascardo <cascardo@canonical.com> wrote:
> When evaluating byteorder expressions with size 2, a union with 32-bit and
> 16-bit members is used. Since the 16-bit members are aligned to 32-bit,
> the array accesses will be out-of-bounds.
> 
> It may lead to a stack-out-of-bounds access like the one below:

Reviewed-by: Florian Westphal <fw@strlen.de>
