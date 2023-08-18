Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2276FC77B7F
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 16:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378575AbjHRQNM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 12:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378543AbjHRQMz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 12:12:55 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339923ABA
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 09:12:52 -0700 (PDT)
Received: from [78.30.34.192] (port=47248 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qX25f-001S5X-Sk; Fri, 18 Aug 2023 18:12:50 +0200
Date:   Fri, 18 Aug 2023 18:12:47 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v3 0/3] src: use reentrant
 getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
Message-ID: <ZN+Yf0rQ/W+zkpI0@calendula>
References: <20230818141124.859037-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818141124.859037-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 18, 2023 at 04:08:18PM +0200, Thomas Haller wrote:
> Changes since version 2:
> 
> - split the patch.
> 
> - add and use defines NFT_PROTONAME_MAXSIZE, NFT_SERVNAME_MAXSIZE,
>   NETDB_BUFSIZE.
> 
> - add new GPL2+ source file as a place for the wrapper functions.

Series LGTM. I would just collapse patch 1 and 2, I can do that before
applying if you like. Or you send v4 as you prefer.

Thanks.
