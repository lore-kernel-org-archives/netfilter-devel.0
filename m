Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450BEC77B7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 May 2023 11:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjEaL3X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 May 2023 07:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjEaL3W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2023 07:29:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34FA196
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2023 04:28:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q4K00-0007Pm-Hi; Wed, 31 May 2023 13:28:16 +0200
Date:   Wed, 31 May 2023 13:28:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Eric Garver <e@erig.me>, danw@redhat.com, aauren@gmail.com
Subject: Re: [iptables PATCH 3/4] Add --compat option to *tables-nft and
 *-nft-restore commands
Message-ID: <20230531112816.GA26130@breakpoint.cc>
References: <20230505183446.28822-1-phil@nwl.cc>
 <20230505183446.28822-4-phil@nwl.cc>
 <ZHaR1M+EFjUHLOc/@calendula>
 <ZHcNDxfJmxcEEDB8@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHcNDxfJmxcEEDB8@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Then I revived my "rule bytecode for output" approach and got it working
> apart from lookup expression. But finally you axed it since it requires
> kernel adjustments.

Can you remind me what the problem with userdata is/was?
Brief summary will hopefully be enough ...

I agree text representation sucks due to two different formats, but what
about storing binary blob (xt format) of the rule in userdata?
