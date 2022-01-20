Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BEAC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 11:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiATLof (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 06:44:35 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38416 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbiATLof (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 06:44:35 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3E86660014;
        Thu, 20 Jan 2022 12:41:35 +0100 (CET)
Date:   Thu, 20 Jan 2022 12:44:29 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: don't increment invalid counter
 on NF_REPEAT
Message-ID: <YelLHZvEqUETR/rB@salvia>
References: <20220113203758.22685-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220113203758.22685-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 13, 2022 at 09:37:58PM +0100, Florian Westphal wrote:
> The packet isn't invalid, REPEAT means we're trying again after cleaning
> out a stale connection, e.g. via tcp tracker.
> 
> This caused increases of invalid stat counter in a test case involving
> frequent connection reuse, even though no packet is actually invalid.

Applied to nf, thanks
