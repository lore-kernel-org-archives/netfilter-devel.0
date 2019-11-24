Return-Path: <SRS0=BgG3=ZQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFE0C432C0
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Nov 2019 14:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 723B520748
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Nov 2019 14:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfKXOpv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Nov 2019 09:45:51 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39226 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbfKXOpv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Nov 2019 09:45:51 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iYt91-00083J-MF; Sun, 24 Nov 2019 15:45:47 +0100
Date:   Sun, 24 Nov 2019 15:45:47 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/1] src: Comment-out code not needed
 since Linux 3.8 in examples/nf-queue.c
Message-ID: <20191124144547.GB21689@breakpoint.cc>
References: <20191123051657.18308-1-duncan_roe@optusnet.com.au>
 <20191123051657.18308-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191123051657.18308-2-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> This makes it clear which lines are no longer required.
> It also obviates the need to document NFQNL_CFG_CMD_PF_(UN)BIND.

Why not simply #if 0 this code?

Or just delete it, v3.8 was released almost 7 years ago.
