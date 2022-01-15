Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511FEC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 19:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiAOT3l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 14:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiAOT3k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 14:29:40 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACAEC061574
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 11:29:40 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n8ok6-00075y-AG; Sat, 15 Jan 2022 20:29:38 +0100
Date:   Sat, 15 Jan 2022 20:29:38 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v2 0/5] Store multiple payload dependencies
Message-ID: <20220115192938.GD25474@breakpoint.cc>
References: <20220115182709.1999424-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220115182709.1999424-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> Patch 1 fixes a mistake in a Python test-case.

Sorry, I fat-fingered this when mangling your patch to delete the
duplicated content.

96 test files, 96 files passed, 1887 unit tests,
0 error, 0 warning

... Can't remember ever seeing all test cases pass with 0 warnings.

Applied, thanks a lot!
