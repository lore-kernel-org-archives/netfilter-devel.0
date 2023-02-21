Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D19C636D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Feb 2023 18:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjBUSiY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Feb 2023 13:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjBUSiT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2023 13:38:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC54B17CDA
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 10:38:16 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pUXWn-0001Sk-Tj; Tue, 21 Feb 2023 19:38:13 +0100
Date:   Tue, 21 Feb 2023 19:38:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] netlink_delinearize: Sanitize concat data element
 decoding
Message-ID: <20230221183813.GD12484@breakpoint.cc>
References: <20230221182133.11746-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221182133.11746-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> The call to netlink_get_register() might return NULL, catch this before
> dereferencing the pointer.
> 
> Fixes: db59a5c1204c9 ("netlink_delinearize: fix decoding of concat data element")

Acked-by: Florian Westphal <fw@strlen.de>
