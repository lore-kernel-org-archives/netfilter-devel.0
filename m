Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C79AC433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 23:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA9D61433
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 23:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhEMXnz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 May 2021 19:43:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34072 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhEMXny (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 May 2021 19:43:54 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9E3366415A;
        Fri, 14 May 2021 01:41:52 +0200 (CEST)
Date:   Fri, 14 May 2021 01:42:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_pipapo_avx2: Add irq_fpu_usable() check,
 fallback to non-AVX2 version
Message-ID: <20210513234241.GA31723@salvia>
References: <239c77ba924208373776f1b8d78be33d8dde95d3.1620608143.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <239c77ba924208373776f1b8d78be33d8dde95d3.1620608143.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 10, 2021 at 07:58:22AM +0200, Stefano Brivio wrote:
> Arturo reported this backtrace:
> 
> [709732.358791] WARNING: CPU: 3 PID: 456 at arch/x86/kernel/fpu/core.c:128 kernel_fpu_begin_mask+0xae/0xe0
[...]
> 
> that is, nft_pipapo_avx2_lookup() uses the FPU running from a softirq
> that interrupted a kthread, also using the FPU.
> 
> That's exactly the reason why irq_fpu_usable() is there: use it, and
> if we can't use the FPU, fall back to the non-AVX2 version of the
> lookup operation, i.e. nft_pipapo_lookup().

Applied to nf, thanks.
