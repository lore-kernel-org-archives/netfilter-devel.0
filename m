Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9C2C54EBD
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Jan 2023 16:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjAMQcu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Jan 2023 11:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjAMQcb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Jan 2023 11:32:31 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86028D3B3
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jan 2023 08:26:28 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pGMss-0006Bp-Ur; Fri, 13 Jan 2023 17:26:26 +0100
Date:   Fri, 13 Jan 2023 17:26:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/5] Fix some covscan findings
Message-ID: <Y8GGMkIZE2G+JjKZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230112172823.7298-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112172823.7298-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 12, 2023 at 06:28:18PM +0100, Phil Sutter wrote:
> All these are rather minor issues, no big deal.

Series applied after fixing up my email address in one of them.
