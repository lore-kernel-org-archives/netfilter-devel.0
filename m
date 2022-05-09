Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A10C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 May 2022 06:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiEIGY6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 May 2022 02:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbiEIGUM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 May 2022 02:20:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB1362AC5B
        for <netfilter-devel@vger.kernel.org>; Sun,  8 May 2022 23:16:18 -0700 (PDT)
Date:   Mon, 9 May 2022 08:16:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sven Auhagen <Sven.Auhagen@voleatech.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] nf_flowtable: nft_flow_route use more data for reverse
 route
Message-ID: <Ynixo9mxKqMbq3Ie@salvia>
References: <20220427071515.qfgqbs6uzoowwnkg@SvensMacbookPro.hq.voleatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220427071515.qfgqbs6uzoowwnkg@SvensMacbookPro.hq.voleatech.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 27, 2022 at 09:15:15AM +0200, Sven Auhagen wrote:
> When creating a flow table entry, the reverse route is looked
> up based on the current packet.
> There can be scenarios where the user creates a custom ip rule
> to route the traffic differently.
> In order to support those scenarios, the lookup needs to add
> more information based on the current packet.
> The patch adds multiple new information to the route lookup.

Applied, thanks
