Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F74C3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 05:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12674216F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 05:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbfHTFgL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 01:36:11 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60736 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729147AbfHTFgK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 01:36:10 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1hzwoR-00028O-3t; Tue, 20 Aug 2019 07:36:07 +0200
Date:   Tue, 20 Aug 2019 07:36:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
Message-ID: <20190820053607.GL2588@breakpoint.cc>
References: <20190820005821.2644-1-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820005821.2644-1-leonardo@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Leonardo Bras <leonardo@linux.ibm.com> wrote:
> If IPv6 is disabled on boot (ipv6.disable=1), but nft_fib_inet ends up
> dealing with a IPv6 package, it causes a kernel panic in
> fib6_node_lookup_1(), crashing in bad_page_fault.
> 
> The panic is caused by trying to deference a very low address (0x38
> in ppc64le), due to ipv6.fib6_main_tbl = NULL.
> BUG: Kernel NULL pointer dereference at 0x00000038
> 
> Fix this behavior by dropping IPv6 packages if !ipv6_mod_enabled().

Wouldn't fib_netdev.c have the same problem?

If so, might be better to place this test in both
nft_fib6_eval_type and nft_fib6_eval.

