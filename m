Return-Path: <SRS0=Hnfl=SH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD9EC4360F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0305021738
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfDEKCC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 06:02:02 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39022 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729820AbfDEKCC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 06:02:02 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hCLfW-0004mm-Az; Fri, 05 Apr 2019 12:01:54 +0200
Date:   Fri, 5 Apr 2019 12:01:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: prevent shift wrap in
 nft_chain_parse_hook()
Message-ID: <20190405100154.ohc6kjfyysug7fpp@breakpoint.cc>
References: <20190402133038.GA18575@kadam>
 <20190405083436.GT32613@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190405083436.GT32613@kadam>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 	if (hook->num > 31 || !(type->hook_mask & (1 << hook->num)))
> 
> which seems like a slightly ugly magic number but it fixes the buffer
> overflow.

You can use NF_MAX_HOOKS instead of 31.
