Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A884C0015E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 10:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjGSKoh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjGSKog (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2023 06:44:36 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132C2C5
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2023 03:44:34 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qM4fY-0005k5-9L; Wed, 19 Jul 2023 12:44:32 +0200
Date:   Wed, 19 Jul 2023 12:44:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH] py: return boolean value from
 Nftables.__[gs]et_output_flag()
Message-ID: <ZLe+kDS8ti84m2zu@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230718103325.277535-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718103325.277535-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 18, 2023 at 12:33:09PM +0200, Thomas Haller wrote:
> The callers of __get_output_flag() and __set_output_flag(), for example
> get_reversedns_output(), are all documented to return a "boolean" value.
> 
> Instead, they returned the underlying, non-zero flags value. That number
> is not obviously useful to the caller, because there is no API so that
> the caller could do anything with it (except evaluating it in a boolean
> context). Adjust that, to match the documentation.
> 
> The alternative would be to update the documentation, to indicate that
> the functions return a non-zero integer when the flag is set. That would
> preserve the previous behavior and maybe the number could be useful
> somehow(?).
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>

Patch applied, thanks!

I wasn't aware Python is not intuitive (from a C programmer's point of
view) in that regard:

| >>> 0 == True
| False
| >>> 1 == True
| True
| >>> 2 == True
| False
| >>> 3 == True
| False
| >>> if 3:
| ...   print("ok")
| ... 
| ok

