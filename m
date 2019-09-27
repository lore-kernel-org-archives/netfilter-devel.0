Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD25C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 200F92146E
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfI0OU3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 10:20:29 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50262 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726926AbfI0OU3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 10:20:29 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iDr6h-0002Xv-QA; Fri, 27 Sep 2019 16:20:27 +0200
Date:   Fri, 27 Sep 2019 16:20:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 04/24] nft: Fix for add and delete of same
 rule in single batch
Message-ID: <20190927142027.GE9938@breakpoint.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
 <20190925212605.1005-5-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925212605.1005-5-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Another corner-case found when extending restore ordering test: If a
> delete command in a dump referenced a rule added earlier within the same
> dump, kernel would reject the resulting NFT_MSG_DELRULE command.
> 
> Catch this by assigning the rule to delete a RULE_ID value if it doesn't
> have a handle yet. Since __nft_rule_del() does not duplicate the
> nftnl_rule object when creating the NFT_COMPAT_RULE_DELETE command, this
> RULE_ID value is added to both NEWRULE and DELRULE commands - exactly
> what is needed to establish the reference.

Acked-by: Florian Westphal <fw@strlen.de>
