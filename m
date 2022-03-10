Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C07C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 12:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239710AbiCJMKF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 07:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239440AbiCJMKF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 07:10:05 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D994B1470C1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 04:09:03 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nSHbI-0003XR-Aa; Thu, 10 Mar 2022 13:09:00 +0100
Date:   Thu, 10 Mar 2022 13:09:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/4] nft: Simplify immediate parsing
Message-ID: <20220310120900.GE26501@breakpoint.cc>
References: <20220302151807.12185-1-phil@nwl.cc>
 <20220302151807.12185-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302151807.12185-2-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Implementations of parse_immediate callback are mostly trivial, the only
> relevant part is access to family-specific parts of struct
> iptables_command_state when setting goto flag for iptables and
> ip6tables. Refactor them into simple set_goto_flag callbacks.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Florian Westphal <fw@strlen.de>
