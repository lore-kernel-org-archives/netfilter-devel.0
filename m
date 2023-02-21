Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFCEC61DA3
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Feb 2023 23:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBUXWH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Feb 2023 18:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBUXWG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2023 18:22:06 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D43B429178
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 15:22:03 -0800 (PST)
Date:   Wed, 22 Feb 2023 00:22:00 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: conntrack: fix rmmod double-free race
Message-ID: <Y/VSGH6gPhuzD2a2@salvia>
References: <20230214162359.5035-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230214162359.5035-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 14, 2023 at 05:23:59PM +0100, Florian Westphal wrote:
> nf_conntrack_hash_check_insert() callers free the ct entry directly, via
> nf_conntrack_free.
> 
> This isn't safe anymore because
> nf_conntrack_hash_check_insert() might place the entry into the conntrack
> table and then delteted the entry again because it found that a conntrack
> extension has been removed at the same time.
> 
> In this case, the just-added entry is removed again and an error is
> returned to the caller.
> 
> Problem is that another cpu might have picked up this entry and
> incremented its reference count.
> 
> This results in a use-after-free/double-free, once by the other cpu and
> once by the caller of nf_conntrack_hash_check_insert().
> 
> Fix this by making nf_conntrack_hash_check_insert() not fail anymore
> after the insertion, just like before the 'Fixes' commit.
> 
> This is safe because a racing nf_ct_iterate() has to wait for us
> to release the conntrack hash spinlocks.
> 
> While at it, make the function return -EAGAIN in the rmmod (genid
> changed) case, this makes nfnetlink replay the command (suggested
> by Pablo Neira).

Applied, thanks
