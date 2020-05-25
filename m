Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D18C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 15:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD7502071A
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 15:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390998AbgEYP7y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 11:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388211AbgEYP7y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 11:59:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4829FC061A0E
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 08:59:54 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jdFW4-0006AQ-Pu; Mon, 25 May 2020 17:59:52 +0200
Date:   Mon, 25 May 2020 17:59:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Avoid breaking basic connectivity when
 run
Message-ID: <20200525155952.GW17795@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <9742365b595a791d4bd47abee6ad6271abe0950b.1590323912.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9742365b595a791d4bd47abee6ad6271abe0950b.1590323912.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sun, May 24, 2020 at 02:59:57PM +0200, Stefano Brivio wrote:
> It might be convenient to run tests from a development branch that
> resides on another host, and if we break connectivity on the test
> host as tests are executed, we con't run them this way.
> 
> To preserve connectivity, for shell tests, we can simply use the
> 'forward' hook instead of 'input' in chains/0036_policy_variable_0
> and transactions/0011_chain_0, without affecting test coverage.
> 
> For py tests, this is more complicated as some test cases install
> chains for all the available hooks, and we would probably need a
> more refined approach to avoid dropping relevant traffic, so I'm
> not covering that right now.

This is a recurring issue, iptables testsuites suffer from this problem
as well. There it was solved by running everything in a dedicated netns:

iptables/tests/shell: Call testscripts via 'unshare -n <file>'.
iptables-test.py: If called with --netns, 'ip netns exec <foo>' is
added as prefix to any of the iptables commands.

I considered doing the same in nftables testsuites several times but
never managed to keep me motivated enough. Maybe you want to give it a
try?

Cheers, Phil
