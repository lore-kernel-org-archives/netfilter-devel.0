Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DB6C25B47
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 09:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbjJYJrE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 05:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbjJYJqr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 05:46:47 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A16172E
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 02:46:07 -0700 (PDT)
Received: from [78.30.35.151] (port=59854 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvaSi-00Ci4h-6d; Wed, 25 Oct 2023 11:46:06 +0200
Date:   Wed, 25 Oct 2023 11:46:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 3/3] netfilter: nft_set_rbtree: prefer sync gc to
 async worker
Message-ID: <ZTjj2xVUjQvEyHZY@calendula>
References: <20231013121821.31322-1-fw@strlen.de>
 <20231013121821.31322-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231013121821.31322-4-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 13, 2023 at 02:18:16PM +0200, Florian Westphal wrote:
> There is no need for asynchronous garbage collection, rbtree inserts
> can only happen from the netlink control plane.
> 
> We already perform on-demand gc on insertion, in the area of the
> tree where the insertion takes place, but we don't do a full tree
> walk there for performance reasons.
> 
> Do a full gc walk at the end of the transaction instead and
> remove the async worker.

Also applied, thanks
