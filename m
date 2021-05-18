Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B75DC433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 18:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E390460FF2
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 18:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351545AbhERS2r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 14:28:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344958AbhERS2k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 14:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621362441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xfWrRv08sjMDxsdU1knud/BrnpvBC6DZVyq3jbSAYe8=;
        b=ZMmqHEUpYoBPpo7/S8GqCqu0x42MlakL4REo7IR+1mHCyRBAF6n3na9xtECAFZNG1XgVyI
        OJHrAj/d0jR3jNw1GQOj5zBu/vz8b3aFJ2iIWYBiXJiXTbnz20Qz60UQScOtvfJumx5m7j
        HpTNess9bin0lSbXpG4HJ5hz9cL0YnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-vFXzcN3qPnOQdvlGGGbLIw-1; Tue, 18 May 2021 14:27:19 -0400
X-MC-Unique: vFXzcN3qPnOQdvlGGGbLIw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0447107ACE6;
        Tue, 18 May 2021 18:27:18 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C7FA163FE;
        Tue, 18 May 2021 18:27:18 +0000 (UTC)
Date:   Tue, 18 May 2021 20:27:15 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] nft_set_pipapo_avx2: Skip LDMXCSR, we don't
 need a valid MXCSR state
Message-ID: <20210518202715.4c38278b@elisabeth>
In-Reply-To: <61461a47-acc3-877e-e5ec-5d4de1c7db45@kernel.org>
References: <1c53a6ec42c6ee933231eeeca27285f405cb0bf4.1620613229.git.sbrivio@redhat.com>
        <20210518160159.GA24307@salvia>
        <61461a47-acc3-877e-e5ec-5d4de1c7db45@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Andy,

On Tue, 18 May 2021 09:48:41 -0700
Andy Lutomirski <luto@kernel.org> wrote:

> On 5/18/21 9:01 AM, Pablo Neira Ayuso wrote:
> > On Mon, May 10, 2021 at 07:58:52AM +0200, Stefano Brivio wrote:  
> >> We don't need a valid MXCSR state for the lookup routines, none of
> >> the instructions we use rely on or affect any bit in the MXCSR
> >> register.
> >>
> >> Instead of calling kernel_fpu_begin(), we can pass 0 as mask to
> >> kernel_fpu_begin_mask() and spare one LDMXCSR instruction.
> >>
> >> Commit 49200d17d27d ("x86/fpu/64: Don't FNINIT in kernel_fpu_begin()")
> >> already speeds up lookups considerably, and by dropping the MCXSR
> >> initialisation we can now get a much smaller, but measurable, increase
> >> in matching rates.
> >>
> >> The table below reports matching rates and a wild approximation of
> >> clock cycles needed for a match in a "port,net" test with 10 entries
> >> from selftests/netfilter/nft_concat_range.sh, limited to the first
> >> field, i.e. the port (with nft_set_rbtree initialisation skipped), run
> >> on a single AMD Epyc 7351 thread (2.9GHz, 512 KiB L1D$, 8 MiB   
> 
> Please consider reverting this patch.  You have papered over the actual
> problem, which is that the kernel does not get the AVX pipeline stalls
> right.  LDMXCSR merely exacerbates the problem, but your patch won't
> really fix it.

I didn't get your comment: all this patch does is to skip the initial
LDMXCSR in kernel_fpu_begin(), because the instructions we use in the
lookup functions don't touch or rely on MCXSR, so a valid initial state
doesn't look relevant to me.

Later on, in the lookup functions, I ordered AVX instructions manually
anyway to minimise stalls.

What am I missing? Do you mean that LDMXCSR would come at a lower or no
cost if ordered differently?

-- 
Stefano

