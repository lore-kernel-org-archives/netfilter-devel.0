Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A6EC001DE
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 09:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235532AbjG1JhQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 05:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbjG1JhP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 05:37:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFB8A2
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 02:37:14 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qPJuK-0004VB-7U; Fri, 28 Jul 2023 11:37:12 +0200
Date:   Fri, 28 Jul 2023 11:37:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, igor@gooddata.com
Subject: Re: [iptables PATCH 0/3] Follow-up on dangling set fix
Message-ID: <ZMOMSHrTOMXgGLpy@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, igor@gooddata.com
References: <20230715125928.18395-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230715125928.18395-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 15, 2023 at 02:59:25PM +0200, Phil Sutter wrote:
> While testing/analyzing the changes in commit 4e95200ded923, I noticed
> comparison of rules containing among matches was not behaving right. In
> fact, most part of the among match data was ignored when comparing, due
> to the way among extension scales its payload. This problem exists since
> day 1 of the extension implementation for ebtables-nft. Patch 1 fixes
> this by placing a hash of the "invisible" data in well-known space.
> 
> Patch 2 is a minor cleanup of commit 4e95200ded923, eliminating some
> ineffective function signature changes.
> 
> Patch 3 adds set (with element) dumps to debug output.
> 
> Note about 4e95200ded923 itself: I don't quite like the approach of
> conditionally converting a rule into libnftnl format using only compat
> expressions for extensions. I am aware my proposed compatibility mode
> does the same, but it's a global switch changing add_match() behaviour
> consistently. What the commit above does works only because for rule
> comparison, both rules are converted back into iptables_command_state
> objects. I'd like to follow an alternative path of delaying the
> rule conversion so that it does not happen in nft_cmd_new() but later
> from nft_action() (or so). This should eliminate some back-and-forth and
> also implicitly fix the case of needless set creation.
> 
> Phil Sutter (3):
>   extensions: libebt_among: Fix for false positive match comparison
>   nft: Do not pass nft_rule_ctx to add_nft_among()
>   nft: Include sets in debug output

Applied the last two patches of this series. Patch 1 turned out to be
ineffective (due to frequent collisions). A proper solution is contained
in commit 10583537004f7 ("nft: Special casing for among match in
compare_matches()").
