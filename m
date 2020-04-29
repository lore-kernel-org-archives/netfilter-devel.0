Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624DCC83000
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 19:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46ADE205C9
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 19:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgD2TNA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 15:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2TNA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 15:13:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0D9C03C1AE
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 12:13:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jTs8e-0000MC-7O; Wed, 29 Apr 2020 21:12:56 +0200
Date:   Wed, 29 Apr 2020 21:12:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_osf: avoid passing pointer to local var
Message-ID: <20200429191256.GL32392@breakpoint.cc>
References: <20200429190051.27993-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429190051.27993-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:
> gcc-10 points out that a code path exists where a pointer to a stack
> variable may be passed back to the caller:
> 
> net/netfilter/nfnetlink_osf.c: In function 'nf_osf_hdr_ctx_init':
> cc1: warning: function may return address of local variable [-Wreturn-local-addr]
> net/netfilter/nfnetlink_osf.c:171:16: note: declared here
>   171 |  struct tcphdr _tcph;
>       |                ^~~~~
> 
> I am not sure whether this can happen in practice, but moving the
> variable declaration into the callers avoids the problem.

LGTM, thanks Arnd.

Reviewed-by: Florian Westphal <fw@strlen.de>
