Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F895C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 13:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbiERNxt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 09:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbiERNxr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 09:53:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 272D31C72E9;
        Wed, 18 May 2022 06:53:44 -0700 (PDT)
Date:   Wed, 18 May 2022 15:53:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     Oz Shlomo <ozsh@nvidia.com>, netfilter-devel@vger.kernel.org,
        nbd@nbd.name, fw@strlen.de, paulb@nvidia.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: flowtable: fix TCP flow teardown
Message-ID: <YoT6ZE83J4fIfmMO@salvia>
References: <20220517094235.10668-1-pablo@netfilter.org>
 <f8247247-4109-18bc-c422-a69619b50258@nvidia.com>
 <20220518041613.4caq2xneizazsaao@svensmacbookpro.sven.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220518041613.4caq2xneizazsaao@svensmacbookpro.sven.lan>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Applied to nf.git, thanks
