Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BDCC6FA8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 16:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbjH2QKr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 12:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237417AbjH2QK2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 12:10:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6CECC2
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 09:10:25 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qb1IO-0002jq-89; Tue, 29 Aug 2023 18:10:24 +0200
Date:   Tue, 29 Aug 2023 18:10:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] evaluate: Drop dead code from expr_evaluate_mapping()
Message-ID: <ZO4YcIMkRyvbXf/m@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230829135424.1053-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230829135424.1053-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 29, 2023 at 03:54:24PM +0200, Phil Sutter wrote:
> Since commit 343a51702656a ("src: store expr, not dtype to track data in
> sets"), set->data is allocated for object maps in set_evaluate(), all
> other map types have set->data initialized by the parser already,
> set_evaluate() also checks that.
> 
> Drop the confusing check, later in the function set->data is
> dereferenced unconditionally.
> 
> Fixes: 343a51702656a ("src: store expr, not dtype to track data in sets")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
