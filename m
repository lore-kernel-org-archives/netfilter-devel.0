Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26562C77B7A
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 09:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjFAJhe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 05:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjFAJhd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 05:37:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8643107
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jun 2023 02:37:28 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1q4ekH-0003FS-Bc; Thu, 01 Jun 2023 11:37:25 +0200
Date:   Thu, 1 Jun 2023 11:37:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: nftables: Writers starve readers
Message-ID: <ZHhm1dn6L1BUAQKK@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

I'm currently triaging a case where 'nft list ruleset' happens to take
more than 60s which causes trouble in the calling code. It is not
entirely clear what happens on the system that leads to this, so I'm
checking "suspicious" cases. One of them is "too many ruleset updates",
and indeed the following script is problematic:

| # init
| iptables-nft -N foo
| (
| 	echo "*filter";
| 	for ((i = 0; i < 100000; i++)); do
| 		echo "-A foo -m comment --comment \"rule $i\" -j ACCEPT"
| 	done
| 	echo "COMMIT"
| ) | iptables-nft-restore --noflush
| 
| # flood
| while true; do
| 	iptables-nft -A foo -j ACCEPT
| 	iptables-nft -D foo -j ACCEPT
| done

A call to 'nft list ruleset' in a second terminal hangs without output.
It apparently hangs in nft_cache_update() because rule_cache_dump()
returns EINTR. On kernel side, I guess it stems from
nl_dump_check_consistent() in __nf_tables_dump_rules(). I haven't
checked, but the generation counter likely increases while dumping the
100k rules.

One may deem this scenario unrealistic, but I had to insert a 'sleep 5'
into the while-loop to unblock 'nft list ruleset' again. A new rule
every 4s especially in such a large ruleset is not that unrealistic IMO.

I wonder if we can provide some fairness to readers? Ideally a reader
would just see the ruleset as it was when it started dumping, but
keeping a copy of the large ruleset is probably not feasible.

Cheers, Phil
