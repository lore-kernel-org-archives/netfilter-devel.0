Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0176C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 16:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbiERQqd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 12:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240551AbiERQqa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 12:46:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3951400D
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 09:46:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nrMoX-0002Om-DX; Wed, 18 May 2022 18:46:21 +0200
Date:   Wed, 18 May 2022 18:46:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        fasnacht@protonmail.ch
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: disable bh to update per-cpu
 rnd_state
Message-ID: <20220518164621.GH4316@breakpoint.cc>
References: <20220518160022.224294-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518160022.224294-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> bh might occur while updating per-cpu rnd_state from user context,
> ie. local_out path.
> 
> [233241.951068] BUG: using smp_processor_id() in preemptible [00000000] code: nginx/2725
> [233241.951220] caller is nft_ng_random_eval+0x24/0x54 [nft_numgen]
> [233241.951225] CPU: 2 PID: 2725 Comm: nginx Tainted: G           OE 5.16.0-0.bpo.4-amd64 #1  Debian 5.16.12-1~bpo11+1
> [233241.951227] Hardware name: Supermicro SYS-5039MC-H8TRF/X11SCD-F, BIOS 1.7 11/23/2021
> [233241.951228] Call Trace:
> [233241.951231]  <TASK>
> [233241.951233]  dump_stack_lvl+0x48/0x5e
> [233241.951236]  check_preemption_disabled+0xde/0xe0
> [233241.951239]  nft_ng_random_eval+0x24/0x54 [nft_numgen]
> 
> Fixes: 6b2faee0ca91 ("netfilter: nft_meta: place prandom handling in a helper")
> Fixes: 978d8f9055c3 ("netfilter: nft_numgen: add map lookups for numgen random operations")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: disable/enable bh
>     @Florian: your rand meta support is missing {disable,enable}_local_bh()

I wonder if its better to just switch to get_random_u32() instead of prandom.
