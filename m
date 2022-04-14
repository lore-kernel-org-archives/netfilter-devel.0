Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F26C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Apr 2022 16:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241507AbiDNQxj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 12:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343911AbiDNQxU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 12:53:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CFCD13BAC1
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2022 09:22:27 -0700 (PDT)
Date:   Thu, 14 Apr 2022 18:22:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] intervals: Simplify element sanity checks
Message-ID: <YlhKQHpyME9YLIK3@salvia>
References: <20220414113924.15553-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220414113924.15553-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 14, 2022 at 01:39:24PM +0200, Phil Sutter wrote:
> Since setelem_delete() assigns to 'prev' pointer only if it doesn't have
> EXPR_F_REMOVE flag set, there is no need to check that flag in called
> functions.

Applied, thanks
