Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07916C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Feb 2022 21:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbiBMV3B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Feb 2022 16:29:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbiBMV3B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Feb 2022 16:29:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D6053B48
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Feb 2022 13:28:54 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nJMQO-0003uf-FK; Sun, 13 Feb 2022 22:28:52 +0100
Date:   Sun, 13 Feb 2022 22:28:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [iptables PATCH 0/4] Re-enable NFLOG tests
Message-ID: <20220213212852.GA13950@breakpoint.cc>
References: <20220212165832.2452695-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220212165832.2452695-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> Some of the NFLOG tests were disabled when iptables-nft was changed to
> use nft's nflog implementation, because nft doesn't support
> `--nflog-range`.  This patch-set builds on Phil's recent work to support
> different test results for -legacy and -nft in order to re-enable those
> tests.

Series applied, thank you.
