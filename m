Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB41C0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 09:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbjJYJqz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 05:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbjJYJqi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 05:46:38 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24B210E6
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 02:45:51 -0700 (PDT)
Received: from [78.30.35.151] (port=42022 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvaSP-00Ci3X-OH; Wed, 25 Oct 2023 11:45:47 +0200
Date:   Wed, 25 Oct 2023 11:45:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/3] netfilter: nft_set_rbtree: rename gc
 deactivate+erase function
Message-ID: <ZTjjyAb4X9svJGTw@calendula>
References: <20231013121821.31322-1-fw@strlen.de>
 <20231013121821.31322-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231013121821.31322-3-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 13, 2023 at 02:18:15PM +0200, Florian Westphal wrote:
> Next patch adds a cllaer that doesn't hold the priv->write lock and
> will need a similar function.
> 
> Rename the existing function to make it clear that it can only
> be used for opportunistic gc during insertion.

Applied to nf-next, thanks
