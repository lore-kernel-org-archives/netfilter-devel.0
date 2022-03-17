Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EFFC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Mar 2022 13:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiCQNOn convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Mar 2022 09:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiCQNOm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Mar 2022 09:14:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D160914DFC5
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2022 06:13:22 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nUpwO-0005cP-ES; Thu, 17 Mar 2022 14:13:20 +0100
Date:   Thu, 17 Mar 2022 14:13:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 1/2] netfilter: nf_tables: validate registers
 coming from userspace.
Message-ID: <20220317131320.GC9722@breakpoint.cc>
References: <20220317130734.97839-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20220317130734.97839-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Bail out in case userspace uses unsupported registers.
> 
> Fixes: 49499c3e6e18 ("netfilter: nf_tables: switch registers to 32 bit addressing")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: fix incorrect register sanity check.

This is better than the patch I made, thanks!

Reviewed-by: Florian Westphal <fw@strlen.de>
