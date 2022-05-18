Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3C0C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 17:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241132AbiERRv2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 13:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241155AbiERRv0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 13:51:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DD563151E
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 10:51:23 -0700 (PDT)
Date:   Wed, 18 May 2022 19:51:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, fasnacht@protonmail.ch
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: disable bh to update per-cpu
 rnd_state
Message-ID: <YoUyFuQVQjiAV0/U@salvia>
References: <20220518160022.224294-1-pablo@netfilter.org>
 <20220518164621.GH4316@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220518164621.GH4316@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 18, 2022 at 06:46:21PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > bh might occur while updating per-cpu rnd_state from user context,
> > ie. local_out path.
> > 
> > [233241.951068] BUG: using smp_processor_id() in preemptible [00000000] code: nginx/2725
> > [233241.951220] caller is nft_ng_random_eval+0x24/0x54 [nft_numgen]
> > [233241.951225] CPU: 2 PID: 2725 Comm: nginx Tainted: G           OE 5.16.0-0.bpo.4-amd64 #1  Debian 5.16.12-1~bpo11+1
> > [233241.951227] Hardware name: Supermicro SYS-5039MC-H8TRF/X11SCD-F, BIOS 1.7 11/23/2021
> > [233241.951228] Call Trace:
> > [233241.951231]  <TASK>
> > [233241.951233]  dump_stack_lvl+0x48/0x5e
> > [233241.951236]  check_preemption_disabled+0xde/0xe0
> > [233241.951239]  nft_ng_random_eval+0x24/0x54 [nft_numgen]
> > 
> > Fixes: 6b2faee0ca91 ("netfilter: nft_meta: place prandom handling in a helper")
> > Fixes: 978d8f9055c3 ("netfilter: nft_numgen: add map lookups for numgen random operations")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: disable/enable bh
> >     @Florian: your rand meta support is missing {disable,enable}_local_bh()
> 
> I wonder if its better to just switch to get_random_u32() instead of prandom.

Feel free to pick if you would like to send a v3.
