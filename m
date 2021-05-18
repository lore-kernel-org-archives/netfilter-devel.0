Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B32BC433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 16:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A01C6113C
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 16:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344303AbhERQEG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 12:04:06 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43166 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344672AbhERQEF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 12:04:05 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8C17963089;
        Tue, 18 May 2021 18:01:51 +0200 (CEST)
Date:   Tue, 18 May 2021 18:02:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/2] nf_tables: avoid retpoline overhead on set
 lookups
Message-ID: <20210518160242.GB24307@salvia>
References: <20210513202956.22709-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210513202956.22709-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 13, 2021 at 10:29:54PM +0200, Florian Westphal wrote:
> This adds a nft_set_do_lookup() helper, then extends it to use
> direct calls when RETPOLINE feature is enabled.
> 
> For non-retpoline builds, nft_set_do_lookup() inline helper
> does a indirect call.  INDIRECT_CALLABLE_SCOPE macro allows to
> keep the lookup functions static in this case.

Applied, thanks.
