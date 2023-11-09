Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39440C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 23:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjKIX3H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 18:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjKIX3G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 18:29:06 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA60420F
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 15:29:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r1ESN-0006Mx-Ac; Fri, 10 Nov 2023 00:29:03 +0100
Date:   Fri, 10 Nov 2023 00:29:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, thaller@redhat.com, fw@strlen.de
Subject: Re: [PATCH nft 00/12] update tests/shell for 5.4 kernels
Message-ID: <20231109232903.GH8000@breakpoint.cc>
References: <20231109162304.119506-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109162304.119506-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi,
> 
> This is still not complete, still 8 tests/shell fail in 5.4 related to
> flowtable features that are missing, but this batch is already getting large.

Thats fine, you can push what you have.
