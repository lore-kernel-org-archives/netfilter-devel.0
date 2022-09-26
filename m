Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D4FC32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Sep 2022 15:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236445AbiIZPr7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Sep 2022 11:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiIZPrX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Sep 2022 11:47:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6A9BEA;
        Mon, 26 Sep 2022 07:32:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1E05B21B79;
        Mon, 26 Sep 2022 14:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664202747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7tqk1/BNUZ/BZYPgkGc3UWgIJGHk0bekQA/PLeqWyLo=;
        b=uAlO4EpqeS/6KqE8Y0DzGycnNBn2BYDfe2ZRaBGp1cNR4Yw2AeZcZAHr5RN7ohULLbwnst
        jV8WnUMpSoL5x3BtLvOPmsHcFrWDXD7VMZr0b/Yjb+9uf250h6ze6taDsb1MkQHshRSHO1
        u52CZftmxzcuCuEB8EUuZB4bd/Z+jeM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 008A913486;
        Mon, 26 Sep 2022 14:32:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5uXKOPq3MWOZDAAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 26 Sep 2022 14:32:26 +0000
Date:   Mon, 26 Sep 2022 16:32:26 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <YzG3+vCO23P/1YYp@dhcp22.suse.cz>
References: <20220923133512.GE22541@breakpoint.cc>
 <YzFZf0Onm6/UH7/I@dhcp22.suse.cz>
 <20220926075639.GA908@breakpoint.cc>
 <YzFplwSxwwsLpzzX@dhcp22.suse.cz>
 <YzFxHlYoncuDl2fM@dhcp22.suse.cz>
 <20220926100800.GB12777@breakpoint.cc>
 <YzGUyWlYd15uLu7G@dhcp22.suse.cz>
 <20220926130808.GD12777@breakpoint.cc>
 <YzGxuZ8jQ2sO4ZML@dhcp22.suse.cz>
 <20220926142013.GF12777@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926142013.GF12777@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon 26-09-22 16:20:13, Florian Westphal wrote:
> Michal Hocko <mhocko@suse.com> wrote:
> > On Mon 26-09-22 15:08:08, Florian Westphal wrote:
> > [...]
> > > To the best of my knowledge there are users of this interface that
> > > invoke it with rcu read lock held, and since those always nest, the
> > > rcu_read_unlock() won't move us to GFP_KERNEL territory.
> > 
> > Fiar point. I can see a comment above rhashtable_insert_fast which is
> > supposed to be used by drivers and explicitly documented to be
> > compatible with an atomic context. So the above is clearly a no-go
> > 
> > In that case I would propose to go with the patch going
> > http://lkml.kernel.org/r/YzFplwSxwwsLpzzX@dhcp22.suse.cz direction.
> 
> FWIW that patch works for me. Will you do a formal patch submission?

Feel free to use it and glue it to the actual bug report.

Thanks!

-- 
Michal Hocko
SUSE Labs
