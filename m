Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A727C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 16:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBCD56113C
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 16:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344447AbhERQDV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 12:03:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43146 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344303AbhERQDU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 12:03:20 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4086B64174;
        Tue, 18 May 2021 18:01:07 +0200 (CEST)
Date:   Tue, 18 May 2021 18:01:59 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] nft_set_pipapo_avx2: Skip LDMXCSR, we don't need
 a valid MXCSR state
Message-ID: <20210518160159.GA24307@salvia>
References: <1c53a6ec42c6ee933231eeeca27285f405cb0bf4.1620613229.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1c53a6ec42c6ee933231eeeca27285f405cb0bf4.1620613229.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 10, 2021 at 07:58:52AM +0200, Stefano Brivio wrote:
> We don't need a valid MXCSR state for the lookup routines, none of
> the instructions we use rely on or affect any bit in the MXCSR
> register.
> 
> Instead of calling kernel_fpu_begin(), we can pass 0 as mask to
> kernel_fpu_begin_mask() and spare one LDMXCSR instruction.
> 
> Commit 49200d17d27d ("x86/fpu/64: Don't FNINIT in kernel_fpu_begin()")
> already speeds up lookups considerably, and by dropping the MCXSR
> initialisation we can now get a much smaller, but measurable, increase
> in matching rates.
> 
> The table below reports matching rates and a wild approximation of
> clock cycles needed for a match in a "port,net" test with 10 entries
> from selftests/netfilter/nft_concat_range.sh, limited to the first
> field, i.e. the port (with nft_set_rbtree initialisation skipped), run
> on a single AMD Epyc 7351 thread (2.9GHz, 512 KiB L1D$, 8 MiB L2$).
> 
> The (very rough) estimation of clock cycles is obtained by simply
> dividing frequency by matching rate. The "cycles spared" column refers
> to the difference in cycles compared to the previous row, and the rate
> increase also refers to the previous row. Results are averages of six
> runs.
> 
> Merely for context, I'm also reporting packet rates obtained by
> skipping kernel_fpu_begin() and kernel_fpu_end() altogether (which
> shows a very limited impact now), as well as skipping the whole lookup
> function, compared to simply counting and dropping all packets using
> the netdev hook drop (see nft_concat_range.sh for details). This
> workload also includes packet generation with pktgen and the receive
> path of veth.

Applied, thanks.
