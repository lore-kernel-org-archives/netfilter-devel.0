Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A27C10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B29220855
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfDIMti (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 08:49:38 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53030 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726035AbfDIMth (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 08:49:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hDqBz-0001X3-P6; Tue, 09 Apr 2019 14:49:36 +0200
Date:   Tue, 9 Apr 2019 14:49:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [ebtables PATCH] Fix segfault with missing lockfile directory
Message-ID: <20190409124935.oqk6efldzer5xhcq@breakpoint.cc>
References: <20190409122125.29658-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409122125.29658-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Apparently, dirname() modifies the buffer passed to it. Given a
> read-only location, this leads to a segfault. Use a buffer initialized
> (and tailored) to the content of LOCKFILE macro at compile-time instead.

Applied, thanks.
