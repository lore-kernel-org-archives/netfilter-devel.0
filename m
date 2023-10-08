Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BDCE95A82
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Oct 2023 08:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbjJHIsD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Oct 2023 04:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbjJHIsC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Oct 2023 04:48:02 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0666AC5
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Oct 2023 01:48:00 -0700 (PDT)
Received: from [78.30.34.192] (port=45988 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qpPS5-004qyx-3g; Sun, 08 Oct 2023 10:47:55 +0200
Date:   Sun, 8 Oct 2023 10:47:51 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] src: Fix IPv6 Fragment Header
 processing
Message-ID: <ZSJst1hriVQdJuwa@calendula>
References: <20231008024131.3654-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231008024131.3654-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Oct 08, 2023 at 01:41:31PM +1100, Duncan Roe wrote:
> 2 items:
>  1. frag_off (Fragment Offset pointer) overshot by 2 bytes because of adding
>     offsetof() to it *after* it had been cast to uint16_t *.
>  2. Need to mask off LS 3 bits of ip6f_offlg *after* call to htons.

Good catch.

Applied, thanks.
