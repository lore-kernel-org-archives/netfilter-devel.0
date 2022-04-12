Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D0BC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 23:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiDLXcD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiDLXby (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 19:31:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0444A8F9BF
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 15:17:40 -0700 (PDT)
Date:   Wed, 13 Apr 2022 00:17:37 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 0/9] nftables: add support for wildcard string
 as set keys
Message-ID: <YlX6gfgq4SFPTU+B@salvia>
References: <20220409135832.17401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220409135832.17401-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 09, 2022 at 03:58:23PM +0200, Florian Westphal wrote:
> Allow to match something like
> 
> meta iifname { eth0, ppp* }.

This series LGTM, thanks for working on this.

> Set ranges or concatenations are not yet supported.
> Test passes on x86_64 and s390 (bigendian), however, the test fails dump
> validation:
> 
> -  iifname { "eth0", "abcdef0" } counter packets 0 bytes 0
> +  iifname { "abcdef0", "eth0" } counter packets 0 bytes 0

Hm. Is it reordering the listing?

> This happens with other tests as well.  Other tests fail
> on s390 too but there are no new failures.
> 
> I wil try to get string range support working and will
> then ook into concat set support.

OK, so then this is a WIP?
