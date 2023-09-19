Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF11CD5BC0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 13:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbjISNoS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 09:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjISNny (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 09:43:54 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F32125
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 06:43:18 -0700 (PDT)
Received: from [78.30.34.192] (port=35032 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qib0U-00Fxj3-T9; Tue, 19 Sep 2023 15:43:16 +0200
Date:   Tue, 19 Sep 2023 15:43:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/1] netlink: fix leaking
 typeof_expr_data/typeof_expr_key in netlink_delinearize_set()
Message-ID: <ZQmlctgHDx6U3T21@calendula>
References: <20230914140952.4177765-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230914140952.4177765-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 14, 2023 at 04:09:50PM +0200, Thomas Haller wrote:
> There are various code paths that return without freeing typeof_expr_data
> and typeof_expr_key. It's not at all obvious, that there isn't a leak
> that way. Quite possibly there is a leak. Fix it, or at least make the
> code more obviously correct.

Applied, thanks
