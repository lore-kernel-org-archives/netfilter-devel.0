Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C23C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 23:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbiAZXBP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 18:01:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58440 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiAZXBP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 18:01:15 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4257E60664;
        Wed, 26 Jan 2022 23:58:10 +0100 (CET)
Date:   Thu, 27 Jan 2022 00:01:10 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH nf] netfilter: nft_ct: fix use after free when attaching
 zone template
Message-ID: <YfHStqxYZimTQX0O@salvia>
References: <20220123142400.533506-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220123142400.533506-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 23, 2022 at 03:24:00PM +0100, Florian Westphal wrote:
> The conversion erronously removed the refcount increment.
> In case we can use the percpu template, we need to increment
> the refcount, else it will be released when the skb gets freed.
> 
> In case the slowpath is taken, the new template already has a
> refcount of 1.

Applied, thanks
