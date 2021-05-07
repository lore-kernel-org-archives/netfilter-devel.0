Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F714C433B4
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 10:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5031E6101A
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 10:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbhEGKxw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 May 2021 06:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235644AbhEGKxw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 May 2021 06:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620384772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y4C34BXCVnChm6N5MxFJy1WSR4ByNx2Aa1nmwoxVBbE=;
        b=dngO5+A9hXW0OSxG9AgzyCIpo0/JS5I5cjlBtfepcTxE5QLTxdFPBLexZy+u3gyXfmSNTc
        il2emyRxqaiQsXMtICpl2x+9aw+JpVO1JxvXd0CF7KrfFcIEmCd1P+BQ6XwwdqLqCXoa50
        rQUhdJLHMC8fi1MWRmtibZSkF+sPtRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-SYuu9uGlMxSKGOt_FR8D1Q-1; Fri, 07 May 2021 06:52:50 -0400
X-MC-Unique: SYuu9uGlMxSKGOt_FR8D1Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 753891006C85;
        Fri,  7 May 2021 10:52:49 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 066E65D9CA;
        Fri,  7 May 2021 10:52:49 +0000 (UTC)
Date:   Fri, 7 May 2021 12:52:47 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: nft_pipapo_avx2_lookup backtrace in linux 5.10
Message-ID: <20210507125247.445aaa92@elisabeth>
In-Reply-To: <20210507103523.GA19649@breakpoint.cc>
References: <8ff71ad7-7171-c8c7-f31b-d4bd7577cc18@netfilter.org>
        <20210507103523.GA19649@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 7 May 2021 12:35:23 +0200
Florian Westphal <fw@strlen.de> wrote:

> Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:
> > Hi there,
> > 
> > I got this backtrace in one of my servers. I wonder if it is known or fixed
> > already in a later version.
> > 
> > My versions:
> > * kernel 5.10.24
> > * nft 0.9.6
> > 
> > Also, find attached the ruleset that triggered this.
> > 
> > [Thu May  6 16:20:21 2021] ------------[ cut here ]------------
> > [Thu May  6 16:20:21 2021] WARNING: CPU: 3 PID: 456 at
> > arch/x86/kernel/fpu/core.c:129 kernel_fpu_begin_mask+0xc9/0xe0
> > [Thu May  6 16:20:21 2021] Modules linked in: binfmt_misc nft_nat  
> 
> Hmm, I suspect this is needed (not even compile tested).
> 
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -1105,6 +1105,18 @@ bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
>  	return true;
>  }
>  
> +static void nft_pipapo_avx_begin(void)
> +{
> +	local_bh_disable();
> +	kernel_fpu_begin();
> +}
>
> [...]
> 
> kernel_fpu_begin() disables preemption, but we can still reenter via
> softirq.

Right... if that's enough (I'm quite convinced), and the overhead is
negligible (not as much... I'll test), I would prefer this to the
fallback option on !irq_fpu_usable() -- it's simpler.

-- 
Stefano

