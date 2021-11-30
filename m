Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE96DC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 21:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344397AbhK3Vy3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 16:54:29 -0500
Received: from mail.netfilter.org ([217.70.188.207]:51974 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344439AbhK3Vy1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 16:54:27 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0F098607E0;
        Tue, 30 Nov 2021 22:48:51 +0100 (CET)
Date:   Tue, 30 Nov 2021 22:51:04 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_queue: remove leftover
 synchronize_rcu
Message-ID: <YaacyG37U7r4H7W0@salvia>
References: <20211119123309.22041-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211119123309.22041-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 19, 2021 at 01:33:09PM +0100, Florian Westphal wrote:
> Its no longer needed after commit 870299707436
> ("netfilter: nf_queue: move hookfn registration out of struct net").

Applied, thanks
