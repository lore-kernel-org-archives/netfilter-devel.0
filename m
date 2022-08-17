Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84421C25B08
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Aug 2022 06:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiHQGsS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Aug 2022 02:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHQGsQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Aug 2022 02:48:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1D8205D4;
        Tue, 16 Aug 2022 23:48:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oOCqL-0006E5-7e; Wed, 17 Aug 2022 08:47:57 +0200
Date:   Wed, 17 Aug 2022 08:47:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jan Engelhardt <jengelh@medozas.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: NF_CONNTRACK_PROCFS should no
 longer default to y
Message-ID: <20220817064757.GB12095@breakpoint.cc>
References: <1498887cf43bf7ab7c47e2a397e67bff55524f92.1660559553.git.geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498887cf43bf7ab7c47e2a397e67bff55524f92.1660559553.git.geert@linux-m68k.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> NF_CONNTRACK_PROCFS was marked obsolete in commit 54b07dca68557b09
> ("netfilter: provide config option to disable ancient procfs parts") in
> v3.3.

Applied to nf.git, thank you.
