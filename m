Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8576BC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 12:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbiCJMPm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 07:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241927AbiCJMPj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 07:15:39 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0AD148643
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 04:14:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nSHge-0003Zx-O5; Thu, 10 Mar 2022 13:14:32 +0100
Date:   Thu, 10 Mar 2022 13:14:32 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/4] nft: Don't pass command state opaque to
 family ops callbacks
Message-ID: <20220310121432.GG26501@breakpoint.cc>
References: <20220302151807.12185-1-phil@nwl.cc>
 <20220302151807.12185-5-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302151807.12185-5-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> There are no family-specific versions of struct iptables_command_state
> anymore, so no need to hide it behind void pointer. Pass the type as-is
> and save a few casts.

Thanks, that is a good improvement to have.

Acked-by: Florian Westphal <fw@strlen.de>
