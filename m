Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BF9C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Mar 2022 13:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiCQNTg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Mar 2022 09:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiCQNTf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Mar 2022 09:19:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120D3DF2A
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2022 06:18:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nUq17-0005dc-7r; Thu, 17 Mar 2022 14:18:13 +0100
Date:   Thu, 17 Mar 2022 14:18:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 2/2] netfilter: nf_tables: initialize registers in
 nft_do_chain()
Message-ID: <20220317131813.GD9722@breakpoint.cc>
References: <20220317130734.97839-1-pablo@netfilter.org>
 <20220317130734.97839-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317130734.97839-2-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Initialize registers to avoid stack leak into userspace.
> 
> Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")

As per David, my assessment was incorrect, this needs to be
Fixes: 96518518cc41 ("netfilter: add nftables")

... because its possible to exfiltrate via cmp+imm and observe if there
is a match (accept/drop/counter, etc).

Patch is correct though, please consider pushing this out with updates
fixes tag.

Thanks!
