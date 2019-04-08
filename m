Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B13C10F13
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 20:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595C520880
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 20:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfDHUTL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 16:19:11 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49204 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726220AbfDHUTL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 16:19:11 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hDajV-0002uU-H6; Mon, 08 Apr 2019 22:19:09 +0200
Date:   Mon, 8 Apr 2019 22:19:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Frederik Himpe <fhimpe@ai.vub.ac.be>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: 5.0.7: WARNING: CPU: 1 PID: 169 at net/netfilter/nft_compat.c:82
 and genreal protection fault
Message-ID: <20190408201909.6mcgobkdnswyikfv@breakpoint.cc>
References: <306bc8c0e81422a73ccfcd0ac3ea2d79fc1df0b0.camel@ai.vub.ac.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <306bc8c0e81422a73ccfcd0ac3ea2d79fc1df0b0.camel@ai.vub.ac.be>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Frederik Himpe <fhimpe@ai.vub.ac.be> wrote:
> I'm experiencing this reproducible bug every time shorewall6 is
> restarted:

> [   28.932323] WARNING: CPU: 1 PID: 169 at net/netfilter/nft_compat.c:82 nft_xt_put.part.9+0x21/0x30 [nft_compat]
[..]
> [   29.015565] general protection fault: 0000 [#1] SMP PTI
> [   29.015574] CPU: 3 PID: 2069 Comm: ip6tables-resto Tainted: G        W   E     5.0.7 #1

Does this problem go away when you apply this commit on top of 5.0.7?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b8e204006340b7aaf32bd2b9806c692f6e0cb38a

If not, can you send a minimal reproducer?

Thanks.
