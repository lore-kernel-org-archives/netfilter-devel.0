Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9238FCD5BBD
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 13:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjISNoT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 09:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbjISNny (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 09:43:54 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7ED1BC5
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 06:42:45 -0700 (PDT)
Received: from [78.30.34.192] (port=36318 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qiazx-00FxhA-Cd; Tue, 19 Sep 2023 15:42:43 +0200
Date:   Tue, 19 Sep 2023 15:42:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/2] libnftables: drop gmp_init() and
 mp_set_memory_functions()
Message-ID: <ZQmlUExigKwdqDI6@calendula>
References: <20230919123621.2770734-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230919123621.2770734-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 19, 2023 at 02:36:16PM +0200, Thomas Haller wrote:
> Setting global handles for libgmp via mp_set_memory_functions() is very
> ugly. When we don't use mini-gmp, then potentially there are other users
> of the library in the same process, and every process fighting about the
> allocation functions is not gonna work.
> 
> It also means, we must not reset the allocation functions after somebody
> already allocated GMP data with them. Which we cannot ensure, as we
> don't know what other parts of the process are doing.
> 
> It's also unnecessary. The default allocation functions for gmp and
> mini-gmp already abort the process on allocation failure ([1], [2]),
> just like our xmalloc().
> 
> Just don't do this.

Applied, thanks
