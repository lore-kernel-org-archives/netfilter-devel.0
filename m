Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922D9C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 11:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347273AbjKBL1X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbjKBL1W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 07:27:22 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73807111
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 04:27:19 -0700 (PDT)
Received: from [78.30.35.151] (port=33608 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyVr1-008ctg-R4; Thu, 02 Nov 2023 12:27:17 +0100
Date:   Thu, 2 Nov 2023 12:27:15 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] json: drop handling missing json() hook for
 "struct expr_ops"
Message-ID: <ZUOHkxVCA1FyJvNd@calendula>
References: <20231102112122.383527-1-thaller@redhat.com>
 <20231102112122.383527-2-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231102112122.383527-2-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 12:20:29PM +0100, Thomas Haller wrote:
> By now, all "struct expr_ops" have a json() hook set. Thus, drop
> handling the possibility that they might not. From now on, it's a bug
> to create a ops without the hook.
> 
> It's not clear what the code tried to do. It bothered to implement a
> fallback via fmemopen(), but apparently that fallback is no considered a
> good solution as it also printed a "warning". Either the fallback is
> good and does not warrant a warning. Or the condition is to be avoided
> to begin with, which we should do by testing the expr_ops structures.
> 
> As the fallback path has an overhead to create the memory stream, the
> fallback path is indeed not great. That is the reason to outlaw a
> missing json() hook, to require that all hooks are present, and to drop
> the fallback path.
> 
> A missing hook is very easy to cover with unit tests. Such a test shall
> be added soon.

That's fine to simplify code.

But then, in 1/2 you better set some STUB that hits BUG() because we
should not ever see variable and symbol expression from json listing
path ever.
