Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7ED7C07E9D
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Sep 2022 07:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbiIZHzj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Sep 2022 03:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234849AbiIZHy7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Sep 2022 03:54:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98A33ED77;
        Mon, 26 Sep 2022 00:50:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5B2BD21BE3;
        Mon, 26 Sep 2022 07:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664178560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VX6pvgjSa7xlYXLMPzQ/q5ZL0MRRPIMy0fepPqULx5Q=;
        b=FgNrf41ceAn1rqG7vRjTqnABF8p9/tkXtTle8rW4fPX2ERr+MxyFtdostCF89SZ5BtR3va
        EbfT535YnHU4Ut8AggUnUtbvQFKsVdWW76IzXrRRpAp/LEOI+AT0MgjPpHhq7ByYsyowLY
        6ltnMMNQp/e4Xp0yYPYoSKc+ALz+b04=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 38D64139BD;
        Mon, 26 Sep 2022 07:49:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oiKSC4BZMWOnQwAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 26 Sep 2022 07:49:20 +0000
Date:   Mon, 26 Sep 2022 09:49:19 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <YzFZf0Onm6/UH7/I@dhcp22.suse.cz>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923133512.GE22541@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri 23-09-22 15:35:12, Florian Westphal wrote:
> Michal Hocko <mhocko@suse.com> wrote:
> > On Fri 23-09-22 12:38:58, Florian Westphal wrote:
> > > Martin Zaharinov reports BUG() in mm land for 5.19.10 kernel:
> > >  kernel BUG at mm/vmalloc.c:2437!
> > >  invalid opcode: 0000 [#1] SMP
> > >  CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 #1
> > >  [..]
> > >  RIP: 0010:__get_vm_area_node+0x120/0x130
> > >   __vmalloc_node_range+0x96/0x1e0
> > >   kvmalloc_node+0x92/0xb0
> > >   bucket_table_alloc.isra.0+0x47/0x140
> > >   rhashtable_try_insert+0x3a4/0x440
> > >   rhashtable_insert_slow+0x1b/0x30
> > >  [..]
> > > 
> > > bucket_table_alloc uses kvzallocGPF_ATOMIC).  If kmalloc fails, this now
> > > falls through to vmalloc and hits code paths that assume GFP_KERNEL.
> > > 
> > > Revert the problematic change and stay with slab allocator.
> > 
> > Why don't you simply fix the caller?
> 
> Uh, not following?
> 
> kvzalloc(GFP_ATOMIC) was perfectly fine, is this illegal again?

kvmalloc has never really supported GFP_ATOMIC semantic.
 
> I can revert 93f976b5190df32793908d49165f78e67fcb66cf instead
> but that change is from 2018.

Yeah I would just revert this one as it relies on internal details of
kvmalloc doing or not doing a fallback.
-- 
Michal Hocko
SUSE Labs
