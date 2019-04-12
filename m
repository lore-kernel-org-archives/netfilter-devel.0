Return-Path: <SRS0=aNn+=SO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04417C10F14
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 08:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D313E2083E
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 08:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfDLIPd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:15:33 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40450 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbfDLIPc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 04:15:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hErLL-0007Qc-16; Fri, 12 Apr 2019 10:15:27 +0200
Date:   Fri, 12 Apr 2019 10:15:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: Re: linux-next: build failure after merge of the netfilter-next tree
Message-ID: <20190412081527.vrym3czsko2lbqx7@breakpoint.cc>
References: <20190412163720.576c6610@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412163720.576c6610@canb.auug.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the netfilter tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
> 
> In file included from /home/sfr/next/next/net/bridge/br_input.c:19:
> /home/sfr/next/next/include/net/netfilter/nf_queue.h:16:23: error: field 'state'
>  has incomplete type
>   struct nf_hook_state state;
>                        ^~~~~
> Caused by commit
> 
>   971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
> 
> This build has CONFIG_NETFILTER not set.
> 
> I have applied this patch for today:

Can you submit this fix formally to netfilter-devel@vger.kernel.org?
