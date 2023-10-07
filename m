Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C0AE95A61
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Oct 2023 10:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343792AbjJGKxm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Oct 2023 06:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343782AbjJGKxm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Oct 2023 06:53:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C1E92;
        Sat,  7 Oct 2023 03:53:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qp4wB-00060Y-2a; Sat, 07 Oct 2023 12:53:35 +0200
Date:   Sat, 7 Oct 2023 12:53:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     George Guo <dongtai.guo@linux.dev>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, George Guo <guodongtai@kylinos.cn>
Subject: Re: [PATCH] netfilter: remove inaccurate code comments from struct
 nft_table
Message-ID: <20231007105335.GB20662@breakpoint.cc>
References: <20231007102528.1544295-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231007102528.1544295-1-dongtai.guo@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

George Guo <dongtai.guo@linux.dev> wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> afinfo is no longer a member of struct nft_table, so remove the comment
> for it.

Correct, but could you please send a v2 that fixes up
all the comments and gets them back in sync with the structure?

Eg. nlpid, family, udlen and udata exist in struct
but are not mentioned in the comments.
