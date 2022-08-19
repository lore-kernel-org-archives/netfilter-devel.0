Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D41C32771
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Aug 2022 10:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348237AbiHSKh2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Aug 2022 06:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348191AbiHSKh1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2022 06:37:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22547F4383;
        Fri, 19 Aug 2022 03:37:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oOzNT-0000D9-CI; Fri, 19 Aug 2022 12:37:23 +0200
Date:   Fri, 19 Aug 2022 12:37:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Julien Moutinho <julm+netfilter@sourcephile.fr>
Cc:     netfilter@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Raw payload matching beyond 2040 bits
Message-ID: <20220819103723.GA14293@breakpoint.cc>
References: <20220819100738.63yvp7iggoilt2uc@sourcephile.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819100738.63yvp7iggoilt2uc@sourcephile.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Julien Moutinho <julm+netfilter@sourcephile.fr> wrote:

[ moving to nf-devel ]

> Hi netfilter@,
> 
> Apparently matching beyond 2040 bits (255 bytes) starts again at 0 or something like that.
> Not sure whether this is intended or not,
> but in this case a warning would be appreciated.

This is a kernel bug, the offset is truncated to u8 (modulo 256).
