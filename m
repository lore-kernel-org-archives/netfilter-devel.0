Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318EFC00140
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Aug 2022 13:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244262AbiHRNcf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Aug 2022 09:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241464AbiHRNce (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Aug 2022 09:32:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0E1A0302
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2022 06:32:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oOfdP-0008OV-CG; Thu, 18 Aug 2022 15:32:31 +0200
Date:   Thu, 18 Aug 2022 15:32:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Xiao Liang <shaw.leon@gmail.com>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] src: Don't parse string as verdict in map
Message-ID: <20220818133231.GB24008@breakpoint.cc>
References: <20220818100623.22601-1-shaw.leon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818100623.22601-1-shaw.leon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Xiao Liang <shaw.leon@gmail.com> wrote:
> In verdict map, string values are accidentally treated as verdicts.
> 
> For example:
>     table ip t {
>         map foo {
>            type mark : verdict
>            elements = {
>               0 : bar
>            }
>         }
>     }
> The value "bar" is sent to kernel as verdict.
> 
> Indeed, we don't parse verdicts during evaluation, but only chains,
> which is of type string rather than verdict.

Can you explain what this is fixing?

This reverts the commit that adds support for defines as aliases:

commit c64457cff9673fbb41f613a67e158b4d62235c09
src: Allow goto and jump to a variable

