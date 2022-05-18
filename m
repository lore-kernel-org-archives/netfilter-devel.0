Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A98C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 14:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbiERODF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 10:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbiERODE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 10:03:04 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78E41167CB
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 07:03:03 -0700 (PDT)
Date:   Wed, 18 May 2022 16:03:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fasnacht@protonmail.ch
Subject: Re: [PATCH nf] netfilter: nft_numgen: disable preempt to access
 per-cpu data
Message-ID: <YoT8lLOVB0mRTXpv@salvia>
References: <20220516085552.212616-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220516085552.212616-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 16, 2022 at 10:55:52AM +0200, Pablo Neira Ayuso wrote:
> [233241.951068] BUG: using smp_processor_id() in preemptible [00000000] code: nginx/2725
> [233241.951220] caller is nft_ng_random_eval+0x24/0x54 [nft_numgen]
> [233241.951225] CPU: 2 PID: 2725 Comm: nginx Tainted: G           OE 5.16.0-0.bpo.4-amd64 #1  Debian 5.16.12-1~bpo11+1
> [233241.951227] Hardware name: Supermicro SYS-5039MC-H8TRF/X11SCD-F, BIOS 1.7 11/23/2021
> [233241.951228] Call Trace:
> [233241.951231]  <TASK>
> [233241.951233]  dump_stack_lvl+0x48/0x5e
> [233241.951236]  check_preemption_disabled+0xde/0xe0
> [233241.951239]  nft_ng_random_eval+0x24/0x54 [nft_numgen]

For the record, patch applied to nf.git
