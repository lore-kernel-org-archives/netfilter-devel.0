Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258B6C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 21:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiLHVYw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 16:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLHVYv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 16:24:51 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA690786B4
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 13:24:50 -0800 (PST)
Date:   Thu, 8 Dec 2022 22:24:48 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netlink: unfold function to generate concatenations
 for keys and data
Message-ID: <Y5JWIGTy7hlegf8O@salvia>
References: <20221208013217.483019-1-pablo@netfilter.org>
 <20221208013217.483019-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221208013217.483019-2-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 08, 2022 at 02:32:17AM +0100, Pablo Neira Ayuso wrote:
> Add a specific function to generate concatenation with and without
> intervals in maps. This restores the original function added by
> 8ac2f3b2fca3 ("src: Add support for concatenated set ranges") which is
> used by 66746e7dedeb ("src: support for nat with interval
> concatenation") to generate the data concatenations in maps.
> 
> Only the set element key requires the byteswap introduced by 1017d323cafa
> ("src: support for selectors with different byteorder with interval
> concatenations"). Therefore, better not to reuse the same function for
> key and data as the future might bring support for more kind of
> concatenations in data maps.

This patch needs more work, netlink_gen_concat_key() is still called
for rhs element data in a mapping in this patch.

I'll post a v2.
