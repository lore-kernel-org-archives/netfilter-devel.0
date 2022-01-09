Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7B3C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 22:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbiAIWdx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 17:33:53 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42050 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237278AbiAIWdw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 17:33:52 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CBE4B62BD6;
        Sun,  9 Jan 2022 23:31:02 +0100 (CET)
Date:   Sun, 9 Jan 2022 23:33:47 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: egress: avoid a lockdep splat
Message-ID: <Ydtiy7AGGU6BxDmC@salvia>
References: <20220107144616.4261-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220107144616.4261-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 07, 2022 at 03:46:16PM +0100, Florian Westphal wrote:
> include/linux/netfilter_netdev.h:97 suspicious rcu_dereference_check() usage!
> 2 locks held by sd-resolve/1100:
>  0: ..(rcu_read_lock_bh){1:3}, at: ip_finish_output2
>  1: ..(rcu_read_lock_bh){1:3}, at: __dev_queue_xmit
>  __dev_queue_xmit+0 ..
> 
> The helper has two callers, one uses rcu_read_lock, the other
> rcu_read_lock_bh().  Annotate the dereference to reflect this.

Applied, thanks
