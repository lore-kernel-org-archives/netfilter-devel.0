Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E90AEC433ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 01:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA9F160FE6
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 01:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhDZBWN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Apr 2021 21:22:13 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49768 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhDZBWN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Apr 2021 21:22:13 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id EFD9F605A8;
        Mon, 26 Apr 2021 03:20:55 +0200 (CEST)
Date:   Mon, 26 Apr 2021 03:21:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nat: move nf_xfrm_me_harder to where
 it is used
Message-ID: <20210426012129.GA30979@salvia>
References: <20210419161649.24120-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210419161649.24120-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 19, 2021 at 06:16:49PM +0200, Florian Westphal wrote:
> remove the export and make it static.

Applied, thanks.
