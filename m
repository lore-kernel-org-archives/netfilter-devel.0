Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6105ECAAD8
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Sep 2022 20:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbiIVUPS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 16:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiIVUPS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 16:15:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D084E72B56
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2022 13:15:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1obSbK-0000Ra-Fy; Thu, 22 Sep 2022 22:15:14 +0200
Date:   Thu, 22 Sep 2022 22:15:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Florian Westphal <fwestpha@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] tests: shell: Test delinearization of native
 nftables expressions
Message-ID: <20220922201514.GD22541@breakpoint.cc>
References: <20220922170432.5414-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922170432.5414-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Even if iptables-nft doesn't generate them anymore, it should continue
> to correctly parse them. Make sure this is tested for.

I've added this and will merge what I have with this script.
