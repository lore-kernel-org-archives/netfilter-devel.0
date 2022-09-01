Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79493ECAAD3
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 20:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbiIAUgP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 16:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiIAUgO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 16:36:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C94E3E0D8
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2022 13:35:21 -0700 (PDT)
Date:   Thu, 1 Sep 2022 22:35:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Derek Hageman <hageman@inthat.cloud>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] rule: check address family in set collapse
Message-ID: <YxEXhd+MhZ+tW1AH@salvia>
References: <20220901161041.14814-1-hageman@inthat.cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220901161041.14814-1-hageman@inthat.cloud>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 01, 2022 at 10:10:41AM -0600, Derek Hageman wrote:
> 498a5f0c added collapsing of set operations in different commands.
> However, the logic is currently too relaxed.  It is valid to have a
> table and set with identical names on different address families.
> For example:
> 
>   table ip a {
>     set x {
>       type inet_service;
>     }
>   }
>   table ip6 a {
>       set x {
>         type inet_service;
>       }
>   }
>   add element ip a x { 1 }
>   add element ip a x { 2 }
>   add element ip6 a x { 2 }
> 
> The above currently results in nothing being added to the ip6 family
> table due to being collapsed into the ip table add.  Prior to 498a5f0c
> the set add would work.  The fix is simply to check the family in
> addition to the table and set names before allowing a collapse.

Applied, thanks.
