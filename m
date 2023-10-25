Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D291EC25B47
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 09:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbjJYJrs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 05:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbjJYJri (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 05:47:38 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D794D40
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 02:47:25 -0700 (PDT)
Received: from [78.30.35.151] (port=45068 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvaTx-00CiAE-UQ; Wed, 25 Oct 2023 11:47:23 +0200
Date:   Wed, 25 Oct 2023 11:47:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: switch connlabels to
 atomic_t
Message-ID: <ZTjkKUXZUTAzH7FF@calendula>
References: <20231020123818.32681-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231020123818.32681-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 20, 2023 at 02:38:15PM +0200, Florian Westphal wrote:
> The spinlock is back from the day when connabels did not have
> a fixed size and reallocation had to be supported.
> 
> Remove it.  This change also allows to call the helpers from
> softirq or timers without deadlocks.
> 
> Also add WARN()s to catch refcounting imbalances.

Applied, thanks.
