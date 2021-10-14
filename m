Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 306A2C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Oct 2021 21:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 178FE61056
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Oct 2021 21:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhJNVFD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 17:05:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47190 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhJNVFD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 17:05:03 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B27D363F25;
        Thu, 14 Oct 2021 23:01:19 +0200 (CEST)
Date:   Thu, 14 Oct 2021 23:02:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org,
        ja@ssi.bg, horms@verge.net.au
Subject: Re: [PATCH nf-next v2 0/4] netfilter: ipvs: remove unneeded hook
 wrappers
Message-ID: <YWia/ZWkCbsa3iUm@salvia>
References: <20211012172959.745-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211012172959.745-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 12, 2021 at 07:29:55PM +0200, Florian Westphal wrote:
> V2: Patch 4/4 had a bug that would enter ipv6 branch for
> ipv4 packets, fix that.
> 
> This series reduces the number of different hook function
> implementations by merging the ipv4 and ipv6 hooks into
> common code.

Series applied, thanks.
