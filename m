Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91972CCA480
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Jul 2022 14:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiGKOfR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 10:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGKOfR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 10:35:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 536DB65D57
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2022 07:35:16 -0700 (PDT)
Date:   Mon, 11 Jul 2022 16:35:12 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: use fallthrough to cleanup
Message-ID: <Ysw1IH0/EaR/pLPm@salvia>
References: <20220525023215.422470-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220525023215.422470-1-liu.yun@linux.dev>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 25, 2022 at 10:32:15AM +0800, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> These cases all use the same function. we can simplify the code through
> fallthrough.
> 
> $ size net/netfilter/nf_conntrack_core.o
> 
>         text	   data	    bss	    dec	    hex	filename
> before  81601	  81430	    768	 163799	  27fd7	net/netfilter/nf_conntrack_core.o
> after   80361	  81430	    768	 162559	  27aff	net/netfilter/nf_conntrack_core.o
> 
> Arch: aarch64
> Gcc : gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)

Applied, thanks
