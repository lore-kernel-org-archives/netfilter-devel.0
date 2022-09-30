Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2257DC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Sep 2022 13:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiI3NPc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 09:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiI3NPb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 09:15:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 194E44BD12
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 06:15:10 -0700 (PDT)
Date:   Fri, 30 Sep 2022 15:15:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] monitor: Sanitize startup race condition
Message-ID: <Yzbr2l+oH6ilq2l0@salvia>
References: <20220928223248.25933-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220928223248.25933-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 29, 2022 at 12:32:48AM +0200, Phil Sutter wrote:
> During startup, 'nft monitor' first fetches the current ruleset and then
> keeps this cache up to date based on received events. This is racey, as
> any ruleset changes in between the initial fetch and the socket opening
> are not recognized.
> 
> This script demonstrates the problem:
> 
> | #!/bin/bash
> |
> | while true; do
> | 	nft flush ruleset
> | 	iptables-nft -A FORWARD
> | done &
> | maniploop=$!
> |
> | trap "kill $maniploop; kill \$!; wait" EXIT
> |
> | while true; do
> | 	nft monitor rules >/dev/null &
> | 	sleep 0.2
> | 	kill $!
> | done
> 
> If the table add event is missed, the rule add event callback fails to
> deserialize the rule and calls abort().
> 
> Avoid the inconvenient program exit by returning NULL from
> netlink_delinearize_rule() instead of aborting and make callers check
> the return value.

Fine to apply this meanwhile.

I wanted to fix this, but I found a few kernel bugs at that time, such as:

commit 6fb721cf781808ee2ca5e737fb0592cc68de3381
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Sun Sep 26 09:59:35 2021 +0200

    netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification

which were not allowing me to infer the location accordingly, for
incrementally updating the cache.

So I stopped for a while until these fixes propagate to the kernel.

It's been 1 year even since, times flies...
