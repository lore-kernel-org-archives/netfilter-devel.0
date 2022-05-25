Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B47C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 May 2022 17:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbiEYRLV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 May 2022 13:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiEYRLT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 May 2022 13:11:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD8C20C
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 10:11:17 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ntuXT-0006BY-1T; Wed, 25 May 2022 19:11:15 +0200
Date:   Wed, 25 May 2022 19:11:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Ben Brown <ben@demerara.io>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2] build: Fix error during out of tree build
Message-ID: <Yo5jMz+jkBWUrSzD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Ben Brown <ben@demerara.io>,
        netfilter-devel@vger.kernel.org
References: <20220525152613.152899-1-ben@demerara.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525152613.152899-1-ben@demerara.io>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 25, 2022 at 04:26:13PM +0100, Ben Brown wrote:
> Fixes the following error:
> 
>     ../../libxtables/xtables.c:52:10: fatal error: libiptc/linux_list.h: No such file or directory
>        52 | #include <libiptc/linux_list.h>
> 
> Fixes: f58b0d7406451 ("libxtables: Implement notargets hash table")
> 
> Signed-off-by: Ben Brown <ben@demerara.io>

Applied, thanks!
