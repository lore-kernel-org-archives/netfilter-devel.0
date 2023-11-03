Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FEFC4167D
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 09:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346953AbjKCJS1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 05:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346878AbjKCJSZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 05:18:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58170DE;
        Fri,  3 Nov 2023 02:18:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qyqJV-0004lH-Ne; Fri, 03 Nov 2023 10:18:01 +0100
Date:   Fri, 3 Nov 2023 10:18:01 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_tables: fix pointer math issue in
 nft_byteorder_eval()
Message-ID: <20231103091801.GA8035@breakpoint.cc>
References: <15fdceb5-2de5-4453-98b3-cfa9d486e8da@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15fdceb5-2de5-4453-98b3-cfa9d486e8da@moroto.mountain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dan Carpenter <dan.carpenter@linaro.org> wrote:
> The problem is in nft_byteorder_eval() where we are iterating through a
> loop and writing to dst[0], dst[1], dst[2] and so on...  On each
> iteration we are writing 8 bytes.  But dst[] is an array of u32 so each
> element only has space for 4 bytes.  That means that every iteration
> overwrites part of the previous element.
> 
> I spotted this bug while reviewing commit caf3ef7468f7 ("netfilter:
> nf_tables: prevent OOB access in nft_byteorder_eval") which is a related
> issue.  I think that the reason we have not detected this bug in testing
> is that most of time we only write one element.

LGTM, thanks Dan.  We will route this via nf.git.
