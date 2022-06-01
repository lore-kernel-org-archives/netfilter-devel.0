Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A795BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jun 2022 13:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiFAN0y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jun 2022 09:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353260AbiFAN0y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jun 2022 09:26:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E2610571
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2022 06:26:52 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nwON8-00052f-VN; Wed, 01 Jun 2022 15:26:50 +0200
Date:   Wed, 1 Jun 2022 15:26:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nft_nat: Fix inet l4-only NAT
Message-ID: <YpdpGg9tUP5PZRn/@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220601131914.13322-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601131914.13322-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 01, 2022 at 03:19:14PM +0200, Phil Sutter wrote:
> If nat expression does not specify an address, its family value is
> NFPROTO_INET. Disable the check against the packet's family in that
> case.
> 
> Fixes: a33f387ecd5aa ("netfilter: nft_nat: allow to specify layer 4 protocol NAT only")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Argh. Duplicate work with Florian (message-ID
20220601084735.79090-1-fw@strlen.de), please use his patch - it adds a
test as well.

Sorry for the noise!
