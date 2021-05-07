Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F58C43460
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 10:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15D16613F0
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 10:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbhEGKg1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 May 2021 06:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbhEGKg0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 May 2021 06:36:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBA8C061574
        for <netfilter-devel@vger.kernel.org>; Fri,  7 May 2021 03:35:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lexpL-0008MG-FN; Fri, 07 May 2021 12:35:23 +0200
Date:   Fri, 7 May 2021 12:35:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: nft_pipapo_avx2_lookup backtrace in linux 5.10
Message-ID: <20210507103523.GA19649@breakpoint.cc>
References: <8ff71ad7-7171-c8c7-f31b-d4bd7577cc18@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ff71ad7-7171-c8c7-f31b-d4bd7577cc18@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:
> Hi there,
> 
> I got this backtrace in one of my servers. I wonder if it is known or fixed
> already in a later version.
> 
> My versions:
> * kernel 5.10.24
> * nft 0.9.6
> 
> Also, find attached the ruleset that triggered this.
> 
> [Thu May  6 16:20:21 2021] ------------[ cut here ]------------
> [Thu May  6 16:20:21 2021] WARNING: CPU: 3 PID: 456 at
> arch/x86/kernel/fpu/core.c:129 kernel_fpu_begin_mask+0xc9/0xe0
> [Thu May  6 16:20:21 2021] Modules linked in: binfmt_misc nft_nat

Hmm, I suspect this is needed (not even compile tested).

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1105,6 +1105,18 @@ bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
+static void nft_pipapo_avx_begin(void)
+{
+	local_bh_disable();
+	kernel_fpu_begin();
+}
+
+static void nft_pipapo_avx_end(void)
+{
+	kernel_fpu_end();
+	local_bh_enable();
+}
+
 /**
  * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
  * @net:	Network namespace
@@ -1134,11 +1146,11 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	m = rcu_dereference(priv->match);
 
 	/* This also protects access to all data related to scratch maps */
-	kernel_fpu_begin();
+	nft_pipapo_avx_begin();
 
 	scratch = *raw_cpu_ptr(m->scratch_aligned);
 	if (unlikely(!scratch)) {
-		kernel_fpu_end();
+		nft_pipapo_avx_end();
 		return false;
 	}
 	map_index = raw_cpu_read(nft_pipapo_avx2_scratch_index);
@@ -1217,7 +1229,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 out:
 	if (i % 2)
 		raw_cpu_write(nft_pipapo_avx2_scratch_index, !map_index);
-	kernel_fpu_end();
+	nft_pipapo_avx_end();
 
 	return ret >= 0;
 }

kernel_fpu_begin() disables preemption, but we can still reenter via
softirq.
