Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA7FC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 00:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiCCADI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiCCADH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 19:03:07 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 596BCC30
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 16:02:22 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 19B68625FE;
        Thu,  3 Mar 2022 00:24:49 +0100 (CET)
Date:   Thu, 3 Mar 2022 00:26:17 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH v3] netfilter: nf_tables: Reject tables of
 unsupported family
Message-ID: <Yh/9GfhyZ346OMBk@salvia>
References: <20220216145538.19070-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220216145538.19070-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 16, 2022 at 03:55:38PM +0100, Phil Sutter wrote:
> An nftables family is merely a hollow container, its family just a
> number and such not reliant on compile-time options other than nftables
> support itself. Add an artificial check so attempts at using a family
> the kernel can't support fail as early as possible. This helps user
> space detect kernels which lack e.g. NFPROTO_INET.

Applied, thanks
