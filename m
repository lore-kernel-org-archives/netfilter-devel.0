Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A0DC63797
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Jan 2023 14:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjAQO7p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Jan 2023 09:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjAQO7R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2023 09:59:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C9141B60
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 06:58:07 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pHnPY-0002e7-G7; Tue, 17 Jan 2023 15:58:04 +0100
Date:   Tue, 17 Jan 2023 15:58:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] Implement 'reset rule' and 'reset rules' commands
Message-ID: <Y8a3fB86ccXiv3A9@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230112162342.2986-1-phil@nwl.cc>
 <Y8VDcq8UXg+5GD+F@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8VDcq8UXg+5GD+F@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 16, 2023 at 01:30:42PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 12, 2023 at 05:23:42PM +0100, Phil Sutter wrote:
> > Reset rule counters and quotas in kernel, i.e. without having to reload
> > them. Requires respective kernel patch to support NFT_MSG_GETRULE_RESET
> > message type.
> 
> Only thing to mention: This adds a new rule_cache_dump() call, this
> was consolidated on top of the cache infrastructure, to have a single
> spot in the code to fetch kernel objects via netlink. This triggers to
> netlink dumps, one to populate the cache and another for the reset,
> right?

Well, rule_cache_dump() becomes dual-use, because the rule reset call is
so similar to the regular rule dump one.

I also changed it to allow turning the actual dump off (by sending
NLM_F_ACK instead of NLM_F_DUMP to kernel). This is used for resetting a
single rule (identified by rule-handle). Same functionality as with
resetting (a single) quota instead of "quotas".

If dump is active, the kernel returns the rules that have been reset to
user space, so users see the last state data. To correctly print this,
nft needs a table and chain cache. My v2 has this wrong, it needlessly
requests a rule cache also. Thanks for making me validate this aspect of
the implementation! :)

The only caveat I just noticed with reduced cache is that "whole ruleset
reset" does not print the rules because list_rule_cb() expects h->family
to be set. Making it accept NFPROTO_UNSPEC is trivial, though.

Cheers, Phil
