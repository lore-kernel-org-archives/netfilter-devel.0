Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9CBC19F2A
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Aug 2022 14:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbiHKOe6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Aug 2022 10:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbiHKOe4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Aug 2022 10:34:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D060D78595
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2022 07:34:52 -0700 (PDT)
Date:   Thu, 11 Aug 2022 16:34:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/2] --optimize fixes
Message-ID: <YvUThI5xu5dSxY2V@salvia>
References: <20220809211812.749217-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220809211812.749217-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 09, 2022 at 11:18:10PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> Two more fixes for the -o/--optimize infrastructure, reported by users
> after the release:
> 
> 1) do not hit assert() when concatenation already exists in the ruleset.
> 2) do not merge rules unless they contain at least one mergeable statement.
> 
> Both patches come with tests to illustrate the issues.

I have pushed out these fixes.
