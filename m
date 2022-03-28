Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B05C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Mar 2022 08:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239241AbiC1IRc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 04:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239229AbiC1IRa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 04:17:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78CEF2FFD1;
        Mon, 28 Mar 2022 01:15:45 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 070E963004;
        Mon, 28 Mar 2022 10:12:36 +0200 (CEST)
Date:   Mon, 28 Mar 2022 10:15:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vasily Averin <vasily.averin@linux.dev>
Cc:     Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel@openvz.org
Subject: Re: [PATCH v2 RESEND] memcg: enable accounting for nft objects
Message-ID: <YkFurEyv2RNwWROw@salvia>
References: <20220228122429.GC26547@breakpoint.cc>
 <47f5c00f-86e8-98b5-0cff-3b9fcadb590c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47f5c00f-86e8-98b5-0cff-3b9fcadb590c@linux.dev>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 24, 2022 at 09:05:50PM +0300, Vasily Averin wrote:
> nftables replaces iptables, but it lacks memcg accounting.
> 
> This patch account most of the memory allocation associated with nft
> and should protect the host from misusing nft inside a memcg restricted
> container.

Applied to nf, thanks

I think nft_*.c files whose NFT_EXPR_STATEFUL flag is set on need to
use this _ACCOUNT flag variant for objects that are dinamically
allocated from the packet path.
