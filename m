Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B46C00A8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 08:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjJXI5W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 04:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbjJXI5T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 04:57:19 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56595C0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 01:57:16 -0700 (PDT)
Received: from [78.30.35.151] (port=47284 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvDDp-005SEl-6E; Tue, 24 Oct 2023 10:57:11 +0200
Date:   Tue, 24 Oct 2023 10:57:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/1] Retire 2 libnfnetlink-specific
 functions
Message-ID: <ZTeG5IdKHwuoDIuj@calendula>
References: <20231024005110.19686-1-duncan_roe@optusnet.com.au>
 <20231024005110.19686-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231024005110.19686-2-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 24, 2023 at 11:51:10AM +1100, Duncan Roe wrote:
> Remove nfq_nfnlh() and nfq_open_nfnl() from public access.
> 
> As outlined near the foot of
> https://www.spinics.net/lists/netfilter-devel/msg82762.html,
> nfq_open_nfnl() and nfq_nfnlh() are "problematic" to move to libmnl.
> 
> These functions are only of use to users writing libnfnetlink programs,
> and libnfnetlink is going away.

This is the last thing, first this API needs to be adapted to use
libmnl.
