Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32221C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Oct 2021 13:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1060B60FD9
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Oct 2021 13:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242229AbhJQNuc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Oct 2021 09:50:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52982 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236636AbhJQNub (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Oct 2021 09:50:31 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 12A8E63EE1;
        Sun, 17 Oct 2021 15:46:41 +0200 (CEST)
Date:   Sun, 17 Oct 2021 15:48:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        llvm@lists.linux.dev, kbuild-all@lists.01.org, linux-mm@kvack.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: core: Fix clang warnings about unused
 static inlines
Message-ID: <YWwpoI7DmT31GRW+@salvia>
References: <202110160632.WzahPgao-lkp@intel.com>
 <7bc9f3ee15533d170bc412d6bcdd122632af169d.1634370995.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7bc9f3ee15533d170bc412d6bcdd122632af169d.1634370995.git.lukas@wunner.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Oct 16, 2021 at 10:13:27AM +0200, Lukas Wunner wrote:
> Unlike gcc, clang warns about unused static inlines that are not in an
> include file:
> 
>   net/netfilter/core.c:344:20: error: unused function 'nf_ingress_hook' [-Werror,-Wunused-function]
>   static inline bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
>                      ^
>   net/netfilter/core.c:353:20: error: unused function 'nf_egress_hook' [-Werror,-Wunused-function]
>   static inline bool nf_egress_hook(const struct nf_hook_ops *reg, int pf)
>                      ^
> 
> According to commit 6863f5643dd7 ("kbuild: allow Clang to find unused
> static inline functions for W=1 build"), the proper resolution is to
> mark the affected functions as __maybe_unused.  An alternative approach
> would be to move them to include/linux/netfilter_netdev.h, but since
> Pablo didn't do that in commit ddcfa710d40b ("netfilter: add
> nf_ingress_hook() helper function"), I'm guessing __maybe_unused is
> preferred.
> 
> This fixes both the warning introduced by Pablo in v5.10 as well as the
> one recently introduced by myself with commit 42df6e1d221d ("netfilter:
> Introduce egress hook").

Applied, thanks.
