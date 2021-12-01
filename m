Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646D4C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 11:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243327AbhLAL3j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 06:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbhLAL3i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 06:29:38 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1D5C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 03:26:16 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1msNkc-00054o-DU; Wed, 01 Dec 2021 12:26:14 +0100
Date:   Wed, 1 Dec 2021 12:26:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>, phil@nwl.cc
Subject: Re: [PATCH nft] tests: shell: better parameters for the interval
 stack overflow test
Message-ID: <20211201112614.GB2315@breakpoint.cc>
References: <20211201111200.424375-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211201111200.424375-1-snemec@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Štěpán Němec <snemec@redhat.com> wrote:
> Wider testing has shown that 128 kB stack is too low (e.g. for systems
> with 64 kB page size), leading to false failures in some environments.

We could try to get rid of large on-stack allocations and always malloc
instead.
