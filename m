Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCAA6C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 11:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C0260F5A
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 11:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhKBLkF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 07:40:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60352 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhKBLkE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 07:40:04 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 50C4363F5C;
        Tue,  2 Nov 2021 12:35:36 +0100 (CET)
Date:   Tue, 2 Nov 2021 12:37:26 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nft] tests: shell: $NFT needs to be invoked unquoted
Message-ID: <YYEi9gPdID3GTGg5@salvia>
References: <20211021175438.758386-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211021175438.758386-1-snemec@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 21, 2021 at 07:54:38PM +0200, Štěpán Němec wrote:
> The variable has to undergo word splitting, otherwise the shell tries
> to find the variable value as an executable, which breaks in cases that
> 7c8a44b25c22 ("tests: shell: Allow wrappers to be passed as nft command")
> intends to support.
> 
> Mention this in the shell tests README.
> 
> Fixes: d8ccad2a2b73 ("tests: cover baecd1cf2685 ("segtree: Fix segfault when restoring a huge interval set")")
> Signed-off-by: Štěpán Němec <snemec@redhat.com>
> ---
> The test I added (0068) is the only problematic occurrence.
> 
> This would be best applied on top of the README series (otherwise
> the README still talks about $NFT being a path to a binary).

OK, then I'll mark this one as "Changed Requested" and will wait for
you to include this one in the v2 of you README series.

Thanks.
