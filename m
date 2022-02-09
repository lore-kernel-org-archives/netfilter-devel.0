Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFB4C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 11:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiBILRD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 06:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiBILQ7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 06:16:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B4C2E0888EE;
        Wed,  9 Feb 2022 02:11:49 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CC1D4601B3;
        Wed,  9 Feb 2022 11:08:15 +0100 (CET)
Date:   Wed, 9 Feb 2022 11:08:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] netfilter: xt_socket: fix a typo in
 socket_mt_destroy()
Message-ID: <YgOSl4b7skcUBmxJ@salvia>
References: <20220209023043.3469254-1-eric.dumazet@gmail.com>
 <20220209092907.GE25000@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220209092907.GE25000@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 09, 2022 at 10:29:07AM +0100, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > Calling nf_defrag_ipv4_disable() instead of nf_defrag_ipv6_disable()
> > was probably not the intent.
> 
> Indeed, thanks for catching this.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Applied, thanks
