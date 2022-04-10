Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321C8C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Apr 2022 15:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbiDJPjH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Apr 2022 11:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiDJPjH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Apr 2022 11:39:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20189286E4
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Apr 2022 08:36:57 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C992560187;
        Sun, 10 Apr 2022 17:32:58 +0200 (CEST)
Date:   Sun, 10 Apr 2022 17:36:54 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_socket: make cgroup match work in
 input too
Message-ID: <YlL5lu/FFXOHNJ0V@salvia>
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

Fixes: e0bb96db96f8 ("netfilter: nft_socket: add support for cgroupsv2")

> Cc: Topi Miettinen <toiwoton@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
