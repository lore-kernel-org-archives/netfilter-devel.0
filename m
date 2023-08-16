Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49690C001E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 16:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbjHPQDU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 12:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344531AbjHPQDA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 12:03:00 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F609E2
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2023 09:02:59 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qWIz3-00010P-PZ; Wed, 16 Aug 2023 18:02:57 +0200
Date:   Wed, 16 Aug 2023 18:02:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 3/6] src: add input flag NFT_CTX_INPUT_JSON to
 enable JSON parsing
Message-ID: <ZNzzMWfnZJ4ex7nZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230803193940.1105287-1-thaller@redhat.com>
 <20230803193940.1105287-7-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803193940.1105287-7-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 03, 2023 at 09:35:18PM +0200, Thomas Haller wrote:
> By default, the input is parsed using the nftables grammar. When setting
> NFT_CTX_OUTPUT_JSON flag, nftables will first try to parse the input as
> JSON before falling back to the nftables grammar.
> 
> But NFT_CTX_OUTPUT_JSON flag also turns on JSON for the output. Add a
> flag NFT_CTX_INPUT_JSON which allows to treat only the input as JSON,
> but keep the output mode unchanged.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>

Reviewed-by: Phil Sutter <phil@nwl.cc>
