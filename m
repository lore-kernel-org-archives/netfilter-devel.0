Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3290FC04FF3
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 14:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF86B61209
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 14:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhEXOex (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 May 2021 10:34:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58070 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbhEXOew (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 May 2021 10:34:52 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8789F641D1;
        Mon, 24 May 2021 16:32:23 +0200 (CEST)
Date:   Mon, 24 May 2021 16:33:20 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dominick Grift <dominick.grift@defensec.nl>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nftables PATCH] files: improve secmark.nft example
Message-ID: <20210524143320.GA20893@salvia>
References: <20210524094751.195065-1-dominick.grift@defensec.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210524094751.195065-1-dominick.grift@defensec.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 24, 2021 at 11:47:51AM +0200, Dominick Grift wrote:
> use proper priorities to ensure that ct works properly

Applied, thanks.
