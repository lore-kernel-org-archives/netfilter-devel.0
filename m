Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2423C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 11:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjKCLng (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 07:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjKCLnf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 07:43:35 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53721BF
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 04:43:32 -0700 (PDT)
Received: from [78.30.35.151] (port=40716 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qysaH-00EfDw-6v; Fri, 03 Nov 2023 12:43:31 +0100
Date:   Fri, 3 Nov 2023 12:43:28 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 0/4] add arptables-translate
Message-ID: <ZUTc4ISvyHGYH8Bw@calendula>
References: <20231103102330.27578-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231103102330.27578-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 11:23:22AM +0100, Florian Westphal wrote:
> iptables-nft lacks a translate variant for arptables.
> 
> Add it.  First patch fixes a bug in existing arptables-nft,
> second patch adds missing mask matching.
> Patch 3 is the main arptables-translate support.
> 
> Last patch adds a few test cases.

Thanks a lot for working on this, this has been a long overdue.
