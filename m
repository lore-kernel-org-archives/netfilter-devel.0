Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA5DC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 May 2022 06:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239823AbiEDGLW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 May 2022 02:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbiEDGLV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 May 2022 02:11:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE9D14006
        for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2022 23:07:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nm8Ar-0002Ua-2T; Wed, 04 May 2022 08:07:45 +0200
Date:   Wed, 4 May 2022 08:07:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     William Tu <u9012063@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        Yifeng Sun <pkusunyifeng@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>
Subject: Re: [PATCH] netfilter: nf_conncount: reduce unnecessary GC
Message-ID: <20220504060745.GB32684@breakpoint.cc>
References: <20220503215237.98485-1-u9012063@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503215237.98485-1-u9012063@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

William Tu <u9012063@gmail.com> wrote:
> @@ -231,6 +236,12 @@ bool nf_conncount_gc_list(struct net *net,
>  	if (!spin_trylock(&list->list_lock))
>  		return false;
>  
> +	/* don't bother if we just done GC */
> +	if (time_after_eq(list->last_gc, jiffies)) {
> +		spin_unlock(&list->list_lock);

Minor nit, I think you could place the time_after_eq test before
the spin_trylock if you do wrap the list->last_gc read with READ_ONCE().

You could also check if changing last_gc to u32 and placing it after
the "list_lock" member prevents growth of the list structure.
