Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D00C07E9D
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Sep 2022 15:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbiIZPeM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Sep 2022 11:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiIZPd2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Sep 2022 11:33:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163BB111E;
        Mon, 26 Sep 2022 07:20:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ocoxx-0005nw-PT; Mon, 26 Sep 2022 16:20:13 +0200
Date:   Mon, 26 Sep 2022 16:20:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Florian Westphal <fw@strlen.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <20220926142013.GF12777@breakpoint.cc>
References: <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
 <YzFZf0Onm6/UH7/I@dhcp22.suse.cz>
 <20220926075639.GA908@breakpoint.cc>
 <YzFplwSxwwsLpzzX@dhcp22.suse.cz>
 <YzFxHlYoncuDl2fM@dhcp22.suse.cz>
 <20220926100800.GB12777@breakpoint.cc>
 <YzGUyWlYd15uLu7G@dhcp22.suse.cz>
 <20220926130808.GD12777@breakpoint.cc>
 <YzGxuZ8jQ2sO4ZML@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzGxuZ8jQ2sO4ZML@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Michal Hocko <mhocko@suse.com> wrote:
> On Mon 26-09-22 15:08:08, Florian Westphal wrote:
> [...]
> > To the best of my knowledge there are users of this interface that
> > invoke it with rcu read lock held, and since those always nest, the
> > rcu_read_unlock() won't move us to GFP_KERNEL territory.
> 
> Fiar point. I can see a comment above rhashtable_insert_fast which is
> supposed to be used by drivers and explicitly documented to be
> compatible with an atomic context. So the above is clearly a no-go
> 
> In that case I would propose to go with the patch going
> http://lkml.kernel.org/r/YzFplwSxwwsLpzzX@dhcp22.suse.cz direction.

FWIW that patch works for me. Will you do a formal patch submission?
