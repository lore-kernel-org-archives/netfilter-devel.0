Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBD0C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Apr 2022 10:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345140AbiDKKOS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Apr 2022 06:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239505AbiDKKOR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Apr 2022 06:14:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E16D041FBE
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Apr 2022 03:12:03 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id DA6A4625B9;
        Mon, 11 Apr 2022 12:08:00 +0200 (CEST)
Date:   Mon, 11 Apr 2022 12:11:58 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_socket: make cgroup match work in
 input too
Message-ID: <YlP+7sDJgtpS+ANL@salvia>
References: <20220409112019.12113-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220409112019.12113-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 09, 2022 at 01:20:19PM +0200, Florian Westphal wrote:
> cgroupv2 helper function ignores the already-looked up sk
> and uses skb->sk instead.
> 
> Just pass sk from the calling function instead; this will
> make cgroup matching work for udp and tcp in input even when
> edemux did not set skb->sk already.

Applied to nf.git, thanks Florian
