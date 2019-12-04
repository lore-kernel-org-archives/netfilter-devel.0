Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746BEC43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 13:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 526B520659
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 13:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfLDNqO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 08:46:14 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:49586 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727828AbfLDNqO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 08:46:14 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1icUyp-0004ep-Ty; Wed, 04 Dec 2019 14:46:11 +0100
Date:   Wed, 4 Dec 2019 14:46:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] extensions: CLUSTERIP: Mark as deprecated in
 man page
Message-ID: <20191204134611.GU795@breakpoint.cc>
References: <20191204130921.2914-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204130921.2914-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Kernel even warns if being used, reflect its state in man page, too.

Acked-by: Florian Westphal <fw@strlen.de>
