Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00708C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 13:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhK3NvN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 08:51:13 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50584 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhK3NvM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 08:51:12 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0DE92605C7;
        Tue, 30 Nov 2021 14:45:36 +0100 (CET)
Date:   Tue, 30 Nov 2021 14:47:49 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/15] Fix netlink debug output on Big Endian
Message-ID: <YaYrhZzHJZQYksx6@salvia>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 24, 2021 at 06:22:36PM +0100, Phil Sutter wrote:
> Make use of recent changes to libnftnl and make tests/py testsuite pass
> on Big Endian systems.
> 
> Patches 1, 2 and 3 are more or less unrelated fallout from the actual
> work but simple enough to not deserve separate submission.
> 
> Patches 4-9 fix actual bugs on Big Endian.

I think up to patch 9 should be good to be merged upstream as these
are asorted updates + actual Big Endian bugs as you describe.

Let's discuss patches start 10 and your libnftnl updates separately,
OK?

> Patch 10 is part convenience and part preparation for the following
> patches.
> 
> Patches 11 and 12 prepare for patch 13 which fixes set element dumping.
> 
> Patch 14 adds a shell script which regenerates all payload records,
> respecting the separation into family-specific files where used.
> 
> Patch 15 contains the big mess of regenerated payload records from using
> the previous patch's script. It is at the same time too large to read
> and a clear illustration of this and the respective libnftnl's patch
> series' effect.
