Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28009C433ED
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 May 2021 21:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF0E2611B0
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 May 2021 21:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhEBVfJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 May 2021 17:35:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38910 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhEBVfJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 May 2021 17:35:09 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3CCAF63089;
        Sun,  2 May 2021 23:33:35 +0200 (CEST)
Date:   Sun, 2 May 2021 23:34:13 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     nevola <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser: allow to load stateful ct connlimit elements
 in sets
Message-ID: <20210502213413.GA9078@salvia>
References: <20210413090341.GA16617@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210413090341.GA16617@nevthink>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 13, 2021 at 11:03:41AM +0200, nevola wrote:
> This patch fixes a syntax error after loading a nft
> dump with a set including stateful ct connlimit elements.

Applied, thanks.

Sorry for the delay. Merge window is now closed [1], I'm now catching
up with pending userspace patches.

[1] http://vger.kernel.org/~davem/net-next.html
