Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A6CC433ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 12:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 672A36109E
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 12:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhDZMic (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 08:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbhDZMib (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 08:38:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7233CC061574;
        Mon, 26 Apr 2021 05:37:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lb0Uh-0000Ow-KO; Mon, 26 Apr 2021 14:37:43 +0200
Date:   Mon, 26 Apr 2021 14:37:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack: Add conntrack helper for
 ESP/IPsec
Message-ID: <20210426123743.GB975@breakpoint.cc>
References: <20210414154021.GE14932@breakpoint.cc>
 <20210420223514.10827-1-Cole.Dishington@alliedtelesis.co.nz>
 <20210426115401.GB19277@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426115401.GB19277@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> I have a few more concerns:
[..]

Forgot to add that it would be good to have add a selftest for this feature
to tools/testing/selftests/netfilter/
