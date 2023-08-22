Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A91AEE4993
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 08:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbjHVIzI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 04:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbjHVIzH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 04:55:07 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A8BCCC
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 01:54:42 -0700 (PDT)
Received: from [78.30.34.192] (port=39960 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qYN9q-00HGOp-1y; Tue, 22 Aug 2023 10:54:40 +0200
Date:   Tue, 22 Aug 2023 10:54:37 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 2/2] meta: use reentrant localtime_r()/gmtime_r()
 functions
Message-ID: <ZOR3za+Z+1X0VnIo@calendula>
References: <20230822081318.1370371-1-thaller@redhat.com>
 <20230822081318.1370371-2-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230822081318.1370371-2-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 22, 2023 at 10:13:10AM +0200, Thomas Haller wrote:
> These functions are POSIX.1-2001. We should have them in all
> environments we care about.
> 
> Use them as they are thread-safe.

Also applied, thanks
