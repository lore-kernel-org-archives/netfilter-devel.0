Return-Path: <SRS0=ickv=7I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F33C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 13:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E628207FB
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 13:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgEZNww (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 May 2020 09:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgEZNwv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 May 2020 09:52:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5623C03E96D
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2020 06:52:51 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jda0f-0004rg-US; Tue, 26 May 2020 15:52:49 +0200
Date:   Tue, 26 May 2020 15:52:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Avoid breaking basic connectivity when
 run
Message-ID: <20200526135249.GY17795@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <9742365b595a791d4bd47abee6ad6271abe0950b.1590323912.git.sbrivio@redhat.com>
 <20200525155952.GW17795@orbyte.nwl.cc>
 <20200526011236.2fe8ae7b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526011236.2fe8ae7b@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, May 26, 2020 at 01:12:36AM +0200, Stefano Brivio wrote:
> On Mon, 25 May 2020 17:59:52 +0200
> Phil Sutter <phil@nwl.cc> wrote:
> > On Sun, May 24, 2020 at 02:59:57PM +0200, Stefano Brivio wrote:
> > > It might be convenient to run tests from a development branch that
> > > resides on another host, and if we break connectivity on the test
> > > host as tests are executed, we con't run them this way.
> > > 
> > > To preserve connectivity, for shell tests, we can simply use the
> > > 'forward' hook instead of 'input' in chains/0036_policy_variable_0
> > > and transactions/0011_chain_0, without affecting test coverage.
> > > 
> > > For py tests, this is more complicated as some test cases install
> > > chains for all the available hooks, and we would probably need a
> > > more refined approach to avoid dropping relevant traffic, so I'm
> > > not covering that right now.  
> > 
> > This is a recurring issue, iptables testsuites suffer from this problem
> > as well. There it was solved by running everything in a dedicated netns:
> > 
> > iptables/tests/shell: Call testscripts via 'unshare -n <file>'.
> > iptables-test.py: If called with --netns, 'ip netns exec <foo>' is
> > added as prefix to any of the iptables commands.
> 
> Funny, I thought about doing that in the past and stopped before I could
> even type 'unshare'. Silly, everything will break, I thought.
> 
> Nope, not at all, now that you say that... both 'unshare -n
> ./nft-test.py' and 'unshare -n ./run-tests.sh' worked flawlessly.
> 
> A minor concern I have is that if CONFIG_NETNS is not set we can't do
> that. But we could add a check and run them in the init namespace if
> namespaces are not available, that looks reasonable enough.

Sounds like over-engineering, although your point is valid, of course.
In iptables shell testsuite was changed to always call unshare back in
2018, I don't think anyone has complained yet. So either everyone has
netns support already (likely, given the container inflation) or nobody
apart from hardliners actually run those tests (even more likely). :)

> > I considered doing the same in nftables testsuites several times but
> > never managed to keep me motivated enough. Maybe you want to give it a
> > try?
> 
> I would do that from the main script itself (and figure out how it
> should be done in Python, too), just once, it looks cleaner and we
> don't change how test scripts are invoked. Something like this:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/tools/testing/selftests/netfilter/nft_concat_range.sh#n1463

Maybe support a hidden parameter and do a self-call wrapped by 'unshare'
unless that parameter was passed?

Cheers, Phil
