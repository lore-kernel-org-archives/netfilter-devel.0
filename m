Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B4AC6FD19
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 21:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCJVAo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 16:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjCJVAY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 16:00:24 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1733B13F6A8
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 12:59:22 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pajpf-0008FS-JS; Fri, 10 Mar 2023 21:59:19 +0100
Date:   Fri, 10 Mar 2023 21:59:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: improve error reporting for unsupported chain
 type
Message-ID: <ZAuaJ840va8SiiTI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230310182643.182915-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310182643.182915-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 10, 2023 at 07:26:43PM +0100, Pablo Neira Ayuso wrote:
> 8c75d3a16960 ("Reject invalid chain priority values in user space")
> provides error reporting from the evaluation phase. Instead, this patch
> infers the error after the kernel reports EOPNOTSUPP.
> 
> test.nft:3:28-40: Error: Chains of type "nat" must have a priority value above -200
>                 type nat hook prerouting priority -300;
>                                          ^^^^^^^^^^^^^
> 
> This patch also adds another common issue for users compiling their own
> kernels if they forget to enable CONFIG_NFT_NAT in their .config file.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>
