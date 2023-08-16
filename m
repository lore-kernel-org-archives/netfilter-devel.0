Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FBDC001E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 15:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344349AbjHPPuS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344384AbjHPPts (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 11:49:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52FB26B1
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2023 08:49:46 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qWImG-0000qS-NC; Wed, 16 Aug 2023 17:49:44 +0200
Date:   Wed, 16 Aug 2023 17:49:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 1/6] src: add input flags for nft_ctx
Message-ID: <ZNzwGODIBEB6x12G@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230803193940.1105287-1-thaller@redhat.com>
 <20230803193940.1105287-3-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803193940.1105287-3-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 03, 2023 at 09:35:14PM +0200, Thomas Haller wrote:
> Similar to the existing output flags, add input flags. No flags are yet
> implemented, that will follow.
> 
> One difference to nft_ctx_output_set_flags(), is that the setter for
> input flags returns the previously set flags.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>

Reviewed-by: Phil Sutter <phil@nwl.cc>
